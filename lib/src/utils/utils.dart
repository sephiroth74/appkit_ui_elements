import 'package:appkit_ui_elements/appkit_ui_elements.dart' hide left, right;
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

bool debugCheckHasAppKitTheme(BuildContext context, [bool check = true]) {
  assert(() {
    if (AppKitTheme.maybeOf(context) == null) {
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary('A AppKitTheme widget is necessary to draw this layout.'),
        ErrorHint(
          'To introduce a AppKitTheme widget, you can either directly '
          'include one, or use a widget that contains MacosTheme itself, '
          'such as MacosApp',
        ),
        ...context.describeMissingAncestor(expectedAncestorType: AppKitThemeData),
      ]);
    }
    return true;
  }());
  return true;
}

extension BuildContextExtensions on BuildContext {
  Rect? getWidgetBounds() {
    final widgetRenderBox = findRenderObject() as RenderBox?;
    if (widgetRenderBox == null) return null;
    final widgetPosition = widgetRenderBox.localToGlobal(Offset.zero);
    final widgetSize = widgetRenderBox.size;
    return widgetPosition & widgetSize;
  }
}

extension RenderBoxExtensions on RenderBox? {
  Rect? getWidgetBounds({Offset? offset, Size? size}) {
    if (this == null) return null;
    final widgetPosition = this!.localToGlobal(offset ?? Offset.zero);
    final widgetSize = size ?? this!.size;
    return widgetPosition & widgetSize;
  }
}

extension RectExtension on Rect {
  Rect round() {
    return Rect.fromLTWH(left.roundToDouble(), top.roundToDouble(), width.roundToDouble(), height.roundToDouble());
  }
}

extension OffsetExtension on Offset {
  Offset round() {
    return Offset(dx.roundToDouble(), dy.roundToDouble());
  }
}

extension ColorX on Color {
  Color multiplyOpacity(double factor) {
    assert(a >= 0.0);
    if (factor == 1.0) {
      return this;
    } else if (factor == 0.0) {
      return withAlpha(0);
    }
    final newOpacity = (a * factor).clamp(0, 1.0);
    final alpha = (newOpacity * 255).round();
    return withAlpha(alpha);
  }

  Color multiplyLuminance(double factor) {
    final hslColor = HSLColor.fromColor(this);
    return (hslColor.withLightness((hslColor.lightness * factor).clamp(0.0, 1.0))).toColor();
  }

  Color withLuminance(double luminance) {
    final hslColor = HSLColor.fromColor(this);
    return (hslColor.withLightness(luminance)).toColor();
  }

  double computeLightness() {
    final hslColor = HSLColor.fromColor(this);
    return hslColor.lightness;
  }

  Color merge(Color other) {
    final amount = other.a;
    final newR = (other.r * amount + r * (1 - amount));
    final newG = (other.g * amount + g * (1 - amount));
    final newB = (other.b * amount + b * (1 - amount));
    return withValues(alpha: a, red: newR, green: newG, blue: newB);
  }

  String toHexString() {
    final alphaInt = (a * 255).round();
    final redInt = (r * 255).round();
    final greenInt = (g * 255).round();
    final blueInt = (b * 255).round();
    return '#${alphaInt.toRadixString(16)}${redInt.toRadixString(16)}'
        '${greenInt.toRadixString(16)}${blueInt.toRadixString(16)}';
  }
}

extension RectX on Rect {
  Rect copyWith({double? left, double? top, double? right, double? bottom}) {
    return Rect.fromLTRB(left ?? this.left, top ?? this.top, right ?? this.right, bottom ?? this.bottom);
  }

  /// Returns a new rectangle with horizontal edges moved outwards by the given delta.
  Rect inflateHorizontal(double delta) {
    return Rect.fromLTRB(left - delta, top, right + delta, bottom);
  }

  /// Returns a new rectangle with vertical edges moved outwards by the given delta.
  Rect inflateVertical(double delta) {
    return Rect.fromLTRB(left, top - delta, right, bottom + delta);
  }

  /// Returns a new rectangle with horizontal edges moved inwards by the given delta.
  Rect deflateHorizontal(double delta) => inflateHorizontal(-delta);

  /// Returns a new rectangle with vertical edges moved inwards by the given delta.
  Rect deflateVertical(double delta) => inflateVertical(-delta);
}

extension EdgeInsetsX on EdgeInsets {
  EdgeInsets invertHorizontally() {
    return EdgeInsets.only(left: right, right: left, top: top, bottom: bottom);
  }

  EdgeInsets invertVertically() {
    return EdgeInsets.only(left: left, right: right, top: bottom, bottom: top);
  }
}

extension BrightnessX on Brightness {
  /// Check if the brightness is dark or not.
  bool get isDark => this == Brightness.dark;

  /// Resolves the given colors based on the current brightness.
  T resolve<T>(T light, T dark) {
    if (isDark) return dark;
    return light;
  }
}

extension TextEditingControllerX on TextEditingController {
  void selectAll() {
    selection = TextSelection(baseOffset: 0, extentOffset: text.length);
  }

  void clearSelection() {
    selection = TextSelection.collapsed(offset: text.length);
  }
}

extension TextStyleX on TextStyle {
  Size getTextSize(String text) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: this),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }
}

extension DateTimeX on DateTime {
  DateTime nextMonth() => DateTime(year, month + 1, day);
  DateTime previousMonth() => DateTime(year, month - 1, day);

  bool isBeforeRange(DateTimeRange range) {
    return isBefore(range.start);
  }

  bool isAfterRange(DateTimeRange range) {
    return isAfter(range.end);
  }

  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isSameMonth(DateTime other) {
    return year == other.year && month == other.month;
  }

  bool isBetween(DateTime start, DateTime end, bool inclusive) {
    if (inclusive) {
      // start <= this <= end
      return (isAfter(start) || isSameDay(start)) && (isBefore(end) || isSameDay(end));
    } else {
      // start < this < end
      return isAfter(start) && isBefore(end);
    }
  }

  bool isSameOrBefore(DateTime other) {
    return isBefore(other) || isSameDay(other);
  }

  bool isSameOrAfter(DateTime other) {
    return isAfter(other) || isSameDay(other);
  }

  DateTime clamp(DateTime? start, DateTime? end) {
    if (start != null && isBefore(start)) {
      return start;
    } else if (end != null && isAfter(end)) {
      return end;
    }
    return this;
  }
}

extension EitherX<A, B> on Either<A, B> {
  A getLeft() => fold((A value) => value, (B value) => throw UnsupportedError('Either.right'));
  B getRight() => fold((A value) => throw UnsupportedError('Either.left'), (B value) => value);

  A get left => fold((A value) => value, (B value) => throw UnsupportedError('Either.right'));
  B get right => fold((A value) => throw UnsupportedError('Either.left'), (B value) => value);
}

class DateTimeRange extends Equatable {
  final DateTime start;
  final DateTime end;

  @protected
  final int direction;

  DateTime get middle => start.add(end.difference(start) ~/ 2);

  DateTime get current => direction == 1 ? end : start;

  DateTimeRange({required DateTime start, required DateTime end, this.direction = 1})
    : start = start.isBefore(end) ? start : end,
      end = start.isBefore(end) ? end : start;

  const DateTimeRange.single(DateTime date) : start = date, end = date, direction = 1;

  bool contains(DateTime date) {
    return date.isBetween(start, end, true);
  }

  bool isBefore(DateTime other) {
    return start.isBefore(other);
  }

  bool isAfter(DateTime other) {
    return end.isAfter(other);
  }

  bool isSameOrBefore(DateTime other) {
    return start.isSameOrBefore(start);
  }

  bool isSameOrAfter(DateTime other) {
    return end.isSameOrAfter(end);
  }

  Duration get duration => end.difference(start);

  DateTimeRange copyWith({DateTime? start, DateTime? end, int? direction}) {
    return DateTimeRange(start: start ?? this.start, end: end ?? this.end, direction: direction ?? this.direction);
  }

  @override
  List<Object?> get props => [start, end];
}

Color textLuminance(Color backgroundColor) {
  return backgroundColor.computeLuminance() >= 0.5 ? CupertinoColors.black : CupertinoColors.white;
}

bool hasSameFocusNodeId(String line1, String line2) {
  RegExp focusNodeRegex = RegExp(r"FocusNode#(\d+)");

  RegExpMatch? match1 = focusNodeRegex.firstMatch(line1);
  RegExpMatch? match2 = focusNodeRegex.firstMatch(line2);

  if (match1 != null && match2 != null) {
    String? focusNodeId1 = match1.group(1);
    String? focusNodeId2 = match2.group(1);

    return focusNodeId1 == focusNodeId2;
  } else {
    return false;
  }
}

Rect getScreenRect(BuildContext context) {
  final size = MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.first).size;
  return Offset.zero & size;
}

Color luminance(Color backgroundColor, {required CupertinoDynamicColor textColor}) {
  return backgroundColor.computeLuminance() >= 0.5 ? textColor.darkColor : textColor.color;
}

int lerpInt(int begin, int end, double t) => (begin + (end - begin) * t).round();
