import 'dart:async';

import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:appkit_ui_elements/appkit_ui_elements_platform_interface.dart';
import 'package:appkit_ui_elements/src/controls/appkit_plain_button.dart';
import 'package:appkit_ui_elements/src/vo/color_picker_result.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:indexed/indexed.dart';
import 'package:uuid/uuid.dart';

/// See: https://developer.apple.com/documentation/appkit/nscolorpanel/mode
class AppKitColorWell extends StatefulWidget {
  final String uuid;
  final ValueChanged<Color>? onChanged;
  final AppKitColorPickerMode mode;
  final bool withAlpha;
  final String? semanticLabel;
  final Color? color;
  final AppKitColorWellStyle style;

  /// The label for the button that opens the color picker (inside the colors popover).
  final String popoverColorsButtonLabel;

  AppKitColorWell({
    super.key,
    required this.onChanged,
    this.mode = AppKitColorPickerMode.wheel,
    this.withAlpha = false,
    this.semanticLabel,
    this.color,
    this.style = AppKitColorWellStyle.regular,
    this.popoverColorsButtonLabel = 'Show Colors...',
  }) : uuid = const Uuid().v4();

  @override
  State<AppKitColorWell> createState() => _AppKitColorWellState();
}

class _AppKitColorWellState extends State<AppKitColorWell> {
  StreamSubscription<Color?>? _colorSubscription;

  Color? _selectedColor;

  bool _isDown = false;

  bool isHovered = false;

  bool get enabled => widget.onChanged != null;

  final LayerLink _layerLink = LayerLink();

  Stream<Color?>? _onColorChanged;

  Stream<Color?> get onColorChanged {
    _onColorChanged ??=
        AppKitUiElementsPlatform.instance.listenForColorChange(widget.uuid);
    return _onColorChanged!;
  }

  bool get _isColorPickerOpened =>
      _colorSubscription != null || context.isPopoverVisible(widget.uuid);

  set isDown(bool value) {
    if (_isDown != value) {
      setState(() {
        _isDown = value;
      });
    }
  }

  void _handleMouseEnter() {
    setState(() {
      isHovered = true;
    });
  }

  void _handleMouseExit() {
    setState(() {
      isHovered = false;
    });
  }

  void _handleTapColorPicker() {
    _showColorPicker(mode: widget.mode, withAlpha: widget.withAlpha);
  }

  void _handleTapColorSwatches() {
    _showColorSwatchesPopover();
  }

  void _handleTapDown() {
    if (!enabled || _isColorPickerOpened) return;
    isDown = true;
  }

  void _handleTapCancel() {
    if (!enabled || _isColorPickerOpened) return;
    isDown = false;
  }

  void _showColorPicker(
      {required AppKitColorPickerMode mode, required bool withAlpha}) async {
    if (!enabled || _isColorPickerOpened) {
      return;
    }

    isDown = true;

    _colorSubscription ??= onColorChanged.listen((Color? color) {
      if (color == null) {
        _onColorChanged = null;
        _colorSubscription?.cancel();
        _colorSubscription = null;
        isDown = false;
        return;
      }

      setState(() => _selectedColor = color);
      widget.onChanged?.call(color);
    });

    try {
      await AppKitUiElementsPlatform.instance.colorPicker(
        mode: mode,
        uuid: widget.uuid,
        withAlpha: withAlpha,
        color: _selectedColor,
        colorSpace: mode.toColorSpaceMode(),
      );
    } on MissingPluginException {
      debugPrint('AppKitColorWell: MissingPluginException');
      debugPrint(
          'error: The app is running in a mode that does not support this plugin.');
    } catch (e) {
      debugPrint('error: $e');
    }
  }

  void _showColorSwatchesPopover() async {
    if (!enabled || _isColorPickerOpened) {
      return;
    }

    setState(() {
      _isDown = true;
    });

    final buttonRect = context.getWidgetBounds();
    final link = buttonRect == null ? _layerLink : null;

    final result = await context.showPopover(
      context,
      transitionDuration: const Duration(milliseconds: 200),
      itemRect: buttonRect,
      link: link,
      targetAnchor: Alignment.bottomCenter,
      direction: AppKitMenuEdge.auto,
      showArrow: true,
      child: AppKitColorWellPopover(
          popoverColorsButtonLabel: widget.popoverColorsButtonLabel),
      uuid: widget.uuid,
    );

    if (result == AppKitColorWellPopover.SHOW_COLORS) {
      _showColorPicker(mode: AppKitColorPickerMode.wheel, withAlpha: false);
    } else if (result is Color) {
      setState(() {
        _selectedColor = result;
        _isDown = false;
      });
      widget.onChanged?.call(result);
    } else {
      setState(() {
        _isDown = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.color;
  }

  @override
  void dispose() {
    _colorSubscription?.cancel();
    if (_colorSubscription != null) {
      _onColorChanged = null;
    }
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
    Color selectedColor = _selectedColor ?? theme.primaryColor;

    if (!enabled) {
      selectedColor = selectedColor.withOpacity(selectedColor.opacity * 0.5);
    }

    return Semantics(
      label: widget.semanticLabel,
      button: true,
      child: MainWindowBuilder(builder: (context, isMainWindow) {
        final theme = AppKitTheme.of(context);
        final colorTheme = AppKitColorWellTheme.of(context);
        return MouseRegion(
          onEnter: enabled ? (_) => _handleMouseEnter() : null,
          onExit: enabled ? (_) => _handleMouseExit() : null,
          child: CompositedTransformTarget(
            link: _layerLink,
            child: Builder(builder: (context) {
              if (widget.style == AppKitColorWellStyle.regular) {
                return _ColorWellRegularWidget(
                  onTap: enabled ? _handleTapColorPicker : null,
                  onTapDown: enabled ? _handleTapDown : null,
                  onTapCancel: enabled ? _handleTapCancel : null,
                  colorTheme: colorTheme,
                  theme: theme,
                  selectedColor: selectedColor,
                  isDown: _isDown,
                  isHovered: isHovered,
                );
              } else if (widget.style == AppKitColorWellStyle.expanded) {
                return _ColorWellExpandedWidget(
                  onTapPicker: enabled ? _handleTapColorPicker : null,
                  onTapPopover: enabled ? _handleTapColorSwatches : null,
                  onTapDown: enabled ? _handleTapDown : null,
                  onTapCancel: enabled ? _handleTapCancel : null,
                  colorTheme: colorTheme,
                  theme: theme,
                  selectedColor: selectedColor,
                  isDown: _isDown,
                  isHovered: isHovered,
                );
              } else {
                return _ColorWellMinimalWidget(
                  onTap: enabled ? _handleTapColorSwatches : null,
                  onTapDown: enabled ? _handleTapDown : null,
                  onTapCancel: enabled ? _handleTapCancel : null,
                  colorTheme: colorTheme,
                  theme: theme,
                  selectedColor: selectedColor,
                  isDown: _isDown,
                  isHovered: isHovered,
                );
              }
            }),
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
    properties.add(ColorProperty('color', widget.color));
    properties.add(EnumProperty<AppKitColorWellStyle>('style', widget.style));
  }
}

class _ColorWellMinimalWidget extends StatelessWidget {
  static const _kWidth = 38.0;
  static const _kHeight = 24.0;

  final AppKitThemeData theme;
  final AppKitColorWellThemeData colorTheme;
  final Color selectedColor;
  final bool isDown;
  final bool isHovered;
  final VoidCallback? onTap;
  final VoidCallback? onTapDown;
  final VoidCallback? onTapCancel;
  bool get enabled => onTap != null;

  const _ColorWellMinimalWidget({
    required this.theme,
    required this.colorTheme,
    required this.selectedColor,
    required this.isDown,
    required this.isHovered,
    this.onTap,
    this.onTapDown,
    this.onTapCancel,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isDark = theme.brightness == Brightness.dark;
      final finalConstraints = constraints.isTight
          ? constraints
              .copyWith(minWidth: _kWidth, minHeight: _kHeight)
              .normalize()
          : const BoxConstraints(
              maxWidth: _kWidth,
              maxHeight: _kHeight,
              minHeight: _kHeight,
              minWidth: _kWidth);

      return ConstrainedBox(
        constraints: finalConstraints,
        child: GestureDetector(
          onTap: enabled ? () => onTap?.call() : null,
          onTapDown: enabled ? (_) => onTapDown?.call() : null,
          onTapCancel: enabled ? () => onTapCancel?.call() : null,
          child: Container(
            foregroundDecoration: isDown
                ? BoxDecoration(
                    color: (isDark
                            ? AppKitColors.controlColor.darkColor
                            : Colors.black)
                        .withOpacity(0.1),
                    borderRadius:
                        BorderRadius.circular(colorTheme.borderRadiusMinimal))
                : null,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(colorTheme.borderRadiusMinimal),
              color: selectedColor,
              border: Border.all(
                  color: (isDark
                      ? Colors.white.withOpacity(0.75)
                      : Colors.black.withOpacity(0.25)),
                  width: 0.5),
            ),
            child: isHovered
                ? Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.2),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(1.0),
                          child: RotatedBox(
                            quarterTurns: 1,
                            child: Icon(
                              Icons.chevron_right,
                              size: 12.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : null,
          ),
        ),
      );
    });
  }
}

enum _ColorWellExpandedWidgetType {
  picker,
  popover,
}

class _ColorWellExpandedWidget extends StatefulWidget {
  static const _kWidth = 58.0;
  static const _kHeight = 25.0;

  final AppKitThemeData theme;
  final AppKitColorWellThemeData colorTheme;
  final Color selectedColor;
  final bool isDown;
  final bool isHovered;
  final VoidCallback? onTapPicker;
  final VoidCallback? onTapPopover;
  final VoidCallback? onTapDown;
  final VoidCallback? onTapCancel;
  const _ColorWellExpandedWidget({
    required this.theme,
    required this.colorTheme,
    required this.selectedColor,
    required this.isDown,
    required this.isHovered,
    this.onTapPicker,
    this.onTapPopover,
    this.onTapDown,
    this.onTapCancel,
  });

  @override
  State<_ColorWellExpandedWidget> createState() =>
      _ColorWellExpandedWidgetState();
}

class _ColorWellExpandedWidgetState extends State<_ColorWellExpandedWidget> {
  bool get enabled => widget.onTapPicker != null && widget.onTapPopover != null;

  _ColorWellExpandedWidgetType? _state;

  void _handleTapDown() {
    if (widget.isDown) return;
    widget.onTapDown?.call();
  }

  void _handleTapCancel() {
    if (!widget.isDown) return;
    widget.onTapCancel?.call();
  }

  void _handleTapPopover() {
    widget.onTapPopover?.call();
  }

  void _handleTapPicker() {
    widget.onTapPicker?.call();
  }

  void _handleMouseEnter(_ColorWellExpandedWidgetType type) {
    debugPrint('handleMouseEnter($type)');
    setState(() {
      _state = type;
    });
  }

  void _handleMouseExit(_ColorWellExpandedWidgetType type) {
    debugPrint('handleMouseExit($type)');
    if (_state == type) {
      setState(() {
        _state = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isDark = widget.theme.brightness == Brightness.dark;
      final finalConstraints = constraints.isTight
          ? constraints
              .copyWith(
                  minWidth: _ColorWellExpandedWidget._kWidth,
                  minHeight: _ColorWellExpandedWidget._kHeight)
              .normalize()
          : const BoxConstraints(
              maxWidth: _ColorWellExpandedWidget._kWidth,
              maxHeight: _ColorWellExpandedWidget._kHeight,
              minHeight: _ColorWellExpandedWidget._kHeight,
              minWidth: _ColorWellExpandedWidget._kWidth);

      return GestureDetector(
        onTapDown: enabled ? (_) => _handleTapDown() : null,
        onTapCancel: enabled ? () => _handleTapCancel() : null,
        onTap: enabled
            ? () {
                debugPrint('handleTap($_state)');
                if (_state == _ColorWellExpandedWidgetType.popover) {
                  _handleTapPopover();
                } else if (_state == _ColorWellExpandedWidgetType.picker) {
                  _handleTapPicker();
                }
              }
            : null,
        child: ConstrainedBox(
          constraints: finalConstraints,
          child: Container(
            foregroundDecoration: widget.isDown
                ? BoxDecoration(
                    color:
                        (isDark ? Colors.white : Colors.black).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(
                        widget.colorTheme.borderRadiusExpanded))
                : null,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    widget.colorTheme.borderRadiusExpanded),
                color: (isDark ? Colors.white.withOpacity(0.7) : Colors.white),
                border: GradientBoxBorder(
                  gradient: LinearGradient(
                    colors: [
                      (isDark
                              ? AppKitColors.text.opaque.secondary.darkColor
                              : AppKitColors.text.opaque.tertiary)
                          .multiplyOpacity(0.55),
                      (isDark
                              ? AppKitColors.text.opaque.tertiary.darkColor
                              : AppKitColors.text.opaque.secondary)
                          .multiplyOpacity(0.75)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  width: 0.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppKitColors.shadowColor.withOpacity(0.2),
                    offset: const Offset(0, 0.5),
                    blurRadius: 0.25,
                  ),
                ]),
            child: Row(mainAxisSize: MainAxisSize.max, children: [
              Flexible(
                flex: 1,
                child: MouseRegion(
                  onEnter: enabled
                      ? (_) => _handleMouseEnter(
                          _ColorWellExpandedWidgetType.popover)
                      : null,
                  onExit: enabled
                      ? (_) =>
                          _handleMouseExit(_ColorWellExpandedWidgetType.popover)
                      : null,
                  child: GestureDetector(
                    // behavior: HitTestBehavior.opaque,
                    // onTapUp: enabled ? (_) => _handleTapPopover() : null,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                              widget.colorTheme.borderRadiusExpanded),
                          bottomLeft: Radius.circular(
                              widget.colorTheme.borderRadiusExpanded),
                        ),
                        color: widget.selectedColor,
                      ),
                      child: widget.isHovered
                          ? Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black.withOpacity(0.2),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(1.0),
                                    child: RotatedBox(
                                      quarterTurns: 1,
                                      child: Icon(
                                        Icons.chevron_right,
                                        size: 12.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 0,
                child: MouseRegion(
                  onEnter: enabled
                      ? (_) =>
                          _handleMouseEnter(_ColorWellExpandedWidgetType.picker)
                      : null,
                  onExit: enabled
                      ? (_) =>
                          _handleMouseExit(_ColorWellExpandedWidgetType.picker)
                      : null,
                  child: GestureDetector(
                    // onTapUp: enabled ? (_) => _handleTapPicker() : null,
                    // behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 20.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(
                              widget.colorTheme.borderRadiusExpanded),
                          bottomRight: Radius.circular(
                              widget.colorTheme.borderRadiusExpanded),
                        ),
                        color: widget.theme.controlColor,
                      ),
                      child: Center(
                          child: Image.asset('assets/icons/color_well.png',
                              package: 'appkit_ui_elements', width: 15.0)),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      );
    });
  }
}

class _ColorWellRegularWidget extends StatelessWidget {
  static const _kWidth = 39.0;
  static const _kHeight = 25.0;

  const _ColorWellRegularWidget({
    required this.colorTheme,
    required this.selectedColor,
    required this.theme,
    required this.isDown,
    required this.isHovered,
    required this.onTap,
    required this.onTapDown,
    required this.onTapCancel,
  });

  final AppKitThemeData theme;
  final AppKitColorWellThemeData colorTheme;
  final Color selectedColor;
  final bool isDown;
  final bool isHovered;
  final VoidCallback? onTap;
  final VoidCallback? onTapDown;
  final VoidCallback? onTapCancel;

  bool get enabled => onTap != null;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isDark = theme.brightness == Brightness.dark;
      final finalConstraints = constraints.isTight
          ? constraints
              .copyWith(minWidth: _kWidth, minHeight: _kHeight)
              .normalize()
          : const BoxConstraints(
              maxWidth: _kWidth,
              maxHeight: _kHeight,
              minHeight: _kHeight,
              minWidth: _kWidth);

      return ConstrainedBox(
        constraints: finalConstraints,
        child: GestureDetector(
          onTapDown: enabled ? (_) => onTapDown?.call() : null,
          onTapCancel: enabled ? () => onTapCancel?.call() : null,
          onTap: enabled ? () => onTap?.call() : null,
          child: Container(
            foregroundDecoration: isDown
                ? BoxDecoration(
                    color:
                        (isDark ? Colors.white : Colors.black).withOpacity(0.2),
                    borderRadius:
                        BorderRadius.circular(colorTheme.borderRadiusRegular))
                : null,
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(colorTheme.borderRadiusRegular),
                color:
                    isDark ? AppKitColors.controlColor.darkColor : Colors.white,
                border: GradientBoxBorder(
                  gradient: LinearGradient(
                    colors: [
                      (isDark
                              ? AppKitColors.text.opaque.quaternary
                              : AppKitColors.text.opaque.tertiary)
                          .multiplyOpacity(0.55),
                      (isDark
                              ? AppKitColors.text.opaque.tertiary
                              : AppKitColors.text.opaque.secondary)
                          .multiplyOpacity(0.75)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  width: 0.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(0, 0.5),
                    blurRadius: 0.25,
                  ),
                ]),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: DecoratedBox(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          colorTheme.borderRadiusRegularInner),
                      border: Border.all(
                          color: Colors.black.withOpacity(0.2), width: 0.5),
                      color: selectedColor)),
            ),
          ),
        ),
      );
    });
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

class AppKitColorWellPopover extends StatefulWidget {
  final String popoverColorsButtonLabel;
  static const swatchSize = Size(13.0, 13.0);
  static const swatchPadding = EdgeInsets.all(0.5);
  // ignore: constant_identifier_names
  static const SHOW_COLORS = 'show-colors';

  static final systemColors = [
    AppKitColors.systemRed.color,
    AppKitColors.systemOrange.color,
    AppKitColors.systemYellow.color,
    AppKitColors.systemGreen.color,
    AppKitColors.systemCyan.color,
    AppKitColors.systemBlue.color,
    AppKitColors.systemPurple.color,
    AppKitColors.systemPink.color,
    AppKitColors.systemBrown.color,
    Colors.white,
    AppKitColors.systemGray.color,
    Colors.black,
  ];

  static const swatches = [
    [
      Color(0x00000000),
      Color(0xFFFFFFFF),
      Color(0xFFEBEBEB),
      Color(0xFFD6D6D6),
      Color(0xFFC0C0C0),
      Color(0xFFAAAAAA),
      Color(0xFF929292),
      Color(0xFF7A7A7A),
      Color(0xFF606060),
      Color(0xFF444444),
      Color(0xFF232323),
      Color(0xFF000000),
    ],
    [
      Color(0xff003748),
      Color(0xff001e55),
      Color(0xff0e0639),
      Color(0xff2d073c),
      Color(0xFF3d061a),
      Color(0xFF5e0002),
      Color(0xff5e1904),
      Color(0xff593308),
      Color(0xff563c0a),
      Color(0xff686215),
      Color(0xff515713),
      Color(0xFF263e14)
    ],
    [
      Color(0xff004d63),
      Color(0xff003077),
      Color(0xff160c50),
      Color(0xff440d56),
      Color(0xff560f2a),
      Color(0xff860605),
      Color(0xff7d2706),
      Color(0xff7d4a0e),
      Color(0xff7a5613),
      Color(0xff908520),
      Color(0xff71771f),
      Color(0xff395821),
    ],
    [
      Color(0xff006D8F),
      Color(0xff0042AA),
      Color(0xff2C1376),
      Color(0xff61177C),
      Color(0xff791A3E),
      Color(0xffB51A00),
      Color(0xffAD3E00),
      Color(0xffA96800),
      Color(0xffA77B00),
      Color(0xffC4BC00),
      Color(0xff9AA60E),
      Color(0xff4F7A28),
    ],
    [
      Color(0xFF008CB4),
      Color(0xFF0056D6),
      Color(0xFF371A94),
      Color(0xFF7B219F),
      Color(0xFF9A244F),
      Color(0xFFE32400),
      Color(0xFFD95000),
      Color(0xFFD58400),
      Color(0xFFD29D00),
      Color(0xFFF5EC00),
      Color(0xFFC3D117),
      Color(0xFF669C35),
    ],
    [
      Color(0xFF00A3D7),
      Color(0xFF0061FF),
      Color(0xFF4D22B3),
      Color(0xFF9929BD),
      Color(0xFFB92D5D),
      Color(0xFFFF4013),
      Color(0xFFFF6A00),
      Color(0xFFFFAA00),
      Color(0xFFFEC700),
      Color(0xFFFFFC41),
      Color(0xFFD9EB37),
      Color(0xFF77BB41),
    ],
    [
      Color(0xFF00C7FC),
      Color(0xFF3A88FE),
      Color(0xFF5E30EB),
      Color(0xFFBE38F3),
      Color(0xFFE63B7A),
      Color(0xFFFF6251),
      Color(0xFFFF8647),
      Color(0xFFFFB43F),
      Color(0xFFFECB3E),
      Color(0xFFFFF76B),
      Color(0xFFE4EF65),
      Color(0xFF96D35F),
    ],
    [
      Color(0xFF53D5FD),
      Color(0xFF74A7FE),
      Color(0xFF874EFE),
      Color(0xFFD357FE),
      Color(0xFFED719E),
      Color(0xFFFF8C82),
      Color(0xFFFFA57D),
      Color(0xFFFFC677),
      Color(0xFFFFD877),
      Color(0xFFFFF995),
      Color(0xFFEBF38F),
      Color(0xFFB1DD8C),
    ],
    [
      Color(0xFF94E3FE),
      Color(0xFFA8C6FE),
      Color(0xFFB18CFE),
      Color(0xFFE392FE),
      Color(0xFFF4A4C0),
      Color(0xFFFFB5AF),
      Color(0xFFFFC4AB),
      Color(0xFFFFD9A8),
      Color(0xFFFFE4A8),
      Color(0xFFFFFBB9),
      Color(0xFFF2F7B7),
      Color(0xFFCCE8B5),
    ],
    [
      Color(0xFFCAF0FE),
      Color(0xFFD4E3FE),
      Color(0xFFD9CAFE),
      Color(0xFFF1C9FE),
      Color(0xFFF9D3E0),
      Color(0xFFFFDAD8),
      Color(0xFFFFE2D6),
      Color(0xFFFFECD5),
      Color(0xFFFFF2D5),
      Color(0xFFFEFCDD),
      Color(0xFFF8FADB),
      Color(0xFFE0EDD4),
    ]
  ];

  const AppKitColorWellPopover({
    super.key,
    required this.popoverColorsButtonLabel,
  });

  @override
  State<AppKitColorWellPopover> createState() => _AppKitColorWellPopoverState();
}

class _AppKitColorWellPopoverState extends State<AppKitColorWellPopover> {
  @override
  Widget build(BuildContext context) {
    final swatchWidth = AppKitColorWellPopover.swatchSize.width +
        AppKitColorWellPopover.swatchPadding.horizontal;
    final swatchHeight = AppKitColorWellPopover.swatchSize.height +
        AppKitColorWellPopover.swatchPadding.vertical;

    return Builder(
      builder: (context) {
        final theme = AppKitTheme.of(context);
        final systemSwatches = Indexer(
            children:
                AppKitColorWellPopover.systemColors.mapIndexed((index, color) {
          final isHovered =
              _hoveredSwatch == color && _hoveredSwatchRowIndex == 0;
          return AppKitColorWellSwatch(
            color: color,
            left: index * swatchWidth,
            top: 0,
            rowIndex: 0,
            index: isHovered
                ? AppKitColorWellPopover.systemColors.length + 1
                : index,
            isHovered: isHovered,
            onTap: (value) => _handleColorTap(value.$1, value.$2),
            onMouseEnter: (value) => _handleMouseEnter(value.$1, value.$2),
            onMouseExit: (_) => _handleMouseExit(),
          );
        }).toList());

        final swatchesRows = AppKitColorWellPopover.swatches
            .mapIndexed(
              (rowIndex, row) => Indexed(
                index: _hoveredSwatchRowIndex == rowIndex + 1
                    ? AppKitColorWellPopover.swatches.length + 1
                    : rowIndex,
                child: Positioned(
                  top: rowIndex * swatchHeight,
                  left: 0,
                  child: SizedBox(
                    width: row.length * swatchWidth,
                    height: swatchHeight,
                    child: Indexer(
                        alignment: Alignment.center,
                        children: row.mapIndexed((index, color) {
                          final isHovered = _hoveredSwatch == color &&
                              _hoveredSwatchRowIndex == rowIndex + 1;
                          return AppKitColorWellSwatch(
                            left: index * swatchWidth,
                            top: 0,
                            rowIndex: rowIndex + 1,
                            index: isHovered ? row.length + 1 : index,
                            isHovered: isHovered,
                            color: color,
                            onTap: (value) =>
                                _handleColorTap(value.$1, value.$2),
                            onMouseEnter: (value) =>
                                _handleMouseEnter(value.$1, value.$2),
                            onMouseExit: (_) => _handleMouseExit(),
                          );
                        }).toList()),
                  ),
                ),
              ),
            )
            .toList();

        return IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: AppKitColorWellPopover.systemColors.length * swatchWidth,
                height: swatchHeight,
                child: systemSwatches,
              ),
              const SizedBox(height: 6.0),
              SizedBox(
                width: AppKitColorWellPopover.systemColors.length * swatchWidth,
                height: AppKitColorWellPopover.swatches.length * swatchHeight,
                child: Indexer(
                  children: [
                    ...swatchesRows,
                  ],
                ),
              ),
              const SizedBox(height: 4.0),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: AppKitPlainButton(
                      onPressed: () => Navigator.of(context)
                          .pop(AppKitColorWellPopover.SHOW_COLORS),
                      child: Text(
                        widget.popoverColorsButtonLabel,
                        style:
                            theme.typography.caption1.copyWith(fontSize: 9.0),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Color? _hoveredSwatch;

  int _hoveredSwatchRowIndex = -1;

  void _handleColorTap(int rowIndex, Color color) {
    Navigator.of(context).pop(color);
  }

  void _handleMouseEnter(int rowIndex, Color color) {
    setState(() {
      _hoveredSwatch = color;
      _hoveredSwatchRowIndex = rowIndex;
    });
  }

  void _handleMouseExit() {
    setState(() {
      _hoveredSwatch = null;
      _hoveredSwatchRowIndex = -1;
    });
  }
}

class AppKitColorWellSwatch extends StatefulWidget with IndexedInterface {
  final Color color;
  final ValueChanged<(int, Color)>? onMouseEnter;
  final ValueChanged<(int, Color)>? onMouseExit;
  final ValueChanged<(int, Color)>? onTap;
  final bool isHovered;
  final double left;
  final double top;
  final int rowIndex;

  @override
  final int index;

  AppKitColorWellSwatch({
    required this.color,
    required this.left,
    required this.top,
    required this.index,
    required this.rowIndex,
    this.onMouseEnter,
    this.onMouseExit,
    this.onTap,
    this.isHovered = false,
  }) : super(key: ValueKey((rowIndex, color)));

  @override
  State<AppKitColorWellSwatch> createState() => _AppKitColorWellSwatchState();
}

class _AppKitColorWellSwatchState extends State<AppKitColorWellSwatch> {
  bool get enabled => widget.color.alpha > 0;

  void _handleMouseEnter() {
    widget.onMouseEnter?.call((widget.rowIndex, widget.color));
  }

  void _handleMouseExit() {
    widget.onMouseExit?.call((widget.rowIndex, widget.color));
  }

  void _handleTap() {
    widget.onTap?.call((widget.rowIndex, widget.color));
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = !enabled
        ? Colors.transparent
        : AppKitColors.systemGray.withOpacity(0.5);
    return Positioned(
      left: widget.left,
      top: widget.top,
      child: Padding(
        padding: const EdgeInsets.all(0.5),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: enabled ? () => _handleTap() : null,
          child: MouseRegion(
            onEnter: enabled ? (_) => _handleMouseEnter() : null,
            onExit: enabled ? (_) => _handleMouseExit() : null,
            child: Container(
              width: AppKitColorWellPopover.swatchSize.width,
              height: AppKitColorWellPopover.swatchSize.height,
              color: widget.color,
              foregroundDecoration: BoxDecoration(
                border: Border.all(color: borderColor, width: 1.0),
              ),
              child: CustomPaint(
                painter:
                    _ColorHoveredBorderPainter(isHovered: widget.isHovered),
                child: CustomPaint(painter: _ColorPainter(color: widget.color)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ColorHoveredBorderPainter extends CustomPainter {
  final bool isHovered;

  _ColorHoveredBorderPainter({required this.isHovered});

  @override
  void paint(Canvas canvas, Size size) {
    if (!isHovered) return;

    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final roundedRect = RRect.fromLTRBR(
        -3, -3, size.width + 3, size.height + 3, const Radius.circular(2.0));
    canvas.drawRRect(roundedRect, paint);

    paint.style = PaintingStyle.stroke;
    paint.color = Colors.black.withOpacity(0.5);

    canvas.drawRRect(roundedRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this ||
        (oldDelegate as _ColorHoveredBorderPainter).isHovered != isHovered;
  }
}

class _ColorPainter extends CustomPainter {
  final Color color;

  _ColorPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.alpha == 0 ? Colors.white : color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    canvas.drawRect(Offset.zero & size, paint);

    if (color.alpha == 0) {
      paint
        ..style = PaintingStyle.stroke
        ..color = Colors.red
        ..strokeWidth = 1.0;

      canvas.drawLine(Offset(0, size.height), Offset(size.width, 0), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this || (oldDelegate as _ColorPainter).color != color;
  }
}
