import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/device_token.dart';
import '../../../core/utils/text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/with_opacity_extension.dart';
import '../../../core/widgets/common_primary_button.dart';
import '../../../core/widgets/common_text_field.dart';
import '../../../core/widgets/custome_toast.dart';
import '../../../route_config/routes.dart';
import '../model/signin_request_model.dart';
import '../state_notifier/auth_notifier.dart';
import '../state_notifier/otp_timer_notifier.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadStoredCredentials();
  }

  Future<void> _loadStoredCredentials() async {
    try {
      final credentials = await ref.read(authNotifierProvider.notifier).getStoredCredentials();
      if (credentials['email'] != null && credentials['password'] != null) {
        setState(() {
          _emailController.text = credentials['email']!;
          _passwordController.text = credentials['password']!;
          _rememberMe = true;
        });
      }
    } catch (e) {
      // Handle error silently
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Listen to auth state changes and navigate to dashboard on success
    ref.listen(authNotifierProvider, (previous, next) {
      next.whenData((userData) {
        if (userData != null) {
          // Clear all previous routes and navigate to dashboard
          context.go(Routes.dashboard);
        }
      });
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20.h),
                _buildHeader(theme),
                SizedBox(height: 32.h),
                _buildFormFields(theme),
                SizedBox(height: 5.h),
                _buildRememberMeAndForgotPassword(theme),
                SizedBox(height: 24.h),
                _buildSignInButton(theme),
                SizedBox(height: 24.h),
                _buildSignUpLink(theme),
                SizedBox(height: 32.h),
                _buildSocialLogin(theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: theme.primaryColor.withOpacityExtension(0.1),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [BoxShadow(color: theme.primaryColor.withOpacityExtension(0.1), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Icon(Icons.login_rounded, size: 48.w, color: theme.primaryColor),
        ),
        SizedBox(height: 20.h),
        Text(
          'Welcome Back',
          style: TextHelper.size24(context).copyWith(color: isDark ? Colors.white : Colors.grey.shade800, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 8.h),
        Text(
          'Sign in to continue your journey',
          style: TextHelper.size14(context).copyWith(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600, fontWeight: FontWeight.w400),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFormFields(ThemeData theme) {
    return Column(
      children: [
        // Email field
        CommonTextField(
          controller: _emailController,
          labelText: 'Email Address',
          hintText: 'Enter your email',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.none,
          textInputFormatter: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
          prefixIcon: Icon(Icons.email_outlined, size: 20.w, color: theme.primaryColor),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            final email = value.trim();
            final emailRegex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,}$');
            if (!emailRegex.hasMatch(email)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        SizedBox(height: 16.h),
        // Password field
        CommonTextField(
          controller: _passwordController,
          labelText: 'Password',
          hintText: 'Enter your password',
          obscureText: _obscurePassword,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.done,
          textCapitalization: TextCapitalization.none,
          textInputFormatter: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
          prefixIcon: Icon(Icons.lock_outline, size: 20.w, color: theme.primaryColor),
          suffixIcon: IconButton(
            icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: theme.primaryColor),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          validator: Validators.validateCurrentPassword,
        ),
      ],
    );
  }

  Widget _buildRememberMeAndForgotPassword(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Remember Me checkbox
        Row(
          children: [
            Checkbox(
              value: _rememberMe,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value ?? false;
                });
              },
              activeColor: theme.primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
            ),
            Text(
              'Remember me',
              style: TextHelper.size14(context).copyWith(color: isDark ? Colors.grey.shade300 : Colors.grey.shade700, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        // Forgot Password
        GestureDetector(
          onTap: _openForgotPasswordFlow,
          child: Text(
            'Forgot Password?',
            style: TextHelper.size14(context).copyWith(color: theme.primaryColor, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildSignInButton(ThemeData theme) {
    return Consumer(
      builder: (context, ref, child) {
        final authState = ref.watch(authNotifierProvider);

        return CommonPrimaryButton(label: 'Sign In', onPressed: _handleSignIn, isLoading: authState.isLoading);
      },
    );
  }

  Widget _buildSignUpLink(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Don\'t have an account? ', style: TextHelper.size14(context).copyWith(color: theme.textTheme.bodyMedium?.color)),
        GestureDetector(
          onTap: () {
            // Navigate to sign up screen
            context.push(Routes.signup);
          },
          child: Text(
            'Sign Up',
            style: TextHelper.size14(context).copyWith(color: theme.primaryColor, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLogin(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300, thickness: 1)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                'Or continue with',
                style: TextHelper.size14(context).copyWith(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600, fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(child: Divider(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300, thickness: 1)),
          ],
        ),
        SizedBox(height: 24.h),
        Row(
          children: [
            Expanded(child: _buildSocialButton(theme, 'Google', Icons.g_mobiledata, () => _handleGoogleSignIn())),
            if (Platform.isIOS) ...[
              SizedBox(width: 12.w),
              Expanded(child: _buildSocialButton(theme, 'Apple', Icons.apple, () => _handleAppleSignIn())),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton(ThemeData theme, String label, IconData icon, VoidCallback onTap) {
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300, width: 1),
          color: isDark ? Colors.grey.shade800 : Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20.w, color: isDark ? Colors.white : Colors.grey.shade800),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextHelper.size14(context).copyWith(color: isDark ? Colors.white : Colors.grey.shade800, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Handle remember me functionality
    if (_rememberMe) {
      ref.read(authNotifierProvider.notifier).storeCredentials(email, password);
    } else {
      ref.read(authNotifierProvider.notifier).clearCredentials();
    }

    final deviceToken = await DeviceInfoService().getDeviceToken() ?? 'device_token_${DateTime.now().millisecondsSinceEpoch}';
    final request = SignInRequestModel(
      emailAddress: email,
      password: password,
      deviceToken: deviceToken,
      deviceType: Platform.isAndroid
          ? 'android'
          : Platform.isIOS
          ? 'ios'
          : 'web',
      ln: 'en',
    );

    ref.read(authNotifierProvider.notifier).signIn(request: request);
  }

  Future<void> _openForgotPasswordFlow() async {
    final email = await _showEmailSheet();
    if (email == null) return;

    final verified = await _showOtpSheet(email: email);
    if (verified != true) return;

    await _showResetPasswordSheet(email: email);
  }

  Future<String?> _showEmailSheet() async {
    final emailController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final theme = Theme.of(context);
    return await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (bsContext) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 16.h),
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 36.w,
                        height: 4.h,
                        margin: EdgeInsets.only(bottom: 12.h),
                        decoration: BoxDecoration(color: (theme.dividerColor).withOpacityExtension(0.6), borderRadius: BorderRadius.circular(100.r)),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text('Forgot Password', style: TextHelper.size18(context).copyWith(fontWeight: FontWeight.w700)),
                    SizedBox(height: 16.h),
                    CommonTextField(
                      controller: emailController,
                      labelText: 'Email Address',
                      hintText: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,
                      textInputFormatter: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
                      prefixIcon: Icon(Icons.email_outlined, size: 20.w, color: theme.primaryColor),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        final email = value.trim();
                        final emailRegex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,}$');
                        if (!emailRegex.hasMatch(email)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30.h),
                    CommonPrimaryButton(
                      label: 'Send OTP',
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          final res = await ref.read(authNotifierProvider.notifier).sendForgotOtp(email: emailController.text.trim());
                          if (res.success == true) {
                            if (!bsContext.mounted) return;
                            Navigator.pop(bsContext, emailController.text.trim());
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<bool?> _showOtpSheet({required String email}) async {
    final nodes = List.generate(4, (_) => FocusNode());
    final ctrls = List.generate(4, (_) => TextEditingController());

    void onChanged(int index, String v) {
      if (v.length == 1 && index < 3) nodes[index + 1].requestFocus();
      if (v.isEmpty && index > 0) nodes[index - 1].requestFocus();
    }

    return await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (_) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 16.h),
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 0),
              child: Consumer(
                builder: (context, ref, __) {
                  final timerState = ref.watch(otpTimerProvider);
                  final timerNotifier = ref.read(otpTimerProvider.notifier);

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    // Start automatically when sheet opens (only once per open)
                    if (timerState.secondsRemaining == 120 && !timerState.canResend) {
                      timerNotifier.start();
                    }
                  });

                  String fmt(int s) => '${(s ~/ 60).toString().padLeft(2, '0')}:${(s % 60).toString().padLeft(2, '0')}';

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 36.w,
                          height: 4.h,
                          margin: EdgeInsets.only(bottom: 12.h),
                          decoration: BoxDecoration(
                            color: (Theme.of(context).dividerColor).withOpacityExtension(0.6),
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text('Verify Your OTP', style: TextHelper.size18(context).copyWith(fontWeight: FontWeight.w700)),
                      SizedBox(height: 10.h),
                      Text(
                        'Please enter the verification code that has been sent to $email',
                        style: TextHelper.size14(context).copyWith(fontWeight: FontWeight.w400),
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(7, (i) {
                          if (i.isOdd) return SizedBox(width: 8.w);
                          final index = i ~/ 2;
                          return SizedBox(
                            width: 48.w,
                            child: TextField(
                              controller: ctrls[index],
                              focusNode: nodes[index],
                              maxLength: 1,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                counterText: '',
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                                filled: true,
                                fillColor: Theme.of(context).inputDecorationTheme.fillColor ?? Colors.transparent,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide: BorderSide(color: Theme.of(context).dividerColor.withOpacityExtension(0.4)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                  borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.6),
                                ),
                              ),
                              onChanged: (v) => onChanged(index, v),
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: 14.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(timerState.canResend ? "Didn't received OTP?  " : 'Resend OTP in  ', style: TextHelper.size14(context)),
                          GestureDetector(
                            onTap: timerState.canResend
                                ? () async {
                                    final resend = await ref.read(authNotifierProvider.notifier).sendForgotOtp(email: email);
                                    if (resend.success == true) {
                                      timerNotifier.restart();
                                    }
                                  }
                                : null,
                            child: Text(
                              timerState.canResend ? 'Resend' : fmt(timerState.secondsRemaining),
                              style: TextHelper.size14(context).copyWith(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.h),
                      CommonPrimaryButton(
                        label: 'Verify OTP',
                        onPressed: () async {
                          final code = ctrls.map((c) => c.text).join();
                          final otp = int.tryParse(code) ?? 0;
                          final res = await ref.read(authNotifierProvider.notifier).verifyOtp(email: email, otp: otp);
                          if (res.success == true) {
                            if (!context.mounted) return;
                            Navigator.pop(context, true);
                          }
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showResetPasswordSheet({required String email}) async {
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final theme = Theme.of(context);
    bool obscure = true;
    bool obscureConfirm = true;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
      builder: (bsContext) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 16.h),
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 36.w,
                        height: 4.h,
                        margin: EdgeInsets.only(bottom: 12.h),
                        decoration: BoxDecoration(color: (theme.dividerColor).withOpacityExtension(0.6), borderRadius: BorderRadius.circular(100.r)),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text('Set New Password', style: TextHelper.size18(context).copyWith(fontWeight: FontWeight.w700)),
                    SizedBox(height: 16.h),
                    StatefulBuilder(
                      builder: (context, setSB) {
                        return Column(
                          children: [
                            CommonTextField(
                              controller: passwordController,
                              labelText: 'New Password',
                              hintText: 'Please enter new password',
                              obscureText: obscure,
                              textInputFormatter: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
                              prefixIcon: Icon(Icons.lock_outline, size: 20.w, color: theme.primaryColor),
                              suffixIcon: IconButton(
                                icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
                                onPressed: () => setSB(() => obscure = !obscure),
                              ),
                              validator: Validators.validateNewPassword,
                              onChange: (value) {
                                // Re-validate confirm password when new password changes
                                if (confirmPasswordController.text.isNotEmpty) {
                                  formKey.currentState?.validate();
                                }
                              },
                            ),
                            SizedBox(height: 16.h),
                            CommonTextField(
                              controller: confirmPasswordController,
                              labelText: 'Confirm Password',
                              hintText: 'Please confirm your password',
                              obscureText: obscureConfirm,
                              textInputFormatter: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
                              prefixIcon: Icon(Icons.lock_outline, size: 20.w, color: theme.primaryColor),
                              suffixIcon: IconButton(
                                icon: Icon(obscureConfirm ? Icons.visibility_off : Icons.visibility),
                                onPressed: () => setSB(() => obscureConfirm = !obscureConfirm),
                              ),
                              validator: (v) => Validators.validateConfirmPassword(v, passwordController.text),
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 30.h),
                    CommonPrimaryButton(
                      label: 'Reset Password',
                      onPressed: () async {
                        if (!formKey.currentState!.validate()) return;
                        final res = await ref
                            .read(authNotifierProvider.notifier)
                            .resetPassword(email: email, newPassword: passwordController.text.trim());
                        if (res.success == true) {
                          if (!bsContext.mounted) return;
                          Navigator.pop(bsContext);
                          showStyledToast(res.message ?? 'Password reset successful. Please login.', ToastType.success);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleGoogleSignIn() {
    ref.read(authNotifierProvider.notifier).signInWithGoogle();
  }

  void _handleAppleSignIn() {
    ref.read(authNotifierProvider.notifier).signInWithApple();
  }
}
