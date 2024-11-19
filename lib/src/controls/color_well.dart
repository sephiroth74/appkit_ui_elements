import 'dart:async';

import 'package:appkit_ui_element_colors/appkit_ui_element_colors.dart';
import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:appkit_ui_elements/appkit_ui_elements_platform_interface.dart';
import 'package:appkit_ui_elements/src/library.dart';
import 'package:appkit_ui_elements/src/vo/color_picker_result.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:macos_ui/macos_ui.dart';

const _kWidth = 28.0;
const _kHeight = 20.0;

/// See: https://developer.apple.com/documentation/appkit/nscolorpanel/mode
class AppKitColorWell extends StatefulWidget {
  final String? uuid;
  final ValueChanged<Color>? onChanged;
  final AppKitColorPickerMode mode;
  final bool withAlpha;
  final String? semanticLabel;
  final double width;
  final double height;
  final Color? color;

  const AppKitColorWell({
    super.key,
    required this.onChanged,
    this.mode = AppKitColorPickerMode.wheel,
    this.withAlpha = false,
    this.semanticLabel,
    this.width = _kWidth,
    this.height = _kHeight,
    this.color,
    this.uuid,
  });

  @override
  State<AppKitColorWell> createState() => _AppKitColorWellState();
}

class _AppKitColorWellState extends State<AppKitColorWell> {
  late StreamSubscription<Color>? _colorSubscription;

  Color? _selectedColor;

  bool get enabled => widget.onChanged != null;

  Stream<Color>? _onColorChanged;
  Stream<Color> get onColorChanged {
    _onColorChanged ??=
        AppkitUiElementsPlatform.instance.listenForColorChange(widget.uuid);
    return _onColorChanged!;
  }

  void _handleTap() async {
    try {
      await AppkitUiElementsPlatform.instance.colorPicker(
        mode: widget.mode,
        uuid: widget.uuid,
        withAlpha: widget.withAlpha,
        color: _selectedColor,
        colorSpace: widget.mode.toColorSpaceMode(),
      );
    } on MissingPluginException {
      debugPrint('AppKitColorWell: MissingPluginException');
      debugPrint(
          'error: The app is running in a mode that does not support this plugin.');
    } catch (e) {
      debugPrint('error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.color;
    _colorSubscription = enabled
        ? onColorChanged.listen((Color color) {
            setState(() => _selectedColor = color);
            widget.onChanged?.call(color);
          })
        : null;
  }

  @override
  void dispose() {
    _colorSubscription?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AppKitColorWell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.color != widget.color) {
      _selectedColor = widget.color;
    }
  }

  @override
  Widget build(BuildContext context) {
    debugCheckHasAppKitTheme(context);

    final theme = AppKitTheme.of(context);
    Color selectedColor =
        _selectedColor ?? theme.accentColor ?? MacosColors.appleBlue;

    if (!enabled) {
      selectedColor = selectedColor.withOpacity(selectedColor.opacity * 0.5);
    }

    return Semantics(
      label: widget.semanticLabel,
      button: true,
      child: UiElementColorBuilder(builder: (context, colorContainer) {
        final colorTheme = AppKitColorWellTheme.of(context);
        return GestureDetector(
          onTap: enabled ? _handleTap : null,
          child: Container(
            padding: const EdgeInsets.all(3.0),
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colorTheme.gradientColors
                    .map((color) => color
                        .withOpacity(color.opacity * (enabled ? 1.0 : 0.5)))
                    .toList(),
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              border: Border.all(
                color: colorTheme.borderColor.withOpacity(
                    colorTheme.borderColor.opacity * (enabled ? 1.0 : 0.5)),
                width: 1.0,
              ),
            ),
            child: Container(
              color: selectedColor,
            ),
          ),
        );
      }),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
        ObjectFlagProperty<ValueChanged<Color>>('onChanged', widget.onChanged));
    properties.add(EnumProperty<AppKitColorPickerMode>('mode', widget.mode));
    properties.add(StringProperty('semanticLabel', widget.semanticLabel));
    properties.add(DoubleProperty('width', widget.width));
    properties.add(DoubleProperty('height', widget.height));
    properties.add(ColorProperty('color', widget.color));
  }
}

extension AppKitColorPickerModeX on AppKitColorPickerMode {
  ColorSpaceMode toColorSpaceMode() {
    switch (this) {
      case AppKitColorPickerMode.gray:
        return ColorSpaceMode.gray;
      case AppKitColorPickerMode.rgb:
        return ColorSpaceMode.rgb;
      case AppKitColorPickerMode.cmyk:
        return ColorSpaceMode.cmyk;
      case AppKitColorPickerMode.hsb:
        return ColorSpaceMode.lab;
      case AppKitColorPickerMode.customPalette:
        return ColorSpaceMode.deviceN;
      case AppKitColorPickerMode.colorList:
        return ColorSpaceMode.indexed;
      case AppKitColorPickerMode.wheel:
        return ColorSpaceMode.unknown;
      case AppKitColorPickerMode.crayon:
        return ColorSpaceMode.pattern;
      default:
        return ColorSpaceMode.unknown;
    }
  }
}
