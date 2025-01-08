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
  Widget build(BuildContext context, {required Brightness brightness}) {
    final theme = AppKitTheme.of(context);
    final isDark = brightness == Brightness.dark;

    final Color textColor;
    final Color iconColor;
    final Color inlineHoveredBackgroundColor;
    final Color arrowsColor;

    textColor = AppKitColors.textColor.resolveFromBrightness(brightness);
    iconColor = AppKitColors.toolbarIconColor.resolveFromBrightness(brightness);
    inlineHoveredBackgroundColor = isDark
        ? Colors.white.withValues(alpha: 0.06)
        : Colors.black.withValues(alpha: 0.05);
    arrowsColor = AppKitColors.labelColor.resolveFromBrightness(brightness);

    Widget pulldownButton = Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: AppKitPopupButtonTheme(
        data: AppKitPopupButtonTheme.of(context)
            .copyWith(arrowsColor: arrowsColor, sizeData: {
          AppKitControlSize.regular: AppKitPopupThemeSizeData(
            arrowsButtonSize: 19,
            inlineIconsSize: 16,
            textStyle: theme.typography.body.copyWith(color: textColor),
            inlineTextStyle: theme.typography.body.copyWith(color: textColor),
            inlineChildPadding: const EdgeInsets.only(bottom: 0.0, right: 0.0),
            inlineContainerPadding:
                const EdgeInsets.only(left: 3.0, top: 0, right: 1, bottom: 0),
            inlineHeight: 28.0,
            inlineBorderRadius: 6.0,
            inlineBackgroundColor: Colors.transparent,
            inlineHoveredBackgroundColor: inlineHoveredBackgroundColor,
          ),
        }),
        child: AppKitPulldownButton(
          iconColor: iconColor,
          canRequestFocus: false,
          controlSize: AppKitControlSize.regular,
          minWidth: width,
          color: iconColor,
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
      child: Text(label),
      items: items.map((e) => e).toList(),
    );
  }
}
