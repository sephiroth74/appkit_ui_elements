import 'dart:math';

import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gradient_borders/gradient_borders.dart';

const _kSize = 14.0;
const _kBorderWidthRatio = 28;
const _kBoxShadowSpreadRatio = 28;
const _kBoxShadowOffsetRatio = 10;

class AppKitRadioButton<T> extends StatefulWidget {
  final T? groupValue;
  final T value;
  final Color? color;
  final ValueChanged<T>? onChanged;
  final String? semanticLabel;
  final double size;

  const AppKitRadioButton({
    super.key,
    required this.groupValue,
    required this.value,
    this.color,
    this.onChanged,
    this.semanticLabel,
    this.size = _kSize,
  });

  bool get isSelected => groupValue == value;

  bool get enabled => onChanged != null;

  bool get isIndeterminate => groupValue == null;

  @override
  State<AppKitRadioButton<T>> createState() => _AppKitRadioButtonState<T>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty(
        'state',
        isIndeterminate
            ? 'indeterminate'
            : isSelected
                ? 'selected'
                : 'unselected'));
    properties.add(ColorProperty('color', color));
    properties.add(FlagProperty('enabled', value: enabled, ifTrue: 'enabled'));
    properties.add(StringProperty('semanticLabel', semanticLabel));
  }
}

class _AppKitRadioButtonState<T> extends State<AppKitRadioButton<T>> {
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
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: widget.enabled ? _handleTapDown : null,
      onTapUp: widget.enabled ? _handleTapUp : null,
      onTapCancel: widget.enabled ? _handleTapCancel : null,
      onTap: widget.onChanged != null
          ? () => widget.onChanged!.call(widget.value)
          : null,
      child: Semantics(
        checked: widget.isSelected,
        label: widget.semanticLabel,
        child: MainWindowBuilder(
          builder: (context, isMainWindow) {
            final theme = AppKitTheme.of(context);
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
                shape: BoxShape.circle,
                boxShadow: [
                  if ((widget.isSelected || widget.isIndeterminate) &&
                      isMainWindow &&
                      widget.enabled &&
                      !isDark) ...[
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.12),
                      offset: const Offset(0, 0.5),
                      blurRadius: 0.5,
                      spreadRadius: 0.25,
                    ),
                  ] else if (isDark) ...[
                    BoxShadow(
                      color: AppKitColors.shadowColor.color
                          .withValues(alpha: isDark ? 0.75 : 0.15),
                      blurRadius: 0.25,
                      spreadRadius: 0,
                      offset: const Offset(0, 0.25),
                      blurStyle: BlurStyle.outer,
                    ),
                  ]
                ],
              ),
              child: SizedBox.expand(
                child: _DecoratedContainer(
                  isDown: buttonHeldDown,
                  color: isMainWindow ? accentColor : controlBackgroundColor,
                  value: widget.groupValue == null
                      ? null
                      : widget.groupValue == widget.value,
                  enabled: widget.enabled,
                  theme: theme,
                  size: widget.size,
                  isMainWindow: isMainWindow,
                  isDark: theme.brightness == Brightness.dark,
                  controlBackgroundColor: controlBackgroundColor,
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
  final AppKitThemeData theme;
  final double size;
  final bool isMainWindow;
  final bool isDark;
  final bool isDown;
  final Color controlBackgroundColor;

  const _DecoratedContainer({
    required this.color,
    this.value,
    required this.enabled,
    required this.theme,
    required this.size,
    required this.isMainWindow,
    required this.isDark,
    required this.isDown,
    required this.controlBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final shadowSpread = size / _kBoxShadowSpreadRatio;
    final iconColor = enabled
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
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: !isDark && enabled && (value == false)
              ? Border.all(
                  color: Colors.black.withValues(alpha: 0.2),
                  width: size / _kBorderWidthRatio,
                )
              : null,
          color: !enabled
              ? isDark
                  ? AppKitColors.controlBackgroundColor.color
                      .withValues(alpha: 0.2)
                  : AppKitColors.controlBackgroundColor.darkColor
                      .withValues(alpha: 0.1)
              : value != false && isMainWindow
                  ? color
                  : controlBackgroundColor.withValues(alpha: 0.5),
          boxShadow: [
            if (!isDark && enabled && (value == false || !isMainWindow)) ...[
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
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
            shape: BoxShape.circle,
            border: isDark && enabled && isMainWindow || (value == false)
                ? GradientBoxBorder(
                    gradient: LinearGradient(
                      colors: isDark
                          ? [
                              AppKitDynamicColor.resolve(
                                      context, AppKitColors.text.opaque.primary)
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
                    painter: _RadioButtonIconPainter(
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

class _RadioButtonIconPainter extends CustomPainter {
  final _IconType type;
  final Color color;
  final Paint painter;

  _RadioButtonIconPainter({
    required this.type,
    required this.color,
  }) : painter = Paint()
          ..color = color
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..style = type == _IconType.check
              ? PaintingStyle.fill
              : PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    painter.strokeWidth = size.width / 6;

    switch (type) {
      case _IconType.check:
        {
          path
            ..moveTo(size.width / 2, size.height / 2)
            ..addOval(Rect.fromCircle(
                center: Offset(size.width / 2, size.height / 2),
                radius: size.width / 4.25));
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
  bool shouldRepaint(covariant _RadioButtonIconPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.type != type;
  }
}

enum _IconType {
  check,
  indeterminate,
}
