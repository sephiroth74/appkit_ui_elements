import 'dart:async';

import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:appkit_ui_elements/src/vo/color_picker_result.dart';
import 'package:flutter/services.dart';

import 'appkit_ui_elements_platform_interface.dart';

/// An implementation of [AppKitUiElementsPlatform] that uses method channels.
class MethodChannelAppkitUiElements extends AppKitUiElementsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  @protected
  final methodChannel = const MethodChannel('dev.sephiroth74.appkit_ui_elements');

  @visibleForTesting
  @protected
  final eventChannel = const EventChannel('dev.sephiroth74.appkit_ui_elements/color_picker');

  Stream<dynamic>? _colorPickerListener;

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<void> colorPicker({
    required String? uuid,
    required AppKitColorPickerMode mode,
    bool withAlpha = false,
    Color? color,
    ColorSpaceMode colorSpace = ColorSpaceMode.unknown,
  }) async {
    final rgba = color != null ? RGBAColor.fromColor(color, mode: colorSpace) : null;

    await methodChannel.invokeMethod<void>('colorPicker', {
      'mode': mode.name,
      'uuid': uuid,
      'alpha': withAlpha,
      'color': rgba?.toJson(),
    });
  }

  @override
  Stream<Color?> listenForColorChange(String? uuid) {
    final listener = _colorPickerListener ??= eventChannel.receiveBroadcastStream();
    return listener
        .where((event) {
          if (event is! Map<dynamic, dynamic>) {
            throw Exception('cannot cast event to Map<dynamic, dynamic>');
          }
          if (event.containsKey('uuid')) {
            return event['uuid'] == uuid;
          } else {
            return uuid == null;
          }
        })
        .map((event) {
          final decoded = event as Map<dynamic, dynamic>;
          final action = decoded['action'] as String;
          if (action == 'close' || !decoded.containsKey('color')) {
            return null;
          }
          final color = decoded['color'] as Map<dynamic, dynamic>;
          final rgba = RGBAColor.fromJson(color);
          return rgba.toColor();
        });
  }
}
