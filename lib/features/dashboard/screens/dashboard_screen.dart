import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/text_styles.dart';
import '../../../core/utils/with_opacity_extension.dart';
import '../../../route_config/route_config.dart';
import '../../../route_config/routes.dart';
import '../../auth/model/signup_response_model.dart';
import '../../auth/state_notifier/auth_notifier.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: authState.when(
          data: (userData) => userData != null ? _buildDashboard(theme, userData) : SizedBox.shrink(),
          loading: () => _buildLoadingState(theme),
          error: (error, stack) => _buildErrorState(theme, error.toString()),
        ),
      ),
    );
  }

  Widget _buildDashboard(ThemeData theme, UserData userData) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 20.h),
          _buildHeader(theme, userData),
          SizedBox(height: 32.h),
          _buildWelcomeCard(theme, userData),
          SizedBox(height: 24.h),
          _buildQuickActions(theme),
          SizedBox(height: 24.h),
          _buildUserInfoCard(theme, userData),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, UserData userData) {
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back,',
                style: TextHelper.size16(context).copyWith(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600, fontWeight: FontWeight.w400),
              ),
              SizedBox(height: 4.h),
              Text(
                userData.fullName ?? 'User',
                style: TextHelper.size24(context).copyWith(color: isDark ? Colors.white : Colors.grey.shade800, fontWeight: FontWeight.w700),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        Container(
          decoration: BoxDecoration(
            color: theme.primaryColor.withOpacityExtension(0.1),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: theme.primaryColor.withOpacityExtension(0.2), width: 1),
          ),
          child: GestureDetector(
            onTap: () => context.push(Routes.editProfile),
            child: SizedBox(
              height: 45.w,
              width: 45.w,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: (userData.userProfile != null && userData.userProfile!.isNotEmpty)
                    ? Image.network(
                        userData.userProfile!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(Icons.person_rounded, size: 24.w, color: theme.primaryColor),
                      )
                    : Icon(Icons.person_rounded, size: 24.w, color: theme.primaryColor),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeCard(ThemeData theme, UserData userData) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.primaryColor, theme.primaryColor.withOpacityExtension(0.8)],
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [BoxShadow(color: theme.primaryColor.withOpacityExtension(0.3), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.dashboard_rounded, color: Colors.white, size: 28.w),
              SizedBox(width: 12.w),
              Text(
                'Dashboard',
                style: TextHelper.size20(context).copyWith(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            'You\'re all set! Your account is ready to use.',
            style: TextHelper.size16(context).copyWith(color: Colors.white.withOpacityExtension(0.9), fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 8.h),
          Text(
            'Email: ${userData.emailAddress ?? 'N/A'}',
            style: TextHelper.size14(context).copyWith(color: Colors.white.withOpacityExtension(0.8), fontWeight: FontWeight.w400),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextHelper.size18(context).copyWith(color: isDark ? Colors.white : Colors.grey.shade800, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(child: _buildActionCard(theme, 'Privacy Policy', Icons.privacy_tip_outlined, () => context.push(Routes.privacy))),
            SizedBox(width: 12.w),
            Expanded(child: _buildActionCard(theme, 'Terms & Conditions', Icons.description_outlined, () => context.push(Routes.terms))),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(child: _buildActionCard(theme, 'About Us', Icons.info_outline, () => context.push(Routes.about))),
            SizedBox(width: 12.w),
            Expanded(child: _buildActionCard(theme, 'Change Password', Icons.lock_reset, () => context.push(Routes.changePassword))),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(child: _buildActionCard(theme, 'Delete Account', Icons.delete_forever_outlined, () => _handleDeleteAccount())),
            SizedBox(width: 12.w),
            Expanded(child: _buildActionCard(theme, 'Logout', Icons.logout, () => _handleLogout())),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(ThemeData theme, String title, IconData icon, VoidCallback onTap) {
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade800 : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200, width: 1),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 24.w, color: theme.primaryColor),
            SizedBox(height: 8.h),
            Text(
              title,
              style: TextHelper.size14(context).copyWith(color: isDark ? Colors.white : Colors.grey.shade800, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoCard(ThemeData theme, UserData userData) {
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade800 : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: isDark ? Colors.grey.shade700 : Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Information',
            style: TextHelper.size18(context).copyWith(color: isDark ? Colors.white : Colors.grey.shade800, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 16.h),
          _buildInfoRow('Full Name', userData.fullName ?? 'N/A'),
          _buildInfoRow('Email', userData.emailAddress ?? 'N/A'),
          _buildInfoRow('Phone', userData.mobileNumber?.toString() ?? 'N/A'),
          _buildInfoRow('Country', userData.countryStringCode ?? 'N/A'),
          _buildInfoRow('User Type', userData.userType ?? 'N/A'),
          _buildInfoRow('Verified', userData.isUserVerified == true ? 'Yes' : 'No'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              '$label:',
              style: TextHelper.size14(context).copyWith(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextHelper.size14(context).copyWith(color: isDark ? Colors.white : Colors.grey.shade800, fontWeight: FontWeight.w400),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: theme.primaryColor),
          SizedBox(height: 16.h),
          Text('Loading dashboard...', style: TextHelper.size16(context).copyWith(color: theme.textTheme.bodyMedium?.color)),
        ],
      ),
    );
  }

  Widget _buildErrorState(ThemeData theme, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48.w, color: Colors.red),
          SizedBox(height: 16.h),
          Text(
            'Error loading dashboard',
            style: TextHelper.size18(context).copyWith(color: theme.textTheme.bodyMedium?.color, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8.h),
          Text(
            error,
            style: TextHelper.size14(context).copyWith(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () {
              ref.invalidate(authNotifierProvider);
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        titlePadding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 6.h),
        contentPadding: EdgeInsets.fromLTRB(20.w, 6.h, 20.w, 6.h),
        actionsPadding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 6.h),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(onPressed: () => context.pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              // Close the dialog using its own context
              Navigator.of(context, rootNavigator: true).pop();

              // Use stored device token from user data to clear server session
              final authState = ref.read(authNotifierProvider);
              final userData = authState.value!; // Dashboard renders only for logged-in users
              final deviceToken = userData.deviceToken ?? 'device_token_${DateTime.now().millisecondsSinceEpoch}';

              // Perform logout
              final res = await ref.read(authNotifierProvider.notifier).logout(deviceToken: deviceToken);

              // Navigate only on successful API response
              if (res.success == true) {
                AppRouter.router.go(Routes.login);
              }
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _handleDeleteAccount() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        titlePadding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 6.h),
        contentPadding: EdgeInsets.fromLTRB(20.w, 6.h, 20.w, 6.h),
        actionsPadding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 6.h),
        title: const Text('Delete Account'),
        content: const Text('This action is permanent. Do you want to proceed?'),
        actions: [
          TextButton(onPressed: () => context.pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              // Close dialog
              Navigator.of(context, rootNavigator: true).pop();
              // Call delete account API
              final res = await ref.read(authNotifierProvider.notifier).deleteAccount();
              if (res.success == true) {
                // Clear state and go to login
                ref.read(authNotifierProvider.notifier).clearAuthState();
                AppRouter.router.go(Routes.login);
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
