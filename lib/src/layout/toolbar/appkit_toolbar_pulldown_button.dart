import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/material.dart';

class AppKitToolBarPullDownButton extends AppKitToolbarItem {
  const AppKitToolBarPullDownButton({
    super.key,
    required this.label,
    required this.items,
    this.icon,
    this.tooltipMessage,
    this.showLabel = true,
    double? width,
  }) : width = width ?? (showLabel ? 100 : 44);

  final List<AppKitContextMenuEntry<String>> items;

  final String label;

  final IconData? icon;

  final String? tooltipMessage;

  final bool showLabel;

  final double width;

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
                ? Colors.white.withValues(alpha: 0.06)
                : Colors.black.withValues(alpha: 0.05),
          ),
        }),
        child: AppKitPulldownButton(
          iconColor: AppKitDynamicColor.resolve(
              context, AppKitColors.toolbarIconColor),
          canRequestFocus: false,
          controlSize: AppKitControlSize.regular,
          minWidth: width,
          color: AppKitDynamicColor.resolve(
              context, AppKitColors.toolbarIconColor),
          menuEdge: AppKitMenuEdge.bottom,
          icon: icon,
          style: AppKitPulldownButtonStyle.inline,
          title: label,
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
