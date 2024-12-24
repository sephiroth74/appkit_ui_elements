import 'package:appkit_ui_element_colors/appkit_ui_element_colors.dart';
import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/foundation.dart';

const int _kAnimationDuration = 200;

const int _kHorizontalPaddingThreshold = 0;

// overall minimum width of the widget
const double _kOverallMinWidth = 100.0;

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

    if (widget.style != AppKitSliderStyle.continuous) {
      // check if stops are within min and max limits
      assert(
          widget.stops.first == widget.min && widget.stops.last == widget.max);
      // check if stops are in ascending order
      for (int i = 0; i < widget.stops.length - 1; i++) {
        assert(widget.stops[i] < widget.stops[i + 1]);
      }
    }

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

    return Semantics(
      slider: true,
      label: widget.semanticLabel,
      value: widget.value.toStringAsFixed(2),
      child: UiElementColorBuilder(builder: (context, colorContainer) {
        final AppKitThemeData theme = AppKitTheme.of(context);
        final AppKitSliderThemeData sliderTheme = AppKitSliderTheme.of(context);
        final discreteThumbSize = sliderTheme.discreteThumbSize;
        final continuousThumbSize = sliderTheme.continuousThumbSize;
        final overallHeight =
            sliderTheme.continuousThumbSize + _kHorizontalPaddingThreshold;
        final isMainWindow =
            MainWindowStateListener.instance.isMainWindow.value;

        return ConstrainedBox(
          constraints: const BoxConstraints(minWidth: _kOverallMinWidth),
          child: LayoutBuilder(
            builder: (context, constraints) {
              double width = constraints.maxWidth;
              if (width.isInfinite) width = _kOverallMinWidth;

              double horizontalPadding;
              if (!continous) {
                horizontalPadding = (discreteThumbSize.width / 2) +
                    _kHorizontalPaddingThreshold;
              } else {
                horizontalPadding =
                    (continuousThumbSize / 2) + _kHorizontalPaddingThreshold;
              }

              width -= (horizontalPadding * 2);

              final accentColor = isMainWindow
                  ? (sliderTheme.sliderColor ??
                      theme.primaryColor ??
                      colorContainer.controlAccentColor)
                  : (sliderTheme.accentColorUnfocused ??
                      theme.accentColorUnfocused);

              return Center(
                child: SizedBox(
                  height: overallHeight,
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
                      clipBehavior: Clip.none,
                      children: [
                        // track
                        Center(
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: horizontalPadding),
                            height: sliderTheme.trackHeight,
                            width: width,
                            decoration: BoxDecoration(
                              color: enabled
                                  ? sliderTheme.trackColor
                                  : sliderTheme.trackColor.withOpacity(0.5),
                              border: Border.all(
                                  color: AppKitColors.fills.opaque.tertiary,
                                  width: 0.5),
                              borderRadius: continous
                                  ? BorderRadius.all(Radius.circular(
                                      sliderTheme.continuousTrackCornerRadius))
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
                            height: sliderTheme.trackHeight,
                            width: width * percentage,
                            decoration: BoxDecoration(
                              color: enabled
                                  ? (accentColor)
                                  : (accentColor).withOpacity(0.5),
                              borderRadius: continous
                                  ? BorderRadius.all(Radius.circular(
                                      sliderTheme.continuousTrackCornerRadius))
                                  : null,
                            ),
                          ),
                        ),

                        if (!continous) ...[
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: horizontalPadding),
                            child: SizedBox(
                              height: overallHeight,
                              width: width,
                              child: CustomPaint(
                                size: Size(width, overallHeight),
                                painter: _DiscreteTickPainter(
                                  tickWidth: sliderTheme.tickWidth,
                                  tickHeight: sliderTheme.tickHeight,
                                  cornerRadius:
                                      sliderTheme.discreteTickCornerRadius,
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
                            left:
                                width * percentage - (continuousThumbSize / 2),
                            width: (continuousThumbSize * 2) +
                                (_kHorizontalPaddingThreshold * 2),
                            height: continuousThumbSize,
                            top: overallHeight / 2 - continuousThumbSize / 2,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: horizontalPadding),
                              child: GestureDetector(
                                onTapDown: (details) => thumbHeldDown = true,
                                child: AppKitCircularSliderThumb(
                                  continuousThumbSize: continuousThumbSize,
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
                            left: width * percentage -
                                (discreteThumbSize.width / 2),
                            width: (discreteThumbSize.width * 2) + 4,
                            height: discreteThumbSize.height,
                            top: overallHeight / 2 -
                                (discreteThumbSize.height / 2),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: horizontalPadding),
                              child: GestureDetector(
                                onTapDown: (_) => thumbHeldDown = true,
                                child: _DiscreteThumb(
                                  size: discreteThumbSize,
                                  color: sliderTheme.thumbColor,
                                  cornerRadius:
                                      sliderTheme.discreteThumbCornerRadius,
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
            },
          ),
        );
      }),
    );
  }
}

/// Continuous thumb for the slider.
class AppKitCircularSliderThumb extends StatelessWidget {
  const AppKitCircularSliderThumb({
    super.key,
    required this.color,
    required this.continuousThumbSize,
    this.foregroundColor,
  });

  final Color color;
  final Color? foregroundColor;
  final double continuousThumbSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: continuousThumbSize,
      width: continuousThumbSize,
      foregroundDecoration: foregroundColor != null
          ? BoxDecoration(
              color: foregroundColor,
              borderRadius: BorderRadius.circular(continuousThumbSize))
          : null,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
            color: AppKitColors.fills.opaque.quinary.color, width: 0.5),
        borderRadius: BorderRadius.all(Radius.circular(continuousThumbSize)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.5),
            blurStyle: BlurStyle.outer,
            blurRadius: 0.25,
            spreadRadius: 0,
            offset: Offset(0, .25),
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
    required this.cornerRadius,
    required this.size,
    this.foregroundColor,
  });

  final Color color;
  final Color? foregroundColor;
  final double cornerRadius;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height,
      width: size.width,
      foregroundDecoration: foregroundColor != null
          ? BoxDecoration(
              color: foregroundColor,
              borderRadius: BorderRadius.circular(cornerRadius))
          : null,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
            color: AppKitColors.fills.opaque.quinary.color, width: 0.5),
        borderRadius: BorderRadius.all(Radius.circular(cornerRadius)),
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
    required this.cornerRadius,
    required this.color,
    required this.tickHeight,
    required this.tickWidth,
  });

  final List<double> stops;
  final double selectedPercentage;
  final Color backgroundColor;
  final Color color;
  final double cornerRadius;
  final double tickHeight;
  final double tickWidth;

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
            x - (tickWidth / 2),
            (size.height / 2) - (tickHeight / 2),
            tickWidth,
            tickHeight,
          ),
          Radius.circular(cornerRadius),
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
