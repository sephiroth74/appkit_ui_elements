import 'package:appkit_ui_elements/appkit_ui_elements.dart';

class AppKitToolBarIconButton extends AppKitToolbarItem {
  const AppKitToolBarIconButton({
    super.key,
    required this.label,
    required this.icon,
    this.onPressed,
    required this.showLabel,
    this.tooltipMessage,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool showLabel;
  final String? tooltipMessage;

  @override
  Widget build(BuildContext context) {
    Widget iconButton = AppKitIconTheme.toolbar(context,
        showLabel: showLabel, icon: icon, onPressed: onPressed);

    if (showLabel) {
      iconButton = Padding(
        padding: const EdgeInsets.only(left: 6.0, top: 6.0, right: 6.0),
        child: Column(
          children: [
            iconButton,
            Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 10.0,
                  color: AppKitDynamicColor.resolve(
                      context, AppKitColors.text.opaque.secondary),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (tooltipMessage != null) {
      iconButton = AppKitTooltip.plain(
        message: tooltipMessage!,
        child: iconButton,
      );
    }
    return iconButton;
  }

  @override
  AppKitContextMenuEntry<String>? toContextMenuEntry<T>(BuildContext context) {
    return AppKitContextMenuItem(
      child: Row(
        children: [
          AppKitIcon(icon),
          const SizedBox(width: 8.0),
          Text(label),
        ],
      ),
      value: label,
      onTap: () => onPressed?.call(),
    );
  }
}
