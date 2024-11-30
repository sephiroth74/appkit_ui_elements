import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppKitContextMenu<T> {
  Offset? position;
  Size? size;
  double maxWidth;
  double minWidth;
  List<AppKitContextMenuEntry<T>> entries;

  AppKitContextMenu({
    required this.entries,
    this.position,
    this.maxWidth = 350,
    this.minWidth = 150,
    this.size,
  });

  AppKitContextMenuItem<T>? findItemByValue(T? value) {
    for (final entry in entries) {
      if (entry is AppKitContextMenuItem<T>) {
        if (entry.value == value) {
          return entry;
        }
        if (entry.items != null) {
          final item = entry.items!.firstWhereOrNull((e) {
            if (e is AppKitContextMenuItem) {
              return (e as AppKitContextMenuItem).value == value;
            } else {
              return false;
            }
          });
          if (item != null) {
            return item as AppKitContextMenuItem<T>;
          }
        }
      }
    }
    return null;
  }

  Future<AppKitContextMenuItem<T>?> show(BuildContext context) {
    return showContextMenu(context, contextMenu: this);
  }

  AppKitContextMenu<T> copyWith({
    Offset? position,
    List<AppKitContextMenuEntry<T>>? entries,
    double? maxWidth,
    Size? size,
  }) {
    return AppKitContextMenu<T>(
      position: position ?? this.position,
      entries: entries ?? this.entries,
      maxWidth: maxWidth ?? this.maxWidth,
      size: size ?? this.size,
    );
  }
}
