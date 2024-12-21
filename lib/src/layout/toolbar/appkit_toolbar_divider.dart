import 'package:appkit_ui_elements/appkit_ui_elements.dart';

class AppKitToolBarDivider extends AppKitToolbarItem {
  const AppKitToolBarDivider({
    super.key,
    this.padding = const EdgeInsets.all(6.0),
  });

  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context, AppKitToolbarItemDisplayMode displayMode) {
    Color color = AppKitTheme.brightnessOf(context).resolve(
      const Color.fromRGBO(0, 0, 0, 0.25),
      const Color.fromRGBO(255, 255, 255, 0.25),
    );
    if (displayMode == AppKitToolbarItemDisplayMode.inToolbar) {
      return Container(color: color, width: 1, height: 28, padding: padding!);
    } else {
      return Container(color: color, height: 1, padding: padding!);
    }
  }
}
