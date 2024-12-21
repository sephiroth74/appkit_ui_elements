import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/material.dart';

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
  final Widget icon;
  final VoidCallback? onPressed;
  final bool showLabel;
  final String? tooltipMessage;

  @override
  Widget build(BuildContext context, AppKitToolbarItemDisplayMode displayMode) {
    final brightness = AppKitTheme.of(context).brightness;
    if (displayMode == AppKitToolbarItemDisplayMode.inToolbar) {
      Widget iconButton = AppKitIconButton(
        padding: const EdgeInsets.all(5),
        disabledColor: Colors.transparent,
        icon: AppKitIconTheme(
          data: AppKitTheme.of(context).iconTheme.copyWith(
                color: brightness.resolve(
                  const Color.fromRGBO(0, 0, 0, 0.5),
                  const Color.fromRGBO(255, 255, 255, 0.5),
                ),
                size: showLabel ? 15.0 : 20.0,
              ),
          child: icon,
        ),
        onPressed: onPressed,
        boxConstraints: BoxConstraints(
          minHeight: showLabel ? 15 : 19,
          minWidth: 15,
          maxWidth: 35,
          maxHeight: 28,
        ),
      );

      if (showLabel) {
        iconButton = Padding(
          padding: const EdgeInsets.only(left: 6.0, top: 6.0, right: 6.0),
          child: Column(
            children: [
              iconButton,
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11.0,
                    color: AppKitColors.systemGray,
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
    } else {
      return AppKitToolbarOverflowMenuItem(
        label: label,
        onPressed: onPressed,
      );
    }
  }
}
