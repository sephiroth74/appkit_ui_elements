import 'dart:math';

import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';

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
}) {
  final screenSize = MediaQuery.of(context).size;
  final safeScreenRect = (Offset.zero & screenSize).deflate(8.0);
  Rect menuRect = context.getWidgetBounds()!;
  AlignmentGeometry nextSpawnAlignment = spawnAlignment;

  double x = menuRect.left;
  double y = menuRect.top;
  Size? menuSize;

  if (menuEdge == AppKitMenuEdge.left) {
    x -= menuRect.width;
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

  if (globalMenuRect.bottom > safeScreenRect.bottom) {
    menuRect = globalMenuRect.shift(Offset(0, safeScreenRect.bottom - y));
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
