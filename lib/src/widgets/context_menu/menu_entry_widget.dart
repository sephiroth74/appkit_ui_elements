import 'package:appkit_ui_elements/src/widgets/context_menu/context_menu_entry.dart';
import 'package:appkit_ui_elements/src/widgets/context_menu/context_menu_item.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'context_menu_state.dart';

class MenuEntryWidget<T> extends StatefulWidget {
  final AppKitContextMenuEntry<T> entry;
  final bool focused;
  final bool enabled;
  const MenuEntryWidget({
    super.key,
    required this.entry,
    this.focused = false,
    this.enabled = true,
  });

  @override
  State<MenuEntryWidget<T>> createState() => _MenuEntryWidgetState<T>();
}

class _MenuEntryWidgetState<T> extends State<MenuEntryWidget<T>> {
  late final FocusNode focusNode;

  bool get enabled => widget.enabled && widget.entry.enabled;

  AppKitContextMenuEntry get entry => widget.entry;

  @override
  void initState() {
    focusNode = FocusNode();

    if (widget.focused && enabled) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        focusNode.requestFocus();
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final menuState = AppKitContextMenuState.of(context);

    return MouseRegion(
      onEnter: (event) =>
          enabled ? _onMouseEnter(context, event, menuState) : null,
      onExit: (event) => widget.entry.onMouseExit(event, menuState),
      onHover: (event) => enabled ? _onMouseHover(event, menuState) : null,
      child: Builder(
        builder: (_) {
          if (entry is AppKitContextMenuItem) {
            final item = entry as AppKitContextMenuItem;

            return Focus(
              autofocus: false,
              focusNode: item.isFocusMaintained ? null : focusNode,
              onFocusChange: enabled
                  ? (value) {
                      if (value) {
                        _ensureFocused(item, menuState, focusNode);
                      }
                    }
                  : null,
              child: item.builder(context, menuState, focusNode),
            );
          } else {
            return entry.builder(context, menuState);
          }
        },
      ),
    );
  }

  /// Handles the mouse enter event for the context menu entry.
  ///
  /// This method is called when the mouse pointer enters the area of the context menu entry.
  /// - If the entry is a submenu, it shows the submenu if it is not already opened.
  /// - If the entry is not a submenu, it closes the current context menu.
  void _onMouseEnter(
    BuildContext context,
    PointerEnterEvent event,
    AppKitContextMenuState menuState,
  ) {
    if (widget.entry is AppKitContextMenuItem) {
      final item = widget.entry as AppKitContextMenuItem;
      final isSubmenuItem = item.isSubmenuItem;
      final isOpenedSubmenu = menuState.isOpened(item);
      final isFocused = menuState.isFocused(item);

      if (!isSubmenuItem && !isFocused) {
        menuState.closeSubmenu();
      } else if (isSubmenuItem && !isOpenedSubmenu) {
        menuState.showSubmenu(context: context, parent: item);
      }

      menuState.setFocusedEntry(item);
    }
    widget.entry.onMouseEnter(event, menuState);
  }

  _onMouseHover(PointerHoverEvent event, AppKitContextMenuState menuState) {
    if (menuState.isFocused(entry)) {
      _ensureFocused(entry, menuState, focusNode);
    }
    widget.entry.onMouseHover(event, menuState);
  }

  void _ensureFocused(AppKitContextMenuEntry entry,
      AppKitContextMenuState menuState, FocusNode focusNode) {
    menuState.focusScopeNode.requestFocus(focusNode);
    menuState.setFocusedEntry(entry);
  }
}
