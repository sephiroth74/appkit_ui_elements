import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/cupertino.dart';

class AppKitToolBarDivider extends AppKitToolbarItem {
  const AppKitToolBarDivider({
    super.key,
    this.padding = const EdgeInsets.all(6.0),
    this.color,
  });

  final EdgeInsets? padding;
  final Color? color;

  @override
  Widget build(BuildContext context, {required Brightness brightness}) {
    final dividerColor =
        color ?? AppKitColors.dividerColor.resolveFromBrightness(brightness);

    return SizedBox(
        width: (padding?.horizontal ?? 0) + 1,
        height: 28,
        child:
            Padding(padding: padding!, child: Container(color: dividerColor)));
  }

  @override
  AppKitContextMenuEntry<String>? toContextMenuEntry<T>(BuildContext context) {
    return const AppKitContextMenuDivider();
  }
}
