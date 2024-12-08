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
  final AppKitItemState? itemState;
  final AppKitMenuImageAlignment imageAlignment;
  final TextAlign textAlign;
  final ValueChanged<AppKitContextMenuItem<T>>? onSelected;

  final List<AppKitContextMenuEntry<T>>? items;

  const AppKitContextMenuItem({
    this.value,
    required this.title,
    this.image,
    this.onImage,
    this.offImage,
    this.mixedImage,
    this.items,
    this.itemState,
    this.imageAlignment = AppKitMenuImageAlignment.start,
    this.textAlign = TextAlign.start,
    this.onSelected,
    super.enabled = true,
  });

  @override
  @override
  String toString() => 'ContextMenuItem(title: $title, value: $value)';

  @override
  List<Object?> get props =>
      super.props +
      [
        value,
        title,
        image,
        onImage,
        offImage,
        mixedImage,
        imageAlignment,
        textAlign,
        onSelected,
      ];

  const AppKitContextMenuItem.submenu({
    required this.title,
    this.image,
    required this.items,
    super.enabled = true,
    this.imageAlignment = AppKitMenuImageAlignment.start,
    this.textAlign = TextAlign.start,
  })  : value = null,
        itemState = AppKitItemState.off,
        mixedImage = null,
        onImage = null,
        offImage = null,
        onSelected = null;

  bool get hasSubmenu => items != null;

  bool get isFocusMaintained => false;

  void handleItemSelection(BuildContext context) {
    final menuState = AppKitContextMenuState.of(context);

    if (hasSubmenu) {
      _toggleSubmenu(context, menuState);
    } else {
      menuState.animateSelectedItem(this, () {
        if (Navigator.canPop(context)) {
          Navigator.pop(context, this);
        }
        onSelected?.call(this);
        menuState.setSelectedItem(this);
      });
    }
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

    final Color iconColor =
        itemState?.isOff == true ? Colors.transparent : textColor;

    return GestureDetector(
      onTap: () => enabled ? handleItemSelection(context) : null,
      child: UiElementColorBuilder(builder: (context, colorContainer) {
        final accentColor =
            theme.accentColor ?? colorContainer.controlAccentColor;

        final isSelectionAnimating = menuState.isSelectionAnimating &&
            menuState.focusedEntry == this &&
            menuState.selectionTicks % 2 == 0;

        final statusIconWidget = itemState != null
            ? Padding(
                padding: const EdgeInsets.only(top: 3.0, right: 4.0),
                child: Icon(
                  icon,
                  size: 12,
                  color: iconColor,
                ),
              )
            : const SizedBox(width: 6.0);

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
              mainAxisSize: MainAxisSize.max,
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
                Flexible(child: textWidget),
                if (image != null &&
                    imageAlignment == AppKitMenuImageAlignment.end) ...[
                  imageWidget,
                ],
                if (hasSubmenu) ...[const Spacer(), subMenuIconWidget],
                const SizedBox(width: 12),
              ],
            ),
          ),
        );
      }),
    );
  }
}

enum AppKitMenuImageAlignment { leading, start, end, trailing }
