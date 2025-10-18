import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:starter_template_riverpod/core/utils/text_styles.dart';
import 'package:starter_template_riverpod/core/utils/with_opacity_extension.dart';
import 'package:starter_template_riverpod/core/widgets/common_primary_button.dart';
import 'package:starter_template_riverpod/core/widgets/common_text_field.dart';
import 'package:starter_template_riverpod/features/auth/model/signup_response_model.dart';
import 'package:starter_template_riverpod/features/auth/notifier/auth_notifier.dart';
import 'package:starter_template_riverpod/injectable/injectable.dart';
import 'package:starter_template_riverpod/services/web_service/api_helper.dart';
import 'package:starter_template_riverpod/services/web_service/api_service.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  File? _pickedImage;

  UserData? _initialUser;

  // Country/phone state (mirrors Signup screen UX)
  String _selectedCountryCode = '+91';
  String _selectedCountryStringCode = 'IN';
  Country? _selectedCountry;

  // Track if form has changes
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    final authState = ref.read(authNotifierProvider);
    _initialUser = authState.value;
    if (_initialUser != null) {
      _nameController.text = _initialUser?.fullName ?? '';
      _emailController.text = _initialUser?.emailAddress ?? '';
      _mobileController.text = _initialUser?.mobileNumber ?? '';
      _selectedCountryCode = _initialUser?.countryCode ?? _selectedCountryCode;
      _selectedCountryStringCode = _initialUser?.countryStringCode ?? _selectedCountryStringCode;
      _addressController.text = _initialUser?.address ?? '';
    }

    // Add listeners to detect changes
    _nameController.addListener(_checkForChanges);
    _mobileController.addListener(_checkForChanges);
    _addressController.addListener(_checkForChanges);

    // Initial check for changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForChanges();
    });
  }

  @override
  void dispose() {
    _nameController.removeListener(_checkForChanges);
    _mobileController.removeListener(_checkForChanges);
    _addressController.removeListener(_checkForChanges);
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _checkForChanges() {
    if (_initialUser == null) return;

    final hasTextChanges =
        _nameController.text.trim() != (_initialUser?.fullName ?? '') ||
        _mobileController.text.trim() != (_initialUser?.mobileNumber ?? '') ||
        _addressController.text.trim() != (_initialUser?.address ?? '');

    final hasCountryChanges =
        _selectedCountryCode != (_initialUser?.countryCode ?? '') || _selectedCountryStringCode != (_initialUser?.countryStringCode ?? '');

    final hasImageChanges = _pickedImage != null;

    final hasChanges = hasTextChanges || hasCountryChanges || hasImageChanges;

    if (_hasChanges != hasChanges) {
      setState(() {
        _hasChanges = hasChanges;
      });
    }
  }

  Map<String, dynamic> _buildChangedFields() {
    final Map<String, dynamic> body = {'ln': 'en'};

    if (_nameController.text.trim().isNotEmpty && _nameController.text.trim() != (_initialUser?.fullName ?? '')) {
      body['full_name'] = _nameController.text.trim();
    }
    if (_mobileController.text.trim().isNotEmpty && _mobileController.text.trim() != (_initialUser?.mobileNumber ?? '')) {
      final numeric = int.tryParse(_mobileController.text.trim());
      if (numeric != null) body['mobile_number'] = numeric;
    }
    if (_selectedCountryCode.isNotEmpty && _selectedCountryCode != (_initialUser?.countryCode ?? '')) {
      body['country_code'] = _selectedCountryCode;
    }
    if (_selectedCountryStringCode.isNotEmpty && _selectedCountryStringCode != (_initialUser?.countryStringCode ?? '')) {
      body['country_string_code'] = _selectedCountryStringCode;
    }
    if (_addressController.text.trim().isNotEmpty && _addressController.text.trim() != (_initialUser?.address ?? '')) {
      body['address'] = _addressController.text.trim();
    }

    return body;
  }

  Future<void> _pickImage() async {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, maxWidth: 2048, imageQuality: 90);
    if (picked == null) return;

    final cropped = await ImageCropper().cropImage(
      sourcePath: picked.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop',
          lockAspectRatio: true,
          hideBottomControls: true,
          showCropGrid: true,
          initAspectRatio: CropAspectRatioPreset.square,
          toolbarColor: isDark ? Colors.black : Colors.white,
          statusBarColor: isDark ? Colors.black : Colors.white,
          toolbarWidgetColor: isDark ? Colors.white : Colors.black,
          activeControlsWidgetColor: theme.primaryColor,
          dimmedLayerColor: isDark ? Colors.black87 : Colors.white70,
          cropFrameColor: theme.primaryColor,
          cropGridColor: theme.primaryColor.withOpacityExtension(0.6),
        ),
        IOSUiSettings(
          title: 'Crop',
          aspectRatioLockEnabled: true,
          aspectRatioPickerButtonHidden: true,
          resetAspectRatioEnabled: false,
          rotateButtonsHidden: true,
          rotateClockwiseButtonHidden: true,
          aspectRatioLockDimensionSwapEnabled: false,
        ),
      ],
    );

    final path = cropped?.path ?? picked.path;
    setState(() {
      _pickedImage = File(path);
    });
    _checkForChanges();
  }

  Future<void> _saveProfile() async {
    // Validate form first
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final changes = _buildChangedFields();
    if (changes.keys.where((k) => k != 'ln').isEmpty && _pickedImage == null) {
      return;
    }

    bool success = false;

    // Upload image first if any (server usually updates user_profile on upload)
    if (_pickedImage != null) {
      final ok = await ref.read(authNotifierProvider.notifier).uploadProfileImage(filePath: _pickedImage!.path);
      success = success || ok;
    }

    if (changes.keys.where((k) => k != 'ln').isNotEmpty) {
      final api = getIt<ApiService>();
      final res = await performApiCall<SignupResponseModel>(
        request: () => api.editProfile(changes),
        buildDefaultOnError: (_) => SignupResponseModel(success: false, message: 'Update failed'),
        showLoading: true,
      );

      if (res.success == true && res.data != null) {
        // Update in-memory and persisted user
        ref.read(authNotifierProvider.notifier).setUser(res.data!);
        success = true;
      }
    }

    // If anything succeeded, close this screen (return to dashboard/home)
    if (success && mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authNotifierProvider).value;
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 36.r,
                    backgroundImage: _pickedImage != null
                        ? FileImage(_pickedImage!)
                        : (user?.userProfile != null && user!.userProfile!.isNotEmpty ? NetworkImage(user.userProfile!) as ImageProvider : null),
                    child: (user?.userProfile == null || user!.userProfile!.isEmpty) && _pickedImage == null ? const Icon(Icons.person) : null,
                  ),
                  SizedBox(width: 12.w),
                  TextButton.icon(onPressed: _pickImage, icon: const Icon(Icons.edit), label: const Text('Change Photo')),
                ],
              ),
              SizedBox(height: 16.h),
              CommonTextField(
                controller: _nameController,
                labelText: 'Full name',
                hintText: 'Enter full name',
                prefixIcon: Icon(Icons.person_outline, size: 20.w, color: Theme.of(context).primaryColor),
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
              // Email field (disabled/read-only)
              CommonTextField(
                controller: _emailController,
                labelText: 'Email Address',
                hintText: 'Email address',
                readOnly: true,
                textInputFormatter: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
                fillColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade900.withValues(alpha: 0.8) : Colors.grey.shade100,
                borderColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade700 : Colors.grey.shade300,
                prefixIcon: Icon(
                  Icons.email_outlined,
                  size: 20.w,
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade500 : Colors.grey.shade600,
                ),
                style: TextHelper.size14(context).copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade500 : Colors.grey.shade700,
                ),
                labelStyle: TextHelper.size12(context).copyWith(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade500 : Colors.grey.shade700,
                ),
                hintStyle: TextHelper.size12(context).copyWith(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade600 : Colors.grey.shade500,
                ),
              ),
              SizedBox(height: 12.h),
              // Mobile field with country picker (same UX as Signup)
              CommonTextField(
                controller: _mobileController,
                labelText: 'Mobile number',
                hintText: 'Enter mobile number',
                keyboardType: TextInputType.phone,
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
                        _checkForChanges();
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
                        style: TextHelper.size14(context).copyWith(
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.grey.shade800,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(Icons.keyboard_arrow_down_rounded, color: Theme.of(context).primaryColor, size: 18.w),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              CommonTextField(
                controller: _addressController,
                labelText: 'Address',
                hintText: 'Enter address',
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                prefixIcon: Icon(Icons.location_on_outlined, size: 20.w, color: Theme.of(context).primaryColor),
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
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                child: CommonPrimaryButton(
                  label: 'Update',
                  onPressed: _hasChanges ? _saveProfile : null,
                  backgroundColor: !_hasChanges
                      ? (Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade700 : Colors.grey.shade300)
                      : null,
                  textColor: !_hasChanges ? (Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade400 : Colors.grey.shade600) : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
