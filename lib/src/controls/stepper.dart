import 'dart:async';

import 'package:appkit_ui_element_colors/appkit_ui_element_colors.dart';
import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const _longPressDuration = Duration(milliseconds: 500);
const _tickerDuration = Duration(milliseconds: 100);

class AppKitStepper extends StatefulWidget {
  final String? semanticLabel;
  final double minValue;
  final double maxValue;
  final double increment;
  final double value;
  final ValueChanged<double>? onChanged;
  final AppKitControlSize controlSize;

  const AppKitStepper({
    super.key,
    required this.value,
    this.semanticLabel,
    this.minValue = 0,
    this.maxValue = 100,
    this.increment = 1,
    this.controlSize = AppKitControlSize.regular,
    this.onChanged,
  });

  bool get enabled => onChanged != null;

  @override
  State<AppKitStepper> createState() => _AppKitStepperState();
}

class _AppKitStepperState extends State<AppKitStepper> {
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('semanticLabel', widget.semanticLabel));
    properties.add(DoubleProperty('minValue', widget.minValue));
    properties.add(DoubleProperty('maxValue', widget.maxValue));
    properties.add(DoubleProperty('increment', widget.increment));
    properties.add(DoubleProperty('value', widget.value));
    properties.add(ObjectFlagProperty<ValueChanged<double>>(
      'onChanged',
      widget.onChanged,
      ifNull: 'disabled',
    ));
  }

  Size get size => widget.controlSize.size;

  double get height => size.height;

  double get width => size.width;

  double get borderRadius => widget.controlSize.borderRadius;

  double get borderWidth => 1.0;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasAppKitTheme(context));
    final AppKitThemeData theme = AppKitTheme.of(context);
    final enabledFactor = widget.enabled ? 1.0 : 0.5;
    final controlBorderColor = theme.brightness.isDark
        ? Colors.white.withOpacity(0.2 * enabledFactor)
        : Colors.black.withOpacity(0.2 * enabledFactor);

    //final borderRadius = widget.height / _kBorderRadiusRatio;
    // final borderWidth = widget.height / 40;

    final iconColor = !theme.brightness.isDark
        ? widget.enabled
            ? AppKitColors.labelColor.color
            : AppKitColors.text.opaque.tertiary.color
        : widget.enabled
            ? AppKitColors.labelColor.darkColor
            : AppKitColors.text.opaque.tertiary.darkColor;

    final strokeWidth = widget.controlSize.strokeWidth;
    final separatorWidth = widget.controlSize.separatorWidth;

    return Semantics(
      label: widget.semanticLabel,
      button: true,
      child: SizedBox(
        width: width,
        height: height,
        child: GestureDetector(
          onPanDown: widget.enabled ? _onPanDown : null,
          onPanEnd: widget.enabled ? _onPanEnd : null,
          onPanCancel: widget.enabled ? _onPanCancel : null,
          onPanUpdate: widget.enabled ? _onPanUpdate : null,
          onPanStart: widget.enabled ? _onPanStart : null,
          child: UiElementColorBuilder(builder: (context, colorContainer) {
            return DecoratedBox(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15 * enabledFactor),
                      offset: Offset(0, height / 80),
                      blurRadius: height / 80,
                      blurStyle: BlurStyle.outer,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05 * enabledFactor),
                      offset: Offset(0, height / 20),
                      blurRadius: height / 26.666,
                      blurStyle: BlurStyle.outer,
                    ),
                  ]),
              child: Stack(
                children: [
                  // Top Stepper
                  SizedBox(
                    width: width,
                    height: height / 2,
                    child: Container(
                      foregroundDecoration:
                          _isPointerDown && _isPointerIncreasing
                              ? BoxDecoration(
                                  color: Colors.black.withOpacity(0.1),
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(borderRadius),
                                      topRight: Radius.circular(borderRadius)))
                              : null,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: widget.enabled
                              ? colorContainer.controlBackgroundColor
                              : colorContainer.controlBackgroundColor
                                  .multiplyOpacity(0.5),
                          border: Border(
                            top: BorderSide(
                                color: controlBorderColor, width: borderWidth),
                            left: BorderSide(
                                color: controlBorderColor, width: borderWidth),
                            right: BorderSide(
                                color: controlBorderColor, width: borderWidth),
                          ),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(borderRadius),
                            topRight: Radius.circular(borderRadius),
                          ),
                        ),
                        child: CustomPaint(
                          painter: IconButtonPainter(
                            color: iconColor,
                            icon: AppKitControlButtonIcon.disclosureUp,
                            offset: Offset(0, -height / 10),
                            strokeWidth: strokeWidth,
                            strokeCap: StrokeCap.square,
                            size: height / 2,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Bottom Stepper
                  Positioned(
                    bottom: 0,
                    child: SizedBox(
                      width: width,
                      height: height / 2,
                      child: Container(
                        foregroundDecoration: _isPointerDown &&
                                !_isPointerIncreasing
                            ? BoxDecoration(
                                color: Colors.black.withOpacity(0.1),
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(borderRadius),
                                    bottomRight: Radius.circular(borderRadius)))
                            : null,
                        child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: widget.enabled
                                  ? colorContainer.controlBackgroundColor
                                  : colorContainer.controlBackgroundColor
                                      .multiplyOpacity(0.5),
                              border: Border(
                                left: BorderSide(
                                    color: controlBorderColor,
                                    width: borderWidth),
                                right: BorderSide(
                                    color: controlBorderColor,
                                    width: borderWidth),
                                bottom: BorderSide(
                                    color: controlBorderColor,
                                    width: borderWidth),
                              ),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(borderRadius),
                                bottomRight: Radius.circular(borderRadius),
                              ),
                            ),
                            child: CustomPaint(
                              painter: IconButtonPainter(
                                color: iconColor,
                                icon: AppKitControlButtonIcon.disclosureDown,
                                offset: Offset(0, -height / 10),
                                strokeCap: StrokeCap.square,
                                strokeWidth: strokeWidth,
                                size: height / 2,
                              ),
                            )),
                      ),
                    ),
                  ),

                  // Top Gradient
                  Positioned(
                    bottom: height / 2,
                    left: borderWidth,
                    child: SizedBox(
                      width: width - borderWidth * 2,
                      height: height / 5,
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0),
                          Colors.black.withOpacity(0.05 * enabledFactor),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ))),
                    ),
                  ),

                  // Bottom Gradient
                  Positioned(
                    top: height / 2,
                    left: borderWidth,
                    child: SizedBox(
                      width: width - borderWidth * 2,
                      height: height / 5,
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0),
                          Colors.black.withOpacity(0.05 * enabledFactor),
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ))),
                    ),
                  ),

                  // Filler
                  Positioned(
                    top: (height / 2) - (height / 20),
                    left: borderWidth,
                    child: SizedBox(
                      width: width - borderWidth * 2,
                      height: height / 10,
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.05 * enabledFactor),
                      )),
                    ),
                  ),

                  // Separator
                  Positioned(
                    top: (height / 2) - (separatorWidth / 2),
                    left: borderWidth,
                    child: SizedBox(
                      width: width - borderWidth * 2,
                      height: separatorWidth,
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.05 * enabledFactor),
                      )),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mouseDownInitializationTimer?.cancel();
    _mouseDownTimer?.cancel();
    super.dispose();
  }

  bool _isPointerDown = false;
  bool _isPointerIncreasing = false;

  Timer? _mouseDownInitializationTimer;
  Timer? _mouseDownTimer;

  bool get isPointerDown => _isPointerDown;

  set isPointerDown(bool value) {
    if (_isPointerDown != value) {
      setState(() {
        _isPointerDown = widget.enabled ? value : false;
        if (!_isPointerDown) {
          _mouseDownInitializationTimer?.cancel();
          _mouseDownTimer?.cancel();
        } else {
          _mouseDownInitializationTimer?.cancel();
          _mouseDownInitializationTimer =
              Timer(_longPressDuration, _onStepperInit);
        }
      });
    }
  }

  void _onStepperInit() {
    _mouseDownTimer?.cancel();
    _mouseDownTimer = Timer.periodic(_tickerDuration, (timer) {
      if (_isPointerIncreasing) {
        _incrementValue();
      } else {
        _decrementValue();
      }
    });
  }

  void _onPanDown(DragDownDetails details) {
    setState(() {
      isPointerDown = true;
      _isPointerIncreasing = details.localPosition.dy < height / 2;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      isPointerDown = false;

      if (_mouseDownTimer == null || _mouseDownTimer?.isActive == false) {
        if (_isPointerIncreasing) {
          _incrementValue();
        } else {
          _decrementValue();
        }
      }

      _mouseDownTimer?.cancel();
    });
  }

  void _onPanCancel() {
    setState(() {
      isPointerDown = false;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      isPointerDown = (details.localPosition.dy >= 0 &&
              details.localPosition.dy <= height) &&
          (details.localPosition.dx >= 0 && details.localPosition.dx <= width);
      _isPointerIncreasing = details.localPosition.dy < height / 2;
    });
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _isPointerIncreasing = details.localPosition.dy < height / 2;
    });
  }

  void _incrementValue() {
    final newValue = (widget.value + widget.increment)
        .clamp(widget.minValue, widget.maxValue);
    widget.onChanged?.call(newValue);
  }

  void _decrementValue() {
    final newValue = (widget.value - widget.increment)
        .clamp(widget.minValue, widget.maxValue);
    widget.onChanged?.call(newValue);
  }
}

extension _ConstrolSizeX on AppKitControlSize {
  double get separatorWidth {
    switch (this) {
      case AppKitControlSize.mini:
        return 0.5;
      case AppKitControlSize.small:
        return 1.0;
      case AppKitControlSize.regular:
        return 2.0;
      case AppKitControlSize.large:
        return 2.0;
    }
  }

  double get strokeWidth {
    switch (this) {
      case AppKitControlSize.mini:
        return 1.0;
      case AppKitControlSize.small:
        return 1.0;
      case AppKitControlSize.regular:
        return 1.5;
      case AppKitControlSize.large:
        return 1.5;
    }
  }

  double get borderRadius {
    switch (this) {
      case AppKitControlSize.mini:
        return 3.5;
      case AppKitControlSize.small:
        return 5.0;
      case AppKitControlSize.regular:
        return 6.5;
      case AppKitControlSize.large:
        return 8.0;
    }
  }

  Size get size {
    switch (this) {
      case AppKitControlSize.mini:
        return const Size(11, 15);
      case AppKitControlSize.small:
        return const Size(13, 18);
      case AppKitControlSize.regular:
        return const Size(15, 22);
      case AppKitControlSize.large:
        return const Size(18, 27);
    }
  }
}
