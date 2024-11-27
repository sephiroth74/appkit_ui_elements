import 'package:appkit_ui_element_colors/appkit_ui_element_colors.dart';
import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:appkit_ui_elements/src/utils/appkit_logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final class AppKitContextMenuItem<T> extends AppKitContextMenuEntry<T> {
  final String title;
  final IconData? image;
  final IconData? onImage;
  final IconData? offImage;
  final T? value;
  final MenuItemState itemState;
  final AlignmentGeometry imageAlignment;
  final TextAlign textAlign;

  final List<AppKitContextMenuEntry<T>>? items;
  final VoidCallback? onSelected;

  AppKitContextMenuItem({
    this.value,
    required this.title,
    this.image,
    this.onImage,
    this.offImage,
    this.items,
    this.onSelected,
    this.itemState = MenuItemState.off,
    this.imageAlignment = Alignment.centerLeft,
    this.textAlign = TextAlign.start,
    super.enabled = true,
  });

  @override
  @override
  String toString() => 'ContextMenuItem($title)';

  AppKitContextMenuItem.submenu({
    required this.title,
    this.image,
    required this.items,
    this.onSelected,
    super.enabled = true,
    this.imageAlignment = Alignment.centerLeft,
    this.textAlign = TextAlign.start,
  })  : value = null,
        itemState = MenuItemState.off,
        onImage = null,
        offImage = null;

  bool get isSubmenuItem => items != null;

  bool get isFocusMaintained => false;

  void handleItemSelection(BuildContext context) {
    final menuState = AppKitContextMenuState.of(context);

    if (isSubmenuItem) {
      _toggleSubmenu(context, menuState);
    } else {
      menuState.animateSelectedItem(this, () {
        menuState.setSelectedItem(this);
        if (Navigator.canPop(context)) {
          Navigator.pop(context, value);
        }
      });
    }
    onSelected?.call();
  }

  void _toggleSubmenu(BuildContext context, AppKitContextMenuState menuState) {
    if (menuState.isSubmenuOpen &&
        menuState.focusedEntry == menuState.selectedItem) {
      menuState.closeSubmenu();
    } else {
      menuState.showSubmenu(context: context, parent: this);
    }
  }

  @override
  Widget builder(BuildContext context, AppKitContextMenuState menuState,
      [FocusNode? focusNode]) {
    final theme = AppKitTheme.of(context);
    final selectedOrFocused =
        menuState.focusedEntry == this || menuState.selectedItem == this;

    final IconData icon;
    if (itemState == MenuItemState.on) {
      icon = onImage ?? CupertinoIcons.check_mark;
    } else if (itemState == MenuItemState.off) {
      icon = offImage ?? CupertinoIcons.check_mark;
    } else {
      icon = image ?? CupertinoIcons.minus;
    }

    Color textColor = selectedOrFocused && enabled
        ? AppKitColors.labelColor.darkColor
        : AppKitColors.labelColor;
    if (!enabled) {
      textColor = textColor.withOpacity(0.3);
    }

    final Color iconColor = itemState.isOff ? Colors.transparent : textColor;

    return GestureDetector(
      onTap: () => handleItemSelection(context),
      child: UiElementColorBuilder(builder: (context, colorContainer) {
        final accentColor =
            theme.accentColor ?? colorContainer.controlAccentColor;

        final isSelectionAnimating = menuState.isSelectionAnimating &&
            menuState.focusedEntry == this &&
            menuState.selectionTicks % 2 == 0;

        if (menuState.focusedEntry == this) {
          logger.i('Focused entry: $this');
          logger.d('is animating: ${menuState.isSelectionAnimating}');
          logger.d('animation ticks: ${menuState.selectionTicks}');
          logger.d('isSelectionAnimating: $isSelectionAnimating');
        }

        return DecoratedBox(
          decoration: BoxDecoration(
            color: selectedOrFocused && !isSelectionAnimating
                ? accentColor.withOpacity(0.7)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 3.0, top: 3.0, right: 3.0, bottom: 3.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: Icon(
                    icon,
                    size: 12,
                    color: iconColor,
                  ),
                ),
                const SizedBox(width: 4),
                if (image != null &&
                    imageAlignment == Alignment.centerLeft) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0, right: 4.0),
                    child: Icon(
                      image,
                      size: 12,
                      color: iconColor,
                    ),
                  ),
                ],
                Text(
                  textAlign: textAlign,
                  softWrap: true,
                  title,
                  maxLines: 1,
                  style: theme.typography.body.copyWith(
                    fontSize: 13,
                    color: textColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (image != null &&
                    imageAlignment == Alignment.centerRight) ...[
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0, left: 4.0),
                    child: Icon(
                      image,
                      size: 12,
                      color: iconColor,
                    ),
                  ),
                ],
                if (isSubmenuItem) ...[
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(top: 3.0, left: 6.0),
                    child: Icon(
                      CupertinoIcons.right_chevron,
                      size: 12,
                      color: textColor,
                    ),
                  ),
                ]
              ],
            ),
          ),
        );
      }),
    );
  }
}
