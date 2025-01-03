import 'dart:math';

import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gradient_borders/gradient_borders.dart';

const _kSize = 14.0;
const _kCornerRadiusRatio = 4.0;
const _kBorderWidthRatio = 28;
const _kBoxShadowSpreadRatio = 28;
const _kBoxShadowOffsetRatio = 10;

class AppKitCheckbox extends StatefulWidget {
  final bool? value;
  final Color? color;
  final ValueChanged<bool>? onChanged;
  final String? semanticLabel;
  final double size;

  const AppKitCheckbox({
    super.key,
    required this.value,
    this.color,
    this.onChanged,
    this.semanticLabel,
    this.size = _kSize,
  });

  bool get enabled => onChanged != null;

  bool get isIndeterminate => value == null;

  @override
  State<AppKitCheckbox> createState() => _AppKitCheckboxState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty(
        'state',
        isIndeterminate
            ? 'indeterminate'
            : value!
                ? 'checked'
                : 'unchecked'));
    properties.add(ColorProperty('color', color));
    properties.add(FlagProperty('enabled', value: enabled, ifTrue: 'enabled'));
    properties.add(StringProperty('semanticLabel', semanticLabel));
  }
}

class _AppKitCheckboxState extends State<AppKitCheckbox> {
  @visibleForTesting
  bool buttonHeldDown = false;

  void _handleTapDown(TapDownDetails event) {
    if (!buttonHeldDown) {
      setState(() => buttonHeldDown = true);
    }
  }

  void _handleTapUp(TapUpDetails event) {
    if (buttonHeldDown) {
      setState(() => buttonHeldDown = false);
    }
  }

  void _handleTapCancel() {
    if (buttonHeldDown) {
      setState(() => buttonHeldDown = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    debugCheckHasAppKitTheme(context);
    final theme = AppKitTheme.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: widget.enabled ? _handleTapDown : null,
      onTapUp: widget.enabled ? _handleTapUp : null,
      onTapCancel: widget.enabled ? _handleTapCancel : null,
      onTap: () {
        if (widget.value == null) {
          widget.onChanged?.call(true);
        } else {
          widget.onChanged?.call(!widget.value!);
        }
      },
      child: Semantics(
        checked: widget.value == true,
        label: widget.semanticLabel,
        child: MainWindowBuilder(
          builder: (context, isMainWindow) {
            final isDark = theme.brightness == Brightness.dark;
            final controlBackgroundColor = theme.controlColor;
            final Color accentColor =
                widget.color ?? theme.selectedContentBackgroundColor;

            return Container(
              width: widget.size,
              height: widget.size,
              alignment: Alignment.center,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(widget.size / _kCornerRadiusRatio),
                boxShadow: [
                  if (isDark) ...[
                    const BoxShadow(
                      color: AppKitColors.shadowColor,
                      offset: Offset(0, 0),
                      blurRadius: 0.5,
                      spreadRadius: 0.0,
                      blurStyle: BlurStyle.outer,
                    )
                  ]
                ],
              ),
              child: SizedBox.expand(
                child: _DecoratedContainer(
                  isDown: buttonHeldDown,
                  color: isMainWindow ? accentColor : controlBackgroundColor,
                  value: widget.value,
                  enabled: widget.enabled,
                  theme: theme,
                  size: widget.size,
                  isMainWindow: isMainWindow,
                  isDark: isDark,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _DecoratedContainer extends StatelessWidget {
  final Color color;
  final bool? value;
  final bool enabled;
  final double size;
  final bool isMainWindow;
  final bool isDark;
  final bool isDown;
  final AppKitThemeData theme;

  const _DecoratedContainer({
    required this.color,
    this.value,
    required this.enabled,
    required this.theme,
    required this.size,
    required this.isMainWindow,
    required this.isDark,
    required this.isDown,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppKitTheme.of(context);
    final controlBackgroundColor = theme.controlColor;
    final radius = size / _kCornerRadiusRatio;
    final shadowSpread = size / _kBoxShadowSpreadRatio;
    final iconColor = enabled && isMainWindow
        ? color.computeLuminance() > 0.5
            ? Colors.black
            : Colors.white
        : !isMainWindow && enabled
            ? Colors.white
            : Colors.black.withValues(alpha: 0.5);

    return Container(
      foregroundDecoration: isDown
          ? BoxDecoration(
              color: AppKitDynamicColor.resolve(
                  context, AppKitColors.controlBackgroundPressedColor))
          : null,
      child: Container(
        decoration: BoxDecoration(
          color: !enabled
              ? isDark
                  ? AppKitColors.controlBackgroundColor.color
                      .withValues(alpha: 0.2)
                  : AppKitColors.controlBackgroundColor.darkColor
                      .withValues(alpha: 0.1)
              : value != false
                  ? color
                  : controlBackgroundColor.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            if (!isDark && enabled && (value == false || !isMainWindow)) ...[
              const BoxShadow(
                color: AppKitColors.shadowColor,
              ),
              BoxShadow(
                color:
                    controlBackgroundColor.withValues(alpha: enabled ? 1 : 0.1),
                spreadRadius: -shadowSpread,
                blurRadius: shadowSpread,
                offset: Offset(0, size / _kBoxShadowOffsetRatio),
              ),
            ],
          ],
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            border: enabled || (!isDark && value == false)
                ? GradientBoxBorder(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [
                              AppKitDynamicColor.resolve(context,
                                      AppKitColors.text.opaque.secondary)
                                  .multiplyOpacity(0.75),
                              AppKitDynamicColor.resolve(context,
                                      AppKitColors.text.opaque.quaternary)
                                  .multiplyOpacity(0.0)
                            ]
                          : [
                              AppKitDynamicColor.resolve(context,
                                      AppKitColors.text.opaque.tertiary)
                                  .multiplyOpacity(0.75),
                              AppKitDynamicColor.resolve(context,
                                      AppKitColors.text.opaque.secondary)
                                  .multiplyOpacity(0.5)
                            ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: isDark ? const [0.0, 0.5] : const [0.0, 1.0],
                    ),
                    width: 0.5,
                  )
                : null,
            gradient: value != false && isMainWindow && enabled
                ? LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: isDark ? 0.05 : 0.17),
                      Colors.white.withValues(alpha: 0),
                    ],
                    transform: const GradientRotation(pi / 2),
                  )
                : value == false && enabled
                    ? LinearGradient(
                        colors: [
                          isDark
                              ? Colors.black.withValues(alpha: 0.5)
                              : Colors.white.withValues(alpha: 0.5),
                          isDark
                              ? Colors.black.withValues(alpha: 0.0)
                              : Colors.white.withValues(alpha: 0.0),
                        ],
                        transform: const GradientRotation(pi / 2),
                      )
                    : null,
          ),
          child: (value != false)
              ? Center(
                  child: CustomPaint(
                    size: Size.square(size * 0.9),
                    painter: _CheckboxIconPainter(
                      type: value == null
                          ? _IconType.indeterminate
                          : _IconType.check,
                      color: iconColor,
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

class _CheckboxIconPainter extends CustomPainter {
  final _IconType type;
  final Color color;
  final Paint painter;

  _CheckboxIconPainter({
    required this.type,
    required this.color,
  }) : painter = Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeJoin = StrokeJoin.round
          ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    painter.strokeWidth = size.width / 6;
    final path = Path();

    switch (type) {
      case _IconType.check:
        {
          path
            ..moveTo(size.width * 0.2, size.height * 0.5)
            ..lineTo(size.width * 0.45, size.height * 0.75)
            ..lineTo(size.width * 0.8, size.height * 0.25);
          break;
        }

      case _IconType.indeterminate:
        {
          path
            ..moveTo(size.width * 0.2, size.height * 0.5)
            ..lineTo(size.width * 0.8, size.height * 0.5);
          break;
        }
    }

    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(covariant _CheckboxIconPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.type != type;
  }
}

enum _IconType {
  check,
  indeterminate,
}
