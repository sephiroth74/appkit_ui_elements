import 'dart:math';

import 'package:appkit_ui_element_colors/appkit_ui_element_colors.dart';
import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppKitDialogPushButton extends StatefulWidget {
  const AppKitDialogPushButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.padding,
    this.semanticLabel,
    this.color,
    this.type = AppKitPushButtonType.primary,
    this.mouseCursor = SystemMouseCursors.basic,
  });

  final EdgeInsetsGeometry? padding;
  final VoidCallback? onPressed;
  final String? semanticLabel;
  final MouseCursor mouseCursor;
  final AppKitPushButtonType type;
  final Widget child;
  final AppKitControlSize controlSize = AppKitControlSize.regular;
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
  State<AppKitDialogPushButton> createState() => _AppKitDialogPushButtonState();
}

class _AppKitDialogPushButtonState extends State<AppKitDialogPushButton> {
  @visibleForTesting
  bool buttonHeldDown = false;

  Color _getBackgroundColor({
    required AppKitThemeData theme,
    required AppKitPushButtonThemeData buttonTheme,
    required Color accentColor,
    required bool isDark,
    required bool isMainWindow,
    required UiElementColorContainer colorContainer,
  }) {
    final bool enabled = widget.enabled;

    return _buildBoxDecoration(
      colorContainer: colorContainer,
      theme: theme,
      buttonTheme: buttonTheme,
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
    return luminance > 0.5 ? textColor : Colors.white;
  }

  BoxDecoration _getBackgroundBoxDecoration({
    required AppKitThemeData theme,
    required AppKitPushButtonThemeData buttonTheme,
    required Color accentColor,
    required bool isMainWindow,
    required bool isDark,
    required UiElementColorContainer colorContainer,
  }) {
    return _buildBoxDecoration(
      colorContainer: colorContainer,
      theme: theme,
      buttonTheme: buttonTheme,
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
              Colors.white.withOpacity(0.39),
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
    return BorderRadius.circular(5.0);
  }

  EdgeInsetsGeometry _getButtonPadding(
      {required AppKitPushButtonThemeData theme, EdgeInsetsGeometry? padding}) {
    return const EdgeInsets.only(left: 16.0, right: 16.0, top: 6.0, bottom: 7.0)
        .add(padding ?? EdgeInsets.zero);
  }

  TextStyle _textStyle(
      {required AppKitPushButtonThemeData theme,
      required TextStyle baseStyle}) {
    return baseStyle;
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
                    theme.accentColor ??
                    colorContainer.controlAccentColor;
                final isMainWindow =
                    MainWindowStateListener.instance.isMainWindow.value;

                final Color backgroundColor = _getBackgroundColor(
                  theme: theme,
                  buttonTheme: buttonTheme,
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
                          buttonTheme: buttonTheme,
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
  required AppKitPushButtonThemeData buttonTheme,
  required Color accentColor,
  required bool isEnabled,
  required bool isDark,
  required bool isMainWindow,
  required AppKitPushButtonType type,
  required UiElementColorContainer colorContainer,
}) {
  final isPrimary = type == AppKitPushButtonType.primary && isMainWindow;
  final color = isPrimary && isEnabled
      ? accentColor
      : AppKitColors.fills.opaque.tertiary
          .multiplyOpacity(isEnabled ? 1.0 : 0.5);
  return BoxDecoration(
    color: color,
  );
}
