import 'dart:math';

import 'package:appkit_ui_element_colors/appkit_ui_element_colors.dart';
import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:appkit_ui_elements/src/library.dart';
import 'package:appkit_ui_elements/src/utils/main_window_listener.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:macos_ui/macos_ui.dart';

class AppKitToggleButton extends StatefulWidget {
  const AppKitToggleButton({
    super.key,
    required this.onChanged,
    required this.type,
    required this.childOn,
    required this.childOff,
    required this.isOn,
    this.padding,
    this.semanticLabel,
    this.color,
    this.mouseCursor = SystemMouseCursors.basic,
    this.controlSize = AppKitControlSize.regular,
  });

  final bool isOn;
  final EdgeInsetsGeometry? padding;
  final ValueChanged<bool>? onChanged;
  final String? semanticLabel;
  final MouseCursor mouseCursor;
  final AppKitToggleButtonType type;
  final Widget childOn;
  final Widget childOff;
  final AppKitControlSize controlSize;
  final Color? color;

  bool get enabled => onChanged != null;

  @override
  State<AppKitToggleButton> createState() => _AppKitToggleButtonState();
}

class _AppKitToggleButtonState extends State<AppKitToggleButton> {
  @visibleForTesting
  bool buttonHeldDown = false;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<AppKitToggleButtonType>('type', widget.type));
    properties.add(
        EnumProperty<AppKitControlSize>('controlSize', widget.controlSize));
    properties.add(
        DiagnosticsProperty<EdgeInsetsGeometry>('padding', widget.padding));
    properties.add(StringProperty('semanticLabel', widget.semanticLabel));
    properties.add(
        DiagnosticsProperty<MouseCursor>('mouseCursor', widget.mouseCursor));
    properties.add(
        FlagProperty('enabled', value: widget.enabled, ifFalse: 'disabled'));
    properties.add(DiagnosticsProperty<Color>('color', widget.color));
  }

  Color _getBackgroundColor({
    required AppKitThemeData theme,
    required Color accentColor,
    required bool isDark,
    required bool isMainWindow,
  }) {
    return _BoxDecorationBuilder.buildBoxDecoration(
      theme: theme,
      accentColor: accentColor,
      isEnabled: widget.enabled,
      isDark: isDark,
      isMainWindow: isMainWindow,
      type: widget.type,
      isOn: widget.isOn,
    ).color!;
  }

  Color _getForegroundColor({
    required AppKitThemeData theme,
    required AppKitToggleButtonThemeData buttonTheme,
    required Color accentColor,
    required Color backgroundColor,
    required bool isDark,
    required bool isMainWindow,
  }) {
    final bool isPrimary =
        widget.type == AppKitToggleButtonType.primary && isMainWindow;
    final bgColor = (widget.enabled && isPrimary && widget.isOn)
        ? accentColor
        : backgroundColor;
    final opacity = bgColor.opacity;
    final textColor = (widget.enabled && widget.isOn && !isPrimary)
        ? CupertinoDynamicColor.withBrightness(
            color: accentColor, darkColor: accentColor)
        : buttonTheme.textColor;

    final blendedBackgroundColor = Color.lerp(
      theme.canvasColor,
      bgColor,
      opacity,
    )!;

    return widget.enabled
        ? luminance(blendedBackgroundColor, textColor: textColor)
        : luminance(blendedBackgroundColor, textColor: textColor)
            .withOpacity(0.25);
  }

  BoxDecoration _getBackgroundBoxDecoration({
    required AppKitThemeData theme,
    required Color accentColor,
    required bool isMainWindow,
    required bool isDark,
  }) {
    return _BoxDecorationBuilder.buildBoxDecoration(
      theme: theme,
      accentColor: accentColor,
      isEnabled: widget.enabled,
      isDark: isDark,
      isOn: widget.isOn,
      type: widget.type,
      isMainWindow: isMainWindow,
    );
  }

  BoxDecoration _getForegroundBoxDecoration({
    required AppKitToggleButtonThemeData buttonTheme,
    required bool isMainWindow,
    required BorderRadiusGeometry borderRadius,
  }) {
    final isPrimary = widget.type == AppKitToggleButtonType.primary;
    return isPrimary && isMainWindow && widget.enabled
        ? BoxDecoration(
            borderRadius: borderRadius,
            gradient: LinearGradient(colors: [
              MacosColors.white.withOpacity(0.39),
              MacosColors.white.withOpacity(0.0),
            ], transform: const GradientRotation(pi / 2)))
        : const BoxDecoration();
  }

  BoxDecoration _getForegroundPressedBoxDecoration({
    required AppKitThemeData theme,
    required AppKitToggleButtonThemeData buttonTheme,
    required BorderRadiusGeometry borderRadius,
  }) {
    final isDark = theme.brightness.isDark;
    final color = isDark
        ? buttonTheme.overlayPressedColor.darkColor
        : buttonTheme.overlayPressedColor.color;
    return BoxDecoration(
      color: color,
      borderRadius: borderRadius,
    );
  }

  BorderRadius _getBorderRadius(AppKitToggleButtonThemeData theme) {
    return BorderRadius.circular(theme.buttonRadius[widget.controlSize] ?? 0.0);
  }

  EdgeInsetsGeometry _getButtonPadding(
      {required AppKitToggleButtonThemeData theme,
      EdgeInsetsGeometry? padding}) {
    return (theme.buttonPadding[widget.controlSize] ?? EdgeInsets.zero)
        .add(padding ?? EdgeInsets.zero);
  }

  TextStyle _textStyle(
      {required AppKitToggleButtonThemeData theme,
      required TextStyle baseStyle}) {
    final fontSize = theme.fontSize[widget.controlSize];
    return fontSize != null
        ? baseStyle.copyWith(fontSize: fontSize)
        : baseStyle;
  }

  BoxConstraints _getButtonConstraints(
      {required AppKitToggleButtonThemeData theme}) {
    return BoxConstraints(
      minHeight: theme.buttonSize[widget.controlSize]?.height ?? 0.0,
      minWidth: theme.buttonSize[widget.controlSize]?.width ?? 0.0,
    );
  }

  void _handleTapDown(TapDownDetails event) {
    if (!buttonHeldDown) {
      setState(() => buttonHeldDown = true);
    }
  }

  void _handleTapUp(TapUpDetails event) {
    if (buttonHeldDown) {
      setState(() => buttonHeldDown = false);
    }
  }

  void _handleTapCancel() {
    if (buttonHeldDown) {
      setState(() => buttonHeldDown = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasAppKitTheme(context));

    final bool enabled = widget.enabled;
    final AppKitThemeData theme = AppKitTheme.of(context);
    final AppKitToggleButtonThemeData buttonTheme =
        AppKitToggleButtonTheme.of(context);

    return MouseRegion(
      cursor: widget.mouseCursor,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: enabled ? _handleTapDown : null,
        onTapUp: enabled ? _handleTapUp : null,
        onTapCancel: enabled ? _handleTapCancel : null,
        onTap: widget.enabled
            ? () {
                widget.onChanged!.call(!widget.isOn);
              }
            : null,
        child: Semantics(
          button: true,
          label: widget.semanticLabel,
          child: ConstrainedBox(
              constraints: _getButtonConstraints(theme: buttonTheme),
              child: UiElementColorBuilder(
                  builder: (context, colorContainer) {
                final Color accentColor = widget.color ??
                    theme.accentColor ??
                    colorContainer.controlAccentColor;
                final isMainWindow =
                    MainWindowStateListener.instance.isMainWindow.value;
              
                final Color backgroundColor = _getBackgroundColor(
                  theme: theme,
                  accentColor: accentColor,
                  isDark: theme.brightness.isDark,
                  isMainWindow: isMainWindow,
                );
                final Color foregroundColor = _getForegroundColor(
                  accentColor: accentColor,
                  backgroundColor: backgroundColor,
                  theme: theme,
                  buttonTheme: buttonTheme,
                  isDark: theme.brightness.isDark,
                  isMainWindow: isMainWindow,
                );
                final baseStyle = theme.typography.body
                    .copyWith(color: foregroundColor);
                final borderRadius = _getBorderRadius(buttonTheme);
              
                return DecoratedBox(
                  decoration: _getBackgroundBoxDecoration(
                    theme: theme,
                    accentColor: backgroundColor,
                    isMainWindow: isMainWindow,
                    isDark: theme.brightness.isDark,
                  ).copyWith(
                    borderRadius: borderRadius,
                  ),
                  child: DecoratedBox(
                    decoration: _getForegroundBoxDecoration(
                        buttonTheme: buttonTheme,
                        isMainWindow: isMainWindow,
                        borderRadius: borderRadius),
                    child: Container(
                      foregroundDecoration: buttonHeldDown
                          ? _getForegroundPressedBoxDecoration(
                              theme: theme,
                              buttonTheme: buttonTheme,
                              borderRadius: borderRadius,
                            )
                          : const BoxDecoration(),
                      child: Padding(
                        padding: _getButtonPadding(
                            theme: buttonTheme, padding: widget.padding),
                        child: Align(
                          alignment: Alignment.center,
                          widthFactor: 1.0,
                          heightFactor: 1.0,
                          child: DefaultTextStyle(
                              style: _textStyle(
                                  theme: buttonTheme,
                                  baseStyle: baseStyle),
                              child: widget.isOn
                                  ? widget.childOn
                                  : widget.childOff),
                        ),
                      ),
                    ),
                  ),
                );
              })),
        ),
      ),
    );
  }
}

class _BoxDecorationBuilder {
  static BoxDecoration buildBoxDecoration({
    required AppKitThemeData theme,
    required Color accentColor,
    required bool isOn,
    required bool isEnabled,
    required bool isDark,
    required bool isMainWindow,
    required AppKitToggleButtonType type,
  }) {
    final color = getBackgroundColor(
      theme: theme,
      accentColor: accentColor,
      isEnabled: isEnabled,
      isDark: isDark,
      isMainWindow: isMainWindow,
      type: type,
      isOn: isOn,
    );
    return BoxDecoration(
      border: _getBoxBorder(
        accentColor: accentColor,
        isEnabled: isEnabled,
        isDark: isDark,
        isOn: isOn,
        isMainWindow: isMainWindow,
        type: type,
      ),
      color: color,
      boxShadow: _getBoxShadow(
        accentColor: accentColor,
        isEnabled: isEnabled,
        isDark: isDark,
        isOn: isOn,
        isMainWindow: isMainWindow,
        type: type,
      ),
    );
  }

  static Color getBackgroundColor({
    required AppKitThemeData theme,
    required Color accentColor,
    required bool isEnabled,
    required bool isDark,
    required bool isMainWindow,
    required bool isOn,
    required AppKitToggleButtonType type,
  }) {
    final isPrimary = type == AppKitToggleButtonType.primary && isMainWindow;
    final controlBackgroundColor = theme.controlBackgroundColor;
    return isPrimary && isEnabled && isOn
        ? accentColor
        : (isEnabled
            ? controlBackgroundColor
            : controlBackgroundColor.withOpacity(0.5));
  }

  static BoxBorder? _getBoxBorder({
    required Color accentColor,
    required bool isEnabled,
    required bool isDark,
    required bool isMainWindow,
    required bool isOn,
    required AppKitToggleButtonType type,
  }) {
    final isPrimary =
        (type == AppKitToggleButtonType.primary && isMainWindow && isOn);
    if (isPrimary || !isEnabled) return null;
    return GradientBoxBorder(
      gradient: LinearGradient(
        colors: [
          CupertinoDynamicColor.withBrightness(
              color: MacosColors.black.withOpacity(0.0),
              darkColor: MacosColors.white.withOpacity(0.0)),
          CupertinoDynamicColor.withBrightness(
              color: MacosColors.black.withOpacity(0.3),
              darkColor: MacosColors.white.withOpacity(0.3)),
        ],
        transform: const GradientRotation(pi / 2),
      ),
      width: 0.5,
    );
  }

  static List<BoxShadow> _getBoxShadow({
    required Color accentColor,
    required bool isOn,
    required bool isEnabled,
    required bool isDark,
    required bool isMainWindow,
    required AppKitToggleButtonType type,
  }) {
    final isPrimary =
        (type == AppKitToggleButtonType.primary && isMainWindow && isOn);
    if (!isPrimary || !isEnabled) {
      return [
        const BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.075),
          blurRadius: 0.25,
          spreadRadius: 0,
          offset: Offset(0, 1),
        ),
      ];
    } else {
      return [
        BoxShadow(
          color: accentColor.withOpacity(0.12),
          blurRadius: 3,
          spreadRadius: 0,
          offset: const Offset(0, 0.5),
        ),
        BoxShadow(
          color: accentColor.withOpacity(0.12),
          blurRadius: 2,
          spreadRadius: 0,
          offset: const Offset(0, 1),
        ),
        BoxShadow(
          color: accentColor.withOpacity(0.24),
          blurRadius: 1,
          spreadRadius: 0,
          offset: const Offset(0, 0.5),
        ),
      ];
    }
  }
}
