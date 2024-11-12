import 'package:appkit_ui_element_colors/appkit_ui_element_colors.dart';
import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:appkit_ui_elements/src/library.dart';
import 'package:appkit_ui_elements/src/theme/appkit_colors.dart';
import 'package:flutter/foundation.dart';

const double _kSliderMinWidth = 100.0;
const double _kSliderHeight = 24.0;
const double _kDiscreteThumbCornerRadius = 4.0;
const double _kDiscreteThumbWidth = 8.0;
const double _kContinuousThumbSize = 20.0;
const double _kTrackHeight = 4.0;
const double _kContinuousTrackCornerRadius = 2.0;
const double _kTickWidth = 2.0;
const double _kTickHeight = 8.0;
const int _kAnimationDuration = 200;

class AppKitSlider extends StatefulWidget {
  final double value;
  final double min;
  final double max;
  final ValueChanged<double>? onChanged;
  final AppKitSliderStyle style;
  final List<double> stops;
  final String? semanticLabel;

  const AppKitSlider({
    super.key,
    required this.value,
    this.min = 0.0,
    this.max = 1.0,
    this.onChanged,
    this.stops = const [0.0, 0.5, 1.0],
    this.semanticLabel,
    this.style = AppKitSliderStyle.continuous,
  })  : assert(value >= min && value <= max),
        assert(style != AppKitSliderStyle.continuous ? stops.length > 1 : true),
        assert(min < max);

  @override
  State<AppKitSlider> createState() => _AppKitSliderState();
}

class _AppKitSliderState extends State<AppKitSlider>
    with SingleTickerProviderStateMixin {
  bool get continous => widget.style == AppKitSliderStyle.continuous;

  bool get discreteFree => widget.style == AppKitSliderStyle.discreteFree;

  bool get discreteFixed => widget.style == AppKitSliderStyle.discreteFixed;

  bool get enabled => widget.onChanged != null;

  late AnimationController _animationController;
  late final Animation<double> _animationCurve;
  late final Tween<double> _animationTween;
  late Animation<double> _animation;
  double discreteAnchorThreshold = 0.01;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppKitSliderThemeData sliderTheme = AppKitSliderTheme.of(context);
      discreteAnchorThreshold = sliderTheme.discreteAnchorThreshold;
      _animationController = AnimationController(
          duration: Duration(
              milliseconds:
                  sliderTheme.animationDuration ?? _kAnimationDuration),
          vsync: this);
      _animationCurve = CurvedAnimation(
          parent: _animationController, curve: Curves.easeInOut);
      _animationTween = Tween<double>(begin: percentage, end: percentage);

      _animation = _animationTween.animate(_animationCurve)
        ..addListener(() {
          if (_animationController.isAnimating ||
              _animationController.isCompleted) {
            debugPrint('animation: ${_animation.value}');
            widget.onChanged
                ?.call(_animation.value.clamp(widget.min, widget.max));
          }
        });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DoubleProperty('value', widget.value));
    properties.add(DoubleProperty('min', widget.min));
    properties.add(DoubleProperty('max', widget.max));
    properties.add(EnumProperty<AppKitSliderStyle>('style', widget.style));
    properties.add(IterableProperty<double>('stops', widget.stops));
    properties.add(ObjectFlagProperty<ValueChanged<double>>(
        'onChanged', widget.onChanged,
        ifNull: 'disabled'));
    properties.add(StringProperty('semanticLabel', widget.semanticLabel));
  }

  double _getValuePercentage(double value) {
    return (value - widget.min) / (widget.max - widget.min);
  }

  double get percentage {
    if (discreteFixed) {
      // get value of the stop closest to the current value

      final double value = widget.value;
      final int stopIndex = _findClosestStopIndex(value);

      final double stopValue = widget.stops[stopIndex];
      return (stopValue - widget.min) / (widget.max - widget.min);
    } else {
      return (widget.value - widget.min) / (widget.max - widget.min);
    }
  }

  /// Returns the index of the stop closest to the given value.
  int _findClosestStopIndex(double value) {
    if (value < widget.stops.first) {
      return 0;
    } else if (value > widget.stops.last) {
      return widget.stops.length - 1;
    }
    for (int i = 0; i < widget.stops.length - 1; i++) {
      final currentStop = widget.stops[i];
      final nextStop = widget.stops[i + 1];
      if (currentStop <= value && nextStop >= value) {
        final diff = (nextStop - currentStop) / 2;
        if (value - currentStop < diff) {
          return i;
        } else {
          return i + 1;
        }
      }
    }
    return -1;
  }

  void _update(
      String type, double sliderWidth, double localPosition, bool animate) {
    double newValue =
        (localPosition / sliderWidth) * (widget.max - widget.min) + widget.min;
    if (discreteFixed) {
      // find the closest stop
      final int stopIndex = _findClosestStopIndex(newValue);
      newValue = widget.stops[stopIndex];
    } else {
      if (discreteFree) {
        // check if the value is close to a stop
        final int stopIndex = widget.stops.indexWhere((element) {
          return (_getValuePercentage(element) - _getValuePercentage(newValue))
                  .abs() <
              0.01;
        });
        if (stopIndex != -1) {
          newValue = widget.stops[stopIndex];
        }
      }
    }

    newValue = newValue.clamp(widget.min, widget.max);

    if (newValue == widget.value) {
      return;
    }

    if (animate) {
      _animationController.reset();
      _animationTween.begin = widget.value;
      _animationTween.end = newValue;
      _animationController.forward();
    } else {
      _animationController.stop();
      widget.onChanged?.call(newValue);
    }
  }

  bool _thumbHeldDown = false;

  @visibleForTesting
  bool get thumbHeldDown => _thumbHeldDown;

  @visibleForTesting
  set thumbHeldDown(bool value) {
    if (value != _thumbHeldDown) {
      setState(() {
        _thumbHeldDown = value;
      });
    }
  }

  @visibleForTesting
  bool trackIsDragging = false;

  @override
  Widget build(BuildContext context) {
    debugCheckHasAppKitTheme(context);
    final AppKitThemeData theme = AppKitTheme.of(context);
    final AppKitSliderThemeData sliderTheme = AppKitSliderTheme.of(context);

    return Semantics(
      slider: true,
      label: widget.semanticLabel,
      value: widget.value.toStringAsFixed(2),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: _kSliderMinWidth),
        child: LayoutBuilder(
          builder: (context, constraints) {
            double width = constraints.maxWidth;
            if (width.isInfinite) width = _kSliderMinWidth;

            double horizontalPadding;
            if (!continous) {
              horizontalPadding = (_kDiscreteThumbWidth / 2) + 2;
            } else {
              horizontalPadding = (_kContinuousThumbSize / 2) + 2;
            }

            width -= (horizontalPadding * 2);

            return UiElementColorBuilder(builder: (context, colorContainer) {
              final accentColor = sliderTheme.sliderColor ??
                  theme.accentColor ??
                  colorContainer.controlAccentColor;

              return Center(
                child: SizedBox(
                  height: _kSliderHeight,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapDown: (details) {
                      if (_thumbHeldDown) {
                        return;
                      }
                      _update('onTapDown', width,
                          details.localPosition.dx - horizontalPadding, true);
                    },
                    onHorizontalDragStart: (details) {
                      trackIsDragging = true;
                      _update('onHorizontalDragStart', width,
                          details.localPosition.dx - horizontalPadding, false);
                    },
                    onHorizontalDragUpdate: (details) {
                      _update('onHorizontalDragUpdate', width,
                          details.localPosition.dx - horizontalPadding, false);
                    },
                    onHorizontalDragEnd: (details) => thumbHeldDown = false,
                    onHorizontalDragCancel: () => thumbHeldDown = false,
                    onTapCancel: () {
                      if (!trackIsDragging) {
                        thumbHeldDown = false;
                      }
                    },
                    onTapUp: (details) => thumbHeldDown = false,
                    child: Stack(
                      children: [
                        // track
                        Center(
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: horizontalPadding),
                            height: _kTrackHeight,
                            width: width,
                            decoration: BoxDecoration(
                              color: enabled
                                  ? sliderTheme.trackColor
                                  : sliderTheme.trackColor.withOpacity(0.5),
                              border: Border.all(
                                  color: AppKitColors.fills.opaque.tertiary,
                                  width: 0.5),
                              borderRadius: continous
                                  ? const BorderRadius.all(Radius.circular(
                                      _kContinuousTrackCornerRadius))
                                  : null,
                            ),
                          ),
                        ),

                        // filled track
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: horizontalPadding),
                            height: _kTrackHeight,
                            width: width * percentage,
                            decoration: BoxDecoration(
                              color: enabled
                                  ? (accentColor)
                                  : (accentColor).withOpacity(0.5),
                              borderRadius: continous
                                  ? const BorderRadius.all(Radius.circular(
                                      _kContinuousTrackCornerRadius))
                                  : null,
                            ),
                          ),
                        ),

                        if (!continous) ...[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: horizontalPadding),
                            child: SizedBox(
                              height: _kSliderHeight,
                              width: width,
                              child: CustomPaint(
                                size: Size(width, _kSliderHeight),
                                painter: _DiscreteTickPainter(
                                  color: enabled
                                      ? accentColor
                                      : accentColor.withOpacity(0.5),
                                  backgroundColor: sliderTheme.tickColor ??
                                      AppKitColors.fills.opaque.primary
                                          .resolveFrom(context),
                                  selectedPercentage: percentage,
                                  stops: widget.stops
                                      .map((e) => _getValuePercentage(e))
                                      .toList(),
                                ),
                              ),
                            ),
                          ),
                        ],

                        // continuous thumb
                        if (continous) ...[
                          Positioned(
                            left: width * percentage -
                                (_kContinuousThumbSize / 2),
                            width: (_kContinuousThumbSize * 2) + 4,
                            height: _kContinuousThumbSize,
                            top: _kSliderHeight / 2 - _kContinuousThumbSize / 2,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: horizontalPadding),
                              child: GestureDetector(
                                onTapDown: (details) => thumbHeldDown = true,
                                child: _ContinuousThumb(
                                  color: sliderTheme.thumbColor,
                                  foregroundColor: enabled && _thumbHeldDown
                                      ? AppKitColors.fills.opaque.tertiary.color
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        ] else ...[
                          Positioned(
                            left:
                                width * percentage - (_kDiscreteThumbWidth / 2),
                            width: (_kDiscreteThumbWidth * 2) + 4,
                            height: _kContinuousThumbSize,
                            top: _kSliderHeight / 2 - _kContinuousThumbSize / 2,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: horizontalPadding),
                              child: GestureDetector(
                                onTapDown: (_) => thumbHeldDown = true,
                                child: _DiscreteThumb(
                                  color: sliderTheme.thumbColor,
                                  foregroundColor: enabled && _thumbHeldDown
                                      ? AppKitColors.fills.opaque.tertiary.color
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            });
          },
        ),
      ),
    );
  }
}

enum AppKitSliderStyle {
  continuous,
  discreteFixed,
  discreteFree,
}

class _ContinuousThumb extends StatelessWidget {
  const _ContinuousThumb({
    required this.color,
    this.foregroundColor,
  });

  final Color color;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _kContinuousThumbSize,
      width: _kContinuousThumbSize,
      foregroundDecoration: foregroundColor != null
          ? BoxDecoration(
              color: foregroundColor,
              borderRadius: BorderRadius.circular(_kContinuousThumbSize))
          : null,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
            color: AppKitColors.fills.opaque.quinary.color, width: 0.5),
        borderRadius:
            const BorderRadius.all(Radius.circular(_kContinuousThumbSize)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.5),
            blurStyle: BlurStyle.outer,
            blurRadius: 0.25,
            spreadRadius: 0,
            offset: Offset(0, 0.25),
          ),
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.25),
            blurStyle: BlurStyle.outer,
            blurRadius: 0.75,
            spreadRadius: 0,
            offset: Offset(0, 1),
          ),
        ],
      ),
    );
  }
}

class _DiscreteThumb extends StatelessWidget {
  const _DiscreteThumb({
    required this.color,
    this.foregroundColor,
  });

  final Color color;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _kContinuousThumbSize,
      width: _kDiscreteThumbWidth,
      foregroundDecoration: foregroundColor != null
          ? BoxDecoration(
              color: foregroundColor,
              borderRadius: BorderRadius.circular(_kDiscreteThumbCornerRadius))
          : null,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
            color: AppKitColors.fills.opaque.quinary.color, width: 0.5),
        borderRadius: const BorderRadius.all(
            Radius.circular(_kDiscreteThumbCornerRadius)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.5),
            blurStyle: BlurStyle.outer,
            blurRadius: 0.25,
            spreadRadius: 0,
            offset: Offset(0, 0.25),
          ),
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.25),
            blurStyle: BlurStyle.outer,
            blurRadius: 0.75,
            spreadRadius: 0,
            offset: Offset(0, 1),
          ),
        ],
      ),
    );
  }
}

class _DiscreteTickPainter extends CustomPainter {
  _DiscreteTickPainter({
    required this.stops,
    required this.selectedPercentage,
    required this.backgroundColor,
    required this.color,
  });

  final List<double> stops;
  final double selectedPercentage;
  final Color backgroundColor;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    var width = size.width;

    var paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    var backgroundPaint = Paint()..color = backgroundColor;

    for (var i = 0; i < stops.length; i++) {
      var x = stops[i] * width;
      var isPastSelectedPercentage = x / width > selectedPercentage;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            x - (_kTickWidth / 2),
            (size.height / 2) - (_kTickHeight / 2),
            _kTickWidth,
            _kTickHeight,
          ),
          const Radius.circular(_kDiscreteThumbCornerRadius),
        ),
        isPastSelectedPercentage ? backgroundPaint : paint,
      );
    }
  }

  @override
  bool shouldRepaint(_DiscreteTickPainter oldDelegate) {
    return oldDelegate.stops != stops ||
        oldDelegate.selectedPercentage != selectedPercentage ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.color != color;
  }
}
