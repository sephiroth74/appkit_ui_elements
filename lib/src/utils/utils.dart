import 'dart:math';

import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart' hide BrightnessX;

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
        ...context.describeMissingAncestor(
            expectedAncestorType: AppKitThemeData),
      ]);
    }
    return true;
  }());
  return true;
}

bool debugCheckHasMacosTheme(BuildContext context, [bool check = true]) {
  assert(() {
    if (MacosTheme.maybeOf(context) == null) {
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary('A MacosTheme widget is necessary to draw this layout.'),
        ErrorHint(
          'To introduce a MacosTheme widget, you can either directly '
          'include one, or use a widget that contains MacosTheme itself, '
          'such as MacosApp',
        ),
        ...context.describeMissingAncestor(
            expectedAncestorType: MacosThemeData),
      ]);
    }
    return true;
  }());
  return true;
}

Color luminance(Color backgroundColor,
    {required CupertinoDynamicColor textColor}) {
  return backgroundColor.computeLuminance() >= 0.5
      ? textColor.darkColor
      : textColor.color;
}

int lerpInt(int begin, int end, double t) =>
    (begin + (end - begin) * t).round();

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

/// Calculates the position of the context menu based on the position of the
/// menu and the position of the parent menu. To prevent the menu from
/// extending beyond the screen boundaries.
({Offset pos, Size? size, AlignmentGeometry alignment})
    calculateContextMenuBoundaries({
  required BuildContext context,
  required AppKitContextMenu menu,
  Rect? parentRect,
  required AlignmentGeometry spawnAlignment,
  required bool isSubmenu,
  AppKitMenuEdge menuEdge = AppKitMenuEdge.auto,
  double? maxHeight,
}) {
  final screenSize = MediaQuery.of(context).size;
  final safeScreenRect = (Offset.zero & screenSize).deflate(8.0);
  Rect menuRect = context.getWidgetBounds()!;
  AlignmentGeometry nextSpawnAlignment = spawnAlignment;

  if (maxHeight != null) {
    menuRect = menuRect.copyWith(
        bottom: min(menuRect.bottom, menuRect.top + maxHeight));
  }

  double x = menuRect.left;
  double y = menuRect.top;
  Size? menuSize;

  if (menuEdge == AppKitMenuEdge.left) {
    x -= menuRect.width;
  }

  if (menuRect.height > screenSize.height) {
    menuRect = menuRect.copyWith(top: menuRect.top, bottom: screenSize.height);
  }

  bool isWidthExceed() => x + menuRect.width > screenSize.width || x < 0;

  bool isHeightExceed() => y + menuRect.height > screenSize.height || y < 0;

  Rect currentRect() => Offset(x, y) & menuRect.size;

  if (isWidthExceed()) {
    if (isSubmenu && parentRect != null) {
      final toRightSide = parentRect.right;
      final toLeftSide = parentRect.left - menuRect.width;
      final maxRight = safeScreenRect.right - menuRect.width;
      final maxLeft = safeScreenRect.left;

      if (spawnAlignment == AlignmentDirectional.topEnd) {
        if (currentRect().right > safeScreenRect.right) {
          x = min(toRightSide, safeScreenRect.right);
          nextSpawnAlignment = AlignmentDirectional.topStart;
          if (isWidthExceed()) {
            x = toLeftSide;
            nextSpawnAlignment = AlignmentDirectional.topEnd;
            if (isWidthExceed()) {
              x = min(toRightSide, maxRight);
              nextSpawnAlignment = AlignmentDirectional.topStart;
            }
          }
        } else {
          x = min(toRightSide, safeScreenRect.right);
          nextSpawnAlignment = AlignmentDirectional.topEnd;
          if (isWidthExceed()) {
            x = toLeftSide;
            nextSpawnAlignment = AlignmentDirectional.topStart;
            if (isWidthExceed()) {
              x = min(toRightSide, maxRight);
              nextSpawnAlignment = AlignmentDirectional.topEnd;
            }
          }
        }
      } else {
        if (currentRect().left < safeScreenRect.left) {
          x = toRightSide;
          nextSpawnAlignment = AlignmentDirectional.topEnd;
          if (isWidthExceed()) {
            x = toLeftSide;
            nextSpawnAlignment = AlignmentDirectional.topStart;
            if (isWidthExceed()) {
              x = min(toRightSide, maxRight);
              nextSpawnAlignment = AlignmentDirectional.topEnd;
            }
          }
        } else {
          x = toLeftSide;
          nextSpawnAlignment = AlignmentDirectional.topEnd;
          if (isWidthExceed()) {
            x = toRightSide;
            nextSpawnAlignment = AlignmentDirectional.topStart;
            if (isWidthExceed()) {
              x = max(toLeftSide, maxLeft);
              nextSpawnAlignment = AlignmentDirectional.topEnd;
            }
          }
        }
      }
    } else if (!isSubmenu) {
      x = max(safeScreenRect.left, menuRect.left - menuRect.width);
    }
  }

  if (isHeightExceed()) {
    if (isSubmenu && parentRect != null) {
      y = max(safeScreenRect.top, safeScreenRect.bottom - menuRect.height);
    } else if (!isSubmenu) {
      y = max(safeScreenRect.top, menuRect.top - menuRect.height);
    }
  }

  final globalMenuRect = Rect.fromLTWH(x, y, menuRect.width, menuRect.height);

  if (globalMenuRect.top < safeScreenRect.top) {
    menuRect = globalMenuRect.shift(Offset(0, safeScreenRect.top - y));
    menuSize = menuRect.size;
  } else if (globalMenuRect.bottom > safeScreenRect.bottom) {
    menuRect = globalMenuRect.shift(Offset(0, safeScreenRect.bottom - y));
    menuSize = menuRect.size;
  } else {
    menuSize = menuRect.size;
  }

  return (pos: Offset(x, y), size: menuSize, alignment: nextSpawnAlignment);
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
  final size = MediaQueryData.fromView(
          WidgetsBinding.instance.platformDispatcher.views.first)
      .size;
  return Offset.zero & size;
}

extension ColorX on Color {
  Color multiplyOpacity(double factor) {
    assert(opacity >= 0.0);
    if (factor == 1.0) {
      return this;
    } else if (factor == 0.0) {
      return withAlpha(0);
    }
    final newOpacity = (opacity * factor).clamp(0, 1.0);
    final alpha = (newOpacity * 255).round();
    return withAlpha(alpha);
  }

  Color multiplyLuminance(double factor) {
    final hslColor = HSLColor.fromColor(this);
    return (hslColor.withLightness(hslColor.lightness * factor)).toColor();
  }

  Color withLuminance(double luminance) {
    final hslColor = HSLColor.fromColor(this);
    return (hslColor.withLightness(luminance)).toColor();
  }
}

extension RectX on Rect {
  Rect copyWith({double? left, double? top, double? right, double? bottom}) {
    return Rect.fromLTRB(
      left ?? this.left,
      top ?? this.top,
      right ?? this.right,
      bottom ?? this.bottom,
    );
  }
}

extension EdgeInsetsX on EdgeInsets {
  EdgeInsets invertHorizontally() {
    return EdgeInsets.only(
        left: this.right, right: this.left, top: top, bottom: bottom);
  }

  EdgeInsets invertVertically() {
    return EdgeInsets.only(
        left: this.left, right: this.right, top: bottom, bottom: top);
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
      return (isAfter(start) || isSameDay(start)) &&
          (isBefore(end) || isSameDay(end));
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
  A getLeft() => fold(
      (A value) => value, (B value) => throw UnsupportedError('Either.right'));
  B getRight() => fold(
      (A value) => throw UnsupportedError('Either.left'), (B value) => value);

  A get left => fold(
      (A value) => value, (B value) => throw UnsupportedError('Either.right'));
  B get right => fold(
      (A value) => throw UnsupportedError('Either.left'), (B value) => value);
}

class DateTimeRange extends Equatable {
  final DateTime start;
  final DateTime end;

  DateTimeRange({required DateTime start, required DateTime end})
      : start = start.isBefore(end) ? start : end,
        end = start.isBefore(end) ? end : start;

  const DateTimeRange.single(DateTime date)
      : start = date,
        end = date;

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

  DateTimeRange copyWith({DateTime? start, DateTime? end}) {
    return DateTimeRange(
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }

  @override
  List<Object?> get props => [start, end];
}
