import 'package:flutter/widgets.dart';

import 'context_menu_state.dart';

class AppKitContextMenuProvider extends InheritedNotifier<AppKitContextMenuState> {
  const AppKitContextMenuProvider({super.key, required super.child, required AppKitContextMenuState state})
    : super(notifier: state);
}
