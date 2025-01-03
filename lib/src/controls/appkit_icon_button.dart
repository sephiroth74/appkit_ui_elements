import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppKitIconButton extends StatefulWidget {
  const AppKitIconButton({
    super.key,
    required this.icon,
    this.backgroundColor,
    this.disabledColor,
    this.hoverColor,
    this.pressedColor,
    this.onPressed,
    this.shape = BoxShape.rectangle,
    this.borderRadius,
    this.alignment = Alignment.center,
    this.semanticLabel,
    this.boxConstraints = const BoxConstraints(
      minHeight: 20,
      minWidth: 20,
      maxWidth: 30,
      maxHeight: 30,
    ),
    this.padding,
    this.mouseCursor = SystemMouseCursors.basic,
    this.color,
  });

  final Color? color;

  final IconData icon;

  final Color? backgroundColor;

  final Color? disabledColor;

  final Color? hoverColor;

  final Color? pressedColor;

  final VoidCallback? onPressed;

  final BoxShape shape;

  final BorderRadius? borderRadius;

  final AlignmentGeometry alignment;

  final BoxConstraints boxConstraints;

  final EdgeInsetsGeometry? padding;

  final String? semanticLabel;

  final MouseCursor? mouseCursor;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('backgroundColor', backgroundColor));
    properties.add(ColorProperty('disabledColor', disabledColor));
    properties.add(ColorProperty('hoverColor', hoverColor));
    properties.add(DiagnosticsProperty('alignment', alignment));
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding));
    properties.add(StringProperty('semanticLabel', semanticLabel));
  }

  @override
  AppKitIconButtonState createState() => AppKitIconButtonState();

  static AppKitIconTheme toolbar(
    BuildContext context, {
    required IconData icon,
    bool showLabel = false,
    VoidCallback? onPressed,
  }) {
    return AppKitIconTheme.toolbar(context,
        icon: icon, showLabel: showLabel, onPressed: onPressed);
  }
}

class AppKitIconButtonState extends State<AppKitIconButton> {
  bool _isHovered = false;

  bool get enabled => widget.onPressed != null;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(AppKitIconButton oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  bool _buttonHeldDown = false;

  set buttonHeldDown(bool value) {
    if (value != _buttonHeldDown) {
      setState(() {
        _buttonHeldDown = value;
      });
    }
  }

  void _handleTapDown(TapDownDetails event) {
    if (!_buttonHeldDown) {
      buttonHeldDown = true;
    }
  }

  void _handleTapUp(TapUpDetails event) {
    if (_buttonHeldDown) {
      buttonHeldDown = false;
    }
  }

  void _handleTapCancel() {
    if (_buttonHeldDown) {
      buttonHeldDown = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppKitIconButtonTheme.of(context);
    final iconTheme = AppKitIconTheme.of(context);

    final Color backgroundColor =
        widget.backgroundColor ?? theme.backgroundColor ?? Colors.transparent;
    final Color hoverColor =
        widget.hoverColor ?? theme.hoverColor ?? Colors.transparent;
    final Color? disabledColor = widget.disabledColor ?? theme.disabledColor;
    final Color pressedColor =
        widget.pressedColor ?? theme.pressedColor ?? Colors.transparent;
    final Color? iconColor =
        (widget.color ?? iconTheme.color)?.multiplyOpacity(enabled ? 1.0 : 0.5);

    final padding = widget.padding ?? theme.padding ?? const EdgeInsets.all(8);

    return MouseRegion(
      cursor: widget.mouseCursor!,
      onEnter: (e) {
        setState(() => _isHovered = true);
      },
      onExit: (e) {
        setState(() => _isHovered = false);
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: enabled ? _handleTapDown : null,
        onTapUp: enabled ? _handleTapUp : null,
        onTapCancel: enabled ? _handleTapCancel : null,
        onTap: widget.onPressed,
        child: Semantics(
          label: widget.semanticLabel,
          button: true,
          child: ConstrainedBox(
            constraints: widget.boxConstraints,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: widget.shape,
                borderRadius: widget.borderRadius ??
                    (widget.shape == BoxShape.rectangle
                        ? const BorderRadius.all(Radius.circular(6))
                        : null),
                color: !enabled
                    ? disabledColor
                    : _buttonHeldDown
                        ? pressedColor
                        : _isHovered
                            ? hoverColor
                            : backgroundColor,
              ),
              child: Padding(
                padding: padding,
                child: Align(
                  alignment: widget.alignment,
                  widthFactor: 1.0,
                  heightFactor: 1.0,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: AppKitIconTheme(
                      data: iconTheme.copyWith(color: iconColor),
                      child: AppKitIcon(icon: widget.icon),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color getPressedBackgroundColor(
      {required AppKitThemeData theme, required Color backgroundColor}) {
    final blendedBackgroundColor = Color.lerp(
      theme.canvasColor,
      backgroundColor,
      backgroundColor.a,
    )!;

    final luminance = blendedBackgroundColor.computeLuminance();
    final color = luminance > 0.5
        ? AppKitColors.controlBackgroundPressedColor.color
        : AppKitColors.controlBackgroundPressedColor.darkColor;
    return color;
  }
}
