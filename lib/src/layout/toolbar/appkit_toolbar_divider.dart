import 'package:appkit_ui_elements/appkit_ui_elements.dart';

class AppKitToolBarDivider extends AppKitToolbarItem {
  const AppKitToolBarDivider({
    super.key,
    this.padding = const EdgeInsets.all(6.0),
  });

  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final color = AppKitTheme.of(context).dividerColor;

    return SizedBox(
        width: (padding?.horizontal ?? 0) + 1,
        height: 28,
        child: Padding(padding: padding!, child: Container(color: color)));
  }

  @override
  AppKitContextMenuEntry<String>? toContextMenuEntry<T>(BuildContext context) {
    return const AppKitContextMenuDivider();
  }
}
