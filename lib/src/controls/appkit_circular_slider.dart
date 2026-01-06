import 'dart:math';

import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:provider/provider.dart';

const _kMin = 0.0;
const _kMax = 1.0;
const _kSize = 21.0;
const _kAnimationDuration = 200;
const _kThumbPaddingRatio = 4;
const _kThumbSizeRatio = 3.666667;

/// A custom circular slider widget with customizable properties.
///
/// The [AppKitCircularSlider] widget allows users to select a value from a range
/// by dragging a thumb along a circular path. The appearance and behavior of the
/// slider can be customized using various properties.
///
/// Example usage:
/// ```dart
/// AppKitCircularSlider(
///   value: 0.5,
///   min: 0.0,
///   max: 1.0,
///   onChanged: (newValue) {
///     print('New value: $newValue');
///   },
/// )
/// ```
class AppKitCircularSlider extends StatefulWidget {
  /// The minimum value the slider can have.
  ///
  /// Defaults to [_kMin].
  final double min;

  /// The maximum value the slider can have.
  ///
  /// Defaults to [_kMax].
  final double max;

  /// The current value of the slider.
  ///
  /// Must be between [min] and [max].
  final double value;

  /// The semantic label for the slider.
  ///
  /// Used by accessibility tools to describe the slider.
  final String? semanticLabel;

  /// The number of tick marks on the slider.
  ///
  /// If 0, no tick marks will be displayed.
  final int tickMarks;

  /// Whether the slider is continuous.
  ///
  /// If true, the slider will allow continuous values. If false, the slider will
  /// snap to the nearest tick mark.
  final bool continuous;

  /// The size of the slider.
  ///
  /// Defaults to [_kSize].
  final double size;

  /// The color of the slider.
  ///
  /// If null, a default color will be used.
  final Color? color;

  /// Called when the user changes the slider's value.
  ///
  /// If null, the slider will be disabled.
  final ValueChanged<double>? onChanged;

  /// Creates an [AppKitCircularSlider] widget.
  ///
  /// The [value] parameter must be between [min] and [max].
  const AppKitCircularSlider({
    super.key,
    this.min = _kMin,
    this.max = _kMax,
    required this.value,
    this.semanticLabel,
    this.tickMarks = 0,
    this.continuous = false,
    this.size = _kSize,
    this.color,
    this.onChanged,
  }) : assert(value >= min && value <= max),
       assert(tickMarks > 0 ? tickMarks > 1 : true),
       assert(min < max),
       assert(size > 0);

  @override
  State<AppKitCircularSlider> createState() => _AppKitCircularSliderState();
}

/// The state for an [AppKitCircularSlider] widget.
class _AppKitCircularSliderState extends State<AppKitCircularSlider> with SingleTickerProviderStateMixin {
  bool _handleDown = false;

  bool get continuous => widget.continuous;

  bool get enabled => widget.onChanged != null;

  double get min => widget.min;

  double get max => widget.max;

  double get value => widget.value;

  int get tickMarks => widget.tickMarks;

  bool get hasTickMarks => tickMarks > 0;

  double get size => widget.size;

  double get thumbSize => size / _kThumbSizeRatio;

  Offset get center => Offset(size / 2, size / 2);

  late AnimationController positionController;

  late CurvedAnimation positionCurvedAnimation;

  late Tween<double> positionTween;

  late Animation<double> animation;

  double get thumbPadding => thumbSize / _kThumbPaddingRatio;

  @override
  void initState() {
    super.initState();
    positionController = AnimationController(
      duration: const Duration(milliseconds: _kAnimationDuration),
      vsync: this,
    );

    positionCurvedAnimation = CurvedAnimation(parent: positionController, curve: Curves.easeInOutSine);

    positionTween = Tween<double>(begin: value, end: value);
    animation = positionTween.animate(positionCurvedAnimation);

    animation
      ..addListener(_handleAnimationFrame)
      ..addStatusListener(_handleAnimationStatus);
  }

  @override
  void didUpdateWidget(covariant AppKitCircularSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      positionController.reset();
      positionTween.begin = widget.value;
      positionTween.end = widget.value;
      positionController.forward();
    }
  }

  @override
  void dispose() {
    positionCurvedAnimation.dispose();
    positionController.dispose();
    super.dispose();
  }

  void _handleAnimationFrame() {
    setState(() {});
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status.isCompleted) {
      if (continuous) {
        widget.onChanged!(animation.value);
      }
    }
  }

  Offset _thumbPosition(double value) {
    final center = Offset((size - thumbSize) / 2, (size - thumbSize) / 2);
    // radians from current value
    final angle = (value - min) / (max - min) * 2 * pi;
    final paddedSize = size - (thumbSize + thumbPadding);

    final offset = Offset(
      center.dx + ((paddedSize / 2)) * cos(angle - pi / 2),
      center.dy + ((paddedSize / 2)) * sin(angle - pi / 2),
    );

    return offset;
  }

  double _getValueFromPosition(Offset position) {
    final angle = _getRadiansFromPosition(position);
    final degree = _radiansToDegrees(angle);
    final newValue = _getValueFromDegrees(degree);
    if (hasTickMarks) {
      final tickValue = (max - min) / tickMarks;
      final tick = (newValue / tickValue).round();
      return tick * tickValue;
    } else {
      return newValue;
    }
  }

  double _getRadiansFromPosition(Offset position) {
    return atan2(position.dy - center.dy, position.dx - center.dx) + pi / 2;
  }

  double _radiansToDegrees(double radians) {
    return (radians * 180 / pi) % 360;
  }

  double _getValueFromDegrees(double degree) {
    return (degree / 360) * (max - min) + min;
  }

  void _animateValues(double? from, double to) {
    positionController.reset();

    if (null != from) {
      positionTween.begin = from;
    }

    positionTween.end = to;
    positionController.forward();
  }

  void _onPanDown(DragDownDetails details) {
    _handleDown = true;
    final newValue = _getValueFromPosition(details.localPosition);
    _animateValues(value, newValue);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!_handleDown) {
      return;
    }

    final newValue = _getValueFromPosition(details.localPosition);

    if (continuous) {
      widget.onChanged!(newValue);
    } else {
      _animateValues(newValue, newValue);
    }
  }

  void _onPanEnd(DragEndDetails details) {
    if (!continuous) {
      positionController.reset();
      widget.onChanged!(positionTween.end!);
    }
    _handleDown = false;
  }

  void _onPanCancel() {
    _handleDown = false;
  }

  @override
  Widget build(BuildContext context) {
    debugCheckHasAppKitTheme(context);
    final animationValue = animation.value;

    return Semantics(
      label: widget.semanticLabel,
      value: '$value',
      slider: true,
      child: SizedBox(
        width: size,
        height: size,
        child: Consumer<MainWindowModel>(
          builder: (context, model, _) {
            final isMainWindow = model.isMainWindow;
            final controlBackgroundColor = AppKitDynamicColor.resolve(context, AppKitColors.controlColor);
            final sliderTheme = AppKitCircularSliderTheme.of(context);
            final thumbPosition = _thumbPosition(animationValue);
            final enabledFactor = enabled ? 1.0 : 0.5;
            var thumbColor = isMainWindow ? widget.color ?? sliderTheme.thumbColor : sliderTheme.thumbColorUnfocused;
            var backgroundColor = enabled ? sliderTheme.backgroundColor : controlBackgroundColor.withValues(alpha: 0.5);
            final isDark = AppKitTheme.of(context).brightness == Brightness.dark;

            if (isMainWindow) {
              thumbColor = thumbColor.multiplyOpacity(enabledFactor);
            }

            return GestureDetector(
              dragStartBehavior: DragStartBehavior.down,
              behavior: HitTestBehavior.opaque,
              onPanDown: enabled ? (details) => _onPanDown(details) : null,
              onPanUpdate: enabled ? (details) => _onPanUpdate(details) : null,
              onPanEnd: enabled ? (details) => _onPanEnd(details) : null,
              onPanCancel: enabled ? () => _onPanCancel() : null,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: backgroundColor,
                  border: GradientBoxBorder(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [
                              AppKitDynamicColor.resolve(
                                context,
                                AppKitColors.text.opaque.primary,
                              ).multiplyOpacity(0.5),
                              AppKitDynamicColor.resolve(
                                context,
                                AppKitColors.text.opaque.quaternary,
                              ).multiplyOpacity(0.0),
                            ]
                          : [
                              AppKitDynamicColor.resolve(
                                context,
                                AppKitColors.text.opaque.tertiary,
                              ).multiplyOpacity(0.5),
                              AppKitDynamicColor.resolve(
                                context,
                                AppKitColors.text.opaque.secondary,
                              ).multiplyOpacity(0.5),
                            ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: isDark ? const [0.0, 0.5] : const [0.0, 1.0],
                    ),
                    width: 0.5,
                  ),
                  gradient: enabled && isDark
                      ? LinearGradient(
                          colors: [Colors.white.withValues(alpha: 0.05), backgroundColor],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.0, 0.5],
                        )
                      : null,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x66000000),
                      offset: Offset(0.0, 1.0),
                      blurRadius: 0.5,
                      spreadRadius: 0.0,
                      blurStyle: BlurStyle.outer,
                    ),
                    BoxShadow(
                      color: Color(0x1a000000),
                      offset: Offset(0.0, 0.0),
                      blurRadius: 0.0,
                      spreadRadius: 0.5,
                      blurStyle: BlurStyle.outer,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: thumbPosition.dx,
                      top: thumbPosition.dy,
                      child: Container(
                        width: thumbSize,
                        height: thumbSize,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: thumbColor),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('min', min));
    properties.add(DoubleProperty('max', max));
    properties.add(DoubleProperty('value', value));
    properties.add(IntProperty('tickMarks', tickMarks));
    properties.add(FlagProperty('continuous', value: continuous, ifTrue: 'continuous'));
    properties.add(FlagProperty('enabled', value: enabled, ifTrue: 'enabled'));
    properties.add(DoubleProperty('size', size));
    properties.add(DoubleProperty('thumbSize', thumbSize));
  }
}
