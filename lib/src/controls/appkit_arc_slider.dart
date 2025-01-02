import 'dart:math';

import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const _kArcSweepAngle = 20.0;
const _kSize = 48.0;

class AppKitArcSlider extends StatefulWidget {
  final double size;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double>? onChanged;
  final double sweepAngle;
  final String? semanticLabel;
  final double? thumbRadius;
  final Color? trackColor;
  final Color? progressColor;
  final double? trackWidth;
  final double? progressWidth;

  const AppKitArcSlider({
    super.key,
    required this.value,
    this.size = _kSize,
    this.min = 0.0,
    this.max = 1.0,
    this.sweepAngle = _kArcSweepAngle,
    this.onChanged,
    this.semanticLabel,
    this.thumbRadius,
    this.trackColor,
    this.trackWidth,
    this.progressWidth,
    this.progressColor,
  })  : assert(value >= min && value <= max),
        assert(min < max),
        assert(size > 0),
        assert(sweepAngle >= 0 && sweepAngle < 180),
        assert(
            thumbRadius == null || thumbRadius > 0 || thumbRadius < size / 3);

  @override
  State<AppKitArcSlider> createState() => _AppKitArcSliderState();
}

class _AppKitArcSliderState extends State<AppKitArcSlider> {
  double thumbRadius = 0;

  double get sweepAngle => widget.sweepAngle;

  double get size => widget.size - (thumbRadius * 2);

  double get bounds => widget.size;

  double get radius => size / 2;

  bool get enabled => widget.onChanged != null;

  double get value => widget.value;

  Offset get center =>
      Offset((size / 2) + thumbRadius, (size / 2) + thumbRadius);

  Offset get centerOffset => Offset(thumbRadius, thumbRadius);

  bool _panStarted = false;

  set panStarted(bool value) {
    setState(() => _panStarted = value);
  }

  @override
  void initState() {
    super.initState();
  }

  void _setValue(double value) {
    widget.onChanged?.call(value);
  }

  _thumbPosition() {
    final center = this.center;
    final sweepAngle = value * (360 - this.sweepAngle * 2) * (pi / 180) +
        (this.sweepAngle * pi / 180);
    return Offset(
      center.dx + (size / 2) * cos(sweepAngle - pi / 2),
      center.dy + (size / 2) * sin(sweepAngle - pi / 2),
    );
  }

  void _handleThumbPan(DragUpdateDetails details) {
    final localPosition = details.localPosition + centerOffset;
    final delta = details.delta;

    // // find angle of the pan relative to the center of the wheel
    // final center = this.center;
    // final angle = atan2(localPosition.dy - center.dy, localPosition.dx - center.dx);
    // // find the new value based on the angle
    // final newAngle = angle + pi / 2;
    // final newValue = (newAngle / (2 * pi)) % 1;
    // logger.d('newAngle: $newAngle, newValue: $newValue');
    // _setValue(newValue.clamp(widget.min, widget.max));
    // return;

    /// Pan location on the wheel
    bool onTop = localPosition.dy <= radius;
    bool onLeftSide = localPosition.dx <= radius;
    bool onRightSide = !onLeftSide;
    bool onBottom = !onTop;

    /// Pan movements
    bool panUp = delta.dy <= 0.0;
    bool panLeft = delta.dx <= 0.0;
    bool panRight = !panLeft;
    bool panDown = !panUp;

    /// Absoulte change on axis
    double yChange = delta.dy.abs();
    double xChange = delta.dx.abs();

    /// Directional change on wheel
    double verticalRotation = (onRightSide && panDown) || (onLeftSide && panUp)
        ? yChange
        : yChange * -1;
    double horizontalRotation =
        (onTop && panRight) || (onBottom && panLeft) ? xChange : xChange * -1;

    // Total computed change
    double rotationalChange = (verticalRotation + horizontalRotation) * 2;

    final double clampedValue = value + rotationalChange / 360;
    _setValue(clampedValue.clamp(widget.min, widget.max));
  }

  void _handleTrackPan(DragUpdateDetails details) {
    double xDelta = details.delta.dx / radius;
    double yDelta = details.delta.dy / radius;

    double clampedValue = value + (xDelta + yDelta);
    if (clampedValue != value) {
      setState(() {
        final value = clampedValue.clamp(widget.min, widget.max);
        _setValue(value);
      });
    }
  }

  void _handlePanDown(DragDownDetails details) {
    final thumbCenter = _thumbPosition();

    final distance = (details.localPosition - thumbCenter).distance;
    if (distance > thumbRadius) {
      panStarted = false;
    } else {
      panStarted = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    debugCheckHasAppKitTheme(context);
    return Semantics(
      slider: true,
      label: widget.semanticLabel,
      value: value.toStringAsFixed(2),
      child: Builder(builder: (context) {
        final AppKitThemeData theme = AppKitTheme.of(context);
        final AppKitSliderThemeData sliderTheme = AppKitSliderTheme.of(context);

        if (thumbRadius == 0) {
          thumbRadius =
              widget.thumbRadius ?? (sliderTheme.continuousThumbSize / 3);
        }

        final isMainWindow =
            MainWindowStateListener.instance.isMainWindow.value;
        final enabledFactor = enabled ? 1.0 : 0.5;

        final accentColor = isMainWindow
            ? (widget.progressColor ??
                sliderTheme.sliderColor ??
                theme.activeColor)
            : (sliderTheme.accentColorUnfocused ?? theme.activeColorUnfocused);

        final trackColor = widget.trackColor ?? sliderTheme.trackColor;

        return SizedBox(
          width: bounds,
          height: bounds,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onPanDown: enabled ? _handlePanDown : null,
            onPanEnd: (details) => panStarted = false,
            onPanCancel: () => panStarted = false,
            onPanUpdate: enabled
                ? (details) {
                    if (_panStarted) {
                      _handleThumbPan(details);
                    } else {
                      _handleTrackPan(details);
                    }
                  }
                : null,
            child: Stack(
              children: [
                // track
                Positioned(
                  left: thumbRadius,
                  top: thumbRadius,
                  width: size,
                  height: size,
                  child: CustomPaint(
                    painter: _TrackPainter(
                      color: trackColor
                          .withOpacity(trackColor.opacity * enabledFactor),
                      strokeWidth: widget.trackWidth ?? sliderTheme.trackHeight,
                      sweepAngle: sweepAngle,
                    ),
                  ),
                ),

                // progress
                Positioned(
                  left: thumbRadius,
                  top: thumbRadius,
                  width: size,
                  height: size,
                  child: CustomPaint(
                    painter: _ProgressPainter(
                      color: accentColor
                          .withOpacity(accentColor.opacity * enabledFactor),
                      value: value,
                      strokeWidth:
                          widget.progressWidth ?? sliderTheme.trackHeight,
                      sweepAngle: sweepAngle,
                    ),
                  ),
                ),

                // thumb
                Positioned(
                  top: _thumbPosition().dy - thumbRadius,
                  left: _thumbPosition().dx - thumbRadius,
                  width: thumbRadius * 2,
                  height: thumbRadius * 2,
                  child: AppKitCircularSliderThumb(
                    color: Colors.white,
                    continuousThumbSize: thumbRadius,
                    foregroundColor: (enabled && _panStarted)
                        ? AppKitColors.fills.opaque.tertiary.color
                        : null,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('value', value));
    properties.add(DoubleProperty('min', widget.min));
    properties.add(DoubleProperty('max', widget.max));
    properties.add(ObjectFlagProperty<ValueChanged<double>>.has(
        'onChanged', widget.onChanged));
  }
}

class _ProgressPainter extends CustomPainter {
  final Color color;
  final double value;
  final double strokeWidth;
  final double sweepAngle;

  _ProgressPainter({
    required this.color,
    required this.value,
    required this.strokeWidth,
    required this.sweepAngle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final startAngle = (-90 + this.sweepAngle) * (pi / 180);
    final sweepAngle = value * (360 - this.sweepAngle * 2) * (pi / 180);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle,
        sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! _ProgressPainter ||
        oldDelegate.color != color ||
        oldDelegate.value != value ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.sweepAngle != sweepAngle;
  }
}

class _TrackPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double sweepAngle;

  _TrackPainter({
    required this.color,
    required this.strokeWidth,
    required this.sweepAngle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final startAngle = (-90 + this.sweepAngle) * (pi / 180);
    final sweepAngle = (360 - this.sweepAngle * 2) * (pi / 180);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle,
        sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! _TrackPainter ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.sweepAngle != sweepAngle;
  }
}
