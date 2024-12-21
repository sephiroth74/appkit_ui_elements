import 'package:appkit_ui_elements/appkit_ui_elements.dart';

const _kToolbarItemWidth = 32.0;

class AppKitToolBarSpacer extends AppKitToolbarItem {
  const AppKitToolBarSpacer({
    super.key,
    this.spacerUnits = 1.0,
  });

  final double spacerUnits;

  @override
  Widget build(BuildContext context, AppKitToolbarItemDisplayMode displayMode) {
    if (displayMode == AppKitToolbarItemDisplayMode.inToolbar) {
      return SizedBox(
        width: spacerUnits * _kToolbarItemWidth,
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
