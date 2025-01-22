import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/cupertino.dart' as cupertino;
import 'package:flutter/foundation.dart';

const double _kSize = 64.0;
const double _kStrokeWidth = 10.0;

/// A widget that displays a circular progress indicator.
///
/// The `AppKitProgressCircle` is a stateless widget that shows a circular
/// progress indicator, typically used to indicate that the application is
/// performing a task.
///
/// This widget can be customized to fit the design and requirements of your
/// application.
class AppKitProgressCircle extends StatelessWidget {
  /// The current value of the progress circle. If null, the progress circle will be indeterminate.
  final double? value;

  /// The color of the progress circle.
  final Color? color;

  /// The color of the track behind the progress circle.
  final Color? trackColor;

  /// The size of the progress circle.
  final double _size;

  /// The stroke width of the progress circle.
  final double _strokeWidth;

  /// The semantic label for the progress circle, used for accessibility.
  final String? semanticsLabel;

  /// Creates an instance of [AppKitProgressCircle].
  ///
  /// This widget displays a circular progress indicator.
  ///
  /// The [AppKitProgressCircle] can be customized with various properties
  /// to match the desired appearance and behavior.
  ///
  /// If value if null, the progress circle will be indeterminate.
  ///
  /// Example usage:
  /// ```dart
  /// AppKitProgressCircle(
  ///   value: 0.5,
  /// );
  /// ```
  const AppKitProgressCircle({
    super.key,
    this.value,
    double? size = _kSize,
    double? strokeWidth = _kStrokeWidth,
    this.color,
    this.trackColor,
    this.semanticsLabel,
  })  : _size = size ?? _kSize,
        _strokeWidth = strokeWidth ?? _kStrokeWidth,
        assert(value == null || (value >= 0.0 && value <= 1.0)),
        assert(size == null || size >= 0.0),
        assert(strokeWidth == null || strokeWidth >= 0.0);

  bool get indeterminate => value == null;

  double get size => _size;

  double get strokeWidth => _strokeWidth;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('value', value));
    properties.add(DoubleProperty('size', size));
    properties.add(ColorProperty('color', color));
    properties.add(ColorProperty('trackColor', trackColor));
    properties.add(StringProperty('semanticsLabel', semanticsLabel));
    properties.add(FlagProperty('indeterminate',
        value: indeterminate, ifTrue: 'indeterminate'));
  }

  @override
  Widget build(BuildContext context) {
    if (indeterminate) {
      return Semantics(
        label: semanticsLabel,
        child: cupertino.CupertinoActivityIndicator(radius: size / 2),
      );
    }
    return Semantics(
      value: value?.toStringAsFixed(2),
      label: semanticsLabel,
      child: MainWindowBuilder(builder: (context, isMainWindow) {
        final theme = AppKitTheme.of(context);
        final progressTheme = AppKitProgressTheme.of(context);
        final isMainWindow =
            MainWindowStateListener.instance.isMainWindow.value;
        final color = isMainWindow
            ? (this.color ?? progressTheme.color ?? theme.activeColor)
            : (progressTheme.accentColorUnfocused ?? const Color(0xFFbababa));
        final trackColor = this.trackColor ?? progressTheme.trackColor;

        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _CircularProgressPainter(
              value: value!,
              color: color,
              trackColor: trackColor,
              strokeWidth: strokeWidth,
            ),
          ),
        );
      }),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double value;
  final Color color;
  final Color trackColor;
  final double strokeWidth;
  final double startAngle = -90.0;
  late final Color darkerColor;

  _CircularProgressPainter({
    required this.value,
    required this.color,
    required this.trackColor,
    required this.strokeWidth,
  }) {
    final hsvColor = HSLColor.fromColor(trackColor);
    darkerColor = hsvColor.withLightness(hsvColor.lightness * .5).toColor();
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Rect.largest, Paint());

    final paint = Paint()
      ..color = trackColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double stopSize = (strokeWidth / size.longestSide);
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    canvas.drawCircle(center, radius, paint);

    paint
      ..style = PaintingStyle.fill
      ..shader = RadialGradient(
        colors: [
          darkerColor.withValues(alpha: 0.05),
          darkerColor.withValues(alpha: 0.0),
          darkerColor.withValues(alpha: 0.05),
        ],
        stops: [1 - stopSize * 2, 1 - stopSize, 1],
      ).createShader(
          Rect.fromCircle(center: center, radius: radius + strokeWidth / 2));

    canvas.drawCircle(center, radius + strokeWidth / 2, paint);

    canvas.drawCircle(
        center, radius - strokeWidth / 2, Paint()..blendMode = BlendMode.clear);

    // draw the progress
    paint
      ..shader = null
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 360.0 * value;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle * 0.0174533,
      sweepAngle * 0.0174533,
      false,
      paint,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.color != color ||
        oldDelegate.trackColor != trackColor;
  }
}
