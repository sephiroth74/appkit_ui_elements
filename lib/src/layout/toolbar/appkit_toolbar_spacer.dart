import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/cupertino.dart';

const _kToolbarItemWidth = 32.0;

class AppKitToolBarSpacer extends AppKitToolbarItem {
  const AppKitToolBarSpacer({
    super.key,
    this.spacerUnits = 1.0,
  });

  final double spacerUnits;

  @override
  Widget build(BuildContext context, {required Brightness brightness}) {
    return SizedBox(
      width: spacerUnits * _kToolbarItemWidth,
    );
  }

  @override
  AppKitContextMenuEntry<String>? toContextMenuEntry<T>(BuildContext context) {
    return null;
  }
}
