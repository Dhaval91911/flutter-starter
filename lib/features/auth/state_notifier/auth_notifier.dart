import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:starter_template_riverpod/core/shared_pref/shared_pref.dart';
import 'package:starter_template_riverpod/core/widgets/constant_widgets.dart';
import 'package:starter_template_riverpod/core/widgets/custome_toast.dart';

import '../../../core/shared_pref/storage_keys.dart';
import '../../../core/utils/device_token.dart';
import '../../../injectable/injectable.dart';
import '../../../services/location/location_service.dart';
import '../../../services/web_service/api_helper.dart';
import '../../../services/web_service/api_service.dart';
import '../model/forgot_password_models.dart';
import '../model/signin_request_model.dart';
import '../model/signup_request_model.dart';
import '../model/signup_response_model.dart';
import '../model/validation_models.dart';

final authNotifierProvider = StateNotifierProvider.autoDispose<AuthNotifier, AsyncValue<UserData?>>((ref) {
  return getIt<AuthNotifier>();
});

@injectable
class AuthNotifier extends StateNotifier<AsyncValue<UserData?>> {
  final ApiService apiService;
  final SharedPrefService _sharedPrefService = getIt<SharedPrefService>();

  AuthNotifier(this.apiService) : super(const AsyncValue.data(null)) {
    _loadStoredUser();
  }

  Future<void> signUp({required SignupRequestModel request, bool isShowLoading = true}) async {
    try {
      if (isShowLoading) {
        showProgressIndicator();
      }

      // First validate email
      final emailValidation = await checkEmailAddress(request.emailAddress);
      if (emailValidation.success != true) {
        if (isShowLoading) {
          dismissProgressIndicator();
        }
        showStyledToast(emailValidation.message ?? 'Email validation failed', ToastType.error);
        return;
      }

      // Then validate mobile number
      final mobileValidation = await checkMobileNumber(request.mobileNumber);
      if (mobileValidation.success != true) {
        if (isShowLoading) {
          dismissProgressIndicator();
        }
        showStyledToast(mobileValidation.message ?? 'Mobile number validation failed', ToastType.error);
        return;
      }

      // If both validations pass, proceed with signup
      final response = await apiService.signUp(request);

      if (response.success != null && response.success == true && response.data != null) {
        // Store user data including token
        await _storeUserData(response.data!);
        state = AsyncValue.data(response.data);
        showStyledToast(response.message ?? 'Sign up successful', ToastType.success);
        // Don't dismiss loader here - let UI handle it after navigation
      } else {
        if (isShowLoading) {
          dismissProgressIndicator();
        }
        state = AsyncValue.error(Exception(response.message), StackTrace.current);
        showStyledToast(response.message ?? 'Sign up failed', ToastType.error);
      }
    } catch (e, st) {
      if (isShowLoading) {
        dismissProgressIndicator();
      }
      state = AsyncValue.error(e, st);
      showStyledToast('Sign up failed. Please try again.', ToastType.error);
    }
  }

  Future<void> signIn({required SignInRequestModel request, bool isShowLoading = true}) async {
    try {
      if (isShowLoading) {
        showProgressIndicator();
      }

      final response = await apiService.signIn(request);

      if (response.success != null && response.success == true && response.data != null) {
        // Store user data
        await _storeUserData(response.data!);
        state = AsyncValue.data(response.data);
        showStyledToast(response.message ?? 'Sign in successful', ToastType.success);
      } else {
        state = AsyncValue.error(Exception(response.message), StackTrace.current);
        showStyledToast(response.message ?? 'Sign in failed', ToastType.error);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      showStyledToast('Sign in failed. Please try again.', ToastType.error);
    } finally {
      if (isShowLoading) {
        dismissProgressIndicator();
      }
    }
  }

  void clearAuthState() {
    state = const AsyncValue.data(null);
    _clearStoredUserData();
  }

  void setUser(UserData user) {
    state = AsyncValue.data(user);
    _storeUserData(user);
  }

  // -------- Email and Mobile Validation --------
  Future<CheckEmailResponseModel> checkEmailAddress(String email, {bool showLoading = true}) async {
    final res = await performApiCall<CheckEmailResponseModel>(
      request: () => apiService.checkEmailAddress(CheckEmailRequest(emailAddress: email, ln: 'en')),
      buildDefaultOnError: (_) => CheckEmailResponseModel(success: false, message: 'Network error'),
      networkErrorMessage: 'Unable to check email. Please check your connection.',
      showLoading: showLoading,
    );
    return res;
  }

  Future<CheckMobileResponseModel> checkMobileNumber(int mobileNumber, {bool showLoading = true}) async {
    final res = await performApiCall<CheckMobileResponseModel>(
      request: () => apiService.checkMobileNumber(CheckMobileRequest(mobileNumber: mobileNumber, ln: 'en')),
      buildDefaultOnError: (_) => CheckMobileResponseModel(success: false, message: 'Network error'),
      networkErrorMessage: 'Unable to check mobile number. Please check your connection.',
      showLoading: showLoading,
    );
    return res;
  }

  // -------- Logout --------
  Future<LogoutResponseModel> logout({required String deviceToken, bool isShowLoading = true}) async {
    try {
      if (isShowLoading) {
        showProgressIndicator();
      }

      // Get the current user token for authentication
      final currentUser = state.value;
      final userToken = currentUser?.token ?? _sharedPrefService.getString(StorageKeys.userToken) ?? '';

      // Token available either from current user or storage

      if (userToken.isEmpty) {
        showStyledToast('Authentication token not found', ToastType.error);
        return LogoutResponseModel(success: false, message: 'Authentication token not found');
      }

      // Use the API service - TokenInterceptor will handle Authorization header
      final response = await apiService.logout(LogoutRequest(deviceToken: deviceToken, ln: 'en'));

      if (response.success == true) {
        // Clear auth state and stored data only after successful API response
        clearAuthState();
        clearCredentialsIfNotRemembered();
        showStyledToast(response.message ?? 'Logged out successfully', ToastType.success);
      } else {
        showStyledToast(response.message ?? 'Logout failed', ToastType.error);
      }

      return response;
    } catch (e) {
      showStyledToast('Logout failed. Please try again.', ToastType.error);
      return LogoutResponseModel(success: false, message: 'Network error');
    } finally {
      if (isShowLoading) {
        dismissProgressIndicator();
      }
    }
  }

  // -------- Profile Upload + Refresh --------
  Future<bool> uploadProfileImage({required String filePath}) async {
    try {
      showProgressIndicator();

      final fileName = filePath.split('/').last;
      final multipart = await MultipartFile.fromFile(filePath, filename: fileName);
      final token = _sharedPrefService.getString(StorageKeys.userToken) ?? '';
      final authHeader = 'Bearer $token';
      final uploadRes = await apiService.uploadMedia(authHeader, 'image', multipart, 'en');
      if (uploadRes.success != true) {
        showStyledToast(uploadRes.message ?? 'Upload failed', ToastType.error);
        return false;
      }

      // Fetch updated user data
      final refreshed = await apiService.fetchUpdatedUser({'ln': 'en'});
      if (refreshed.success == true && refreshed.data != null) {
        // Add cache-busting query to force UI refresh of the image
        final ts = DateTime.now().millisecondsSinceEpoch;
        if (refreshed.data!.userProfile != null && refreshed.data!.userProfile!.isNotEmpty) {
          refreshed.data!.userProfile = '${refreshed.data!.userProfile}?v=$ts';
        }
        await _storeUserData(refreshed.data!);
        state = AsyncValue.data(refreshed.data);
        showStyledToast(refreshed.message ?? 'Profile updated', ToastType.success);
        return true;
      }

      showStyledToast(refreshed.message ?? 'Failed to refresh user data', ToastType.error);
      return false;
    } catch (_) {
      showStyledToast('Unable to update profile. Please try again.', ToastType.error);
      return false;
    } finally {
      dismissProgressIndicator();
    }
  }

  // -------- Delete Account --------
  Future<DefaultResponseModel> deleteAccount({bool isShowLoading = true}) async {
    try {
      if (isShowLoading) {
        showProgressIndicator();
      }
      final res = await performApiCall<DefaultResponseModel>(
        request: () => apiService.deleteAccount({'ln': 'en'}),
        buildDefaultOnError: (_) => DefaultResponseModel(success: false, message: 'Network error'),
        networkErrorMessage: 'Unable to delete account. Please check your connection.',
      );
      if (res.success == true) {
        // Clear auth and navigate will be handled by caller
        showStyledToast(res.message ?? 'Account deleted', ToastType.success);
      } else {
        showStyledToast(res.message ?? 'Delete account failed', ToastType.error);
      }
      return res;
    } catch (_) {
      showStyledToast('Unable to delete account. Please try again.', ToastType.error);
      return DefaultResponseModel(success: false, message: 'Network error');
    } finally {
      if (isShowLoading) {
        dismissProgressIndicator();
      }
    }
  }

  // -------- Forgot Password Flow --------
  Future<SendOtpResponseModel> sendForgotOtp({required String email}) async {
    final res = await performApiCall<SendOtpResponseModel>(
      request: () => apiService.sendOtpForgot(SendOtpRequest(emailAddress: email, ln: 'en')),
      buildDefaultOnError: (_) => SendOtpResponseModel(success: false, message: 'Network error'),
      networkErrorMessage: 'Unable to send OTP. Please check your connection.',
    );
    if (res.success == true) {
      showStyledToast(res.message ?? 'OTP sent', ToastType.success);
    } else {
      showStyledToast(res.message ?? 'Failed to send OTP', ToastType.error);
    }
    return res;
  }

  Future<DefaultResponseModel> verifyOtp({required String email, required int otp}) async {
    final res = await performApiCall<DefaultResponseModel>(
      request: () => apiService.verifyOtp(VerifyOtpRequest(otp: otp, emailAddress: email, ln: 'en')),
      buildDefaultOnError: (_) => DefaultResponseModel(success: false, message: 'Network error'),
      networkErrorMessage: 'Unable to verify OTP. Please check your connection.',
    );
    if (res.success == true) {
      showStyledToast(res.message ?? 'OTP verified', ToastType.success);
    } else {
      showStyledToast(res.message ?? 'OTP verification failed', ToastType.error);
    }
    return res;
  }

  Future<DefaultResponseModel> resetPassword({required String email, required String newPassword}) async {
    final res = await performApiCall<DefaultResponseModel>(
      request: () => apiService.resetPassword(ResetPasswordRequest(emailAddress: email, newPassword: newPassword, ln: 'en')),
      buildDefaultOnError: (_) => DefaultResponseModel(success: false, message: 'Network error'),
      networkErrorMessage: 'Unable to reset password. Please check your connection.',
    );
    if (res.success == true) {
      showStyledToast(res.message ?? 'Password changed', ToastType.success);
    } else {
      showStyledToast(res.message ?? 'Reset failed', ToastType.error);
    }
    return res;
  }

  Future<DefaultResponseModel> changePassword({required String oldPassword, required String newPassword, bool isShowLoading = true}) async {
    try {
      if (isShowLoading) {
        showProgressIndicator();
      }
      final res = await performApiCall<DefaultResponseModel>(
        request: () => apiService.changePassword(ChangePasswordRequest(oldPassword: oldPassword, newPassword: newPassword, ln: 'en')),
        buildDefaultOnError: (_) => DefaultResponseModel(success: false, message: 'Network error'),
        networkErrorMessage: 'Unable to change password. Please check your connection.',
      );
      if (res.success == true) {
        showStyledToast(res.message ?? 'Password changed', ToastType.success);
      } else {
        showStyledToast(res.message ?? 'Change password failed', ToastType.error);
      }
      return res;
    } catch (_) {
      showStyledToast('Unable to change password. Please try again.', ToastType.error);
      return DefaultResponseModel(success: false, message: 'Network error');
    } finally {
      if (isShowLoading) {
        dismissProgressIndicator();
      }
    }
  }

  Future<void> _loadStoredUser() async {
    try {
      final userJson = _sharedPrefService.getString(StorageKeys.userData);
      if (userJson != null && userJson.isNotEmpty) {
        final Map<String, dynamic> dataMap = jsonDecode(userJson) as Map<String, dynamic>;
        final user = UserData.fromJson(dataMap);
        state = AsyncValue.data(user);
      }
    } catch (e) {
      // Handle error silently
    }
  }

  // Expose a public method to allow callers (e.g., splash) to load stored user before navigation
  Future<void> loadStoredUser() async {
    await _loadStoredUser();
  }

  Future<void> _storeUserData(UserData user) async {
    try {
      // Preserve existing token if refreshed payload doesn't include one
      final existingToken = _sharedPrefService.getString(StorageKeys.userToken);
      final tokenToPersist = (user.token != null && user.token!.isNotEmpty) ? user.token! : (existingToken ?? '');

      // Preserve existing device token if refreshed payload doesn't include one
      String? existingDeviceToken;
      final existingUserJson = _sharedPrefService.getString(StorageKeys.userData);
      if (existingUserJson != null && existingUserJson.isNotEmpty) {
        try {
          final existingMap = jsonDecode(existingUserJson) as Map<String, dynamic>;
          existingDeviceToken = existingMap['device_token'] as String?;
        } catch (_) {}
      }
      final deviceTokenToPersist = (user.deviceToken != null && user.deviceToken!.isNotEmpty) ? user.deviceToken! : (existingDeviceToken ?? '');

      // If the incoming user object lacks token, inject the preserved token into the serialized copy
      final Map<String, dynamic> userMap = user.toJson();
      userMap['token'] = tokenToPersist;
      userMap['device_token'] = deviceTokenToPersist;

      final userString = jsonEncode(userMap);
      await _sharedPrefService.setString(StorageKeys.userData, userString);
      await _sharedPrefService.setString(StorageKeys.userToken, tokenToPersist);
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> storeCredentials(String email, String password) async {
    try {
      await _sharedPrefService.setString(StorageKeys.rememberedEmail, email);
      await _sharedPrefService.setString(StorageKeys.rememberedPassword, password);
      await _sharedPrefService.setBool(StorageKeys.rememberMe, true);
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> clearCredentials() async {
    try {
      await _sharedPrefService.remove(StorageKeys.rememberedEmail);
      await _sharedPrefService.remove(StorageKeys.rememberedPassword);
      await _sharedPrefService.setBool(StorageKeys.rememberMe, false);
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> clearCredentialsIfNotRemembered() async {
    try {
      final remember = _sharedPrefService.getBool(StorageKeys.rememberMe) ?? false;
      if (!remember) {
        await clearCredentials();
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<Map<String, String?>> getStoredCredentials() async {
    try {
      final email = _sharedPrefService.getString(StorageKeys.rememberedEmail);
      final password = _sharedPrefService.getString(StorageKeys.rememberedPassword);
      final rememberMe = _sharedPrefService.getBool(StorageKeys.rememberMe) ?? false;

      if (rememberMe && email != null && password != null) {
        return {'email': email, 'password': password};
      }
      return {'email': null, 'password': null};
    } catch (e) {
      return {'email': null, 'password': null};
    }
  }

  Future<bool> isUserLoggedIn() async {
    try {
      final token = _sharedPrefService.getString(StorageKeys.userToken);
      final userData = _sharedPrefService.getString(StorageKeys.userData);
      return token != null && token.isNotEmpty && userData != null && userData.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  Future<void> checkLoginStatus() async {
    try {
      final isLoggedIn = await isUserLoggedIn();
      if (isLoggedIn) {
        // If we have stored user data, ensure it's loaded into state
        if (state.value == null) {
          await _loadStoredUser();
        }
      }
    } catch (e) {
      // Handle error silently
    }
  }

  // -------- Google Sign-In --------
  Future<void> signInWithGoogle() async {
    try {
      showProgressIndicator();

      final googleSignIn = GoogleSignIn(scopes: const ['email', 'profile']);
      await googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        // user cancelled
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      if (userCredential.user == null) {
        showStyledToast('Google login failed', ToastType.error);
        return;
      }

      final email = userCredential.user!.email ?? googleUser.email;

      // Re-show loader to cover subsequent API calls (account picker may have hidden overlay)
      showProgressIndicator();

      // Check if email exists via existing API
      final check = await checkEmailAddress(email, showLoading: false);

      // Prepare device metadata: always try fresh FCM token first via common helper
      String? freshFcm;
      try {
        freshFcm = await DeviceInfoService().getDeviceToken();
      } catch (_) {}
      // Do NOT use stored token for login/signup; prefer fresh token or fallback
      final effectiveDeviceToken = freshFcm ?? 'device_token_${DateTime.now().millisecondsSinceEpoch}';

      const locService = LocationService();
      final loc = await locService.getCurrentLocationAndAddress();
      final coords = (loc.latitude != null && loc.longitude != null)
          ? '[${loc.longitude!.toStringAsFixed(6)},${loc.latitude!.toStringAsFixed(6)}]'
          : '[0.0,0.0]';
      final locationString = '{"type":"Point","coordinates":$coords}';

      if (check.success == true) {
        // Email available => treat as new user social signup
        final body = {
          'full_name': userCredential.user!.displayName ?? googleUser.displayName ?? 'Google User',
          'email_address': email,
          'is_social_login': true,
          'social_platform': 'google',
          'device_token': effectiveDeviceToken,
          'device_type': 'android',
          'location': locationString,
          'address': loc.address ?? '',
          'ln': 'en',
        };
        // Keep loader visible during network call
        showProgressIndicator();
        final response = await apiService.signUpSocial(body);
        if (response.success == true && response.data != null) {
          await _storeUserData(response.data!);
          state = AsyncValue.data(response.data);
          showStyledToast(response.message ?? 'Sign up successful', ToastType.success);
        } else {
          showStyledToast(response.message ?? 'Social signup failed', ToastType.error);
        }
      } else {
        // Existing user: perform social sign-in
        final body = {
          'email_address': email,
          'is_social_login': true,
          'social_platform': 'google',
          'device_token': effectiveDeviceToken,
          'device_type': 'android',
          'ln': 'en',
        };
        // Keep loader visible during network call
        showProgressIndicator();
        final response = await apiService.signInSocial(body);
        if (response.success == true && response.data != null) {
          await _storeUserData(response.data!);
          state = AsyncValue.data(response.data);
          showStyledToast('Signed in with Google', ToastType.success);
        } else {
          showStyledToast(response.message ?? 'Social sign-in failed', ToastType.error);
        }
      }
    } catch (_) {
      showStyledToast('Unable to sign in with Google. Please try again.', ToastType.error);
    } finally {
      dismissProgressIndicator();
    }
  }

  // -------- Apple Sign-In --------
  Future<void> signInWithApple() async {
    try {
      showProgressIndicator();

      // Check availability first
      final isAvailable = await SignInWithApple.isAvailable();
      if (!isAvailable) {
        showStyledToast('Apple Sign-In is not available on this device.', ToastType.error);
        return;
      }

      // Request Apple credentials
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
      );

      final oauthCredential = OAuthProvider(
        'apple.com',
      ).credential(idToken: appleCredential.identityToken, accessToken: appleCredential.authorizationCode);

      final userCredential = await FirebaseAuth.instance.signInWithCredential(oauthCredential);
      if (userCredential.user == null) {
        showStyledToast('Apple login failed', ToastType.error);
        return;
      }

      final email = userCredential.user!.email ?? appleCredential.email ?? '';
      if (email.isEmpty) {
        showStyledToast('Unable to get email from Apple. Please share email.', ToastType.error);
        return;
      }

      // Keep loader manually; avoid inner auto-dismiss
      final check = await checkEmailAddress(email, showLoading: false);

      // Fresh FCM token
      String? freshFcm;
      try {
        freshFcm = await DeviceInfoService().getDeviceToken();
      } catch (_) {}
      final effectiveDeviceToken = freshFcm ?? 'device_token_${DateTime.now().millisecondsSinceEpoch}';

      // Location (no reverse geocode to keep flow fast)
      const locService = LocationService();
      final loc = await locService.getCurrentLocationAndAddress();
      final coords = (loc.latitude != null && loc.longitude != null)
          ? '[${loc.longitude!.toStringAsFixed(6)},${loc.latitude!.toStringAsFixed(6)}]'
          : '[0.0,0.0]';
      final locationString = '{"type":"Point","coordinates":$coords}';

      if (check.success == true) {
        final body = {
          'full_name': userCredential.user!.displayName ?? '${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}'.trim(),
          'email_address': email,
          'is_social_login': true,
          'social_platform': 'apple',
          'device_token': effectiveDeviceToken,
          'device_type': 'ios',
          'location': locationString,
          'address': loc.address ?? '',
          'ln': 'en',
        };
        showProgressIndicator();
        final response = await apiService.signUpSocial(body);
        if (response.success == true && response.data != null) {
          await _storeUserData(response.data!);
          state = AsyncValue.data(response.data);
          showStyledToast(response.message ?? 'Sign up successful', ToastType.success);
        } else {
          showStyledToast(response.message ?? 'Social signup failed', ToastType.error);
        }
      } else {
        final body = {
          'email_address': email,
          'is_social_login': true,
          'social_platform': 'apple',
          'device_token': effectiveDeviceToken,
          'device_type': 'ios',
          'ln': 'en',
        };
        showProgressIndicator();
        final response = await apiService.signInSocial(body);
        if (response.success == true && response.data != null) {
          await _storeUserData(response.data!);
          state = AsyncValue.data(response.data);
          showStyledToast('Signed in with Apple', ToastType.success);
        } else {
          showStyledToast(response.message ?? 'Social sign-in failed', ToastType.error);
        }
      }
    } catch (_) {
      showStyledToast('Unable to sign in with Apple. Please try again.', ToastType.error);
    } finally {
      dismissProgressIndicator();
    }
  }

  Future<void> _clearStoredUserData() async {
    try {
      await _sharedPrefService.remove(StorageKeys.userData);
      await _sharedPrefService.remove(StorageKeys.userToken);
    } catch (e) {
      // Handle error silently
    }
  }
}
