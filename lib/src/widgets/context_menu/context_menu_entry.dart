import 'package:appkit_ui_elements/src/widgets/context_menu/context_menu_state.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

abstract base class AppKitContextMenuEntry<T> {
  final bool enabled;

  const AppKitContextMenuEntry({required this.enabled});

  Widget builder(BuildContext context, AppKitContextMenuState menuState);

  void onMouseEnter(
      PointerEnterEvent event, AppKitContextMenuState menuState) {}

  void onMouseExit(PointerExitEvent event, AppKitContextMenuState menuState) {}

  void onMouseHover(
      PointerHoverEvent event, AppKitContextMenuState menuState) {}

  String get debugLabel =>
      '$runtimeType ${hashCode.toString().substring(0, 5)}';
}
