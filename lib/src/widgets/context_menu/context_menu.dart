import 'package:appkit_ui_elements/src/widgets/context_menu/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'context_menu_entry.dart';

class AppKitContextMenu<T> {
  Offset? position;
  double maxWidth;
  double minWidth;
  List<AppKitContextMenuEntry<T>> entries;

  AppKitContextMenu({
    required this.entries,
    this.position,
    this.maxWidth = 350,
    this.minWidth = 150,
  });

  Future<T?> show(BuildContext context) {
    return showContextMenu(context, contextMenu: this);
  }

  AppKitContextMenu<T> copyWith({
    Offset? position,
    List<AppKitContextMenuEntry<T>>? entries,
    double? maxWidth,
  }) {
    return AppKitContextMenu<T>(
      position: position ?? this.position,
      entries: entries ?? this.entries,
      maxWidth: maxWidth ?? this.maxWidth,
    );
  }
}
