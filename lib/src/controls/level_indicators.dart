import 'package:appkit_ui_element_colors/appkit_ui_element_colors.dart';
import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:appkit_ui_elements/src/library.dart';

const _kHeight = 16.0;
const _kWidth = 64.0;
const _kStrokeWidth = 0.5;
const _kAnimationDuration = 200;
const _kTickMarkPadding = 3.0;
const _kTickMarkWidth = 1.0;
const _kTickMarkHeightMajor = 6.0;
const _kTickMarkHeightMinor = 3.0;

class AppKitLevelIndicator extends StatefulWidget {
  final bool drawsTieredCapacityLevels;
  final bool continuous;
  final double value;
  final int min;
  final int max;
  final double warningValue;
  final double criticalValue;
  final Color? normalColor;
  final Color? warningColor;
  final Color? criticalColor;
  final String? semanticLabel;
  final int majorTickMarks;
  final int minorTickMarks;
  final AppKitLevelIndicatorTickMarkPosition tickMarkPosition;
  final AppKitLevelIndicatorStyle style;
  final ValueChanged<double>? onChanged;

  const AppKitLevelIndicator({
    super.key,
    required this.drawsTieredCapacityLevels,
    required this.value,
    this.continuous = true,
    this.min = 0,
    this.max = 10,
    this.warningValue = 6,
    this.criticalValue = 8,
    this.normalColor,
    this.warningColor,
    this.criticalColor,
    this.onChanged,
    this.semanticLabel,
    this.tickMarkPosition = AppKitLevelIndicatorTickMarkPosition.none,
    this.majorTickMarks = 0,
    this.minorTickMarks = 0,
    this.style = AppKitLevelIndicatorStyle.continuous,
  })  : assert(min <= max),
        assert(value >= min && value <= max);

  @override
  State<AppKitLevelIndicator> createState() => _AppKitLevelIndicatorState();
}

class _AppKitLevelIndicatorState extends State<AppKitLevelIndicator> {
  bool get enabled => widget.onChanged != null;

  int get min => widget.min;

  int get max => widget.max;

  bool get continuous => widget.continuous;

  double? _animatedValue;

  bool get drawsTieredCapacityLevels => widget.drawsTieredCapacityLevels;

  bool get hasTickMarks =>
      widget.majorTickMarks > 0 ||
      widget.minorTickMarks > 0 &&
          widget.tickMarkPosition != AppKitLevelIndicatorTickMarkPosition.none;

  set animatedValue(double? value) {
    if (value != _animatedValue) {
      setState(() {
        _animatedValue = value;
      });
    }
  }

  bool get discrete => widget.style == AppKitLevelIndicatorStyle.discrete;

  double get sanitizedValue =>
      discrete ? widget.value.floor().toDouble() : widget.value;

  double get value => _animatedValue ?? sanitizedValue;

  void _onPanDown(DragDownDetails details) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset localOffset = box.globalToLocal(details.globalPosition);
    final double value = localOffset.dx / box.size.width; // 0 to 1
    double valueInRange =
        value * (widget.max - widget.min) + widget.min; // min to max

    if (discrete) {
      valueInRange = valueInRange.ceilToDouble();
    }

    final double clampedValue =
        valueInRange.clamp(widget.min.toDouble(), widget.max.toDouble());

    if (continuous) {
      widget.onChanged?.call(clampedValue);
    } else {
      animatedValue = clampedValue;
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset localOffset = box.globalToLocal(details.globalPosition);
    final double value = localOffset.dx / box.size.width;
    double valueInRange =
        value * (widget.max - widget.min) + widget.min; // min to max

    if (discrete) {
      valueInRange = valueInRange.ceilToDouble();
    }

    final double clampedValue =
        valueInRange.clamp(widget.min.toDouble(), widget.max.toDouble());

    if (continuous) {
      widget.onChanged?.call(clampedValue);
    } else {
      animatedValue = clampedValue;
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (!continuous) {
      widget.onChanged?.call(value);
    }
  }

  @override
  void didUpdateWidget(covariant AppKitLevelIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.value != oldWidget.value) {
      animatedValue = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    debugCheckHasAppKitTheme(context);

    return Semantics(
      label: widget.semanticLabel,
      slider: true,
      value: widget.value.toStringAsFixed(2),
      child: UiElementColorBuilder(builder: (context, colorContainer) {
        return LayoutBuilder(builder: (context, constraints) {
          final levelIndicatorsTheme = AppKitLevelIndicatorsTheme.of(context);
          final normalColor =
              widget.normalColor ?? levelIndicatorsTheme.normalColor;
          final warningColor =
              widget.warningColor ?? levelIndicatorsTheme.warningColor;
          final criticalColor =
              widget.criticalColor ?? levelIndicatorsTheme.criticalColor;
          final borderRadius = levelIndicatorsTheme.borderRadius;

          final color = drawsTieredCapacityLevels
              ? normalColor
              : value < widget.warningValue
                  ? normalColor
                  : value < widget.criticalValue
                      ? warningColor
                      : criticalColor;

          final strokeColor = levelIndicatorsTheme.strokeColor;
          final backgroundColor = levelIndicatorsTheme.backgroundColor;
          final totalHeight = _kHeight +
              (hasTickMarks ? _kTickMarkHeightMajor + _kTickMarkPadding : 0);
          final boxConstraints = BoxConstraints.loose(Size(
            constraints.maxWidth.isFinite ? constraints.maxWidth : _kWidth,
            totalHeight,
          ));

          return ConstrainedBox(
              constraints: boxConstraints,
              child: Column(
                children: [
                  if (hasTickMarks &&
                      widget.tickMarkPosition ==
                          AppKitLevelIndicatorTickMarkPosition.above) ...[
                    CustomPaint(
                      size: Size(constraints.maxWidth, _kTickMarkHeightMajor),
                      painter: _LevelIndicatorTickMarksPainter(
                        majorTickMarks: widget.majorTickMarks,
                        minorTickMarks: widget.minorTickMarks,
                        position: widget.tickMarkPosition,
                        color: strokeColor,
                        width: _kTickMarkWidth,
                        heightMajor: _kTickMarkHeightMajor,
                        heightMinor: _kTickMarkHeightMinor,
                      ),
                    ),
                    const SizedBox(height: _kTickMarkPadding),
                  ],
                  GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onPanDown: enabled ? _onPanDown : null,
                      onPanUpdate: enabled ? _onPanUpdate : null,
                      onPanEnd: enabled ? _onPanEnd : null,
                      child: SizedBox(
                        width: boxConstraints.maxWidth,
                        height: _kHeight,
                        child:
                            widget.style == AppKitLevelIndicatorStyle.continuous
                                ? _AnimatedIndicator(
                                    drawsTieredCapacityLevels:
                                        drawsTieredCapacityLevels,
                                    style: widget.style,
                                    value: value,
                                    min: min,
                                    max: max,
                                    warningValue: widget.warningValue,
                                    criticalValue: widget.criticalValue,
                                    normalColor: color,
                                    warningColor: warningColor,
                                    criticalColor: criticalColor,
                                    strokeWidth: _kStrokeWidth,
                                    strokeColor: strokeColor,
                                    backgroundColor: backgroundColor,
                                    borderRadius: borderRadius,
                                  )
                                : CustomPaint(
                                    painter: _DiscreteIndicatorPainter(
                                    value: value,
                                    min: min,
                                    max: max,
                                    warningValue: widget.warningValue,
                                    criticalValue: widget.criticalValue,
                                    normalColor: normalColor,
                                    warningColor: warningColor,
                                    criticalColor: criticalColor,
                                    strokeWidth: _kStrokeWidth,
                                    strokeColor: strokeColor,
                                    backgroundColor: backgroundColor,
                                    borderRadius: borderRadius,
                                    drawsTieredCapacityLevels:
                                        drawsTieredCapacityLevels,
                                  )),
                      )),
                  if (hasTickMarks &&
                      widget.tickMarkPosition ==
                          AppKitLevelIndicatorTickMarkPosition.below) ...[
                    const SizedBox(height: _kTickMarkPadding),
                    CustomPaint(
                      size: Size(constraints.maxWidth, _kTickMarkHeightMajor),
                      painter: _LevelIndicatorTickMarksPainter(
                        majorTickMarks: widget.majorTickMarks,
                        minorTickMarks: widget.minorTickMarks,
                        position: widget.tickMarkPosition,
                        color: strokeColor,
                        width: _kTickMarkWidth,
                        heightMajor: _kTickMarkHeightMajor,
                        heightMinor: _kTickMarkHeightMinor,
                      ),
                    ),
                  ]
                ],
              ));
        });
      }),
    );
  }
}

class _AnimatedIndicator extends StatefulWidget {
  final double value;
  final int min;
  final int max;
  final double borderRadius;
  final double warningValue;
  final double criticalValue;
  final Color normalColor;
  final Color warningColor;
  final Color criticalColor;
  final double strokeWidth;
  final Color strokeColor;
  final Color backgroundColor;
  final bool drawsTieredCapacityLevels;
  final AppKitLevelIndicatorStyle style;

  const _AnimatedIndicator({
    required this.value,
    required this.min,
    required this.max,
    required this.strokeWidth,
    required this.strokeColor,
    required this.backgroundColor,
    required this.borderRadius,
    required this.warningValue,
    required this.criticalValue,
    required this.normalColor,
    required this.warningColor,
    required this.criticalColor,
    required this.drawsTieredCapacityLevels,
    required this.style,
  });

  @override
  State<_AnimatedIndicator> createState() => _AnimatedIndicatorState();
}

class _AnimatedIndicatorState extends State<_AnimatedIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: _kAnimationDuration),
    vsync: this,
  );

  late final CurvedAnimation _curvedAnimation =
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

  late ColorTween _colorTween;

  @override
  void initState() {
    super.initState();
    _colorTween =
        ColorTween(begin: widget.normalColor, end: widget.normalColor);
    _colorTween.animate(_curvedAnimation).addListener(() => setState(() {}));
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant _AnimatedIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_shouldAnimateTween(_colorTween, widget.normalColor)) {
      _updateTween(_colorTween, widget.normalColor);
      _controller.forward(from: 0.0);
    }
  }

  bool _shouldAnimateTween(Tween<dynamic> tween, dynamic targetValue) {
    return targetValue != (tween.end ?? tween.begin);
  }

  void _updateTween(Tween<dynamic>? tween, dynamic targetValue) {
    if (tween == null) {
      return;
    }
    tween
      ..begin = tween.evaluate(_curvedAnimation)
      ..end = targetValue;
  }

  @override
  void dispose() {
    _curvedAnimation.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ContinuosoIndicatorPainter(
        normalColor: _colorTween.evaluate(_controller)!,
        min: widget.min,
        max: widget.max,
        value: widget.value,
        strokeColor: widget.strokeColor,
        strokeWidth: widget.strokeWidth,
        backgroundColor: widget.backgroundColor,
        borderRadius: widget.borderRadius,
        warningValue: widget.warningValue,
        criticalValue: widget.criticalValue,
        warningColor: widget.warningColor,
        criticalColor: widget.criticalColor,
        drawsTieredCapacityLevels: widget.drawsTieredCapacityLevels,
      ),
    );
  }
}

class _ContinuosoIndicatorPainter extends CustomPainter {
  final double value;
  final int min;
  final int max;
  final double warningValue;
  final double criticalValue;
  final Color normalColor;
  final Color warningColor;
  final Color criticalColor;
  final double strokeWidth;
  final Color strokeColor;
  final Color backgroundColor;
  final double borderRadius;
  final bool drawsTieredCapacityLevels;

  late final double valuePercent = (value - min) / (max - min);
  late final double warningPercent = (warningValue - min) / (max - min);
  late final double criticalPercent = (criticalValue - min) / (max - min);

  _ContinuosoIndicatorPainter({
    required this.value,
    required this.min,
    required this.max,
    required this.warningValue,
    required this.criticalValue,
    required this.normalColor,
    required this.warningColor,
    required this.criticalColor,
    required this.strokeWidth,
    required this.strokeColor,
    required this.backgroundColor,
    required this.borderRadius,
    required this.drawsTieredCapacityLevels,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final RRect rrect = RRect.fromLTRBR(
        0, 0, size.width, size.height, Radius.circular(borderRadius));
    canvas.drawRRect(rrect, paint);

    canvas.clipRRect(rrect);
    final saveCount = canvas.getSaveCount();
    canvas.save();

    if (drawsTieredCapacityLevels) {
      // draw the normal color first
      paint
        ..color = normalColor
        ..style = PaintingStyle.fill;

      final RRect normalRRect = RRect.fromLTRBR(
          0, 0, size.width * valuePercent, size.height, Radius.zero);
      canvas.drawRRect(normalRRect, paint);

      // now draw the warning color (if necessary)
      if (value >= warningValue) {
        paint
          ..color = warningColor
          ..style = PaintingStyle.fill;

        final RRect warningRRect = RRect.fromLTRBR(size.width * warningPercent,
            0, size.width * valuePercent, size.height, Radius.zero);
        canvas.drawRRect(warningRRect, paint);
      }

      // now draw the critical color (if necessary)
      if (value >= criticalValue) {
        paint
          ..color = criticalColor
          ..style = PaintingStyle.fill;

        final RRect criticalRRect = RRect.fromLTRBR(
            size.width * criticalPercent,
            0,
            size.width * valuePercent,
            size.height,
            Radius.zero);
        canvas.drawRRect(criticalRRect, paint);
      }
    } else {
      paint
        ..color = normalColor
        ..style = PaintingStyle.fill;
      final double valuePercent = (value - min) / (max - min);

      final RRect fillRRect = RRect.fromLTRBR(
          0, 0, size.width * valuePercent, size.height, Radius.zero);
      canvas.drawRRect(fillRRect, paint);
    }

    canvas.restoreToCount(saveCount);

    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeJoin = StrokeJoin.round
      ..color = strokeColor;

    final RRect strokeRRect = RRect.fromLTRBR(
        strokeWidth / 2,
        strokeWidth / 2,
        size.width - strokeWidth / 2,
        size.height - strokeWidth / 2,
        Radius.circular(borderRadius));
    canvas.drawRRect(strokeRRect, paint);
  }

  @override
  bool shouldRepaint(covariant _ContinuosoIndicatorPainter oldDelegate) {
    return oldDelegate.value != value ||
        oldDelegate.min != min ||
        oldDelegate.max != max ||
        oldDelegate.warningValue != warningValue ||
        oldDelegate.criticalValue != criticalValue ||
        oldDelegate.normalColor != normalColor ||
        oldDelegate.warningColor != warningColor ||
        oldDelegate.criticalColor != criticalColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.strokeColor != strokeColor ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}

class _DiscreteIndicatorPainter extends CustomPainter {
  final double value;
  final int min;
  final int max;
  final double warningValue;
  final double criticalValue;
  final Color normalColor;
  final Color warningColor;
  final Color criticalColor;
  final double strokeWidth;
  final Color strokeColor;
  final Color backgroundColor;
  final double borderRadius;
  final bool drawsTieredCapacityLevels;

  late final double valuePercent = (value - min) / (max - min);
  late final double warningPercent = (warningValue - min) / (max - min);
  late final double criticalPercent = (criticalValue - min) / (max - min);

  _DiscreteIndicatorPainter({
    required this.value,
    required this.min,
    required this.max,
    required this.warningValue,
    required this.criticalValue,
    required this.normalColor,
    required this.warningColor,
    required this.criticalColor,
    required this.strokeWidth,
    required this.strokeColor,
    required this.backgroundColor,
    required this.borderRadius,
    required this.drawsTieredCapacityLevels,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    // draw as many rect as there are discrete values
    final discreteRectWidth = size.width / (max - min);
    final radius = Radius.circular(borderRadius);
    final int totalRects = max - min;

    for (int i = 0; i < totalRects; i++) {
      final double x = i * discreteRectWidth;
      final RRect rrect =
          RRect.fromLTRBR(x, 0, x + discreteRectWidth, size.height, radius);

      final color = i < value
          ? (drawsTieredCapacityLevels
              ? i < warningValue
                  ? normalColor
                  : i < criticalValue
                      ? warningColor
                      : criticalColor
              : i < warningValue
                  ? normalColor
                  : i < criticalValue
                      ? warningColor
                      : criticalColor)
          : backgroundColor;

      paint
        ..color = color
        ..style = PaintingStyle.fill;

      canvas.drawRRect(rrect, paint);
    }

    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeJoin = StrokeJoin.round
      ..color = strokeColor;

    for (int i = 0; i < totalRects; i++) {
      final double x = i * discreteRectWidth;
      final RRect rrect =
          RRect.fromLTRBR(x, 0, x + discreteRectWidth, size.height, radius);
      canvas.drawRRect(rrect, paint);
    }

    return;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is! _DiscreteIndicatorPainter) {
      return true;
    }
    return oldDelegate.value != value ||
        oldDelegate.min != min ||
        oldDelegate.max != max ||
        oldDelegate.warningValue != warningValue ||
        oldDelegate.criticalValue != criticalValue ||
        oldDelegate.normalColor != normalColor ||
        oldDelegate.warningColor != warningColor ||
        oldDelegate.criticalColor != criticalColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.strokeColor != strokeColor ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}

class _LevelIndicatorTickMarksPainter extends CustomPainter {
  final int majorTickMarks;
  final int minorTickMarks;
  final AppKitLevelIndicatorTickMarkPosition position;
  final Color color;
  final double width;
  final double heightMajor;
  final double heightMinor;

  _LevelIndicatorTickMarksPainter({
    required this.majorTickMarks,
    required this.minorTickMarks,
    required this.position,
    required this.color,
    required this.width,
    required this.heightMajor,
    required this.heightMinor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..strokeCap = StrokeCap.round;

    final double tickMarkMinorY =
        position == AppKitLevelIndicatorTickMarkPosition.above
            ? size.height - heightMinor
            : 0;

    final double tickMarkPadding = size.width / (majorTickMarks - 1);

    for (int i = 0; i <= majorTickMarks; i++) {
      final double x = i * tickMarkPadding;
      final Offset start = Offset(x, 0);
      final Offset end = Offset(x, heightMajor);
      canvas.drawLine(start, end, paint);
    }

    if (minorTickMarks > 0) {
      final double minorTickMarkPadding = size.width / (minorTickMarks - 1);

      for (int i = 0; i <= minorTickMarks; i++) {
        final double x = i * minorTickMarkPadding;
        final Offset start = Offset(x, tickMarkMinorY);
        final Offset end = Offset(x, tickMarkMinorY + heightMinor);
        canvas.drawLine(start, end, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is! _LevelIndicatorTickMarksPainter) {
      return true;
    }
    return oldDelegate.majorTickMarks != majorTickMarks ||
        oldDelegate.minorTickMarks != minorTickMarks ||
        oldDelegate.position != position ||
        oldDelegate.color != color ||
        oldDelegate.width != width ||
        oldDelegate.heightMajor != heightMajor ||
        oldDelegate.heightMinor != heightMinor;
  }
}
