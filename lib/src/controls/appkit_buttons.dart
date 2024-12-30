import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';

const _kAnimationDuration = Duration(milliseconds: 100);

class AppKitButton extends StatefulWidget {
  final AppKitButtonStyle style;
  final AppKitButtonType type;
  final AppKitControlSize size;
  final Widget child;
  final VoidCallback? onPressed;
  final Color? accentColor;
  final EdgeInsetsGeometry? padding;
  final String? semanticLabel;
  final MouseCursor? mouseCursor;
  final TextStyle? textStyle;

  const AppKitButton({
    super.key,
    required this.child,
    this.onPressed,
    this.accentColor,
    this.padding,
    this.semanticLabel,
    this.textStyle,
    this.size = AppKitControlSize.regular,
    this.mouseCursor = SystemMouseCursors.basic,
    this.style = AppKitButtonStyle.push,
    this.type = AppKitButtonType.primary,
  });

  @override
  State<AppKitButton> createState() => _AppKitButtonState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<AppKitButtonStyle>('style', style));
    properties.add(EnumProperty<AppKitButtonType>('type', type));
    properties.add(EnumProperty<AppKitControlSize>('size', size));
    properties.add(DiagnosticsProperty<Widget>('child', child));
    properties
        .add(ObjectFlagProperty<VoidCallback>.has('onPressed', onPressed));
    properties.add(ColorProperty('accentColor', accentColor));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding));
    properties.add(StringProperty('semanticLabel', semanticLabel));
    properties
        .add(DiagnosticsProperty<MouseCursor>('mouseCursor', mouseCursor));
    properties.add(DiagnosticsProperty<TextStyle>('textStyle', textStyle));
  }
}

class _AppKitButtonState extends State<AppKitButton> {
  bool get enabled => widget.onPressed != null;

  @override
  Widget build(BuildContext context) {
    debugCheckHasAppKitTheme(context);
    return Semantics(
      label: widget.semanticLabel,
      button: true,
      enabled: enabled,
      child: MouseRegion(
        cursor: enabled
            ? widget.mouseCursor ?? SystemMouseCursors.basic
            : SystemMouseCursors.basic,
        hitTestBehavior: HitTestBehavior.opaque,
        child: MainWindowBuilder(builder: (context, isMainWindow) {
          final theme = AppKitTheme.of(context);
          final buttonTheme = AppKitButtonTheme.of(context);
          if (widget.style == AppKitButtonStyle.inline) {
            return _InlineButton(
              type: widget.type,
              theme: theme,
              buttonTheme: buttonTheme,
              isMainWindow: isMainWindow,
              size: widget.size,
              onPressed: widget.onPressed,
              accentColor: widget.accentColor,
              padding: widget.padding,
              isEnabled: enabled,
              textStyle: widget.textStyle,
              child: widget.child,
            );
          } else if (widget.style == AppKitButtonStyle.flat) {
            return _FlatButton(
              type: widget.type,
              theme: theme,
              buttonTheme: buttonTheme,
              isMainWindow: isMainWindow,
              size: widget.size,
              onPressed: widget.onPressed,
              accentColor: widget.accentColor,
              padding: widget.padding,
              isEnabled: enabled,
              textStyle: widget.textStyle,
              child: widget.child,
            );
          } else if (widget.style == AppKitButtonStyle.push) {
            return _PushButton(
              type: widget.type,
              theme: theme,
              buttonTheme: buttonTheme,
              isMainWindow: isMainWindow,
              size: widget.size,
              onPressed: widget.onPressed,
              accentColor: widget.accentColor,
              padding: widget.padding,
              isEnabled: enabled,
              textStyle: widget.textStyle,
              child: widget.child,
            );
          }
          return Container(
            width: 100,
            height: 24,
            color: theme.activeColor,
          );
        }),
      ),
    );
  }
}

// #region PushButton
class _PushButton extends _ButtonBase {
  const _PushButton({
    required super.size,
    required super.child,
    required super.isMainWindow,
    required super.isEnabled,
    required super.theme,
    required super.buttonTheme,
    required super.type,
    super.onPressed,
    super.padding,
    super.accentColor,
    super.textStyle,
  });

  @override
  final AppKitButtonStyle style = AppKitButtonStyle.flat;

  @override
  State<_PushButton> createState() => _PushButtonState();
}

class _PushButtonState extends _ButtonBaseState<_PushButton> {
  late Color backgroundColor;
  late Color backgroundColorPressed;

  late double borderRadius = widget.size.getBorderRadius(widget.style);

  late double fontSize = widget.size.getFontSize(widget.style);

  late FontWeight fontWeight = widget.size.getFontWeight(widget.style);

  late EdgeInsetsGeometry padding =
      widget.padding ?? widget.size.getPadding(widget.style);

  @override
  Widget buildButton(BuildContext context, BoxConstraints constraints) {
    Color textColor;
    final controlBackgroundColor = Color.lerp(
        backgroundColor, backgroundColorPressed, colorAnimation.value);

    if (widget.type == AppKitButtonType.destructive) {
      textColor =
          widget.buttonTheme.push.destructiveColor ?? AppKitColors.appleRed;
    } else {
      final blendedColor = Color.lerp(
          widget.theme.canvasColor, backgroundColor, backgroundColor.opacity)!;
      if (blendedColor.computeLuminance() > 0.5) {
        textColor = AppKitColors.text.opaque.primary.color;
      } else {
        textColor = AppKitColors.text.opaque.primary.darkColor;
      }
    }

    final textStyle = widget.theme.typography.body
        .copyWith(
          color: textColor.multiplyOpacity(widget.isEnabled ? 1.0 : 0.3),
          fontSize: fontSize,
          fontWeight: fontWeight,
        )
        .merge(widget.textStyle);

    return Container(
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: widget.type == AppKitButtonType.primary &&
                widget.isMainWindow &&
                widget.isEnabled
            ? LinearGradient(
                colors: [
                  Colors.white.withOpacity(isDark ? 0.05 : 0.17),
                  Colors.white.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.0, 0.5],
              )
            : null,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: widget.type != AppKitButtonType.primary ||
                  !widget.isMainWindow ||
                  !widget.isEnabled ||
                  isDark
              ? GradientBoxBorder(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [
                            AppKitDynamicColor.resolve(
                                    context, AppKitColors.text.opaque.primary)
                                .multiplyOpacity(0.5),
                            AppKitDynamicColor.resolve(context,
                                    AppKitColors.text.opaque.quaternary)
                                .multiplyOpacity(0.0)
                          ]
                        : [
                            AppKitDynamicColor.resolve(
                                    context, AppKitColors.text.opaque.tertiary)
                                .multiplyOpacity(0.5),
                            AppKitDynamicColor.resolve(
                                    context, AppKitColors.text.opaque.secondary)
                                .multiplyOpacity(0.5)
                          ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: isDark ? const [0.0, 0.5] : const [0.0, 1.0],
                  ),
                  width: 0.5,
                )
              : null,
          color: controlBackgroundColor,
          boxShadow: [
            if (widget.type == AppKitButtonType.primary &&
                widget.isMainWindow &&
                widget.isEnabled &&
                !isDark) ...[
              BoxShadow(
                color: backgroundColor.withOpacity(0.5),
                blurRadius: 0.5,
                spreadRadius: 0,
                offset: const Offset(0, 0.5),
              ),
            ] else ...[
              BoxShadow(
                color: AppKitColors.shadowColor.color
                    .withOpacity(isDark ? 0.75 : 0.15),
                blurRadius: 0.5,
                spreadRadius: 0,
                offset: const Offset(0, 0.5),
                blurStyle: BlurStyle.outer,
              ),
            ],
          ],
        ),
        child: SizedBox(
          height: constraints.maxHeight,
          child: Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: Padding(
              padding: padding,
              child: DefaultTextStyle(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: textStyle,
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void computeColors() {
    final themeData = widget.buttonTheme.push;
    if (!widget.isEnabled) {
      backgroundColor = themeData.backgroundColorDisabled;
    } else {
      if (widget.type == AppKitButtonType.primary && widget.isMainWindow) {
        backgroundColor = widget.accentColor ??
            themeData.accentColor ??
            widget.theme.activeColor;
      } else {
        backgroundColor = widget.accentColor ??
            themeData.secondaryColor ??
            widget.theme.controlBackgroundColor;
      }
    }

    final blendedColor = Color.lerp(
        widget.theme.canvasColor, backgroundColor, backgroundColor.opacity)!;
    final blendedColorLuminance = blendedColor.computeLuminance();

    if (blendedColorLuminance > 0.15) {
      backgroundColorPressed =
          Color.lerp(backgroundColor, Colors.black, isDark ? 0.15 : 0.08)!;
    } else {
      backgroundColorPressed =
          Color.lerp(backgroundColor, Colors.white, isDark ? 0.15 : 0.08)!;
    }
  }
}

// #endregion

// #region FlatButton

class _FlatButton extends _ButtonBase {
  const _FlatButton({
    required super.size,
    required super.child,
    required super.isMainWindow,
    required super.isEnabled,
    required super.theme,
    required super.buttonTheme,
    required super.type,
    super.onPressed,
    super.padding,
    super.accentColor,
    super.textStyle,
  });

  @override
  final AppKitButtonStyle style = AppKitButtonStyle.flat;

  @override
  State<_FlatButton> createState() => _FlatButtonState();
}

class _FlatButtonState extends _ButtonBaseState<_FlatButton> {
  late Color backgroundColor;
  late Color backgroundColorPressed;

  @override
  Widget buildButton(BuildContext context, BoxConstraints constraints) {
    Color textColor;
    final controlBackgroundColor = Color.lerp(
        backgroundColor, backgroundColorPressed, colorAnimation.value);
    if (widget.type == AppKitButtonType.destructive) {
      textColor =
          widget.buttonTheme.flat.destructiveColor ?? AppKitColors.systemRed;
    } else {
      final blendedColor = Color.lerp(
          widget.theme.canvasColor, backgroundColor, backgroundColor.opacity)!;
      if (blendedColor.computeLuminance() > 0.5) {
        textColor = AppKitColors.textColor.color;
      } else {
        textColor = AppKitColors.textColor.darkColor;
      }
    }

    final textStyle = widget.theme.typography.body.copyWith(
      color: textColor.multiplyOpacity(widget.isEnabled ? 1.0 : 0.3),
      fontSize: widget.size.getFontSize(widget.style),
      fontWeight: widget.size.getFontWeight(widget.style),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(widget.size.getBorderRadius(widget.style)),
        color: controlBackgroundColor,
      ),
      child: SizedBox(
        height: constraints.maxHeight,
        child: Align(
          alignment: AlignmentDirectional.bottomCenter,
          child: Padding(
            padding: widget.padding ?? widget.size.getPadding(widget.style),
            child: DefaultTextStyle(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: textStyle,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void computeColors() {
    final themeData = widget.buttonTheme.flat;
    if (!widget.isEnabled) {
      backgroundColor = themeData.backgroundColorDisabled;
    } else {
      if (widget.type == AppKitButtonType.primary && widget.isMainWindow) {
        backgroundColor = widget.accentColor ??
            themeData.accentColor ??
            widget.theme.activeColor;
      } else {
        backgroundColor = widget.accentColor ??
            themeData.secondaryColor ??
            widget.theme.controlBackgroundColor;
      }
    }

    final blendedColor = Color.lerp(
        widget.theme.canvasColor, backgroundColor, backgroundColor.opacity)!;
    final blendedColorLuminance = blendedColor.computeLuminance();

    if (blendedColorLuminance > 0.15) {
      backgroundColorPressed = Color.lerp(backgroundColor, Colors.black, 0.15)!;
    } else {
      backgroundColorPressed = Color.lerp(backgroundColor, Colors.white, 0.15)!;
    }
  }
}

// #endregion

// #region InlineButton
class _InlineButton extends _ButtonBase {
  const _InlineButton({
    required super.size,
    required super.child,
    required super.isMainWindow,
    required super.isEnabled,
    required super.theme,
    required super.buttonTheme,
    required super.type,
    super.onPressed,
    super.padding,
    super.accentColor,
    super.textStyle,
  });

  @override
  final AppKitButtonStyle style = AppKitButtonStyle.inline;

  @override
  State<_InlineButton> createState() => _InlineButtonState();
}

class _InlineButtonState extends _ButtonBaseState<_InlineButton> {
  late Color backgroundColor;
  late Color backgroundColorPressed;

  @override
  Widget buildButton(BuildContext context, BoxConstraints constraints) {
    Color textColor;
    final controlBackgroundColor = Color.lerp(
        backgroundColor, backgroundColorPressed, colorAnimation.value);

    if (widget.type == AppKitButtonType.destructive) {
      textColor =
          widget.buttonTheme.inline.destructiveColor ?? AppKitColors.systemRed;
    } else {
      final blendedColor = Color.lerp(
          widget.theme.canvasColor, backgroundColor, backgroundColor.opacity)!;
      if (blendedColor.computeLuminance() > 0.5) {
        textColor = AppKitColors.textColor.color;
      } else {
        textColor = AppKitColors.textColor.darkColor;
      }
    }

    final textStyle = widget.theme.typography.body.copyWith(
      color: textColor.multiplyOpacity(widget.isEnabled ? 1.0 : 0.3),
      fontSize: widget.size.getFontSize(widget.style),
      fontWeight: widget.size.getFontWeight(widget.style),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(constraints.maxHeight / 2),
        color: controlBackgroundColor,
      ),
      child: SizedBox(
        height: constraints.maxHeight,
        child: Align(
          alignment: AlignmentDirectional.bottomCenter,
          child: Padding(
            padding: widget.padding ?? widget.size.getPadding(widget.style),
            child: DefaultTextStyle(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: textStyle,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void computeColors() {
    final themeData = widget.buttonTheme.inline;
    if (!widget.isEnabled) {
      backgroundColor = themeData.backgroundColorDisabled;
    } else {
      if (widget.type == AppKitButtonType.primary && widget.isMainWindow) {
        backgroundColor = widget.accentColor ??
            themeData.accentColor ??
            widget.theme.activeColor;
      } else {
        backgroundColor = widget.accentColor ??
            themeData.secondaryColor ??
            widget.theme.controlBackgroundColor;
      }
    }

    final blendedColor = Color.lerp(
        widget.theme.canvasColor, backgroundColor, backgroundColor.opacity)!;
    final blendedColorLuminance = blendedColor.computeLuminance();

    if (blendedColorLuminance > 0.15) {
      backgroundColorPressed = Color.lerp(backgroundColor, Colors.black, 0.15)!;
    } else {
      backgroundColorPressed = Color.lerp(backgroundColor, Colors.white, 0.15)!;
    }
  }
}

// #endregion

// #region ButtonBase
abstract class _ButtonBase extends StatefulWidget {
  final AppKitControlSize size;
  final Widget child;
  final VoidCallback? onPressed;
  final Color? accentColor;
  final EdgeInsetsGeometry? padding;
  final bool isMainWindow;
  final bool isEnabled;
  final AppKitThemeData theme;
  final AppKitButtonThemeData buttonTheme;
  final AppKitButtonType type;
  final TextStyle? textStyle;

  abstract final AppKitButtonStyle style;

  const _ButtonBase({
    required this.size,
    required this.child,
    required this.isMainWindow,
    required this.isEnabled,
    required this.theme,
    required this.buttonTheme,
    required this.type,
    this.onPressed,
    this.accentColor,
    this.padding,
    this.textStyle,
  });
}

abstract class _ButtonBaseState<T extends _ButtonBase> extends State<T>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> colorAnimation;

  bool get isDark => widget.theme.brightness == Brightness.dark;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(T oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isEnabled != widget.isEnabled ||
        oldWidget.accentColor != widget.accentColor ||
        oldWidget.theme != widget.theme ||
        oldWidget.buttonTheme != widget.buttonTheme ||
        oldWidget.type != widget.type ||
        oldWidget.isMainWindow != widget.isMainWindow) {
      computeColors();
    }
  }

  @override
  void initState() {
    super.initState();
    computeColors();

    controller = AnimationController(
      vsync: this,
      duration: _kAnimationDuration,
    );

    colorAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      controller.forward();
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      controller.reverse();
    });
    widget.onPressed?.call();
  }

  void _handleTapCancel() {
    setState(() {
      controller.reverse();
    });
  }

  void computeColors();

  Widget buildButton(BuildContext context, BoxConstraints constraints);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: widget.size.getBoxConstraints(widget.style),
      child: GestureDetector(
        onTapDown: widget.isEnabled ? _handleTapDown : null,
        onTapUp: widget.isEnabled ? _handleTapUp : null,
        onTapCancel: widget.isEnabled ? _handleTapCancel : null,
        child: LayoutBuilder(builder: (context, constraints) {
          return buildButton(context, constraints);
        }),
      ),
    );
  }
}

// #endregion

extension _AppKitControlSizeX on AppKitControlSize {
  double getBorderRadius(AppKitButtonStyle style) {
    switch (this) {
      case AppKitControlSize.mini:
        switch (style) {
          case AppKitButtonStyle.inline:
            return 6.5;
          case AppKitButtonStyle.flat:
          case AppKitButtonStyle.push:
            return 2.0;
        }

      case AppKitControlSize.small:
        switch (style) {
          case AppKitButtonStyle.inline:
            return 8.0;
          case AppKitButtonStyle.flat:
          case AppKitButtonStyle.push:
            return 3.0;
        }

      case AppKitControlSize.regular:
        switch (style) {
          case AppKitButtonStyle.inline:
            return 12.0;
          case AppKitButtonStyle.flat:
          case AppKitButtonStyle.push:
            return 5.0;
        }

      case AppKitControlSize.large:
        switch (style) {
          case AppKitButtonStyle.inline:
            return 14.5;
          case AppKitButtonStyle.flat:
          case AppKitButtonStyle.push:
            return 5.5;
        }
    }
  }

  BoxConstraints getBoxConstraints(AppKitButtonStyle style) {
    switch (this) {
      case AppKitControlSize.mini:
        switch (style) {
          case AppKitButtonStyle.inline:
            return const BoxConstraints(
                minWidth: 26, maxHeight: 13, minHeight: 13);
          case AppKitButtonStyle.flat:
          case AppKitButtonStyle.push:
            return const BoxConstraints(
                minWidth: 26, maxHeight: 12, minHeight: 12);
        }

      case AppKitControlSize.small:
        switch (style) {
          case AppKitButtonStyle.inline:
            return const BoxConstraints(
                minWidth: 42, maxHeight: 16, minHeight: 16);
          case AppKitButtonStyle.flat:
          case AppKitButtonStyle.push:
            return const BoxConstraints(
                minWidth: 42, maxHeight: 14, minHeight: 14);
        }

      case AppKitControlSize.regular:
        switch (style) {
          case AppKitButtonStyle.inline:
            return const BoxConstraints(
                minWidth: 48, maxHeight: 24, minHeight: 24);
          case AppKitButtonStyle.flat:
          case AppKitButtonStyle.push:
            return const BoxConstraints(
                minWidth: 48, maxHeight: 22, minHeight: 22);
        }

      case AppKitControlSize.large:
        switch (style) {
          case AppKitButtonStyle.inline:
            return const BoxConstraints(
                minWidth: 54, maxHeight: 29, minHeight: 29);
          case AppKitButtonStyle.flat:
          case AppKitButtonStyle.push:
            return const BoxConstraints(
                minWidth: 54, maxHeight: 26, minHeight: 26);
        }
    }
  }

  double getFontSize(AppKitButtonStyle style) {
    switch (this) {
      case AppKitControlSize.mini:
        switch (style) {
          case AppKitButtonStyle.inline:
            return 7.5;

          case AppKitButtonStyle.flat:
          case AppKitButtonStyle.push:
            return 8.0;
        }

      case AppKitControlSize.small:
        switch (style) {
          case AppKitButtonStyle.inline:
            return 9;
          case AppKitButtonStyle.flat:
          case AppKitButtonStyle.push:
            return 10;
        }

      case AppKitControlSize.regular:
        switch (style) {
          case AppKitButtonStyle.inline:
            return 12;
          case AppKitButtonStyle.flat:
          case AppKitButtonStyle.push:
            return 13;
        }

      case AppKitControlSize.large:
        switch (style) {
          case AppKitButtonStyle.inline:
            return 13.5;
          case AppKitButtonStyle.flat:
          case AppKitButtonStyle.push:
            return 15;
        }
    }
  }

  EdgeInsetsGeometry getPadding(AppKitButtonStyle style) {
    switch (this) {
      case AppKitControlSize.mini:
        switch (style) {
          case AppKitButtonStyle.inline:
            return const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 1.5);
          case AppKitButtonStyle.flat:
          case AppKitButtonStyle.push:
            return const EdgeInsets.only(left: 6.0, right: 6.0, bottom: 1.5);
        }

      case AppKitControlSize.small:
        switch (style) {
          case AppKitButtonStyle.inline:
            return const EdgeInsets.only(left: 13.5, right: 13.5, bottom: 2.5);
          case AppKitButtonStyle.flat:
          case AppKitButtonStyle.push:
            return const EdgeInsets.only(left: 7.0, right: 7.0, bottom: 1.5);
        }

      case AppKitControlSize.regular:
        switch (style) {
          case AppKitButtonStyle.inline:
            return const EdgeInsets.only(left: 20, right: 20, bottom: 5.5);
          case AppKitButtonStyle.flat:
          case AppKitButtonStyle.push:
            return const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 4.0);
        }
      case AppKitControlSize.large:
        switch (style) {
          case AppKitButtonStyle.inline:
            return const EdgeInsets.only(left: 26.5, right: 26.5, bottom: 6.5);
          case AppKitButtonStyle.flat:
          case AppKitButtonStyle.push:
            return const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 5.0);
        }
    }
  }

  FontWeight getFontWeight(AppKitButtonStyle style) {
    switch (this) {
      case AppKitControlSize.mini:
        return FontWeight.w300;

      case AppKitControlSize.small:
        return FontWeight.w400;

      case AppKitControlSize.regular:
        return FontWeight.normal;

      case AppKitControlSize.large:
        switch (style) {
          case AppKitButtonStyle.inline:
            return AppKitFontWeight.w500;
          case AppKitButtonStyle.flat:
          case AppKitButtonStyle.push:
            return AppKitFontWeight.normal;
        }
    }
  }
}

enum AppKitButtonStyle {
  push,
  inline,
  flat,
}

enum AppKitButtonType {
  primary,
  secondary,
  destructive,
}
