import 'package:appkit_ui_elements/src/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:macos_window_utils/macos_window_utils.dart';

/// A class that ensures that the application’s macOS window’s brightness
/// matches the given brightness.
class AppKitBrightnessOverrideHandler {
  static Brightness? _lastBrightness;

  /// Ensures that the application’s macOS window’s brightness matches
  /// [currentBrightness].
  ///
  /// For performance reasons, the brightness setting will only be overridden if
  /// [currentBrightness] differs from the value it had when this method was
  /// previously called. Therefore, it is safe to call this method frequently.
  static void ensureMatchingBrightness(Brightness currentBrightness) {
    if (currentBrightness == _lastBrightness) return;
    WindowManipulator.overrideMacOSBrightness(dark: currentBrightness.isDark);
    _lastBrightness = currentBrightness;
  }
}
