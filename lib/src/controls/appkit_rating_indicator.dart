import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/material.dart';

const _kSize = 13.0;

/// A custom rating indicator widget with customizable properties.
///
/// The [AppKitRatingIndicator] widget allows users to display a rating indicator
/// with customizable icons, colors, and behavior. The appearance and behavior of
/// the rating indicator can be customized using various properties.
///
/// Example usage:
/// ```dart
/// AppKitRatingIndicator(
///   min: 1,
///   max: 5,
///   value: 3,
///   continuous: true,
///   onChanged: (newValue) {
///     print('Rating changed: $newValue');
///   },
/// )
/// ```
class AppKitRatingIndicator extends StatefulWidget {
  /// The minimum rating value.
  ///
  /// Must be less than or equal to [max].
  final int min;

  /// The maximum rating value.
  ///
  /// Must be greater than or equal to [min].
  final int max;

  /// The current rating value.
  ///
  /// Must be between [min] and [max].
  final int value;

  /// Whether the rating indicator is continuous.
  ///
  /// If true, the rating indicator allows fractional values.
  final bool continuous;

  /// Whether the placeholder icon is always visible.
  ///
  /// Defaults to true.
  final bool placeholderAlwaysVisible;

  /// The color of the rating icons.
  ///
  /// If null, a default color will be used.
  final Color? imageColor;

  /// The icon to use for the rating indicator.
  ///
  /// If null, a default icon will be used.
  final IconData? icon;

  /// The icon to use for the placeholder.
  ///
  /// If null, a default placeholder icon will be used.
  final IconData? placeholderIcon;

  /// The semantic label for the rating indicator.
  ///
  /// Used by accessibility tools to describe the rating indicator.
  final String? semanticLabel;

  /// Called when the user changes the rating value.
  ///
  /// If null, the rating indicator will be read-only.
  final ValueChanged<int>? onChanged;

  /// The size of the rating icons.
  ///
  /// Defaults to [_kSize].
  final double? size;

  /// The padding between the rating icons.
  ///
  /// If null, a default padding will be used.
  final double? iconsPadding;

  /// Creates an [AppKitRatingIndicator] widget.
  ///
  /// The [min], [max], and [value] parameters must not be null.
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
        child: MainWindowBuilder(builder: (context, isMainWindow) {
          final placeholderOpacity = theme.placeholderOpacity;
          final fillColor = widget.imageColor ?? theme.imageColor;
          final placeholderColor = placeholderAlwaysVisible || _handleDown
              ? hasCustomPlaceholder
                  ? widget.imageColor
                  : widget.imageColor?.withValues(alpha: placeholderOpacity) ??
                      AppKitColors.secondaryLabelColor
                          .withValues(alpha: placeholderOpacity)
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
