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
    this.type = AppKitIconButtonType.outlined,
  });

  final AppKitIconButtonType type;

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
    required Brightness brightness,
    required IconData icon,
    bool showLabel = false,
    VoidCallback? onPressed,
    Color? color,
  }) {
    return AppKitIconTheme.toolbar(
      context,
      brightness: brightness,
      icon: icon,
      showLabel: showLabel,
      onPressed: onPressed,
      color: color,
    );
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
            child: Builder(builder: (context) {
              if (widget.type == AppKitIconButtonType.outlined) {
                final Color backgroundColor = widget.backgroundColor ??
                    theme.outlined.backgroundColor ??
                    Colors.transparent;
                final Color hoverColor = widget.hoverColor ??
                    theme.outlined.hoverColor ??
                    Colors.transparent;
                final Color? disabledColor =
                    widget.disabledColor ?? theme.outlined.disabledColor;
                final Color pressedColor = widget.pressedColor ??
                    theme.outlined.pressedColor ??
                    Colors.transparent;
                final Color? iconColor = (widget.color ?? iconTheme.color)
                    ?.multiplyOpacity(enabled ? 1.0 : 0.5);
                final padding = widget.padding ??
                    theme.outlined.padding ??
                    const EdgeInsets.all(8);

                return _OutlinedContainer(
                    widget: widget,
                    enabled: enabled,
                    disabledColor: disabledColor,
                    buttonHeldDown: _buttonHeldDown,
                    pressedColor: pressedColor,
                    isHovered: _isHovered,
                    hoverColor: hoverColor,
                    backgroundColor: backgroundColor,
                    padding: padding,
                    iconTheme: iconTheme,
                    iconColor: iconColor);
              } else {
                final Color hoverColor = widget.hoverColor ??
                    theme.flat.hoverColor ??
                    Colors.transparent;
                final Color? disabledColor =
                    widget.disabledColor ?? theme.flat.disabledColor;
                final Color pressedColor = widget.pressedColor ??
                    theme.flat.pressedColor ??
                    Colors.transparent;
                final Color? iconColor = (widget.color ?? iconTheme.color)
                    ?.multiplyOpacity(enabled ? 1.0 : 0.5);
                final padding = widget.padding ??
                    theme.flat.padding ??
                    const EdgeInsets.all(8);

                return _PlainContainer(
                    widget: widget,
                    enabled: enabled,
                    disabledColor: disabledColor,
                    buttonHeldDown: _buttonHeldDown,
                    pressedColor: pressedColor,
                    isHovered: _isHovered,
                    hoverColor: hoverColor,
                    padding: padding,
                    iconTheme: iconTheme,
                    iconColor: iconColor);
              }
            }),
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

class _PlainContainer extends StatelessWidget {
  const _PlainContainer({
    required this.widget,
    required this.enabled,
    required this.disabledColor,
    required bool buttonHeldDown,
    required this.pressedColor,
    required bool isHovered,
    required this.hoverColor,
    required this.padding,
    required this.iconTheme,
    required this.iconColor,
  })  : _buttonHeldDown = buttonHeldDown,
        _isHovered = isHovered;

  final AppKitIconButton widget;
  final bool enabled;
  final Color? disabledColor;
  final bool _buttonHeldDown;
  final Color pressedColor;
  final bool _isHovered;
  final Color hoverColor;
  final EdgeInsetsGeometry padding;
  final AppKitIconThemeData iconTheme;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    AppKitIconThemeData iconTheme =
        AppKitIconTheme.of(context).copyWith(color: iconColor);
    final color = iconTheme.color;

    iconTheme = AppKitIconTheme.of(context).copyWith(
        color: !enabled
            ? disabledColor
            : _buttonHeldDown
                ? color?.merge(pressedColor)
                : _isHovered
                    ? color?.merge(hoverColor)
                    : color);

    return Padding(
      padding: padding,
      child: Align(
        alignment: widget.alignment,
        widthFactor: 1.0,
        heightFactor: 1.0,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: AppKitIconTheme(
            data: iconTheme,
            child: AppKitIcon(widget.icon),
          ),
        ),
      ),
    );
  }
}

class _OutlinedContainer extends StatelessWidget {
  const _OutlinedContainer({
    required this.widget,
    required this.enabled,
    required this.disabledColor,
    required bool buttonHeldDown,
    required this.pressedColor,
    required bool isHovered,
    required this.hoverColor,
    required this.backgroundColor,
    required this.padding,
    required this.iconTheme,
    required this.iconColor,
  })  : _buttonHeldDown = buttonHeldDown,
        _isHovered = isHovered;

  final AppKitIconButton widget;
  final bool enabled;
  final Color? disabledColor;
  final bool _buttonHeldDown;
  final Color pressedColor;
  final bool _isHovered;
  final Color hoverColor;
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final AppKitIconThemeData iconTheme;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
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
              child: AppKitIcon(widget.icon),
            ),
          ),
        ),
      ),
    );
  }
}
