import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const _kHeight = 6.0;
const _kAnimationDuration = Duration(milliseconds: 1500);

abstract class AppKitProgress {
  const AppKitProgress._();

  static Widget circle({
    double? value,
    Color? color,
    Color? trackColor,
    double? size,
    double? strokeWidth,
    String? semanticsLabel,
  }) {
    return AppKitProgressCircle(
      value: value,
      color: color,
      trackColor: trackColor,
      size: size,
      strokeWidth: strokeWidth,
      semanticsLabel: semanticsLabel,
    );
  }

  static Widget linear({
    double? value,
    double height = _kHeight,
    Color? trackColor,
    Color? color,
    String? semanticsLabel,
  }) {
    return AppKitProgressBar(
      value: value,
      height: height,
      trackColor: trackColor,
      color: color,
      semanticsLabel: semanticsLabel,
    );
  }
}

class AppKitProgressBar extends StatefulWidget {
  final double? value;
  final double height;
  final Color? trackColor;
  final Color? color;
  final String? semanticsLabel;

  const AppKitProgressBar({
    super.key,
    this.value,
    this.height = _kHeight,
    this.trackColor,
    this.color,
    this.semanticsLabel,
  });

  @override
  State<AppKitProgressBar> createState() => _AppKitProgressBarState();
}

class _AppKitProgressBarState extends State<AppKitProgressBar>
    with TickerProviderStateMixin {
  bool get inderterminate => widget.value == null;

  late final AnimationController _controller;
  late final Animation<double> _progressEndAnimation;
  late final Animation<double> _progressLeftAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: _kAnimationDuration, value: 0.0);

    _progressEndAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.1, 0.9, curve: Curves.easeInOut)));

    _progressLeftAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.4, 0.95, curve: Curves.easeInOut)));

    Tween<double>(begin: 1.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: const Interval(0.9, 1.0)));

    Tween<double>(begin: 0.0, end: 0.0).animate(
        CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.1)));

    if (inderterminate) {
      _controller.addListener(_animationListener);
      _controller.addStatusListener(_animationStatusListener);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.repeat(reverse: true);
      });
    }
  }

  @override
  void dispose() {
    if (inderterminate) {
      _progressEndAnimation.removeListener(_animationListener);
      _progressEndAnimation.removeStatusListener(_animationStatusListener);
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('value', widget.value));
    properties.add(DoubleProperty('height', widget.height));
    properties.add(StringProperty('semanticsLabel', widget.semanticsLabel));
    properties.add(ColorProperty('trackColor', widget.trackColor));
    properties.add(ColorProperty('color', widget.color));
  }

  void _animationListener() {
    setState(() {});
  }

  void _animationStatusListener(AnimationStatus status) {}

  @override
  Widget build(BuildContext context) {
    debugCheckHasAppKitTheme(context);

    return Semantics(
        value: widget.value?.toStringAsFixed(2) ?? 'Indeterminate',
        label: widget.semanticsLabel,
        child: Builder(builder: (context) {
          final theme = AppKitTheme.of(context);
          final progressTheme = AppKitProgressTheme.of(context);
          final isDark = theme.brightness == Brightness.dark;
          return ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: widget.height, minHeight: widget.height),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final realWidth = constraints.maxWidth;

                final width = realWidth - widget.height;
                final borderRadius = BorderRadius.circular(widget.height / 2);
                final isMainWindow =
                    MainWindowStateListener.instance.isMainWindow.value;
                final trackColor =
                    widget.trackColor ?? progressTheme.trackColor;
                final color = isMainWindow
                    ? (widget.color ?? progressTheme.color ?? theme.activeColor)
                    : (progressTheme.accentColorUnfocused ??
                        theme.activeColorUnfocused);

                final double progressEnd;
                final double progressLeft;

                if (inderterminate) {
                  final bool isForward =
                      _controller.status == AnimationStatus.forward;

                  if (isForward) {
                    progressLeft = (width * _progressLeftAnimation.value);
                    progressEnd = (width * _progressEndAnimation.value);
                  } else {
                    progressLeft =
                        (width * _progressEndAnimation.value + widget.height);
                    progressEnd =
                        (width * _progressLeftAnimation.value - widget.height);
                  }
                } else {
                  progressLeft = 0.0;
                  progressEnd = (width * widget.value!);
                }

                return SizedBox(
                  width: realWidth,
                  child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: trackColor,
                        borderRadius: borderRadius,
                        border: Border.all(
                          color: isDark
                              ? AppKitColors.fills.opaque.quaternary.color
                              : AppKitColors.fills.opaque.quaternary.darkColor,
                          width: 1.0,
                        ),
                        // TODO: Check this
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: AppKitDynamicColor.resolve(context, AppKitColors.shadowColor).withValues(alpha: 0.5),
                        //     spreadRadius: -widget.height / 6,
                        //     blurRadius: widget.height / 6,
                        //   ),
                        // ],
                      ),
                      child: CustomPaint(
                        painter: _ProgressPainter(
                          left: progressLeft,
                          end: progressEnd + widget.height,
                          isMainWindow: isMainWindow,
                          borderRadius: borderRadius,
                          progressColor: color,
                        ),
                      )),
                );
              },
            ),
          );
        }));
  }
}

class _ProgressPainter extends CustomPainter {
  final double end;
  final double left;
  final bool isMainWindow;
  final BorderRadius borderRadius;
  final Color progressColor;
  late final LinearGradient gradient;
  late final Color darkerColor;

  _ProgressPainter({
    required this.left,
    required this.end,
    required this.isMainWindow,
    required this.borderRadius,
    required this.progressColor,
  }) {
    final hsvColor = HSLColor.fromColor(progressColor);
    darkerColor = hsvColor.withLightness(hsvColor.lightness * .5).toColor();
    gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        darkerColor.withValues(alpha: 0.1),
        darkerColor.withValues(alpha: 0.0),
        darkerColor.withValues(alpha: 0.05),
      ],
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromLTRB(left, 0, end, size.height);
    final rrect = RRect.fromRectAndCorners(rect,
        topLeft: borderRadius.topLeft,
        bottomLeft: borderRadius.bottomLeft,
        topRight: borderRadius.topRight,
        bottomRight: borderRadius.bottomRight);
    canvas.drawRRect(rrect, paint);

    if (isMainWindow) {
      paint.shader = gradient.createShader(rect);
      canvas.drawRRect(rrect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ProgressPainter oldDelegate) {
    return oldDelegate.end != end ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.isMainWindow != isMainWindow ||
        oldDelegate.progressColor != progressColor;
  }
}
