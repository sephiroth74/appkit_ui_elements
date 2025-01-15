import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final class AppKitContextMenuItem<T> extends AppKitContextMenuEntry<T> {
  final Widget child;
  final IconData? onImage;
  final IconData? offImage;
  final IconData? mixedImage;
  final T? value;
  final AppKitItemState? itemState;
  final VoidCallback? onTap;

  final List<AppKitContextMenuEntry<T>>? items;

  const AppKitContextMenuItem({
    this.value,
    required this.child,
    this.onImage,
    this.offImage,
    this.mixedImage,
    this.items,
    this.itemState,
    this.onTap,
    super.enabled = true,
  });

  AppKitContextMenuItem.plain(
    String label, {
    this.value,
    this.onImage,
    this.offImage,
    this.mixedImage,
    this.items,
    this.itemState,
    this.onTap,
    super.enabled = true,
  }) : child = Text(label);

  @override
  @override
  String toString() => 'ContextMenuItem(title: $child, value: $value)';

  @override
  List<Object?> get props =>
      super.props +
      [
        value,
        child,
        onImage,
        offImage,
        mixedImage,
        onTap,
      ];

  const AppKitContextMenuItem.submenu({
    required this.child,
    required this.items,
    super.enabled = true,
    this.onTap,
  })  : value = null,
        itemState = AppKitItemState.off,
        mixedImage = null,
        onImage = null,
        offImage = null;

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
        onTap?.call();
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
    final contextMenuTheme = AppKitContextMenuTheme.of(context);
    final selectedOrFocused =
        menuState.focusedEntry == this || menuState.selectedItem == this;
    final isSelectionAnimating = menuState.isSelectionAnimating &&
        menuState.focusedEntry == this &&
        menuState.selectionTicks % 2 == 0;

    final accentColor = theme.activeColor;
    final decorationColor = selectedOrFocused && !isSelectionAnimating
        ? accentColor
        : Colors.transparent;

    final decorationColorBlended = Color.lerp(
        contextMenuTheme.backgroundColor ??
            AppKitDynamicColor.resolve(context, AppKitColors.materials.medium),
        decorationColor,
        decorationColor.a)!;

    final IconData? icon;
    if (itemState == AppKitItemState.on) {
      icon = onImage ?? CupertinoIcons.check_mark;
    } else if (itemState == AppKitItemState.off) {
      icon = offImage;
    } else {
      icon = mixedImage ?? CupertinoIcons.minus;
    }

    Color textColor = selectedOrFocused && enabled
        ? decorationColorBlended.computeLuminance() > 0.5
            ? Colors.black
            : Colors.white
        : AppKitDynamicColor.resolve(context, AppKitColors.labelColor);
    if (!enabled) {
      textColor = textColor.withValues(alpha: 0.3);
    }

    final Color iconColor =
        itemState?.isOff == true ? Colors.transparent : textColor;

    return GestureDetector(
      onTap: () => enabled ? handleItemSelection(context) : null,
      child: Builder(builder: (context) {
        final statusIconWidget = !menuState.statusIconRequired
            ? const SizedBox.shrink()
            : itemState != null
                ? Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Icon(
                      icon,
                      size: 12,
                      color: iconColor,
                    ),
                  )
                : const SizedBox(width: 6.0);

        final subMenuIconWidget = Icon(
          CupertinoIcons.right_chevron,
          size: 12,
          color: textColor,
        );

        final textWidget = Padding(
          padding: const EdgeInsets.only(right: 6.0),
          child: DefaultTextStyle(
            softWrap: true,
            maxLines: 1,
            style: theme.typography.body.copyWith(
              fontSize: 13,
              color: textColor,
            ),
            overflow: TextOverflow.ellipsis,
            child: AppKitIconTheme(
                data: AppKitIconTheme.of(context).copyWith(color: textColor),
                child: child),
          ),
        );

        return DecoratedBox(
          decoration: BoxDecoration(
            color: decorationColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 6.0, top: 3.5, right: 6.0, bottom: 3.5),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              textDirection: Directionality.of(context),
              children: [
                // Left to right
                statusIconWidget,
                Flexible(child: textWidget),
                if (hasSubmenu) ...[const Spacer(), subMenuIconWidget],
              ],
            ),
          ),
        );
      }),
    );
  }
}

enum AppKitMenuImageAlignment { leading, start, end, trailing }
