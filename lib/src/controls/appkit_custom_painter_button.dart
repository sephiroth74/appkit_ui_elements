import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const _kSize = 22.0;
const _kBorderRadiusRatio = 4.4;

class AppKitCustomPainterButton extends StatefulWidget {
  final Color? color;
  final double size;
  final String? semanticLabel;
  final VoidCallback? onPressed;
  final AppKitControlButtonIcon icon;
  final AppKitControlButtonIconStyle style;

  const AppKitCustomPainterButton({
    super.key,
    this.color,
    this.size = _kSize,
    this.semanticLabel,
    this.onPressed,
    required this.icon,
    this.style = AppKitControlButtonIconStyle.bordered,
  });

  bool get enabled => onPressed != null;

  @override
  State<AppKitCustomPainterButton> createState() =>
      _AppKitCustomPainterButtonState();
}

class _AppKitCustomPainterButtonState extends State<AppKitCustomPainterButton> {
  bool _buttonHeldDown = false;
  bool _isHovered = false;

  void _handleTapDown(TapDownDetails event) {
    if (!_buttonHeldDown) {
      setState(() => _buttonHeldDown = true);
    }
  }

  void _handleTapUp(TapUpDetails event) {
    if (_buttonHeldDown) {
      setState(() => _buttonHeldDown = false);
    }
  }

  void _handleTapCancel() {
    if (_buttonHeldDown) {
      setState(() => _buttonHeldDown = false);
    }
  }

  void _handleMouseEnter() {
    setState(() {
      _isHovered = true;
    });
  }

  void _handleMouseExit() {
    setState(() {
      _isHovered = false;
    });
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('color', widget.color));
    properties.add(DoubleProperty('size', widget.size));
    properties.add(StringProperty('semanticLabel', widget.semanticLabel));
    properties.add(ObjectFlagProperty<VoidCallback>(
        'onPressed', widget.onPressed,
        ifNull: 'disabled'));
    properties.add(EnumProperty<AppKitControlButtonIcon>('icon', widget.icon));
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasAppKitTheme(context));

    return MouseRegion(
      onEnter: widget.enabled ? (_) => _handleMouseEnter : null,
      onExit: widget.enabled ? (_) => _handleMouseExit : null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: widget.enabled ? _handleTapDown : null,
        onTapUp: widget.enabled ? _handleTapUp : null,
        onTapCancel: widget.enabled ? _handleTapCancel : null,
        onTap: widget.enabled ? () => widget.onPressed?.call() : null,
        child: Semantics(
          label: widget.semanticLabel,
          button: true,
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: widget.size,
                minHeight: widget.size,
                maxWidth: widget.size,
                maxHeight: widget.size),
            child: MainWindowBuilder(builder: (context, isMainWindow) {
              final theme = AppKitTheme.of(context);
              switch (widget.style) {
                case AppKitControlButtonIconStyle.bordered:
                  return buildBorderedContainer(
                      theme: theme, isMainWindow: isMainWindow);
              }
            }),
          ),
        ),
      ),
    );
  }

  Widget buildBorderedContainer({
    required AppKitThemeData theme,
    required bool isMainWindow,
  }) {
    final Color color = widget.enabled
        ? (isMainWindow
            ? widget.color ?? theme.controlColor
            : theme.controlColor)
        : theme.controlColor.multiplyOpacity(0.5);

    final isDark = theme.brightness == Brightness.dark;
    final colorLuminance = color.computeLuminance();

    final iconColor = colorLuminance >= 0.5
        ? widget.enabled
            ? isDark
                ? AppKitColors.labelColor.darkColor
                : AppKitColors.labelColor.color
            : (isDark
                    ? AppKitColors.labelColor.darkColor
                    : AppKitColors.labelColor.color)
                .withOpacity(0.35)
        : widget.enabled
            ? isDark
                ? AppKitColors.labelColor.darkColor
                : AppKitColors.labelColor.color
            : (isDark
                    ? AppKitColors.labelColor.color
                    : AppKitColors.labelColor.darkColor)
                .withOpacity(0.35);

    final foregroundColor = colorLuminance >= 0.5
        ? AppKitColors.labelColor.color.withOpacity(0.1)
        : AppKitColors.labelColor.darkColor.withOpacity(0.1);

    return Container(
      foregroundDecoration: BoxDecoration(
        color: _buttonHeldDown ? foregroundColor : null,
        borderRadius: BorderRadius.circular(widget.size / _kBorderRadiusRatio),
      ),
      child: DecoratedBox(
          decoration: BoxDecoration(
              color: color,
              borderRadius:
                  BorderRadius.circular(widget.size / _kBorderRadiusRatio),
              boxShadow: [
                BoxShadow(
                  color: AppKitColors.shadowColor.color.withOpacity(0.75),
                  blurRadius: 0.5,
                  spreadRadius: 0,
                  offset: const Offset(0, 0.5),
                  blurStyle: BlurStyle.outer,
                ),
              ]),
          child: SizedBox.expand(
            child: CustomPaint(
              painter: IconButtonPainter(
                color: iconColor,
                size: widget.size * 0.8,
                icon: widget.icon,
              ),
            ),
          )),
    );
  }
}

class IconButtonPainter extends CustomPainter {
  final Color color;
  final double size;
  final AppKitControlButtonIcon icon;
  final Paint _paint;
  final Offset offset;
  final double? strokeWidth;
  final StrokeCap? strokeCap;

  IconButtonPainter({
    required this.color,
    required this.size,
    required this.icon,
    this.offset = Offset.zero,
    this.strokeWidth,
    this.strokeCap,
  }) : _paint = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth ?? size / 10
          ..strokeCap = strokeCap ?? StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    final double halfSize = size.width / 2;

    // canvas.drawRect(Rect.fromLTRB(0, 0, size.width, size.height), Paint()..color = Colors.amber.withOpacity(0.5));

    switch (icon) {
      case AppKitControlButtonIcon.arrows:
        {
          final double arrowWidthSize = size.width / 8.88;
          final double arrowHeightSize = size.width / 8.88;
          final double padding = size.width / 8.88;
          path.moveTo(halfSize - arrowWidthSize, halfSize - padding);
          path.lineTo(halfSize, halfSize - padding - arrowHeightSize);
          path.lineTo(halfSize + arrowWidthSize, halfSize - padding);
          path.moveTo(halfSize - arrowWidthSize, halfSize + padding);
          path.lineTo(halfSize, halfSize + padding + arrowHeightSize);
          path.lineTo(halfSize + arrowWidthSize, halfSize + padding);
          break;
        }

      case AppKitControlButtonIcon.disclosureUp:
        {
          final double arrowWidthSize = size.width / 6.285;
          final double arrowHeightSize = size.width / 11;
          path.moveTo(halfSize - arrowWidthSize + offset.dx,
              halfSize + arrowHeightSize + offset.dy);
          path.lineTo(
              halfSize + offset.dx, halfSize - arrowHeightSize + offset.dy);
          path.lineTo(halfSize + offset.dx + arrowWidthSize,
              halfSize + arrowHeightSize + offset.dy);
          break;
        }

      case AppKitControlButtonIcon.disclosureDown:
        {
          final double arrowWidthSize = size.width / 6.285;
          final double arrowHeightSize = size.width / 11;
          path.moveTo(halfSize - arrowWidthSize + offset.dx,
              halfSize - arrowHeightSize + offset.dy);
          path.lineTo(
              halfSize + offset.dx, halfSize + arrowHeightSize + offset.dy);
          path.lineTo(halfSize + arrowWidthSize + offset.dx,
              halfSize - arrowHeightSize + offset.dy);
          break;
        }

      case AppKitControlButtonIcon.arrowLeft:
        {
          // draw an arrow pointing left
          final double arrowWidthSize = size.width / 11;
          final double arrowHeightSize = size.width / 6.285;
          path.moveTo(halfSize + arrowWidthSize + offset.dx,
              halfSize - arrowHeightSize + offset.dy);
          path.lineTo(
              halfSize - arrowWidthSize + offset.dx, halfSize + offset.dy);
          path.lineTo(halfSize + arrowWidthSize + offset.dx,
              halfSize + arrowHeightSize + offset.dy);

          break;
        }
    }

    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(covariant IconButtonPainter oldDelegate) {
    return color != oldDelegate.color || size != oldDelegate.size;
  }
}

enum AppKitControlButtonIcon { arrows, disclosureUp, disclosureDown, arrowLeft }

enum AppKitControlButtonIconStyle { bordered }
