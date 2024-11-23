import 'package:appkit_ui_element_colors/appkit_ui_element_colors.dart';
import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:appkit_ui_elements/src/library.dart';
import 'package:flutter/material.dart';

const _kSize = 13.0;
const _kItemsPadding = -1.0;

class AppKitRatingIndicator extends StatefulWidget {
  final int min;
  final int max;
  final int value;
  final bool continuous;
  final bool placeholderAlwaysVisible;
  final Color? imageColor;
  final IconData? icon;
  final IconData? placeholderIcon;
  final String? semanticLabel;
  final ValueChanged<int>? onChanged;
  final double? size;
  final double? iconsPadding;

  const AppKitRatingIndicator({
    super.key,
    required this.min,
    required this.max,
    required this.value,
    required this.continuous,
    this.placeholderAlwaysVisible = true,
    this.imageColor,
    this.icon,
    this.placeholderIcon,
    this.semanticLabel,
    this.onChanged,
    this.size,
    this.iconsPadding,
  })  : assert(min <= max),
        assert(value >= min && value <= max);

  @override
  State<AppKitRatingIndicator> createState() => _AppKitRatingIndicatorState();
}

class _AppKitRatingIndicatorState extends State<AppKitRatingIndicator> {
  bool _handleDown = false;

  set handleDown(bool value) {
    if (value != _handleDown && !placeholderAlwaysVisible) {
      setState(() => _handleDown = value);
    }
  }

  late int _currentValue = widget.value;

  late AppKitRatingIndicatorThemeData theme =
      AppKitRatingIndicatorTheme.of(context);

  late double iconsPadding = widget.iconsPadding ?? theme.iconsPadding;

  set currentValue(int value) {
    if (value != _currentValue) {
      setState(() => _currentValue = value);
    }
  }

  bool get placeholderAlwaysVisible => widget.placeholderAlwaysVisible;

  int get min => widget.min;

  int get max => widget.max;

  int get range => max - min;

  double get size => widget.size ?? _kSize;

  int get value => _currentValue;

  /// The width of the widget
  double get width => range * size + (max - 1) * iconsPadding;

  bool get hasCustomPlaceholder => widget.placeholderIcon != null;

  bool get enabled => widget.onChanged != null;

  bool get continuous => widget.continuous;

  @override
  void didUpdateWidget(covariant AppKitRatingIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _currentValue = widget.value;
    }
  }

  void _onPanDown(DragDownDetails details) {
    handleDown = true;
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset localPosition = box.globalToLocal(details.globalPosition);
    final double value = localPosition.dx / width * widget.max;
    final int intValue = value.ceil().clamp(widget.min, widget.max);

    if (continuous) {
      widget.onChanged?.call(intValue);
    } else {
      currentValue = intValue;
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    handleDown = true;
    final RenderBox box = context.findRenderObject() as RenderBox;
    final Offset localPosition = box.globalToLocal(details.globalPosition);
    final double value = localPosition.dx / width * widget.max;
    final int intValue = value.ceil().clamp(widget.min, widget.max);

    if (continuous) {
      widget.onChanged?.call(intValue);
    } else {
      currentValue = intValue;
    }
  }

  void _onPanEnd(DragEndDetails details) {
    handleDown = false;

    if (!continuous) {
      widget.onChanged?.call(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    debugCheckHasAppKitTheme(context);

    return Semantics(
        label: widget.semanticLabel,
        slider: true,
        value: widget.value.toString(),
        child: UiElementColorBuilder(builder: (context, colorContainer) {
          final placeholderOpacity = theme.placeholderOpacity;
          final fillColor = widget.imageColor ?? theme.imageColor;
          final placeholderColor = placeholderAlwaysVisible || _handleDown
              ? hasCustomPlaceholder
                  ? widget.imageColor
                  : widget.imageColor?.withOpacity(placeholderOpacity) ??
                      AppKitColors.secondaryLabelColor
                          .withOpacity(placeholderOpacity)
              : Colors.transparent;
          final fillIcon = widget.icon ?? theme.icon ?? Icons.star_sharp;
          final placeholderIcon =
              widget.placeholderIcon ?? widget.icon ?? fillIcon;

          return SizedBox(
              width: width,
              height: size,
              child: Builder(builder: (context) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanDown: enabled ? _onPanDown : null,
                  onPanUpdate: enabled ? _onPanUpdate : null,
                  onPanEnd: enabled ? _onPanEnd : null,
                  child: Stack(
                    children: List.generate(widget.max, (index) {
                      final isPlaceholder = index >= value;
                      final icon = isPlaceholder ? placeholderIcon : fillIcon;
                      final iconColor =
                          isPlaceholder ? placeholderColor : fillColor;
                      return Positioned(
                        left: index * (size + iconsPadding),
                        child: Icon(
                          icon,
                          color: iconColor,
                          size: size,
                        ),
                      );
                    }),
                  ),
                );
              }));
        }));
  }
}
