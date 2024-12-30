import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/material.dart';

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

  const AppKitButton({
    super.key,
    required this.size,
    required this.child,
    this.onPressed,
    this.accentColor,
    this.padding,
    this.semanticLabel,
    this.mouseCursor = SystemMouseCursors.basic,
    this.style = AppKitButtonStyle.inline,
    this.type = AppKitButtonType.primary,
  });

  @override
  State<AppKitButton> createState() => _AppKitButtonState();
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
            return _MaterialButtonImpl(
              type: widget.type,
              theme: theme,
              buttonTheme: buttonTheme,
              isMainWindow: isMainWindow,
              size: widget.size,
              onPressed: widget.onPressed,
              accentColor: widget.accentColor,
              padding: widget.padding,
              isEnabled: enabled,
              child: widget.child,
            );
          } else if (widget.style == AppKitButtonStyle.flat) {
            return _FlatButtonImpl(
              type: widget.type,
              theme: theme,
              buttonTheme: buttonTheme,
              isMainWindow: isMainWindow,
              size: widget.size,
              onPressed: widget.onPressed,
              accentColor: widget.accentColor,
              padding: widget.padding,
              isEnabled: enabled,
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

class _FlatButtonImpl extends _ButtonBase {
  const _FlatButtonImpl({
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
  });

  @override
  final AppKitButtonStyle style = AppKitButtonStyle.flat;

  @override
  State<_FlatButtonImpl> createState() => _FlatButtonImplState();
}

class _FlatButtonImplState extends _ButtonBaseState<_FlatButtonImpl> {
  late Color backgroundColor;
  late Color backgroundColorPressed;

  @override
  Widget buildButton(BuildContext context, BoxConstraints constraints) {
    Color textColor;
    final controlBackgroundColor = Color.lerp(
        backgroundColor, backgroundColorPressed, colorAnimation.value);
    final blendedColor = Color.lerp(
        widget.theme.canvasColor, backgroundColor, backgroundColor.opacity)!;
    if (blendedColor.computeLuminance() > 0.5) {
      textColor = AppKitColors.textColor.color;
    } else {
      textColor = AppKitColors.textColor.darkColor;
    }

    final textStyle = widget.theme.typography.body.copyWith(
      color: textColor.multiplyOpacity(widget.isEnabled ? 1.0 : 0.5),
      fontSize: widget.size.getFontSize(AppKitButtonStyle.flat),
      fontWeight: widget.size.getFontWeight(AppKitButtonStyle.flat),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
            widget.size.getBorderRadius(AppKitButtonStyle.flat)),
        color: controlBackgroundColor,
      ),
      child: SizedBox(
        height: constraints.maxHeight,
        child: Align(
          alignment: AlignmentDirectional.bottomCenter,
          child: Padding(
            padding: widget.padding ??
                widget.size.getPadding(AppKitButtonStyle.flat),
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
    if (!widget.isEnabled) {
      backgroundColor = widget.buttonTheme.flat.backgroundColorDisabled;
    } else {
      if (widget.type == AppKitButtonType.primary) {
        backgroundColor = widget.accentColor ??
            widget.buttonTheme.flat.accentColor ??
            widget.theme.activeColor;
      } else if (widget.type == AppKitButtonType.secondary) {
        backgroundColor = widget.accentColor ??
            widget.buttonTheme.flat.secondaryColor ??
            widget.theme.controlBackgroundColor;
      } else {
        backgroundColor = widget.accentColor ??
            widget.buttonTheme.flat.destructiveColor ??
            AppKitColors.systemRed;
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

class _MaterialButtonImpl extends _ButtonBase {
  const _MaterialButtonImpl({
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
  });

  @override
  final AppKitButtonStyle style = AppKitButtonStyle.inline;

  @override
  State<_MaterialButtonImpl> createState() => _MaterialButtonImplState();
}

class _MaterialButtonImplState extends _ButtonBaseState<_MaterialButtonImpl> {
  late Color backgroundColor;
  late Color backgroundColorPressed;

  @override
  Widget buildButton(BuildContext context, BoxConstraints constraints) {
    Color textColor;
    final controlBackgroundColor = Color.lerp(
        backgroundColor, backgroundColorPressed, colorAnimation.value);
    final blendedColor = Color.lerp(
        widget.theme.canvasColor, backgroundColor, backgroundColor.opacity)!;
    if (blendedColor.computeLuminance() > 0.5) {
      textColor = AppKitColors.textColor.color;
    } else {
      textColor = AppKitColors.textColor.darkColor;
    }

    final textStyle = widget.theme.typography.body.copyWith(
      color: textColor.multiplyOpacity(widget.isEnabled ? 1.0 : 0.5),
      fontSize: widget.size.getFontSize(AppKitButtonStyle.inline),
      fontWeight: widget.size.getFontWeight(AppKitButtonStyle.inline),
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
            padding: widget.padding ??
                widget.size.getPadding(AppKitButtonStyle.inline),
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
    if (!widget.isEnabled) {
      backgroundColor = widget.buttonTheme.inline.backgroundColorDisabled;
    } else {
      if (widget.type == AppKitButtonType.primary) {
        backgroundColor = widget.accentColor ??
            widget.buttonTheme.inline.accentColor ??
            widget.theme.activeColor;
      } else if (widget.type == AppKitButtonType.secondary) {
        backgroundColor = widget.accentColor ??
            widget.buttonTheme.inline.secondaryColor ??
            widget.theme.controlBackgroundColor;
      } else {
        backgroundColor = widget.accentColor ??
            widget.buttonTheme.inline.destructiveColor ??
            AppKitColors.systemRed;
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
  });
}

abstract class _ButtonBaseState<T extends _ButtonBase> extends State<T>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> colorAnimation;

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

extension _AppKitControlSizeX on AppKitControlSize {
  double getBorderRadius(AppKitButtonStyle style) {
    switch (this) {
      case AppKitControlSize.mini:
        switch (style) {
          case AppKitButtonStyle.inline:
            return 6.5;
          case AppKitButtonStyle.flat:
            return 2.0;
        }

      case AppKitControlSize.small:
        switch (style) {
          case AppKitButtonStyle.inline:
            return 8.0;
          case AppKitButtonStyle.flat:
            return 3.0;
        }

      case AppKitControlSize.regular:
        switch (style) {
          case AppKitButtonStyle.inline:
            return 12.0;
          case AppKitButtonStyle.flat:
            return 5.0;
        }

      case AppKitControlSize.large:
        switch (style) {
          case AppKitButtonStyle.inline:
            return 14.5;
          case AppKitButtonStyle.flat:
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
            return const BoxConstraints(
                minWidth: 26, maxHeight: 12, minHeight: 12);
        }

      case AppKitControlSize.small:
        switch (style) {
          case AppKitButtonStyle.inline:
            return const BoxConstraints(
                minWidth: 42, maxHeight: 16, minHeight: 16);
          case AppKitButtonStyle.flat:
            return const BoxConstraints(
                minWidth: 42, maxHeight: 14, minHeight: 14);
        }

      case AppKitControlSize.regular:
        switch (style) {
          case AppKitButtonStyle.inline:
            return const BoxConstraints(
                minWidth: 48, maxHeight: 24, minHeight: 24);
          case AppKitButtonStyle.flat:
            return const BoxConstraints(
                minWidth: 48, maxHeight: 22, minHeight: 22);
        }

      case AppKitControlSize.large:
        switch (style) {
          case AppKitButtonStyle.inline:
            return const BoxConstraints(
                minWidth: 54, maxHeight: 29, minHeight: 29);
          case AppKitButtonStyle.flat:
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
            return 8.0;
        }

      case AppKitControlSize.small:
        switch (style) {
          case AppKitButtonStyle.inline:
            return 9;
          case AppKitButtonStyle.flat:
            return 10;
        }

      case AppKitControlSize.regular:
        switch (style) {
          case AppKitButtonStyle.inline:
            return 12;
          case AppKitButtonStyle.flat:
            return 13;
        }

      case AppKitControlSize.large:
        switch (style) {
          case AppKitButtonStyle.inline:
            return 13.5;
          case AppKitButtonStyle.flat:
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
            return const EdgeInsets.only(left: 6.0, right: 6.0, bottom: 1.5);
        }

      case AppKitControlSize.small:
        switch (style) {
          case AppKitButtonStyle.inline:
            return const EdgeInsets.only(left: 13.5, right: 13.5, bottom: 2.5);
          case AppKitButtonStyle.flat:
            return const EdgeInsets.only(left: 7.0, right: 7.0, bottom: 1.5);
        }

      case AppKitControlSize.regular:
        switch (style) {
          case AppKitButtonStyle.inline:
            return const EdgeInsets.only(left: 20, right: 20, bottom: 5.5);
          case AppKitButtonStyle.flat:
            return const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 4.0);
        }
      case AppKitControlSize.large:
        switch (style) {
          case AppKitButtonStyle.inline:
            return const EdgeInsets.only(left: 26.5, right: 26.5, bottom: 6.5);
          case AppKitButtonStyle.flat:
            return const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 4.5);
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
            return AppKitFontWeight.normal;
        }
    }
  }
}

enum AppKitButtonStyle {
  inline,
  flat,
}

enum AppKitButtonType {
  primary,
  secondary,
  destructive,
}
