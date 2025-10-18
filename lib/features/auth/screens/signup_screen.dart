import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/device_token.dart';
import '../../../core/utils/text_styles.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/with_opacity_extension.dart';
import '../../../core/widgets/common_primary_button.dart';
import '../../../core/widgets/common_text_field.dart';
import '../../../core/widgets/constant_widgets.dart';
import '../../../core/widgets/custome_toast.dart';
import '../../../route_config/routes.dart';
import '../../../services/location/location_service.dart';
import '../model/signup_request_model.dart';
import '../state_notifier/auth_notifier.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _addressController = TextEditingController();

  String _selectedCountryCode = '+91';
  String _selectedCountryStringCode = 'IN';
  Country? _selectedCountry;
  final bool _isSocialLogin = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  double? _currentLat;
  double? _currentLng;
  final LocationService _locationService = const LocationService();

  // Removed static list in favor of country_picker

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initLocation());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Listen to auth state changes and navigate to dashboard on success
    ref.listen(authNotifierProvider, (previous, next) {
      next.whenData((userData) {
        if (userData != null) {
          // Dismiss loader before navigation
          dismissProgressIndicator();
          // Clear all previous routes and navigate to dashboard
          context.go(Routes.dashboard);
        }
      });
      // Handle errors and dismiss loader
      next.whenOrNull(
        error: (error, stack) {
          dismissProgressIndicator();
        },
      );
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
                SizedBox(height: 24.h),
                _buildFormFields(theme),
                SizedBox(height: 24.h),
                _buildSignupButton(theme),
                SizedBox(height: 24.h),
                _buildLoginLink(theme),
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
          child: Icon(Icons.person_add_rounded, size: 48.w, color: theme.primaryColor),
        ),
        SizedBox(height: 20.h),
        Text(
          'Create Account',
          style: TextHelper.size24(context).copyWith(color: isDark ? Colors.white : Colors.grey.shade800, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 8.h),
        Text(
          'Join us today and start your journey',
          style: TextHelper.size14(context).copyWith(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600, fontWeight: FontWeight.w400),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFormFields(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        // Full name field
        CommonTextField(
          controller: _fullNameController,
          labelText: 'Full Name',
          hintText: 'Enter your full name',
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          prefixIcon: Icon(Icons.person_outline, size: 20.w, color: theme.primaryColor),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your full name';
            }
            if (value.length < 2) {
              return 'Name must be at least 2 characters';
            }
            return null;
          },
        ),
        SizedBox(height: 12.h),
        // Email field
        CommonTextField(
          controller: _emailController,
          labelText: 'Email Address',
          hintText: 'Enter your email',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          textInputFormatter: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
          prefixIcon: Icon(Icons.email_outlined, size: 20.w, color: theme.primaryColor),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            final email = value.trim();
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        SizedBox(height: 12.h),
        // Phone number field
        CommonTextField(
          controller: _mobileController,
          labelText: 'Mobile Number',
          hintText: 'Enter mobile number',
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          textInputFormatter: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your mobile number';
            }
            if (value.length != 10) {
              return 'Mobile number must be 10 digits';
            }
            return null;
          },
          prefixIcon: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              final theme = Theme.of(context);

              showCountryPicker(
                context: context,
                showPhoneCode: true,
                countryListTheme: CountryListThemeData(
                  bottomSheetHeight: 0.7.sh,
                  backgroundColor: theme.dialogTheme.backgroundColor ?? theme.colorScheme.surface,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(16.r), topRight: Radius.circular(16.r)),
                  inputDecoration: InputDecoration(
                    hintText: 'Search country',
                    prefixIcon: const Icon(Icons.search),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
                  ),
                ),
                onSelect: (Country c) {
                  setState(() {
                    _selectedCountry = c;
                    _selectedCountryCode = '+${c.phoneCode}';
                    _selectedCountryStringCode = c.countryCode;
                  });
                },
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_selectedCountry?.flagEmoji ?? '🇮🇳', style: TextHelper.size16(context)),
                SizedBox(width: 8.w),
                Text(
                  _selectedCountryCode,
                  style: TextHelper.size14(context).copyWith(color: isDark ? Colors.white : Colors.grey.shade800, fontWeight: FontWeight.w600),
                ),
                Icon(Icons.keyboard_arrow_down_rounded, color: theme.primaryColor, size: 18.w),
              ],
            ),
          ),
        ),
        SizedBox(height: 12.h),
        // Password field
        CommonTextField(
          controller: _passwordController,
          labelText: 'Password',
          hintText: 'Enter your password',
          obscureText: _obscurePassword,
          keyboardType: TextInputType.visiblePassword,
          textInputAction: TextInputAction.next,
          textInputFormatter: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
          prefixIcon: Icon(Icons.lock_outline, size: 20.w, color: theme.primaryColor),
          suffixIcon: IconButton(
            icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          validator: Validators.validatePassword,
        ),
        SizedBox(height: 12.h),
        // Confirm passsword field
        CommonTextField(
          controller: _confirmPasswordController,
          labelText: 'Confirm Password',
          hintText: 'Confirm your password',
          obscureText: _obscureConfirmPassword,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.visiblePassword,
          textInputFormatter: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
          prefixIcon: Icon(Icons.lock_outline, size: 20.w, color: theme.primaryColor),
          suffixIcon: IconButton(
            icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              });
            },
          ),
          validator: (value) => Validators.validateConfirmPassword(value, _passwordController.text),
        ),
        SizedBox(height: 12.h),
        // Address field
        CommonTextField(
          controller: _addressController,
          labelText: 'Address',
          hintText: 'Fetching your current address...',
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          prefixIcon: Icon(Icons.location_on_outlined, size: 20.w, color: theme.primaryColor),
          maxLines: 2,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your address';
            }
            if (value.trim().length < 10) {
              return 'Address must be at least 10 characters';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSignupButton(ThemeData theme) {
    return Consumer(
      builder: (context, ref, child) {
        final authState = ref.watch(authNotifierProvider);

        return CommonPrimaryButton(label: 'Create Account', onPressed: _handleSignup, isLoading: authState.isLoading);
      },
    );
  }

  Widget _buildLoginLink(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Already have an account? ', style: TextHelper.size14(context).copyWith(color: theme.textTheme.bodyMedium?.color)),
        GestureDetector(
          onTap: () {
            // Go back to login screen
            context.pop();
          },
          child: Text(
            'Sign In',
            style: TextHelper.size14(context).copyWith(color: theme.primaryColor, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_currentLat == null || _currentLng == null || _addressController.text.trim().isEmpty) {
      showStyledToast('Please allow location to auto-fill your address', ToastType.warning);
      return;
    }

    final locationString = (_currentLat != null && _currentLng != null)
        ? '{"type":"Point","coordinates":[${_currentLat!.toStringAsFixed(6)},${_currentLng!.toStringAsFixed(6)}]}'
        : '{"type":"Point","coordinates":[0.0,0.0]}';

    final deviceToken = await DeviceInfoService().getDeviceToken() ?? 'device_token_${DateTime.now().millisecondsSinceEpoch}';
    final request = SignupRequestModel(
      fullName: _fullNameController.text.trim(),
      emailAddress: _emailController.text.trim(),
      countryCode: _selectedCountryCode,
      countryStringCode: _selectedCountryStringCode,
      mobileNumber: int.tryParse(_mobileController.text.trim()) ?? 0,
      isSocialLogin: _isSocialLogin,
      socialId: _isSocialLogin ? 'social_id_${DateTime.now().millisecondsSinceEpoch}' : null,
      socialPlatform: _isSocialLogin ? 'flutter_app' : null,
      password: _passwordController.text,
      deviceToken: deviceToken,
      deviceType: Platform.isAndroid
          ? 'android'
          : Platform.isIOS
          ? 'ios'
          : 'web',
      location: locationString,
      address: _addressController.text.trim(),
      ln: 'en',
    );

    ref.read(authNotifierProvider.notifier).signUp(request: request);
  }

  Future<void> _initLocation() async {
    try {
      showProgressIndicator();
      final result = await _locationService.getCurrentLocationAndAddress();
      if (!mounted) return;

      _currentLat = result.latitude;
      _currentLng = result.longitude;
      if (result.address != null && result.address!.trim().isNotEmpty) {
        setState(() {
          _addressController.text = result.address!;
        });
      } else if (result.permission == LocationPermission.denied || result.permission == LocationPermission.deniedForever) {
        setState(() {
          _addressController.text = '';
        });
        showStyledToast('Location permission denied. Please enable to continue.', ToastType.warning);
      } else {
        setState(() {
          _addressController.text = '';
        });
        showStyledToast('Unable to fetch address. Please try again.', ToastType.error);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _addressController.text = '';
      });
      showStyledToast('Unable to fetch address. Please try again.', ToastType.error);
    } finally {
      dismissProgressIndicator();
    }
  }
}
