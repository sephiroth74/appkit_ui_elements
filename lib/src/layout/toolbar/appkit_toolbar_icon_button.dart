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
  final IconData icon;
  final VoidCallback? onPressed;
  final bool showLabel;
  final String? tooltipMessage;

  @override
  Widget build(BuildContext context, AppKitToolbarItemDisplayMode displayMode) {
    final brightness = AppKitTheme.of(context).brightness;
    if (displayMode == AppKitToolbarItemDisplayMode.inToolbar) {
      Widget iconButton = AppKitIconTheme(
        data: AppKitIconThemeData(
          size: showLabel ? 20.0 : 20.0,
        ),
        child: AppKitIconButton(
          icon: icon,
          padding: showLabel
              ? const EdgeInsets.symmetric(horizontal: 5, vertical: 3)
              : const EdgeInsets.all(5),
          disabledColor: Colors.transparent,
          color: brightness.resolve(
            const Color.fromRGBO(0, 0, 0, 0.5),
            const Color.fromRGBO(255, 255, 255, 0.5),
          ),
          onPressed: onPressed,
          boxConstraints: showLabel
              ? const BoxConstraints(
                  minHeight: 19,
                  minWidth: 35,
                  maxWidth: 35,
                  maxHeight: 22,
                )
              : const BoxConstraints(
                  minHeight: 19,
                  minWidth: 15,
                  maxWidth: 35,
                  maxHeight: 28,
                ),
        ),
      );

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
                    fontSize: 11.0,
                    color: AppKitColors.text.opaque.secondary,
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
