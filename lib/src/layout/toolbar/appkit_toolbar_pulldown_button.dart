import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/material.dart';

class AppKitToolBarPullDownButton extends AppKitToolbarItem {
  const AppKitToolBarPullDownButton({
    super.key,
    required this.label,
    required this.icon,
    required this.items,
    this.tooltipMessage,
  });

  final List<AppKitContextMenuEntry<String>> items;

  final String label;

  final IconData icon;

  final String? tooltipMessage;

  get menuBuilder => (context) {
        return AppKitContextMenu<String>(
          entries: items,
        );
      };

  @override
  Widget build(BuildContext context) {
    final theme = AppKitTheme.of(context);
    final brightness = theme.brightness;
    final isDark = brightness == Brightness.dark;

    Widget pulldownButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: AppKitPopupButtonTheme(
        data: AppKitPopupButtonTheme.of(context).copyWith(sizeData: {
          AppKitControlSize.regular: AppKitPopupThemeSizeData(
            arrowsButtonSize: 19,
            inlineIconsSize: 16,
            textStyle: theme.typography.body,
            inlineTextStyle: theme.typography.body,
            inlineChildPadding: const EdgeInsets.only(bottom: 0.0, right: 0.0),
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
          onItemSelected: (_) {},
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
  }

  @override
  AppKitContextMenuEntry<String>? toContextMenuEntry<T>(BuildContext context) {
    return AppKitContextMenuItem(
      title: label,
      items: items.map((e) => e).toList(),
    );
  }
}
