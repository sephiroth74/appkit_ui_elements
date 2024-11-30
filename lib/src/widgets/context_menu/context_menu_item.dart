import 'package:appkit_ui_element_colors/appkit_ui_element_colors.dart';
import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final class AppKitContextMenuItem<T> extends AppKitContextMenuEntry<T> {
  final String title;
  final IconData? image;
  final IconData? onImage;
  final IconData? offImage;
  final IconData? mixedImage;
  final T? value;
  final AppKitItemState itemState;
  final AppKitMenuImageAlignment imageAlignment;
  final TextAlign textAlign;

  final List<AppKitContextMenuEntry<T>>? items;
  final VoidCallback? onSelected;

  AppKitContextMenuItem({
    this.value,
    required this.title,
    this.image,
    this.onImage,
    this.offImage,
    this.mixedImage,
    this.items,
    this.onSelected,
    this.itemState = AppKitItemState.off,
    this.imageAlignment = AppKitMenuImageAlignment.start,
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
    required this.imageAlignment,
    this.textAlign = TextAlign.start,
  })  : value = null,
        itemState = AppKitItemState.off,
        mixedImage = null,
        onImage = null,
        offImage = null;

  bool get isSubmenuItem => items != null;

  bool get isFocusMaintained => false;

  void _handleItemSelection(BuildContext context) {
    final menuState = AppKitContextMenuState.of(context);

    if (isSubmenuItem) {
      _toggleSubmenu(context, menuState);
    } else {
      menuState.animateSelectedItem(this, () {
        menuState.setSelectedItem(this);
        if (Navigator.canPop(context)) {
          Navigator.pop(context, this);
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
    if (itemState == AppKitItemState.on) {
      icon = onImage ?? CupertinoIcons.check_mark;
    } else if (itemState == AppKitItemState.off) {
      icon = offImage ?? CupertinoIcons.check_mark;
    } else {
      icon = mixedImage ?? CupertinoIcons.minus;
    }

    Color textColor = selectedOrFocused && enabled
        ? AppKitColors.labelColor.darkColor
        : AppKitColors.labelColor;
    if (!enabled) {
      textColor = textColor.withOpacity(0.3);
    }

    final Color iconColor = itemState.isOff ? Colors.transparent : textColor;

    return GestureDetector(
      onTap: () => enabled ? _handleItemSelection(context) : null,
      child: UiElementColorBuilder(builder: (context, colorContainer) {
        final accentColor =
            theme.accentColor ?? colorContainer.controlAccentColor;

        final isSelectionAnimating = menuState.isSelectionAnimating &&
            menuState.focusedEntry == this &&
            menuState.selectionTicks % 2 == 0;

        final statusIconWidget = Padding(
          padding: const EdgeInsets.only(top: 3.0, right: 4.0),
          child: Icon(
            icon,
            size: 12,
            color: iconColor,
          ),
        );

        final imageWidget = Padding(
          padding: EdgeInsets.only(
              top: 3.0,
              right:
                  imageAlignment == AppKitMenuImageAlignment.start ? 4.0 : 0.0,
              left: imageAlignment == AppKitMenuImageAlignment.end ? 4.0 : 0.0),
          child: Icon(
            image,
            size: 12,
            color: textColor,
          ),
        );

        final subMenuIconWidget = Padding(
          padding: const EdgeInsets.only(top: 3.0, left: 6.0),
          child: Icon(
            CupertinoIcons.right_chevron,
            size: 12,
            color: textColor,
          ),
        );

        final textWidget = Text(
          textAlign: textAlign,
          softWrap: true,
          title,
          maxLines: 1,
          style: theme.typography.body.copyWith(
            fontSize: 13,
            color: textColor,
          ),
          overflow: TextOverflow.ellipsis,
        );

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
              textDirection: Directionality.of(context),
              children: [
                // Left to right
                statusIconWidget,
                if (textAlign == TextAlign.right || textAlign == TextAlign.end)
                  const Spacer(),
                if (image != null &&
                    imageAlignment == AppKitMenuImageAlignment.start) ...[
                  imageWidget,
                ],
                textWidget,
                if (image != null &&
                    imageAlignment == AppKitMenuImageAlignment.end) ...[
                  imageWidget,
                ],
                if (isSubmenuItem) ...[const Spacer(), subMenuIconWidget]
              ],
            ),
          ),
        );
      }),
    );
  }
}

enum AppKitMenuImageAlignment { start, end }
