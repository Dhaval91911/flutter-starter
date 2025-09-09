import 'package:flutter/material.dart';

extension ColorOpacityExtension on Color {
  /// Returns a new color with the given [opacity] (from 0.0 to 1.0).
  Color withOpacityExtension(double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0);
    return withAlpha((opacity * 255).round());
  }
}
