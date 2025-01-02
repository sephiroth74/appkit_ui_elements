import 'package:appkit_ui_elements/src/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:macos_window_utils/macos_window_utils.dart';

class AppKitBrightnessOverrideHandler {
  static Brightness? _lastBrightness;

  static void ensureMatchingBrightness(Brightness currentBrightness) {
    if (currentBrightness == _lastBrightness) return;
    WindowManipulator.overrideMacOSBrightness(dark: currentBrightness.isDark);
    _lastBrightness = currentBrightness;
  }
}
