import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/material.dart';

class AppKitToolBarPullDownButton<T> extends AppKitToolbarItem {
  const AppKitToolBarPullDownButton({
    super.key,
    required this.label,
    required this.icon,
    required this.items,
    this.tooltipMessage,
    this.onItemSelected,
  });

  final List<AppKitContextMenuEntry<T>> items;

  final String label;

  final IconData icon;

  final String? tooltipMessage;

  final ValueChanged<AppKitContextMenuItem<T>?>? onItemSelected;

  get menuBuilder => (context) {
        return AppKitContextMenu<T>(
          entries: items,
        );
      };

  @override
  Widget build(BuildContext context, AppKitToolbarItemDisplayMode displayMode) {
    final theme = AppKitTheme.of(context);
    final brightness = theme.brightness;
    final isDark = brightness == Brightness.dark;

    if (displayMode == AppKitToolbarItemDisplayMode.inToolbar) {
      Widget pulldownButton = Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: AppKitPopupButtonTheme(
          data: AppKitPopupButtonTheme.of(context).copyWith(sizeData: {
            AppKitControlSize.regular: AppKitPopupThemeSizeData(
              arrowsButtonSize: 19,
              inlineIconsSize: 16,
              textStyle: theme.typography.body,
              inlineTextStyle: theme.typography.body,
              inlineChildPadding:
                  const EdgeInsets.only(bottom: 0.0, right: 0.0),
              inlineContainerPadding:
                  const EdgeInsets.only(left: 3.0, top: 0, right: 1, bottom: 0),
              inlineHeight: 28.0,
              inlineBorderRadius: 6.0,
              inlineBackgroundColor: Colors.transparent,
              inlineHoveredBackgroundColor: isDark
                  ? const Color(0xff333336)
                  : Colors.black.withOpacity(0.05),
              inlinePressedBackgroundColor: isDark
                  ? const Color(0xff333336)
                  : Colors.black.withOpacity(0.2),
            ),
          }),
          child: AppKitPulldownButton(
            iconColor: brightness.resolve(
              const Color.fromRGBO(0, 0, 0, 0.5),
              const Color.fromRGBO(255, 255, 255, 0.5),
            ),
            canRequestFocus: false,
            controlSize: AppKitControlSize.regular,
            width: 44,
            color: brightness.resolve(
              const Color.fromRGBO(0, 0, 0, 0.5),
              const Color.fromRGBO(255, 255, 255, 0.5),
            ),
            menuEdge: AppKitMenuEdge.bottom,
            icon: icon,
            style: AppKitPulldownButtonStyle.inline,
            menuBuilder: menuBuilder,
            onItemSelected: onItemSelected,
          ),
        ),
      );

      if (tooltipMessage != null) {
        pulldownButton = AppKitTooltip.plain(
          message: tooltipMessage!,
          child: pulldownButton,
        );
      }
      return pulldownButton;
    } else {
      // // We should show a submenu for the pulldown button items.
      final subMenuKey = GlobalKey<AppKitToolbarPopupState>();
      List<AppKitToolbarOverflowMenuItem> subMenuItems = [];
      bool isSelected = false;
      // Convert the original pulldown menu items to toolbar overflow menu items.
      for (var element in items) {
        if (element is AppKitContextMenuItem) {
          final item = element as AppKitContextMenuItem;
          subMenuItems.add(
            AppKitToolbarOverflowMenuItem(
              label: item.title,
              onPressed: () {
                item.onSelected?.call(item);
                // Close the initial overflow menu as well.
                Navigator.of(context).pop();
              },
            ),
          );
        }
      }
      return StatefulBuilder(
        builder: (context, setState) {
          return AppKitToolbarPopup(
            key: subMenuKey,
            content: (context) => MouseRegion(
              child: AppKitToolbarOverflowMenu(children: subMenuItems),
              onExit: (e) {
                // Moving the mouse cursor outside of the submenu should
                // dismiss it.
                subMenuKey.currentState?.removeToolbarPopupRoute();
                setState(() => isSelected = false);
              },
            ),
            verticalOffset: 0.0,
            horizontalOffset: 0.0,
            position: AppKitToolbarPopupPosition.side,
            placement: AppKitToolbarPopupPlacement.start,
            child: MouseRegion(
              onHover: (e) {
                subMenuKey.currentState
                    ?.openPopup()
                    .then((value) => setState(() => isSelected = false));
                setState(() => isSelected = true);
              },
              child: AppKitToolbarOverflowMenuItem(
                label: label,
                subMenuItems: subMenuItems,
                onPressed: () {},
                isSelected: isSelected,
              ),
            ),
          );
        },
      );
    }
  }
}
