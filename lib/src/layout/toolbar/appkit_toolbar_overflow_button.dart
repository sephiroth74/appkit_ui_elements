import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/cupertino.dart';

class AppKitToolbarOverflowButton extends StatelessWidget {
  const AppKitToolbarOverflowButton({
    super.key,
    required this.overflowContentBuilder,
    this.isDense = false,
  });

  final WidgetBuilder overflowContentBuilder;

  final bool isDense;

  @override
  Widget build(BuildContext context) {
    final popupKey = GlobalKey<AppKitToolbarPopupState>();
    return AppKitToolbarPopup(
      key: popupKey,
      content: overflowContentBuilder,
      verticalOffset: 8.0,
      horizontalOffset: 10.0,
      position: AppKitToolbarPopupPosition.below,
      placement: AppKitToolbarPopupPlacement.end,
      child: AppKitToolBarIconButton(
        label: "",
        icon: CupertinoIcons.chevron_right_2,
        onPressed: () {
          popupKey.currentState?.openPopup();
        },
        showLabel: isDense,
      ).build(context, AppKitToolbarItemDisplayMode.inToolbar),
    );
  }
}
