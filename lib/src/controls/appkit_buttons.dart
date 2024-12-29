import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

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

  bool isDown = false;

  bool isHovered = false;

  void _handleMouseEnter(PointerEnterEvent event) {
    setState(() {
      isHovered = true;
    });
  }

  void _handleMouseExit(PointerExitEvent event) {
    setState(() {
      isHovered = false;
    });
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      isDown = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      isDown = false;
    });
    widget.onPressed?.call();
  }

  void _handleTapCancel() {
    setState(() {
      isDown = false;
    });
  }

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
        onEnter: enabled ? _handleMouseEnter : null,
        onExit: enabled ? _handleMouseExit : null,
        child: MainWindowBuilder(builder: (context, isMainWindow) {
          final theme = AppKitTheme.of(context);
          final buttonTheme = AppKitButtonTheme.of(context);
          if (widget.style == AppKitButtonStyle.inline) {
            return _MaterialButton(
              type: widget.type,
              theme: theme,
              buttonTheme: buttonTheme,
              isMainWindow: isMainWindow,
              size: widget.size,
              onPressed: widget.onPressed,
              accentColor: widget.accentColor,
              padding: widget.padding,
              isHovered: isHovered,
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

class _MaterialButton extends StatefulWidget {
  final AppKitControlSize size;
  final Widget child;
  final VoidCallback? onPressed;
  final Color? accentColor;
  final EdgeInsetsGeometry? padding;
  final bool isHovered;
  final bool isMainWindow;
  final bool isEnabled;
  final AppKitThemeData theme;
  final AppKitButtonThemeData buttonTheme;
  final AppKitButtonType type;

  const _MaterialButton({
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
    required this.isHovered,
  });

  @override
  State<_MaterialButton> createState() => _MaterialButtonState();
}

class _MaterialButtonState extends State<_MaterialButton>
    with SingleTickerProviderStateMixin {
  bool isDown = false;

  late AnimationController controller;
  late Animation<double> colorAnimation;
  late Color backgroundColor;
  late Color backgroundColorPressed;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(_MaterialButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.isEnabled != widget.isEnabled ||
        oldWidget.accentColor != widget.accentColor ||
        oldWidget.theme != widget.theme ||
        oldWidget.buttonTheme != widget.buttonTheme ||
        oldWidget.type != widget.type ||
        oldWidget.isMainWindow != widget.isMainWindow) {
      _computeColors();
    }
  }

  void _computeColors() {
    if (!widget.isEnabled) {
      backgroundColor = widget.buttonTheme.material.backgroundColorDisabled;
    } else {
      if (widget.type == AppKitButtonType.primary) {
        backgroundColor = widget.accentColor ??
            widget.buttonTheme.material.accentColor ??
            widget.theme.activeColor;
      } else if (widget.type == AppKitButtonType.secondary) {
        backgroundColor = widget.accentColor ??
            widget.buttonTheme.material.secondaryColor ??
            widget.theme.controlBackgroundColor;
      } else {
        backgroundColor = widget.accentColor ??
            widget.buttonTheme.material.destructiveColor ??
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

  @override
  void initState() {
    super.initState();
    _computeColors();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
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
      isDown = true;
      controller.forward();
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      isDown = false;
      controller.reverse();
    });
    widget.onPressed?.call();
  }

  void _handleTapCancel() {
    setState(() {
      isDown = false;
      controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: widget.size.getBoxConstraints(AppKitButtonStyle.inline),
      child: GestureDetector(
        onTapDown: widget.isEnabled ? _handleTapDown : null,
        onTapUp: widget.isEnabled ? _handleTapUp : null,
        onTapCancel: widget.isEnabled ? _handleTapCancel : null,
        child: LayoutBuilder(builder: (context, constraints) {
          Color textColor;
          final controlBackgroundColor = Color.lerp(
              backgroundColor, backgroundColorPressed, colorAnimation.value);
          final blendedColor = Color.lerp(widget.theme.canvasColor,
              backgroundColor, backgroundColor.opacity)!;
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
        }),
      ),
    );
  }
}

enum AppKitButtonStyle {
  inline,
}

enum AppKitButtonType {
  primary,
  secondary,
  destructive,
}

extension _AppKitControlSizeX on AppKitControlSize {
  BoxConstraints getBoxConstraints(AppKitButtonStyle style) {
    switch (this) {
      case AppKitControlSize.mini:
        return const BoxConstraints(minWidth: 26, maxHeight: 13, minHeight: 13);

      case AppKitControlSize.small:
        return const BoxConstraints(minWidth: 42, maxHeight: 16, minHeight: 16);

      case AppKitControlSize.regular:
        switch (style) {
          case AppKitButtonStyle.inline:
            return const BoxConstraints(
                minWidth: 48, maxHeight: 24, minHeight: 24);
        }

      case AppKitControlSize.large:
        switch (style) {
          case AppKitButtonStyle.inline:
            return const BoxConstraints(
                minWidth: 54, maxHeight: 29, minHeight: 29);
        }
    }
  }

  double getFontSize(AppKitButtonStyle style) {
    switch (this) {
      case AppKitControlSize.mini:
        switch (style) {
          case AppKitButtonStyle.inline:
            return 7.5;
        }

      case AppKitControlSize.small:
        switch (style) {
          case AppKitButtonStyle.inline:
            return 9;
        }

      case AppKitControlSize.regular:
        switch (style) {
          case AppKitButtonStyle.inline:
            return 12;
        }

      case AppKitControlSize.large:
        switch (style) {
          case AppKitButtonStyle.inline:
            return 13.5;
        }
    }
  }

  EdgeInsetsGeometry getPadding(AppKitButtonStyle style) {
    switch (this) {
      case AppKitControlSize.mini:
        return const EdgeInsets.only(
            left: 10, right: 10, top: 0.0, bottom: 1.5);

      case AppKitControlSize.small:
        switch (style) {
          case AppKitButtonStyle.inline:
            return const EdgeInsets.only(
                left: 13.5, right: 13.5, top: 0.0, bottom: 2.5);
        }
      case AppKitControlSize.regular:
        switch (style) {
          case AppKitButtonStyle.inline:
            return const EdgeInsets.only(
                left: 20, right: 20, top: 0.0, bottom: 5.5);
        }
      case AppKitControlSize.large:
        switch (style) {
          case AppKitButtonStyle.inline:
            return const EdgeInsets.only(
                left: 26.5, right: 26.5, top: 0.0, bottom: 6.5);
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
        return AppKitFontWeight.w500;
    }
  }
}
