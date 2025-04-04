import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:provider/provider.dart';

const _kAnimationDuration = Duration(milliseconds: 100);

/// A custom button widget with various styles and behaviors.
///
/// The [AppKitButton] widget allows users to create buttons with different
/// styles, sizes, and behaviors. It supports tap, long press, and long press end
/// gestures, and can be customized with various properties.
///
/// Example usage:
/// ```dart
/// AppKitButton(
///   child: Text('Press me'),
///   onTap: () {
///     print('Button pressed');
///   },
/// )
/// ```
class AppKitButton extends StatefulWidget {
  /// The style of the button.
  ///
  /// Determines the visual appearance of the button.
  final AppKitButtonStyle style;

  /// The type of the button.
  ///
  /// Determines the behavior and interaction of the button.
  final AppKitButtonType type;

  /// The size of the button.
  ///
  /// Determines the overall dimensions of the button.
  final AppKitControlSize size;

  /// The widget to display inside the button.
  ///
  /// Typically a [Text] or [Icon] widget.
  final Widget child;

  /// Called when the button is tapped.
  ///
  /// If null, the button will be disabled.
  final VoidCallback? onTap;

  /// Called when the button is long-pressed.
  ///
  /// If null, the long press gesture will be disabled.
  final VoidCallback? onLongPress;

  /// Called when the long press gesture ends.
  ///
  /// If null, the long press end gesture will be disabled.
  final GestureLongPressEndCallback? onLongPressEnd;

  /// The accent color of the button.
  ///
  /// If null, a default color will be used.
  final Color? accentColor;

  /// The padding inside the button.
  ///
  /// If null, a default padding will be used.
  final EdgeInsetsGeometry? padding;

  /// The semantic label for the button.
  ///
  /// Used by accessibility tools to describe the button.
  final String? semanticLabel;

  /// The mouse cursor to display when hovering over the button.
  ///
  /// If null, a default cursor will be used.
  final MouseCursor? mouseCursor;

  /// The text style for the button's child.
  ///
  /// If null, a default text style will be used.
  final TextStyle? textStyle;

  /// The width of the button.
  ///
  /// If null, the button will size itself to fit its child.
  final double? width;

  /// Creates an [AppKitButton] widget.
  ///
  /// The [child] parameter must not be null.
  const AppKitButton({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.onLongPressEnd,
    this.accentColor,
    this.padding,
    this.semanticLabel,
    this.textStyle,
    this.width,
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
    properties.add(ObjectFlagProperty<VoidCallback>.has('onTap', onTap));
    properties
        .add(ObjectFlagProperty<VoidCallback>.has('onLongPress', onLongPress));
    properties.add(ObjectFlagProperty<GestureLongPressEndCallback>.has(
        'onLongPressEnd', onLongPressEnd));
    properties.add(ColorProperty('accentColor', accentColor));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding));
    properties.add(StringProperty('semanticLabel', semanticLabel));
    properties
        .add(DiagnosticsProperty<MouseCursor>('mouseCursor', mouseCursor));
    properties.add(DiagnosticsProperty<TextStyle>('textStyle', textStyle));
    properties.add(DoubleProperty('width', width));
  }
}

class _AppKitButtonState extends State<AppKitButton> {
  bool _isHovered = false;

  void _onMouseEnter() {
    setState(() {
      _isHovered = true;
    });
  }

  void _onMouseExit() {
    setState(() {
      _isHovered = false;
    });
  }

  bool get enabled =>
      widget.onTap != null ||
      widget.onLongPress != null ||
      widget.onLongPressEnd != null;

  @override
  Widget build(BuildContext context) {
    debugCheckHasAppKitTheme(context);
    return Semantics(
      label: widget.semanticLabel,
      button: true,
      enabled: enabled,
      child: MouseRegion(
        onEnter: enabled ? (_) => _onMouseEnter() : null,
        onExit: enabled ? (_) => _onMouseExit() : null,
        cursor: enabled
            ? widget.mouseCursor ?? SystemMouseCursors.basic
            : SystemMouseCursors.basic,
        hitTestBehavior: HitTestBehavior.opaque,
        child: Consumer<MainWindowModel>(builder: (context, model, child) {
          final isMainWindow = model.isMainWindow;
          final theme = AppKitTheme.of(context);
          final buttonTheme = AppKitButtonTheme.of(context);
          if (widget.style == AppKitButtonStyle.inline) {
            return _InlineButton(
              hovered: _isHovered,
              type: widget.type,
              theme: theme,
              buttonTheme: buttonTheme,
              isMainWindow: isMainWindow,
              size: widget.size,
              onTap: widget.onTap,
              onLongPress: widget.onLongPress,
              onLongPressEnd: widget.onLongPressEnd,
              accentColor: widget.accentColor,
              padding: widget.padding,
              textStyle: widget.textStyle,
              width: widget.width,
              child: widget.child,
            );
          } else if (widget.style == AppKitButtonStyle.flat) {
            return _FlatButton(
              hovered: _isHovered,
              type: widget.type,
              theme: theme,
              buttonTheme: buttonTheme,
              isMainWindow: isMainWindow,
              size: widget.size,
              onTap: widget.onTap,
              onLongPress: widget.onLongPress,
              onLongPressEnd: widget.onLongPressEnd,
              accentColor: widget.accentColor,
              padding: widget.padding,
              textStyle: widget.textStyle,
              width: widget.width,
              child: widget.child,
            );
          } else if (widget.style == AppKitButtonStyle.push) {
            return _PushButton(
              hovered: _isHovered,
              type: widget.type,
              theme: theme,
              buttonTheme: buttonTheme,
              isMainWindow: isMainWindow,
              size: widget.size,
              onTap: widget.onTap,
              onLongPress: widget.onLongPress,
              onLongPressEnd: widget.onLongPressEnd,
              accentColor: widget.accentColor,
              padding: widget.padding,
              textStyle: widget.textStyle,
              width: widget.width,
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
    required super.theme,
    required super.buttonTheme,
    required super.type,
    super.onTap,
    super.onLongPress,
    super.onLongPressEnd,
    super.padding,
    super.accentColor,
    super.textStyle,
    super.width,
    super.hovered,
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
          widget.theme.canvasColor, backgroundColor, backgroundColor.a)!;
      if (blendedColor.computeLuminance() > 0.5) {
        textColor = AppKitColors.text.opaque.primary.color;
      } else {
        textColor = AppKitColors.text.opaque.primary.darkColor;
      }
    }

    final textStyle = widget.theme.typography.body
        .copyWith(
          color: textColor.multiplyOpacity(widget.enabled ? 1.0 : 0.3),
          fontSize: fontSize,
          fontWeight: fontWeight,
        )
        .merge(widget.textStyle);

    return Container(
      foregroundDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: widget.type == AppKitButtonType.primary &&
                widget.isMainWindow &&
                widget.enabled
            ? LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: isDark ? 0.05 : 0.17),
                  Colors.white.withValues(alpha: 0.0),
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
                  !widget.enabled ||
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
                widget.enabled &&
                !isDark) ...[
              BoxShadow(
                color: backgroundColor.withValues(alpha: 0.5),
                blurRadius: 0.5,
                spreadRadius: 0,
                offset: const Offset(0, 0.5),
              ),
            ] else ...[
              BoxShadow(
                color: AppKitColors.shadowColor.color
                    .withValues(alpha: isDark ? 0.75 : 0.15),
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
    if (!widget.enabled) {
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
        widget.theme.canvasColor, backgroundColor, backgroundColor.a)!;
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
    required super.theme,
    required super.buttonTheme,
    required super.type,
    super.onTap,
    super.onLongPress,
    super.onLongPressEnd,
    super.padding,
    super.accentColor,
    super.textStyle,
    super.width,
    super.hovered,
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
          widget.theme.canvasColor, backgroundColor, backgroundColor.a)!;
      if (blendedColor.computeLuminance() > 0.5) {
        textColor = AppKitColors.textColor.color;
      } else {
        textColor = AppKitColors.textColor.darkColor;
      }
    }

    final textStyle = widget.theme.typography.body.copyWith(
      color: textColor.multiplyOpacity(widget.enabled ? 1.0 : 0.3),
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
    if (!widget.enabled) {
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
        widget.theme.canvasColor, backgroundColor, backgroundColor.a)!;
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
    required super.theme,
    required super.buttonTheme,
    required super.type,
    super.onTap,
    super.onLongPress,
    super.onLongPressEnd,
    super.padding,
    super.accentColor,
    super.textStyle,
    super.width,
    super.hovered,
  });

  @override
  final AppKitButtonStyle style = AppKitButtonStyle.inline;

  @override
  State<_InlineButton> createState() => _InlineButtonState();
}

class _InlineButtonState extends _ButtonBaseState<_InlineButton> {
  late Color backgroundColor;
  late Color backgroundColorPressed;
  late Color backgroundColorHovered;

  bool get isDown => controller.isAnimating || controller.value > 0.0;

  bool get isHovered => widget.hovered;

  @override
  Widget buildButton(BuildContext context, BoxConstraints constraints) {
    Color textColor;
    final bool isDown = controller.isAnimating || controller.value > 0.0;
    final controlBackgroundColor = isDown || !isHovered
        ? Color.lerp(isHovered ? backgroundColorHovered : backgroundColor,
            backgroundColorPressed, colorAnimation.value)
        : backgroundColorHovered;

    if (widget.type == AppKitButtonType.destructive) {
      textColor =
          widget.buttonTheme.inline.destructiveColor ?? AppKitColors.systemRed;
    } else {
      final blendedColor = Color.lerp(
          widget.theme.canvasColor, backgroundColor, backgroundColor.a)!;
      if (blendedColor.computeLuminance() > 0.5) {
        textColor = AppKitColors.textColor.color;
      } else {
        textColor = AppKitColors.textColor.darkColor;
      }
    }

    final textStyle = widget.theme.typography.body.copyWith(
      color: textColor.multiplyOpacity(widget.enabled ? 1.0 : 0.3),
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
    if (!widget.enabled) {
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
        widget.theme.canvasColor, backgroundColor, backgroundColor.a)!;
    final blendedColorLuminance = blendedColor.computeLuminance();

    if (blendedColorLuminance > 0.15) {
      backgroundColorPressed = Color.lerp(backgroundColor, Colors.black, 0.15)!;
      backgroundColorHovered = Color.lerp(backgroundColor, Colors.black, 0.08)!;
    } else {
      backgroundColorPressed = Color.lerp(backgroundColor, Colors.white, 0.15)!;
      backgroundColorHovered = Color.lerp(backgroundColor, Colors.white, 0.08)!;
    }
  }
}

// #endregion

// #region ButtonBase
abstract class _ButtonBase extends StatefulWidget {
  final AppKitControlSize size;
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final GestureLongPressEndCallback? onLongPressEnd;
  final Color? accentColor;
  final EdgeInsetsGeometry? padding;
  final bool isMainWindow;
  final AppKitThemeData theme;
  final AppKitButtonThemeData buttonTheme;
  final AppKitButtonType type;
  final TextStyle? textStyle;
  final double? width;
  final bool hovered;

  abstract final AppKitButtonStyle style;

  const _ButtonBase({
    required this.size,
    required this.child,
    required this.isMainWindow,
    required this.theme,
    required this.buttonTheme,
    required this.type,
    this.onTap,
    this.onLongPress,
    this.onLongPressEnd,
    this.accentColor,
    this.padding,
    this.textStyle,
    this.width,
    this.hovered = false,
  });

  bool get enabled =>
      onTap != null || onLongPress != null || onLongPressEnd != null;

  bool get tapEnabled => onTap != null;

  bool get longPressEnabled => onLongPress != null || onLongPressEnd != null;
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

    if (oldWidget.enabled != widget.enabled ||
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
    widget.onTap?.call();
  }

  void _handleTapCancel() {
    if (widget.longPressEnabled) {
      return;
    }

    setState(() {
      controller.reverse();
    });
  }

  void _handleLongPressStart(LongPressStartDetails details) {
    setState(() {
      controller.forward();
    });
  }

  void _handleLongPressDown(LongPressDownDetails details) {
    setState(() {
      controller.forward();
    });
  }

  void _handleLongPressCancel() {
    setState(() {
      controller.reverse();
    });
  }

  void _handleLongPress() {
    widget.onLongPress?.call();
  }

  void _handleLongPressEnd(LongPressEndDetails details) {
    setState(() {
      controller.reverse();
    });
    widget.onLongPressEnd?.call(details);
  }

  void computeColors();

  Widget buildButton(BuildContext context, BoxConstraints constraints);

  @override
  Widget build(BuildContext context) {
    final constraints = widget.size.getBoxConstraints(widget.style)
      ..copyWith(maxWidth: widget.width, minWidth: widget.width);

    return SizedBox(
      width: widget.width,
      child: ConstrainedBox(
        constraints: constraints,
        child: GestureDetector(
          onLongPressStart:
              widget.longPressEnabled ? _handleLongPressStart : null,
          onLongPressDown: !widget.tapEnabled && widget.longPressEnabled
              ? _handleLongPressDown
              : null,
          onLongPressCancel: !widget.tapEnabled && widget.longPressEnabled
              ? _handleLongPressCancel
              : null,
          onLongPress: widget.onLongPress != null ? _handleLongPress : null,
          onLongPressEnd:
              widget.onLongPressEnd != null ? _handleLongPressEnd : null,
          onTapDown: widget.tapEnabled ? _handleTapDown : null,
          onTapUp: widget.tapEnabled ? _handleTapUp : null,
          onTapCancel: widget.tapEnabled ? _handleTapCancel : null,
          child: LayoutBuilder(builder: (context, constraints) {
            return buildButton(context, constraints);
          }),
        ),
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
            return const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 5.0);
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
