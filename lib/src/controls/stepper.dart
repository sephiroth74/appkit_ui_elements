import 'dart:async';

import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:appkit_ui_elements/src/library.dart';
import 'package:flutter/foundation.dart';
import 'package:macos_ui/macos_ui.dart';

const _kSize = 21.0;
const _kWidthRatio = 1.5;
const _kBorderRadiusRatio = 4;
const _longPressDuration = Duration(milliseconds: 500);
const _tickerDuration = Duration(milliseconds: 100);

class AppKitStepper extends StatefulWidget {
  final String? semanticLabel;
  final double minValue;
  final double maxValue;
  final double increment;
  final double value;
  final ValueChanged<double>? onChanged;
  final double height;
  final double width;

  const AppKitStepper({
    super.key,
    this.semanticLabel,
    this.minValue = 0,
    this.maxValue = 100,
    this.increment = 1,
    double size = _kSize,
    required this.value,
    this.onChanged,
  })  : height = size,
        width = size / _kWidthRatio;

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

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasAppKitTheme(context));
    final AppKitThemeData theme = AppKitTheme.of(context);
    final enabledFactor = widget.enabled ? 1.0 : 0.5;
    final controlBorderColor = theme.brightness.isDark
        ? MacosColors.white.withOpacity(0.2 * enabledFactor)
        : MacosColors.black.withOpacity(0.2 * enabledFactor);

    final borderRadius = widget.height / _kBorderRadiusRatio;
    final borderWidth = widget.height / 40;

    final iconColor = !theme.brightness.isDark
        ? widget.enabled
            ? MacosColors.labelColor.color
            : MacosColors.tertiaryLabelColor.color
        : widget.enabled
            ? MacosColors.labelColor.darkColor
            : MacosColors.tertiaryLabelColor.darkColor;

    return Semantics(
      label: widget.semanticLabel,
      button: true,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: GestureDetector(
          onPanDown: widget.enabled ? _onPanDown : null,
          onPanEnd: widget.enabled ? _onPanEnd : null,
          onPanCancel: widget.enabled ? _onPanCancel : null,
          onPanUpdate: widget.enabled ? _onPanUpdate : null,
          onPanStart: widget.enabled ? _onPanStart : null,
          child: DecoratedBox(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                boxShadow: [
                  BoxShadow(
                    color: MacosColors.black.withOpacity(0.15 * enabledFactor),
                    offset: Offset(0, widget.height / 80),
                    blurRadius: widget.height / 80,
                  ),
                  BoxShadow(
                    color: MacosColors.black.withOpacity(0.05 * enabledFactor),
                    offset: Offset(0, widget.height / 20),
                    blurRadius: widget.height / 26.666,
                  ),
                ]),
            child: Stack(
              children: [
                // Top Stepper
                SizedBox(
                  width: widget.width,
                  height: widget.height / 2,
                  child: Container(
                    foregroundDecoration: _isPointerDown && _isPointerIncreasing
                        ? BoxDecoration(
                            color: MacosColors.black.withOpacity(0.1),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(borderRadius),
                                topRight: Radius.circular(borderRadius)))
                        : null,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: widget.enabled
                            ? theme.controlBackgroundColor
                            : theme.controlBackgroundColorDisabled,
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
                          offset: Offset(0, -widget.height / 10),
                          size: widget.height / 2,
                        ),
                      ),
                    ),
                  ),
                ),

                // Bottom Stepper
                Positioned(
                  bottom: 0,
                  child: SizedBox(
                    width: widget.width,
                    height: widget.height / 2,
                    child: Container(
                      foregroundDecoration: _isPointerDown &&
                              !_isPointerIncreasing
                          ? BoxDecoration(
                              color: MacosColors.black.withOpacity(0.1),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(borderRadius),
                                  bottomRight: Radius.circular(borderRadius)))
                          : null,
                      child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: widget.enabled
                                ? theme.controlBackgroundColor
                                : theme.controlBackgroundColorDisabled,
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
                              offset: Offset(0, -widget.height / 10),
                              size: widget.height / 2,
                            ),
                          )),
                    ),
                  ),
                ),

                // Top Gradient
                Positioned(
                  bottom: widget.height / 2,
                  left: borderWidth,
                  child: SizedBox(
                    width: widget.width - borderWidth * 2,
                    height: widget.height / 5,
                    child: DecoratedBox(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                      colors: [
                        MacosColors.black.withOpacity(0),
                        MacosColors.black.withOpacity(0.05 * enabledFactor),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ))),
                  ),
                ),

                // Bottom Gradient
                Positioned(
                  top: widget.height / 2,
                  left: borderWidth,
                  child: SizedBox(
                    width: widget.width - borderWidth * 2,
                    height: widget.height / 5,
                    child: DecoratedBox(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                      colors: [
                        MacosColors.black.withOpacity(0),
                        MacosColors.black.withOpacity(0.05 * enabledFactor),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ))),
                  ),
                ),

                // Filler
                Positioned(
                  top: (widget.height / 2) - (widget.height / 20),
                  left: borderWidth,
                  child: SizedBox(
                    width: widget.width - borderWidth * 2,
                    height: widget.height / 10,
                    child: DecoratedBox(
                        decoration: BoxDecoration(
                      color:
                          MacosColors.black.withOpacity(0.05 * enabledFactor),
                    )),
                  ),
                ),

                // Separator
                Positioned(
                  top: (widget.height / 2) - (widget.height / 40),
                  left: borderWidth,
                  child: SizedBox(
                    width: widget.width - borderWidth * 2,
                    height: widget.height / 20,
                    child: DecoratedBox(
                        decoration: BoxDecoration(
                      color:
                          MacosColors.black.withOpacity(0.125 * enabledFactor),
                    )),
                  ),
                ),
              ],
            ),
          ),
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
      _isPointerIncreasing = details.localPosition.dy < widget.height / 2;
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
              details.localPosition.dy <= widget.height) &&
          (details.localPosition.dx >= 0 &&
              details.localPosition.dx <= widget.width);
      _isPointerIncreasing = details.localPosition.dy < widget.height / 2;
    });
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _isPointerIncreasing = details.localPosition.dy < widget.height / 2;
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
