import 'package:appkit_ui_elements/src/widgets/context_menu/context_menu_entry.dart';
import 'package:appkit_ui_elements/src/widgets/context_menu/context_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'context_menu_state.dart';

class AppKitMenuEntryWidget<T> extends StatefulWidget {
  final AppKitContextMenuEntry<T> entry;
  final bool focused;
  final bool enabled;
  const AppKitMenuEntryWidget({
    super.key,
    required this.entry,
    this.focused = false,
    this.enabled = true,
  });

  @override
  State<AppKitMenuEntryWidget<T>> createState() =>
      _AppKitMenuEntryWidgetState<T>();
}

class _AppKitMenuEntryWidgetState<T> extends State<AppKitMenuEntryWidget<T>> {
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
      onEnter: (event) => enabled
          ? _onMouseEnter(context,
              event: event, menuState: menuState, focusNode: focusNode)
          : null,
      onExit: (event) => widget.entry.onMouseExit(event, menuState),
      onHover: (event) => enabled
          ? _onMouseHover(
              event: event, menuState: menuState, focusNode: focusNode)
          : null,
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
                        _ensureFocused(
                            entry: item,
                            menuState: menuState,
                            focusNode: focusNode);
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

  void _onEnter(BuildContext context, AppKitContextMenuState menuState) {
    if (widget.entry is AppKitContextMenuItem) {
      final item = widget.entry as AppKitContextMenuItem;
      final isSubmenuItem = item.hasSubmenu;
      final isOpenedSubmenu = menuState.isOpened(item);
      final isFocused = menuState.isFocused(item);

      if (isFocused && menuState.isSubmenuOpen && !isOpenedSubmenu) {
        menuState.closeSubmenu();
      }

      if (!isSubmenuItem && !isFocused) {
        menuState.closeSubmenu();
      } else if (isSubmenuItem && !isOpenedSubmenu) {
        menuState.showSubmenu(context: context, parent: item);
      }

      menuState.setFocusedEntry(item);
    }
  }

  /// Handles the mouse enter event for the context menu entry.
  ///
  /// This method is called when the mouse pointer enters the area of the context menu entry.
  /// - If the entry is a submenu, it shows the submenu if it is not already opened.
  /// - If the entry is not a submenu, it closes the current context menu.
  void _onMouseEnter(
    BuildContext context, {
    required PointerEnterEvent event,
    required AppKitContextMenuState menuState,
    required FocusNode focusNode,
  }) {
    _ensureFocused(entry: entry, menuState: menuState, focusNode: focusNode);
    widget.entry.onMouseEnter(event, menuState);
  }

  _onMouseHover({
    required PointerHoverEvent event,
    required AppKitContextMenuState menuState,
    required FocusNode focusNode,
  }) {
    if (!menuState.isFocused(entry)) {
      _ensureFocused(entry: entry, menuState: menuState, focusNode: focusNode);
    }
    widget.entry.onMouseHover(event, menuState);
  }

  void _ensureFocused({
    required AppKitContextMenuEntry entry,
    required AppKitContextMenuState menuState,
    required FocusNode focusNode,
  }) {
    menuState.focusScopeNode.requestFocus(focusNode);
    menuState.setFocusedEntry(entry);
    _onEnter(context, menuState);
  }
}
