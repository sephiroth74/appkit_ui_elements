import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:appkit_ui_elements/src/vo/color_picker_result.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'appkit_ui_elements_method_channel.dart';

abstract class AppkitUiElementsPlatform extends PlatformInterface {
  /// Constructs a AppkitUiElementsPlatform.
  AppkitUiElementsPlatform() : super(token: _token);

  static final Object _token = Object();

  static AppkitUiElementsPlatform _instance = MethodChannelAppkitUiElements();

  /// The default instance of [AppkitUiElementsPlatform] to use.
  ///
  /// Defaults to [MethodChannelAppkitUiElements].
  static AppkitUiElementsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AppkitUiElementsPlatform] when
  /// they register themselves.
  static set instance(AppkitUiElementsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> colorPicker({
    required String? uuid,
    required AppKitColorPickerMode mode,
    bool withAlpha = false,
    Color? color,
    ColorSpaceMode colorSpace = ColorSpaceMode.unknown,
  }) {
    throw UnimplementedError('colorPicker() has not been implemented.');
  }

  Stream<Color?> listenForColorChange(String? uuid) {
    throw UnimplementedError(
        'listenForColorChange() has not been implemented.');
  }
}
