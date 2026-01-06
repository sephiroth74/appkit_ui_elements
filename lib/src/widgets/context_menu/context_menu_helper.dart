import 'dart:math';

import 'package:appkit_ui_elements/appkit_ui_elements.dart';

const _kContextMenuMaxScrollHeightRatio = 0.6;

/// Calculates the position of the context menu based on the position of the
/// menu and the position of the parent menu. To prevent the menu from
/// extending beyond the screen boundaries.
@protected
({Offset pos, Size? size, AlignmentGeometry alignment, bool scrollbarsRequired}) calculateContextMenuBoundaries({
  required BuildContext context,
  required AppKitContextMenu menu,
  Rect? parentRect,
  required AlignmentGeometry spawnAlignment,
  required bool isSubmenu,
  AppKitMenuEdge menuEdge = AppKitMenuEdge.auto,
  double? maxHeight,
}) {
  // debugPrint('--------------------------------------');
  // debugPrint('*** calculateContextMenuBoundaries ***');
  // debugPrint('menu: $menu');
  // debugPrint('spawnAlignment: $spawnAlignment');
  // debugPrint('isSubmenu: $isSubmenu, parentRect: $parentRect');
  // debugPrint('menuEdge: $menuEdge');
  // debugPrint('maxHeight: $maxHeight');

  final screenSize = MediaQuery.of(context).size;
  final safeScreenRect = (Offset.zero & screenSize).deflateVertical(24).deflateHorizontal(8);
  Rect menuRect = context.getWidgetBounds()!;
  AlignmentGeometry nextSpawnAlignment = spawnAlignment;
  bool scrollbarsRequired = false;
  final originalMenuRect = menuRect.copyWith();

  // debugPrint('screenSize: $screenSize');
  // debugPrint('safeScreenRect: $safeScreenRect');

  if (maxHeight != null) {
    menuRect = menuRect.copyWith(bottom: min(menuRect.bottom, menuRect.top + maxHeight));
  }

  // debugPrint('menuRect: $menuRect');

  double x = menuRect.left;
  double y = menuRect.top;
  Size? menuSize;

  if (menuEdge == AppKitMenuEdge.left) {
    x -= menuRect.width;
    menuRect = menuRect.copyWith(left: x);
  }

  Rect currentMenuRect = menuRect.copyWith();

  if (menuRect.height > safeScreenRect.height) {
    // debugPrint('menuRect.height > safeScreenRect.height');
    menuRect = menuRect.copyWith(top: safeScreenRect.top, bottom: safeScreenRect.bottom);
    scrollbarsRequired = true;
  } else if (menuRect.bottom > safeScreenRect.bottom) {
    // debugPrint('menuRect.bottom > safeScreenRect.bottom');

    if (!isSubmenu) {
      menuRect = menuRect.copyWith(bottom: safeScreenRect.bottom);
      scrollbarsRequired = true;
    }

    // check if the new height, compared to the current height, is less than _kContextMenuMaxScrollHeightRatio
    final heightRatio = menuRect.height / currentMenuRect.height;

    if (isSubmenu || heightRatio < _kContextMenuMaxScrollHeightRatio) {
      menuRect = currentMenuRect.shift(Offset(0, -(currentMenuRect.bottom - safeScreenRect.bottom)));
      scrollbarsRequired = false;
    }
  } else if (menuRect.top < safeScreenRect.top) {
    // debugPrint('menuRect.top < safeScreenRect.top');

    if (!isSubmenu) {
      menuRect = menuRect.copyWith(top: safeScreenRect.top);
      scrollbarsRequired = true;
    }

    final heightRatio = menuRect.height / currentMenuRect.height;

    if (isSubmenu || heightRatio < _kContextMenuMaxScrollHeightRatio) {
      menuRect = currentMenuRect.shift(Offset(0, safeScreenRect.top - currentMenuRect.top));
      scrollbarsRequired = false;
    }
    scrollbarsRequired = true;
  }
  if (!isSubmenu) {
    currentMenuRect = menuRect.copyWith();

    if (menuRect.width > safeScreenRect.width) {
      // debugPrint('menuRect.width > safeScreenRect.width');
      menuRect = menuRect.copyWith(left: safeScreenRect.left, right: safeScreenRect.right);
    } else if (menuRect.right > safeScreenRect.right) {
      // debugPrint('menuRect.right > safeScreenRect.right');
      menuRect = currentMenuRect.shift(Offset(-(currentMenuRect.right - safeScreenRect.right), 0));
    } else if (menuRect.left < safeScreenRect.left) {
      // debugPrint('menuRect.left < safeScreenRect.left');
      menuRect = currentMenuRect.shift(Offset(safeScreenRect.left - currentMenuRect.left, 0));
    }
  } else {
    // is submenu
    if (spawnAlignment == AlignmentDirectional.topStart) {
      menuRect = menuRect.shift(Offset(-currentMenuRect.width - parentRect!.width, 0));
      currentMenuRect = menuRect.copyWith();
    }

    if (menuRect.right > safeScreenRect.right || menuRect.left < safeScreenRect.left) {
      if (spawnAlignment == AlignmentDirectional.topEnd) {
        if (menuRect.width > safeScreenRect.width) {
          // debugPrint('menuRect.width > safeScreenRect.width');
          menuRect = menuRect.copyWith(left: safeScreenRect.left, right: safeScreenRect.right);
        } else if (menuRect.right > safeScreenRect.right) {
          // debugPrint('menuRect.right > safeScreenRect.right');
          // check if we have enough space to the left
          (parentRect!.left - menuRect.width) < safeScreenRect.left
              ? menuRect = currentMenuRect.shift(Offset(currentMenuRect.right - safeScreenRect.right, 0))
              : menuRect = menuRect.shift(Offset(-currentMenuRect.width - parentRect.width, 0));
        } else if (menuRect.left < safeScreenRect.left) {
          // debugPrint('menuRect.left < safeScreenRect.left');
          // check if we have enough space to the right
          (parentRect!.right + menuRect.width) > safeScreenRect.right
              ? menuRect = currentMenuRect.shift(Offset(safeScreenRect.right - currentMenuRect.right, 0))
              : menuRect = menuRect.shift(Offset(parentRect.width, 0));
        }
      } else if (spawnAlignment == AlignmentDirectional.topStart) {
        if (menuRect.width > safeScreenRect.width) {
          // debugPrint('menuRect.width > safeScreenRect.width');
          menuRect = menuRect.copyWith(left: safeScreenRect.left, right: safeScreenRect.right);
        } else if (menuRect.right > safeScreenRect.right) {
          // debugPrint('menuRect.right > safeScreenRect.right');
          menuRect = currentMenuRect.shift(Offset(currentMenuRect.right - safeScreenRect.right, 0));
        } else if (menuRect.left < safeScreenRect.left) {
          // debugPrint('menuRect.left < safeScreenRect.left');
          menuRect = currentMenuRect.shift(Offset(safeScreenRect.left - currentMenuRect.left, 0));
        }
      }
    }
  }

  currentMenuRect = menuRect.copyWith();
  // debugPrint('final menuRect: $menuRect');

  // if (isWidthExceed()) {
  //   if (isSubmenu && parentRect != null) {
  //     final toRightSide = parentRect.right;
  //     final toLeftSide = parentRect.left - menuRect.width;
  //     final maxRight = safeScreenRect.right - menuRect.width;
  //     final maxLeft = safeScreenRect.left;

  //     if (spawnAlignment == AlignmentDirectional.topEnd) {
  //       if (currentRect().right > safeScreenRect.right) {
  //         x = min(toRightSide, safeScreenRect.right);
  //         nextSpawnAlignment = AlignmentDirectional.topStart;
  //         if (isWidthExceed()) {
  //           x = toLeftSide;
  //           nextSpawnAlignment = AlignmentDirectional.topEnd;
  //           if (isWidthExceed()) {
  //             x = min(toRightSide, maxRight);
  //             nextSpawnAlignment = AlignmentDirectional.topStart;
  //           }
  //         }
  //       } else {
  //         x = min(toRightSide, safeScreenRect.right);
  //         nextSpawnAlignment = AlignmentDirectional.topEnd;
  //         if (isWidthExceed()) {
  //           x = toLeftSide;
  //           nextSpawnAlignment = AlignmentDirectional.topStart;
  //           if (isWidthExceed()) {
  //             x = min(toRightSide, maxRight);
  //             nextSpawnAlignment = AlignmentDirectional.topEnd;
  //           }
  //         }
  //       }
  //     } else {
  //       if (currentRect().left < safeScreenRect.left) {
  //         x = toRightSide;
  //         nextSpawnAlignment = AlignmentDirectional.topEnd;
  //         if (isWidthExceed()) {
  //           x = toLeftSide;
  //           nextSpawnAlignment = AlignmentDirectional.topStart;
  //           if (isWidthExceed()) {
  //             x = min(toRightSide, maxRight);
  //             nextSpawnAlignment = AlignmentDirectional.topEnd;
  //           }
  //         }
  //       } else {
  //         x = toLeftSide;
  //         nextSpawnAlignment = AlignmentDirectional.topEnd;
  //         if (isWidthExceed()) {
  //           x = toRightSide;
  //           nextSpawnAlignment = AlignmentDirectional.topStart;
  //           if (isWidthExceed()) {
  //             x = max(toLeftSide, maxLeft);
  //             nextSpawnAlignment = AlignmentDirectional.topEnd;
  //           }
  //         }
  //       }
  //     }
  //   } else if (!isSubmenu) {
  //     // x = max(safeScreenRect.left, safeScreenRect.right - menuRect.width);
  //   }
  // }

  // if (isHeightExceed()) {
  //   if (isSubmenu && parentRect != null) {
  //     y = max(safeScreenRect.top, safeScreenRect.bottom - menuRect.height);
  //   } else if (!isSubmenu) {
  //     y = max(safeScreenRect.top, menuRect.top - menuRect.height);
  //   }
  // }

  // final globalMenuRect = Rect.fromLTWH(x, y, menuRect.width, menuRect.height);

  // if (globalMenuRect.top < safeScreenRect.top) {
  //   menuRect = globalMenuRect.shift(Offset(0, safeScreenRect.top - y));
  //   menuSize = menuRect.size;
  // } else if (globalMenuRect.bottom > safeScreenRect.bottom) {
  //   menuRect = globalMenuRect.shift(Offset(0, safeScreenRect.bottom - y));
  //   menuSize = menuRect.size;
  // } else {
  //   menuSize = menuRect.size;
  // }

  menuSize = menuRect.size;
  x = menuRect.left;
  y = menuRect.top;

  // debugPrint('final x: $x, y: $y, size: $menuSize');

  if (!scrollbarsRequired) {
    if (originalMenuRect.height > menuSize.height) {
      scrollbarsRequired = true;
    }
  }

  return (pos: Offset(x, y), size: menuSize, alignment: nextSpawnAlignment, scrollbarsRequired: scrollbarsRequired);
}
