import 'dart:math';

import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const _kArcSweepAngle = 20.0;
const _kSize = 48.0;

/// A custom slider widget that displays a slider in an arc shape.
///
/// The [AppKitArcSlider] widget allows users to select a value from a range
/// by dragging a thumb along an arc. The arc's appearance and behavior can be
/// customized using various properties.
///
/// The [value] property must be between [min] and [max].
///
/// Example usage:
/// ```dart
/// AppKitArcSlider(
///   value: 0.5,
///   min: 0.0,
///   max: 1.0,
///   onChanged: (newValue) {
///     print('New value: $newValue');
///   },
/// )
/// ```
class AppKitArcSlider extends StatefulWidget {
  /// The size of the slider.
  ///
  /// Defaults to [_kSize].
  final double size;

  /// The current value of the slider.
  ///
  /// Must be between [min] and [max].
  final double value;

  /// The minimum value the slider can have.
  ///
  /// Defaults to 0.0.
  final double min;

  /// The maximum value the slider can have.
  ///
  /// Defaults to 1.0.
  final double max;

  /// Called when the user changes the slider's value.
  ///
  /// If null, the slider will be disabled.
  final ValueChanged<double>? onChanged;

  /// The sweep angle of the arc in degrees.
  ///
  /// Defaults to [_kArcSweepAngle].
  final double sweepAngle;

  /// The semantic label for the slider.
  ///
  /// Used by accessibility tools to describe the slider.
  final String? semanticLabel;

  /// The radius of the thumb.
  ///
  /// If null, a default radius will be used.
  final double? thumbRadius;

  /// The color of the track.
  ///
  /// If null, a default color will be used.
  final Color? trackColor;

  /// The color of the progress indicator.
  ///
  /// If null, a default color will be used.
  final Color? progressColor;

  /// The width of the track.
  ///
  /// If null, a default width will be used.
  final double? trackWidth;

  /// The width of the progress indicator.
  ///
  /// If null, a default width will be used.
  final double? progressWidth;

  /// Creates an [AppKitArcSlider] widget.
  ///
  /// The [value] parameter must be between [min] and [max].
  /// The [size] parameter must be greater than 0.
  /// The [sweepAngle] parameter must be between 0 and 180 degrees.
  /// The [thumbRadius] parameter, if provided, must be greater than 0 and less than [size] / 3.
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

/// The state for an [AppKitArcSlider] widget.
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
                      color: trackColor.withValues(
                          alpha: trackColor.a * enabledFactor),
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
                      color: accentColor.withValues(
                          alpha: accentColor.a * enabledFactor),
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
