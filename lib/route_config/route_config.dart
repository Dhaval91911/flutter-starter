import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:starter_template_riverpod/features/auth/screens/signin_screen.dart';
import 'package:starter_template_riverpod/features/auth/screens/signup_screen.dart';
import 'package:starter_template_riverpod/features/check_version/screens/maintenance_screen.dart';
import 'package:starter_template_riverpod/features/dashboard/screens/dashboard_screen.dart';
import 'package:starter_template_riverpod/features/network/screens/network_lost_screen.dart';
import 'package:starter_template_riverpod/features/pagination/screens/user_screen.dart';
import 'package:starter_template_riverpod/features/people/screens/people_screen.dart';
import 'package:starter_template_riverpod/features/settings/screens/about_screen.dart';
import 'package:starter_template_riverpod/features/settings/screens/change_password_screen.dart';
import 'package:starter_template_riverpod/features/settings/screens/edit_profile_screen.dart';
import 'package:starter_template_riverpod/features/settings/screens/language_screen.dart';
import 'package:starter_template_riverpod/features/settings/screens/privacy_screen.dart';
import 'package:starter_template_riverpod/features/settings/screens/terms_screen.dart';
import 'package:starter_template_riverpod/features/settings/screens/theme_switch_screen.dart';
// import 'package:starter_template_riverpod/features/home/screens/home_screen.dart';
import 'package:starter_template_riverpod/features/splash/screens/splash_screen.dart';
import 'package:starter_template_riverpod/route_config/routes.dart';

/// Slide directions
enum SlideDirection { right, left, up, down }

/// Custom transition page with slide animation
class SlideRouteTransition extends CustomTransitionPage<void> {
  SlideRouteTransition({required super.key, required super.child, SlideDirection direction = SlideDirection.left})
    : super(
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curve = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
          Offset begin;

          switch (direction) {
            case SlideDirection.right:
              begin = const Offset(-1.0, 0.0);
              break;
            case SlideDirection.left:
              begin = const Offset(1.0, 0.0);
              break;
            case SlideDirection.up:
              begin = const Offset(0.0, 1.0);
              break;
            case SlideDirection.down:
              begin = const Offset(0.0, -1.0);
              break;
          }

          return SlideTransition(
            position: Tween(begin: begin, end: Offset.zero).animate(curve),
            child: child,
          );
        },
      );
}

/// Extension to use slide animation easily
extension GoRouterStateExtension on GoRouterState {
  SlideRouteTransition slidePage(Widget child, {SlideDirection direction = SlideDirection.left}) {
    return SlideRouteTransition(key: pageKey, child: child, direction: direction);
  }
}

/// Central router class
class AppRouter {
  static late GoRouter router;

  static void init() {
    router = GoRouter(
      initialLocation: Routes.splash,
      routes: [
        GoRoute(path: Routes.splash, pageBuilder: (context, state) => state.slidePage(const SplashScreen())),
        GoRoute(path: Routes.appearances, pageBuilder: (context, state) => state.slidePage(ThemeSwitchScreen())),
        GoRoute(
          path: Routes.languages,
          pageBuilder: (context, state) {
            final map = state.extra as Map?;
            return state.slidePage(LanguageScreen(title: map?['hello'] ?? ''));
          },
        ),
        GoRoute(path: Routes.people, pageBuilder: (context, state) => state.slidePage(PeopleScreen())),
        GoRoute(path: Routes.network, pageBuilder: (context, state) => state.slidePage(NetworkLostScreen())),
        GoRoute(path: Routes.user, pageBuilder: (context, state) => state.slidePage(UserScreen())),
        GoRoute(path: Routes.login, pageBuilder: (context, state) => state.slidePage(const SignInScreen())),
        GoRoute(path: Routes.signup, pageBuilder: (context, state) => state.slidePage(const SignupScreen())),
        GoRoute(path: Routes.dashboard, pageBuilder: (context, state) => state.slidePage(const DashboardScreen())),
        GoRoute(path: Routes.terms, pageBuilder: (context, state) => state.slidePage(const TermsScreen())),
        GoRoute(path: Routes.privacy, pageBuilder: (context, state) => state.slidePage(const PrivacyScreen())),
        GoRoute(path: Routes.about, pageBuilder: (context, state) => state.slidePage(const AboutScreen())),
        GoRoute(path: Routes.changePassword, pageBuilder: (context, state) => state.slidePage(const ChangePasswordScreen())),
        GoRoute(path: Routes.editProfile, pageBuilder: (context, state) => state.slidePage(const EditProfileScreen())),
        GoRoute(
          path: Routes.maintenance,
          pageBuilder: (context, state) {
            final map = state.extra as Map?;
            return state.slidePage(MaintenanceScreen(maintenanceMessage: map?['message']));
          },
        ),
      ],
    );
  }
}
