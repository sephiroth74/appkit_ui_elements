import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/cupertino.dart';

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
  Widget build(BuildContext context, {required Brightness brightness}) {
    Widget widget = inToolbarBuilder(context);
    if (tooltipMessage != null) {
      widget = AppKitTooltip.plain(
        message: tooltipMessage!,
        child: widget,
      );
    }
    return widget;
  }

  @override
  AppKitContextMenuEntry<String>? toContextMenuEntry<T>(BuildContext context) {
    throw UnimplementedError("Not implemented");
  }
}
