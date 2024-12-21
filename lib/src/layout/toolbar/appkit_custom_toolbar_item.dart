import 'package:appkit_ui_elements/appkit_ui_elements.dart';

class AppKitCustomToolbarItem extends AppKitToolbarItem {
  const AppKitCustomToolbarItem({
    super.key,
    required this.inToolbarBuilder,
    this.inOverflowedBuilder,
    this.tooltipMessage,
  });

  final WidgetBuilder inToolbarBuilder;

  final WidgetBuilder? inOverflowedBuilder;

  final String? tooltipMessage;

  @override
  Widget build(BuildContext context, AppKitToolbarItemDisplayMode displayMode) {
    if (displayMode == AppKitToolbarItemDisplayMode.inToolbar) {
      Widget widget = inToolbarBuilder(context);
      if (tooltipMessage != null) {
        widget = AppKitTooltip.plain(
          message: tooltipMessage!,
          child: widget,
        );
      }
      return widget;
    } else {
      return (inOverflowedBuilder != null)
          ? inOverflowedBuilder!(context)
          : const SizedBox.shrink();
    }
  }
}
