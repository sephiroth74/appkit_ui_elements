import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _kAnimationDuration = 200;
const _kStatusAnimationDuration = 100;

extension _AppKitControlSizeX on AppKitControlSize {
  Size get size {
    switch (this) {
      case AppKitControlSize.mini:
        return const Size(17.0, 10.0);
      case AppKitControlSize.small:
        return const Size(22.0, 13.0);
      case AppKitControlSize.regular:
        return const Size(26.0, 15.0);
      case AppKitControlSize.large:
        return const Size(38.0, 22.0);
    }
  }

  double get handleSize {
    switch (this) {
      case AppKitControlSize.mini:
        return 9.0;
      case AppKitControlSize.small:
        return 12.0;
      case AppKitControlSize.regular:
        return 14.0;
      case AppKitControlSize.large:
        return 21.0;
    }
  }

  double get handlePadding {
    switch (this) {
      case AppKitControlSize.mini:
        return 1.0;
      case AppKitControlSize.small:
        return 1.0;
      case AppKitControlSize.regular:
        return 1.0;
      case AppKitControlSize.large:
        return 1.0;
    }
  }

  double get borderRadius => size.height / 2;
}

class AppKitSwitch extends StatefulWidget {
  final bool checked;
  final String? semanticLabel;
  final ValueChanged<bool>? onChanged;
  final Color? color;
  final AppKitControlSize size;

  const AppKitSwitch({
    super.key,
    required this.checked,
    this.onChanged,
    this.semanticLabel,
    this.color,
    this.size = AppKitControlSize.regular,
  });

  @override
  State<AppKitSwitch> createState() => _AppKitSwitchState();
}

class _AppKitSwitchState extends State<AppKitSwitch>
    with TickerProviderStateMixin {
  set mouseIsDown(value) {
    if (value) {
      statusController.forward();
    } else {
      statusController.reverse();
    }
  }

  @visibleForTesting
  bool isInteractive = false;

  Offset dragStartPosition = Offset.zero;

  bool dragStartedOnHandle = false;

  bool get checked => widget.checked;

  bool get enabled => widget.onChanged != null;

  late AnimationController positionController;

  late Animation<double> positionCurvedAnimation;

  late AnimationController statusController;

  late final Size _size = widget.size.size;

  late final double _handleSize = widget.size.handleSize;

  late final double _handlePadding = widget.size.handlePadding;

  double get _borderRadius => widget.size.borderRadius;

  @override
  void initState() {
    super.initState();
    isInteractive = false;
    dragStartedOnHandle = false;

    positionController = AnimationController(
        lowerBound: 0.0,
        upperBound: 1.0,
        value: checked ? 1.0 : 0.0,
        duration: const Duration(milliseconds: _kAnimationDuration),
        reverseDuration: const Duration(milliseconds: _kAnimationDuration),
        vsync: this);

    positionCurvedAnimation = CurvedAnimation(
        parent: positionController, curve: Curves.easeInOutSine);
    positionController.addListener(_handleAnimationFrame);
    positionController.addStatusListener(_handleAnimationStatus);

    statusController = AnimationController(
      lowerBound: 0.0,
      upperBound: 1.0,
      value: 0.0,
      duration: const Duration(milliseconds: _kStatusAnimationDuration),
      vsync: this,
    );

    statusController.addListener(_handleStatusAnimationFrame);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(FlagProperty('checked',
        value: checked,
        ifTrue: 'checked',
        ifFalse: 'unchecked',
        showName: true));
    properties.add(FlagProperty('enabled',
        value: enabled,
        ifTrue: 'enabled',
        ifFalse: 'disabled',
        showName: true));
    properties.add(FlagProperty('isInteractive',
        value: isInteractive,
        ifTrue: 'isInteractive',
        ifFalse: 'isNotInteractive',
        showName: true));
    properties.add(FlagProperty('dragStartedOnHandle',
        value: dragStartedOnHandle,
        ifTrue: 'dragStartedOnHandle',
        ifFalse: 'dragStartedOnContainer',
        showName: true));
    properties.add(
        DiagnosticsProperty<Offset>('dragStartPosition', dragStartPosition));
    properties.add(DiagnosticsProperty<ValueChanged<bool>?>(
        'onChanged', widget.onChanged));
    properties.add(StringProperty('semanticLabel', widget.semanticLabel));
    properties.add(ColorProperty('color', widget.color));
    properties.add(EnumProperty<AppKitControlSize>('size', widget.size));
  }

  @override
  void didUpdateWidget(covariant AppKitSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.checked != widget.checked) {
      _resumeAnimation();
    }
  }

  @override
  void dispose() {
    positionController.dispose();
    super.dispose();
  }

  void _resumeAnimation() {
    if (positionController.isAnimating) {
      positionController.stop();
    }
    _animateTo(checked);
  }

  void _animateTo(bool value) {
    if (value) {
      positionController.forward();
    } else {
      positionController.reverse();
    }
  }

  void _handleTap() {
    widget.onChanged?.call(!checked);
  }

  void _handleTapDown(Offset localPosition) {
    setState(() {
      dragStartPosition = localPosition;
      if (checked) {
        dragStartedOnHandle =
            localPosition.dx > ((_size.width - _handleSize - _handlePadding));
      } else {
        dragStartedOnHandle =
            localPosition.dx < ((_handleSize + _handlePadding));
      }
      mouseIsDown = true;
      isInteractive = true;
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      mouseIsDown = false;
      isInteractive = false;
    });
  }

  void _handleStatusAnimationFrame() {
    setState(() {});
  }

  void _handleAnimationFrame() {
    setState(() {});
  }

  void _handleAnimationStatus(AnimationStatus status) {}

  void _handleMouseEnter(PointerEnterEvent event) {
    if (enabled && isInteractive) {
      setState(() {
        mouseIsDown = true;
      });
    }
  }

  void _handleMouseExit(PointerExitEvent event) {
    setState(() {
      mouseIsDown = false;
    });
  }

  void _handleDragStart(DragStartDetails details) {
    if (!enabled || !isInteractive) return;

    setState(() {
      mouseIsDown = true;
      isInteractive = true;
    });
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!isInteractive || !enabled) return;

    if (dragStartedOnHandle) {
      if (details.localPosition.dx < ((_size.width) / 2)) {
        if (!positionController.isAnimating ||
            positionController.status != AnimationStatus.reverse) {
          _animateTo(false);
        }
      } else {
        if (!positionController.isAnimating ||
            positionController.status != AnimationStatus.forward) {
          _animateTo(true);
        }
      }
    } else {
      if (checked) {
        if (dragStartPosition.dx - details.localPosition.dx > _handleSize) {
          dragStartedOnHandle = true;
          if (!positionController.isAnimating ||
              positionController.status != AnimationStatus.reverse) {
            _animateTo(false);
          }
        }
      } else {
        if (details.localPosition.dx - dragStartPosition.dx > _handleSize) {
          dragStartedOnHandle = true;
          if (!positionController.isAnimating ||
              positionController.status != AnimationStatus.forward) {
            _animateTo(true);
          }
        }
      }
    }
  }

  void _handleDragEnd(DragEndDetails details) {
    bool newValue = false;
    if (positionController.isAnimating) {
      if (positionController.status == AnimationStatus.forward) {
        newValue = true;
      }
    } else {
      if (positionController.value > 0.5) {
        newValue = true;
      }
    }

    setState(() {
      isInteractive = false;
      mouseIsDown = false;

      if (enabled && newValue != checked) {
        widget.onChanged?.call(newValue);
      }
    });
  }

  void _handleDragCancel() {
    setState(() {
      isInteractive = false;
      mouseIsDown = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugCheckHasAppKitTheme(context);
    return Semantics(
        button: true,
        label: widget.semanticLabel,
        checked: widget.checked,
        child: Builder(
          builder: (context) {
            final animationValue = positionCurvedAnimation.value;
            final theme = AppKitTheme.of(context);
            final switchTheme = AppKitSwitchTheme.of(context);
            final isDark = theme.brightness == Brightness.dark;
            final enableFactor = enabled ? 1.0 : 0.5;
            final uncheckedColor = enabled
                ? switchTheme.uncheckedColor
                : switchTheme.uncheckedColorDisabled;
            final checkedColor = enabled
                ? (widget.color ?? switchTheme.checkedColor)
                : uncheckedColor;
            final controlBackgroundColor =
                AppKitColors.controlBackgroundColor.color;

            final accentColor = enabled
                ? Color.lerp(uncheckedColor, checkedColor, animationValue)!
                : controlBackgroundColor.withValues(alpha: 0.2);

            final containerBackgroundColor = enabled
                ? AppKitDynamicColor.resolve(
                        context, AppKitColors.fills.opaque.secondary)
                    .withValues(
                        alpha: AppKitDynamicColor.resolve(context,
                                    AppKitColors.fills.opaque.secondary)
                                .a *
                            (1.0 - animationValue))
                : AppKitColors.fills.opaque.primary.color
                    .withValues(alpha: 0.04);

            final Color borderColor = isDark
                ? Colors.white.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.2);

            final Color innerShadowColor;
            if (enabled) {
              final hsvColor = HSLColor.fromColor(accentColor);
              final checkedInnerShadowColor =
                  hsvColor.withLightness(hsvColor.lightness / 1.05).toColor();
              final uncheckedInnerShadowColor =
                  Colors.black.withValues(alpha: 0.2);
              innerShadowColor = Color.lerp(uncheckedInnerShadowColor,
                  checkedInnerShadowColor, animationValue)!;
            } else {
              innerShadowColor = Colors.black.withValues(alpha: 0.1);
            }

            return MouseRegion(
              onExit: enabled ? _handleMouseExit : null,
              onEnter: enabled ? _handleMouseEnter : null,
              child: GestureDetector(
                onTap: enabled ? _handleTap : null,
                onTapDown: enabled
                    ? (details) => _handleTapDown(details.localPosition)
                    : null,
                onTapUp: enabled ? _handleTapUp : null,
                onHorizontalDragStart: enabled ? _handleDragStart : null,
                onHorizontalDragUpdate: enabled ? _handleDragUpdate : null,
                onHorizontalDragEnd: enabled ? _handleDragEnd : null,
                onHorizontalDragCancel: enabled ? _handleDragCancel : null,
                onHorizontalDragDown: enabled
                    ? (details) => _handleTapDown(details.localPosition)
                    : null,
                dragStartBehavior: DragStartBehavior.start,
                child: SizedBox(
                  width: _size.width,
                  height: _size.height,
                  child: Container(
                    foregroundDecoration: enabled &&
                            statusController.value > 0.0
                        ? BoxDecoration(
                            color: Color.lerp(
                                theme.controlBackgroundPressedColor
                                    .withValues(alpha: 0.0),
                                theme.controlBackgroundPressedColor,
                                statusController.value),
                            borderRadius: BorderRadius.circular(_borderRadius))
                        : null,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(_borderRadius),
                      color: containerBackgroundColor,
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: borderColor,
                          width: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(_borderRadius),
                        color: accentColor,
                        boxShadow: [
                          BoxShadow(
                            color: innerShadowColor,
                          ),
                          BoxShadow(
                            blurStyle: BlurStyle.normal,
                            color: accentColor,
                            spreadRadius: -1.0,
                            blurRadius: 1.0,
                          ),
                        ],
                      ),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(_borderRadius),
                          gradient: enabled
                              ? LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: const [0.0, 0.68],
                                  colors: [
                                    Color.fromRGBO(
                                        102, 102, 102, 0.3 * animationValue),
                                    const Color(0x00666666),
                                  ],
                                )
                              : null,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all((_handlePadding / 2)),
                          child: Stack(
                            children: [
                              Positioned(
                                left: animationValue *
                                    ((_size.width -
                                        _handleSize -
                                        _handlePadding)),
                                child: SizedBox(
                                  width: _handleSize,
                                  height: _handleSize,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(
                                          alpha: 0.08 * enableFactor),
                                      shape: BoxShape.circle,
                                    ),
                                    padding:
                                        EdgeInsets.all((_handlePadding / 2)),
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                          color: enabled
                                              ? controlBackgroundColor
                                              : controlBackgroundColor
                                                  .multiplyOpacity(0.75),
                                          shape: BoxShape.circle,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                  alpha: enabled ? 0.12 : 0.02),
                                              blurStyle: BlurStyle.outer,
                                              spreadRadius: 0.0,
                                              blurRadius: 0.25,
                                              offset: const Offset(0.0, 0.2),
                                            ),
                                          ]),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ));
  }
}
