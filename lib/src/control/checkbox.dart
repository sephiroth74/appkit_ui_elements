import 'dart:math';

import 'package:appkit_ui_element_colors/appkit_ui_element_colors.dart';
import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:appkit_ui_elements/src/library.dart';
import 'package:appkit_ui_elements/src/theme/appkit_theme.dart';
import 'package:appkit_ui_elements/src/utils/main_window_listener.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:macos_ui/macos_ui.dart';

const _kSize = 14.0;
const _kCornerRadiusRatio = 4.0;
const _kBorderWidthRatio = 28;
const _kBoxShadowSpreadRatio = 28;
const _kBoxShadowOffsetRatio = 14;

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

  @override
  State<AppKitCheckbox> createState() => _AppKitCheckboxState();
}

class _AppKitCheckboxState extends State<AppKitCheckbox> {
  @visibleForTesting
  bool buttonHeldDown = false;

  bool get enabled => widget.onChanged != null;

  bool get isIndeterminate => widget.value == null;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty(
        'state',
        isIndeterminate
            ? 'indeterminate'
            : widget.value!
                ? 'checked'
                : 'unchecked'));
    properties.add(ColorProperty('color', widget.color));
    properties.add(FlagProperty('enabled', value: enabled, ifTrue: 'enabled'));
    properties.add(StringProperty('semanticLabel', widget.semanticLabel));
  }

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
      onTapDown: enabled ? _handleTapDown : null,
      onTapUp: enabled ? _handleTapUp : null,
      onTapCancel: enabled ? _handleTapCancel : null,
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
        child: UiElementColorBuilder(
          builder: (context, colorContainer) {
            final Color accentColor = widget.color ?? theme.accentColor ?? colorContainer.controlAccentColor;
            final isMainWindow = MainWindowStateListener.instance.isMainWindow.value;
            return Container(
              width: widget.size,
              height: widget.size,
              alignment: Alignment.center,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.size / _kCornerRadiusRatio),
                boxShadow: [
                  if (widget.value != false && isMainWindow && enabled) ...[
                    BoxShadow(
                      color: accentColor.withOpacity(0.24),
                      offset: Offset(0, widget.size / _kBoxShadowSpreadRatio),
                      blurRadius: (widget.size / 5.6).clamp(0, 20),
                    ),
                    BoxShadow(
                      color: accentColor.withOpacity(0.12),
                      offset: const Offset(0, 0),
                      blurRadius: 0,
                      spreadRadius: 0.25,
                    ),
                  ],
                ],
              ),
              child: SizedBox.expand(
                child: _DecoratedContainer(
                  isDown: buttonHeldDown,
                  color: isMainWindow ? accentColor : theme.controlBackgroundColor,
                  value: widget.value,
                  enabled: enabled,
                  theme: theme,
                  size: widget.size,
                  isMainWindow: isMainWindow,
                  isDark: theme.brightness == Brightness.dark,
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
    final radius = size / _kCornerRadiusRatio;
    final shadowSpread = size / _kBoxShadowSpreadRatio;
    final iconColor = color.computeLuminance() > 0.5
        ? (enabled ? MacosColors.black : MacosColors.tertiaryLabelColor)
        : (enabled ? Colors.white : MacosColors.tertiaryLabelColor);

    return Container(
      foregroundDecoration: isDown ? BoxDecoration(color: Colors.black.withOpacity(0.1)) : null,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: !enabled
              ? theme.controlBackgroundColor.withOpacity(0.5)
              : value != false && isMainWindow
                  ? color
                  : null,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            if (value == false || !isMainWindow && enabled) ...[
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
              ),
              BoxShadow(
                color: theme.controlBackgroundColor.withOpacity(enabled ? 1 : 0.5),
                spreadRadius: -shadowSpread,
                blurRadius: shadowSpread,
                offset: Offset(0, size / _kBoxShadowOffsetRatio),
              ),
            ],
          ],
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: ((value == false || !isMainWindow) && enabled)
                ? GradientBoxBorder(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.2),
                        Colors.black.withOpacity(0.15),
                      ],
                      transform: const GradientRotation(pi / 2),
                    ),
                    width: size / _kBorderWidthRatio,
                  )
                : null,
            borderRadius: BorderRadius.circular(radius),
            gradient: value != false && isMainWindow
                ? LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.17),
                      Colors.white.withOpacity(0),
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
                      type: value == null ? _IconType.indeterminate : _IconType.check,
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

  _CheckboxIconPainter({
    required this.type,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 6
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

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

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

enum _IconType {
  check,
  indeterminate,
}
