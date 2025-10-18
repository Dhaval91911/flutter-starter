import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/validators.dart';
import '../../../core/widgets/common_primary_button.dart';
import '../../../core/widgets/common_text_field.dart';
// removed router imports; we will pop on success
import '../../auth/state_notifier/auth_notifier.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _ob1 = true, _ob2 = true, _ob3 = true;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Change Password')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CommonTextField(
                controller: _currentController,
                labelText: 'Current Password',
                hintText: 'Enter current password',
                obscureText: _ob1,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                textInputFormatter: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
                prefixIcon: Icon(Icons.lock_outline, size: 20.w, color: theme.primaryColor),
                suffixIcon: IconButton(
                  icon: Icon(_ob1 ? Icons.visibility_off : Icons.visibility, color: theme.primaryColor),
                  onPressed: () => setState(() => _ob1 = !_ob1),
                ),
                validator: Validators.validateCurrentPassword,
              ),
              SizedBox(height: 12.h),
              CommonTextField(
                controller: _newController,
                labelText: 'New Password',
                hintText: 'Enter new password',
                obscureText: _ob2,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                textInputFormatter: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
                prefixIcon: Icon(Icons.lock_outline, size: 20.w, color: theme.primaryColor),
                suffixIcon: IconButton(
                  icon: Icon(_ob2 ? Icons.visibility_off : Icons.visibility, color: theme.primaryColor),
                  onPressed: () => setState(() => _ob2 = !_ob2),
                ),
                validator: Validators.validateNewPassword,
              ),
              SizedBox(height: 12.h),
              CommonTextField(
                controller: _confirmController,
                labelText: 'Confirm Password',
                hintText: 'Re-enter new password',
                obscureText: _ob3,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                textInputFormatter: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
                prefixIcon: Icon(Icons.lock_outline, size: 20.w, color: theme.primaryColor),
                suffixIcon: IconButton(
                  icon: Icon(_ob3 ? Icons.visibility_off : Icons.visibility, color: theme.primaryColor),
                  onPressed: () => setState(() => _ob3 = !_ob3),
                ),
                validator: (v) => Validators.validateConfirmPassword(v, _newController.text),
              ),
              SizedBox(height: 24.h),
              CommonPrimaryButton(
                label: 'Update Password',
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  final res = await ref
                      .read(authNotifierProvider.notifier)
                      .changePassword(oldPassword: _currentController.text.trim(), newPassword: _newController.text.trim());
                  if (res.success == true) {
                    if (!context.mounted) return;
                    Navigator.pop(context);
                  }
                },
                padding: EdgeInsets.symmetric(vertical: 14.h),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
