import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:appkit_ui_elements/src/library.dart';
import 'package:appkit_ui_elements/src/utils/main_window_listener.dart';
import 'package:flutter/src/foundation/diagnostics.dart';
import 'package:macos_ui/macos_ui.dart';

const _kSize = 22.0;
const _kBorderRadiusRatio = 4.4;

class AppKitArrowButton extends StatefulWidget {
  final Color? color;
  final double size;
  final String? semanticLabel;
  final VoidCallback? onPressed;

  const AppKitArrowButton({
    super.key,
    this.color,
    this.size = _kSize,
    this.semanticLabel,
    this.onPressed,
  });

  bool get enabled => onPressed != null;

  @override
  State<AppKitArrowButton> createState() => _AppKitArrowButtonState();
}

class _AppKitArrowButtonState extends State<AppKitArrowButton> {
  @visibleForTesting
  bool buttonHeldDown = false;

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
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ColorProperty('color', widget.color));
    properties.add(DoubleProperty('size', widget.size));
    properties.add(StringProperty('semanticLabel', widget.semanticLabel));
    properties.add(ObjectFlagProperty<VoidCallback>(
        'onPressed', widget.onPressed,
        ifNull: 'disabled'));
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasAppKitTheme(context));
    final AppKitThemeData theme = AppKitTheme.of(context);

    return GestureDetector(
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
          child: MainWindowStreamBuilder(
            builder: (context, snapshot) {
              final bool isMainWindow = snapshot.data ?? true;
              final Color color = widget.enabled
                  ? (isMainWindow
                      ? widget.color ?? theme.controlBackgroundColor
                      : theme.controlBackgroundColor)
                  : theme.controlBackgroundColorDisabled;

              final colorLuminance = color.computeLuminance();

              final iconColor = colorLuminance >= 0.5
                  ? widget.enabled
                      ? MacosColors.labelColor.color
                      : MacosColors.tertiaryLabelColor.color
                  : widget.enabled
                      ? MacosColors.labelColor.darkColor
                      : MacosColors.tertiaryLabelColor.darkColor;

              final foregroundColor = colorLuminance >= 0.5
                  ? MacosColors.labelColor.color.withOpacity(0.1)
                  : MacosColors.labelColor.darkColor.withOpacity(0.1);

              return Container(
                foregroundDecoration: BoxDecoration(
                  color: buttonHeldDown ? foregroundColor : null,
                  borderRadius:
                      BorderRadius.circular(widget.size / _kBorderRadiusRatio),
                ),
                child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(
                            widget.size / _kBorderRadiusRatio),
                        boxShadow: [
                          BoxShadow(
                              color: MacosColors.black
                                  .withOpacity(widget.enabled ? 0.25 : 0.15),
                              blurStyle: BlurStyle.outer,
                              offset: const Offset(0, 0.15),
                              blurRadius: 1.0,
                              spreadRadius: 0),
                          BoxShadow(
                            color: MacosColors.black
                                .withOpacity(widget.enabled ? 0.055 : 0.025),
                            offset: const Offset(0, 0),
                            blurStyle: BlurStyle.solid,
                            blurRadius: 0,
                            spreadRadius: 0.5,
                          )
                        ]),
                    child: SizedBox.expand(
                      child: CustomPaint(
                        painter: _IconButtonPainter(
                          color: iconColor,
                          size: widget.size * 0.8,
                          icon: _ButtonIcon.arrows,
                        ),
                      ),
                    )),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _IconButtonPainter extends CustomPainter {
  final Color color;
  final double size;
  final _ButtonIcon icon;
  final Paint _paint;

  _IconButtonPainter(
      {required this.color, required this.size, required this.icon})
      : _paint = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = size / 10
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();

    switch (icon) {
      case _ButtonIcon.arrows:
        {
          final double halfSize = size.width / 2;
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
    }

    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(covariant _IconButtonPainter oldDelegate) {
    return color != oldDelegate.color || size != oldDelegate.size;
  }
}

enum _ButtonIcon { arrows }
