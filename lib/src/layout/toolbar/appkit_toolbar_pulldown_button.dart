import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:macos_ui/macos_ui.dart' hide BrightnessX;

class AppKitToolBarPullDownButton extends AppKitToolbarItem {
  const AppKitToolBarPullDownButton({
    super.key,
    required this.label,
    required this.icon,
    required this.items,
    this.tooltipMessage,
  });

  final String label;

  final IconData icon;

  final List<MacosPulldownMenuEntry>? items;

  final String? tooltipMessage;

  @override
  Widget build(BuildContext context, AppKitToolbarItemDisplayMode displayMode) {
    final brightness = MacosTheme.of(context).brightness;

    if (displayMode == AppKitToolbarItemDisplayMode.inToolbar) {
      Widget pulldownButton = Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: MacosPulldownButtonTheme(
          data: MacosPulldownButtonTheme.of(context).copyWith(
            iconColor: brightness.resolve(
              const Color.fromRGBO(0, 0, 0, 0.5),
              const Color.fromRGBO(255, 255, 255, 0.5),
            ),
          ),
          child: MacosPulldownButton(
            icon: icon,
            items: items,
          ),
        ),
      );

      if (tooltipMessage != null) {
        pulldownButton = MacosTooltip(
          message: tooltipMessage!,
          child: pulldownButton,
        );
      }
      return pulldownButton;
    } else {
      // We should show a submenu for the pulldown button items.
      final subMenuKey = GlobalKey<ToolbarPopupState>();
      List<AppKitToolbarOverflowMenuItem> subMenuItems = [];
      bool isSelected = false;
      // Convert the original pulldown menu items to toolbar overflow menu items.
      items?.forEach((element) {
        if (element is MacosPulldownMenuItem) {
          assert(element.label != null,
              'When you use a MacosPulldownButton in the Toolbar, you must set the label property for all MacosPulldownMenuItems.');
          subMenuItems.add(
            AppKitToolbarOverflowMenuItem(
              label: element.label!,
              onPressed: () {
                element.onTap?.call();
                // Close the initial overflow menu as well.
                Navigator.of(context).pop();
              },
            ),
          );
        }
      });
      return StatefulBuilder(
        builder: (context, setState) {
          return ToolbarPopup(
            key: subMenuKey,
            content: (context) => MouseRegion(
              child: ToolbarOverflowMenu(children: subMenuItems),
              onExit: (e) {
                // Moving the mouse cursor outside of the submenu should
                // dismiss it.
                subMenuKey.currentState?.removeToolbarPopupRoute();
                setState(() => isSelected = false);
              },
            ),
            verticalOffset: 0.0,
            horizontalOffset: 0.0,
            position: ToolbarPopupPosition.side,
            placement: ToolbarPopupPlacement.start,
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
