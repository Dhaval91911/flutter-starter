import 'package:flutter/material.dart';

/// A widget that dismisses the keyboard when tapping outside of text fields.
///
/// This widget wraps its child with a GestureDetector that calls
/// FocusScope.of(context).unfocus() when tapped, effectively dismissing
/// the keyboard.
///
/// Usage:
/// ```dart
/// KeyboardDismissible(
///   child: YourScreenContent(),
/// )
/// ```
class KeyboardDismissible extends StatelessWidget {
  final Widget child;

  const KeyboardDismissible({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside
        FocusScope.of(context).unfocus();
      },
      // Don't consume the tap event, let it pass through to child widgets
      behavior: HitTestBehavior.translucent,
      child: child,
    );
  }
}

/// Extension to easily wrap any widget with keyboard dismissal functionality
extension KeyboardDismissibleExtension on Widget {
  /// Wraps this widget with keyboard dismissal functionality
  Widget dismissKeyboardOnTap() {
    return KeyboardDismissible(child: this);
  }
}
