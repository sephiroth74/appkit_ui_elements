import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class AppKitButton extends StatefulWidget {
  final AppKitButtonStyle style;
  final AppKitControlSize size;
  final Widget child;
  final VoidCallback? onPressed;
  final Color? accentColor;
  final EdgeInsetsGeometry? padding;
  final String? semanticLabel;
  final MouseCursor? mouseCursor;

  const AppKitButton({
    required this.style,
    required this.size,
    required this.child,
    this.onPressed,
    this.accentColor,
    this.padding,
    this.semanticLabel,
    this.mouseCursor = SystemMouseCursors.basic,
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
    final theme = AppKitTheme.of(context);
    final buttonTheme = AppKitButtonTheme.of(context);
    final isMainWindow = MainWindowStateListener.instance.isMainWindow.value;
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
        child: Builder(builder: (context) {
          if (widget.style == AppKitButtonStyle.material) {
            return _MaterialButton(
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

  const _MaterialButton({
    required this.size,
    required this.child,
    required this.isMainWindow,
    required this.isEnabled,
    required this.theme,
    required this.buttonTheme,
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
  late Animation<Color?> colorAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    colorAnimation = ColorTween(
      begin: backgroundColor,
      end: backgroundColorPressed,
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

  late Color backgroundColor = !widget.isEnabled
      ? widget.buttonTheme.material.controlBackgroundColorDisabled
      : widget.accentColor ??
          widget.buttonTheme.material.accentColor ??
          widget.theme.activeColor;

  late Color backgroundColorPressed =
      Color.lerp(backgroundColor, Colors.black, 0.2) ??
          widget.theme.controlBackgroundPressedColor;

  late Color controlBackgroundColor = backgroundColor;

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
      constraints: widget.size.getBoxConstraints(AppKitButtonStyle.material),
      child: GestureDetector(
        onTapDown: widget.isEnabled ? _handleTapDown : null,
        onTapUp: widget.isEnabled ? _handleTapUp : null,
        onTapCancel: widget.isEnabled ? _handleTapCancel : null,
        child: LayoutBuilder(builder: (context, constraints) {
          final controlBackgroundColor =
              colorAnimation.value ?? backgroundColor;
          // Color backgroundColor = widget.accentColor ?? buttonTheme.material.accentColor ?? theme.activeColor;

          // if (!widget.isEnabled) {
          //   backgroundColor = buttonTheme.material.controlBackgroundColorDisabled;
          // } else {
          //   if (isDown) {
          //     backgroundColor = Color.lerp(backgroundColor, Colors.black, 0.2) ?? theme.controlBackgroundPressedColor;
          //   }
          // }

          Color textColor;

          if (controlBackgroundColor.computeLuminance() > 0.5) {
            textColor = AppKitColors.textColor.color;
          } else {
            textColor = AppKitColors.textColor.darkColor;
          }

          final textStyle = widget.theme.typography.body.copyWith(
            color: textColor.multiplyOpacity(widget.isEnabled ? 1.0 : 0.5),
            fontSize: widget.size.getFontSize(AppKitButtonStyle.material),
            fontWeight: widget.size.getFontWeight(AppKitButtonStyle.material),
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
                      widget.size.getPadding(AppKitButtonStyle.material),
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
  material,
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
          case AppKitButtonStyle.material:
            return const BoxConstraints(
                minWidth: 48, maxHeight: 24, minHeight: 24);
        }

      case AppKitControlSize.large:
        switch (style) {
          case AppKitButtonStyle.material:
            return const BoxConstraints(
                minWidth: 54, maxHeight: 29, minHeight: 29);
        }
    }
  }

  double getFontSize(AppKitButtonStyle style) {
    switch (this) {
      case AppKitControlSize.mini:
        switch (style) {
          case AppKitButtonStyle.material:
            return 7.5;
        }

      case AppKitControlSize.small:
        switch (style) {
          case AppKitButtonStyle.material:
            return 9;
        }

      case AppKitControlSize.regular:
        switch (style) {
          case AppKitButtonStyle.material:
            return 12;
        }

      case AppKitControlSize.large:
        switch (style) {
          case AppKitButtonStyle.material:
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
          case AppKitButtonStyle.material:
            return const EdgeInsets.only(
                left: 13.5, right: 13.5, top: 0.0, bottom: 2.5);
        }
      case AppKitControlSize.regular:
        switch (style) {
          case AppKitButtonStyle.material:
            return const EdgeInsets.only(
                left: 20, right: 20, top: 0.0, bottom: 5.5);
        }
      case AppKitControlSize.large:
        switch (style) {
          case AppKitButtonStyle.material:
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
