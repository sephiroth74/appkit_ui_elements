import 'package:appkit_ui_elements/appkit_ui_elements.dart';

class AppKitToolBarDivider extends AppKitToolbarItem {
  const AppKitToolBarDivider({
    super.key,
    this.padding = const EdgeInsets.all(6.0),
  });

  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context, AppKitToolbarItemDisplayMode displayMode) {
    final color = AppKitTheme.of(context).dividerColor;

    if (displayMode == AppKitToolbarItemDisplayMode.inToolbar) {
      return SizedBox(
          width: (padding?.horizontal ?? 0) + 1,
          height: 28,
          child: Padding(padding: padding!, child: Container(color: color)));
    } else {
      return SizedBox(
        height: 1,
        child: Padding(
          padding: padding!,
          child: Container(
            color: color,
          ),
        ),
      );
    }
  }
}
