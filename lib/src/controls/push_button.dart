import 'dart:math';

import 'package:appkit_ui_element_colors/appkit_ui_element_colors.dart';
import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';

class AppKitPushButton extends StatefulWidget {
  const AppKitPushButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.padding,
    this.semanticLabel,
    this.color,
    this.type = AppKitPushButtonType.primary,
    this.mouseCursor = SystemMouseCursors.basic,
    this.controlSize = AppKitControlSize.regular,
  });

  final EdgeInsetsGeometry? padding;
  final VoidCallback? onPressed;
  final String? semanticLabel;
  final MouseCursor mouseCursor;
  final AppKitPushButtonType type;
  final Widget child;
  final AppKitControlSize controlSize;
  final Color? color;

  bool get enabled => onPressed != null;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<AppKitPushButtonType>('type', type));
    properties.add(EnumProperty<AppKitControlSize>('controlSize', controlSize));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding));
    properties.add(StringProperty('semanticLabel', semanticLabel));
    properties
        .add(DiagnosticsProperty<MouseCursor>('mouseCursor', mouseCursor));
    properties
        .add(FlagProperty('enabled', value: enabled, ifFalse: 'disabled'));
    properties.add(DiagnosticsProperty<Color>('color', color));
  }

  @override
  State<AppKitPushButton> createState() => _AppKitPushButtonState();
}

class _AppKitPushButtonState extends State<AppKitPushButton> {
  @visibleForTesting
  bool buttonHeldDown = false;

  Color _getBackgroundColor({
    required AppKitThemeData theme,
    required Color accentColor,
    required bool isDark,
    required bool isMainWindow,
    required UiElementColorContainer colorContainer,
  }) {
    final bool enabled = widget.enabled;

    return _buildBoxDecoration(
      colorContainer: colorContainer,
      theme: theme,
      accentColor: accentColor,
      isEnabled: enabled,
      isDark: isDark,
      isMainWindow: isMainWindow,
      type: widget.type,
    ).color!;
  }

  Color _getForegroundColor({
    required AppKitThemeData theme,
    required AppKitPushButtonThemeData buttonTheme,
    required UiElementColorContainer colorContainer,
    required Color backgroundColor,
    required bool isMainWindow,
  }) {
    final opacity = backgroundColor.opacity;
    final isPrimary = widget.type == AppKitPushButtonType.primary;

    final Color textColor;

    if (!widget.enabled || !isMainWindow) {
      textColor = colorContainer.disabledControlTextColor;
    } else {
      if (widget.color != null && !isPrimary) {
        textColor = CupertinoDynamicColor.withBrightness(
          color: widget.color!,
          darkColor: widget.color!,
        );
      } else {
        switch (widget.type) {
          case AppKitPushButtonType.primary:
          case AppKitPushButtonType.secondary:
            textColor = colorContainer.controlTextColor;
            break;

          case AppKitPushButtonType.destructive:
            textColor = buttonTheme.destructiveTextColor;
            break;
        }
      }
    }

    final blendedBackgroundColor = Color.lerp(
      theme.canvasColor,
      backgroundColor,
      opacity,
    )!;

    final luminance = blendedBackgroundColor.computeLuminance();

    if (theme.brightness.isDark) {
      return luminance > 0.5 ? AppKitColors.controlTextColor.color : textColor;
    } else {
      return luminance > 0.5
          ? textColor
          : AppKitColors.controlTextColor.darkColor;
    }
  }

  BoxDecoration _getBackgroundBoxDecoration({
    required AppKitThemeData theme,
    required Color accentColor,
    required bool isMainWindow,
    required bool isDark,
    required UiElementColorContainer colorContainer,
  }) {
    return _buildBoxDecoration(
      colorContainer: colorContainer,
      theme: theme,
      accentColor: accentColor,
      isEnabled: widget.enabled,
      isDark: isDark,
      type: widget.type,
      isMainWindow: isMainWindow,
    );
  }

  BoxDecoration _getForegroundBoxDecoration({
    required AppKitPushButtonThemeData buttonTheme,
    required bool isMainWindow,
    required BorderRadiusGeometry borderRadius,
  }) {
    final isPrimary = widget.type == AppKitPushButtonType.primary;
    return isPrimary && isMainWindow && widget.enabled
        ? BoxDecoration(
            borderRadius: borderRadius,
            gradient: LinearGradient(colors: [
              Colors.white.withOpacity(0.4),
              Colors.white.withOpacity(0.0),
            ], transform: const GradientRotation(pi / 2)))
        : const BoxDecoration();
  }

  BoxDecoration _getForegroundPressedBoxDecoration({
    required AppKitThemeData theme,
    required AppKitPushButtonThemeData buttonTheme,
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

  BorderRadius _getBorderRadius(AppKitPushButtonThemeData theme) {
    return BorderRadius.circular(theme.buttonRadius[widget.controlSize] ?? 0.0);
  }

  EdgeInsetsGeometry _getButtonPadding(
      {required AppKitPushButtonThemeData theme, EdgeInsetsGeometry? padding}) {
    return (theme.buttonPadding[widget.controlSize] ?? EdgeInsets.zero)
        .add(padding ?? EdgeInsets.zero);
  }

  TextStyle _textStyle(
      {required AppKitPushButtonThemeData theme,
      required TextStyle baseStyle}) {
    final fontSize = theme.fontSize[widget.controlSize];
    return fontSize != null
        ? baseStyle.copyWith(fontSize: fontSize)
        : baseStyle;
  }

  BoxConstraints _getButtonConstraints(
      {required AppKitPushButtonThemeData theme}) {
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
    final AppKitPushButtonThemeData buttonTheme =
        AppKitPushButtonTheme.of(context);

    return MouseRegion(
      cursor: widget.mouseCursor,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: enabled ? _handleTapDown : null,
        onTapUp: enabled ? _handleTapUp : null,
        onTapCancel: enabled ? _handleTapCancel : null,
        onTap: widget.enabled ? widget.onPressed : null,
        child: Semantics(
          button: true,
          label: widget.semanticLabel,
          child: ConstrainedBox(
              constraints: _getButtonConstraints(theme: buttonTheme),
              child: UiElementColorBuilder(builder: (context, colorContainer) {
                final Color accentColor = widget.color ??
                    (theme.primaryColor ?? colorContainer.controlAccentColor)
                        .multiplyLuminance(0.5);
                final isMainWindow =
                    MainWindowStateListener.instance.isMainWindow.value;

                final Color backgroundColor = _getBackgroundColor(
                  theme: theme,
                  accentColor: accentColor,
                  isDark: theme.brightness.isDark,
                  isMainWindow: isMainWindow,
                  colorContainer: colorContainer,
                );
                final Color foregroundColor = _getForegroundColor(
                  theme: theme,
                  buttonTheme: buttonTheme,
                  backgroundColor: backgroundColor,
                  isMainWindow: isMainWindow,
                  colorContainer: colorContainer,
                );

                final baseStyle =
                    theme.typography.body.copyWith(color: foregroundColor);
                final borderRadius = _getBorderRadius(buttonTheme);

                return DecoratedBox(
                  decoration: _getBackgroundBoxDecoration(
                          theme: theme,
                          accentColor: backgroundColor,
                          isMainWindow: isMainWindow,
                          isDark: theme.brightness.isDark,
                          colorContainer: colorContainer)
                      .copyWith(
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
                                  theme: buttonTheme, baseStyle: baseStyle),
                              child: widget.child),
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

BoxDecoration _buildBoxDecoration({
  required AppKitThemeData theme,
  required Color accentColor,
  required bool isEnabled,
  required bool isDark,
  required bool isMainWindow,
  required AppKitPushButtonType type,
  required UiElementColorContainer colorContainer,
}) {
  final isPrimary = type == AppKitPushButtonType.primary && isMainWindow;
  final controlBackgroundColor = colorContainer.controlBackgroundColor;
  final color = isPrimary && isEnabled
      ? accentColor
      : (isEnabled
          ? controlBackgroundColor
          : controlBackgroundColor.multiplyOpacity(0.5));
  return BoxDecoration(
    border: _buildBoxBorder(
        accentColor: accentColor,
        isEnabled: isEnabled,
        isDark: isDark,
        isMainWindow: isMainWindow,
        type: type),
    color: color,
    boxShadow: _buildBoxShadow(
      accentColor: accentColor,
      isEnabled: isEnabled,
      isDark: isDark,
      isMainWindow: isMainWindow,
      type: type,
    ),
  );
}

BoxBorder? _buildBoxBorder({
  required Color accentColor,
  required bool isEnabled,
  required bool isDark,
  required bool isMainWindow,
  required AppKitPushButtonType type,
}) {
  final isPrimary = type == AppKitPushButtonType.primary && isMainWindow;
  if (isPrimary || !isEnabled) return null;
  return GradientBoxBorder(
    gradient: LinearGradient(
      colors: [
        AppKitColors.text.opaque.tertiary.multiplyOpacity(0.6),
        AppKitColors.text.opaque.secondary.multiplyOpacity(0.5)
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    ),
    width: 1.0,
  );
}

List<BoxShadow> _buildBoxShadow({
  required Color accentColor,
  required bool isEnabled,
  required bool isDark,
  required bool isMainWindow,
  required AppKitPushButtonType type,
}) {
  final isPrimary = type == AppKitPushButtonType.primary && isMainWindow;
  if (!isPrimary || !isEnabled) {
    return [
      const BoxShadow(
        color: Color.fromRGBO(0, 0, 0, 0.06),
        blurRadius: 0.25,
        spreadRadius: 0,
        offset: Offset(0, 0.5),
      ),
    ];
  } else {
    return [
      BoxShadow(
        color: accentColor.withOpacity(0.06),
        blurRadius: 3,
        spreadRadius: 0,
        offset: const Offset(0, 0.25),
      ),
      BoxShadow(
        color: accentColor.withOpacity(0.06),
        blurRadius: 2,
        spreadRadius: 0,
        offset: const Offset(0, 0.5),
      ),
      BoxShadow(
        color: accentColor.withOpacity(0.12),
        blurRadius: 1,
        spreadRadius: 0,
        offset: const Offset(0, 0.25),
      ),
    ];
  }
}
