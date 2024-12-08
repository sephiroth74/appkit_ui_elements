import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppKitContextMenu<T> {
  Offset? position;
  Size? size;
  double maxWidth;
  double minWidth;
  double? maxHeight;
  List<AppKitContextMenuEntry<T>> entries;

  AppKitContextMenu({
    required this.entries,
    this.position,
    this.maxWidth = 350,
    this.minWidth = 50,
    this.maxHeight,
    this.size,
  });

  AppKitContextMenuItem<T>? _firstWhereOrNull(
      List<AppKitContextMenuEntry<T>> entries,
      bool Function(AppKitContextMenuItem<T> element) test) {
    for (final entry in entries) {
      if (entry is AppKitContextMenuItem<T>) {
        if (test(entry)) {
          return entry;
        }
        if (entry.items != null) {
          final item = _firstWhereOrNull(entry.items!, test);
          if (item != null) {
            return item;
          }
        }
      }
    }
    return null;
  }

  AppKitContextMenuItem<T>? firstWhereOrNull(
      bool Function(AppKitContextMenuItem<T> element) test) {
    return _firstWhereOrNull(entries, test);
  }

  AppKitContextMenuItem<T>? findItemByValue(T? value) {
    return _firstWhereOrNull(entries, (e) => e.value == value);
  }

  Future<AppKitContextMenuItem<T>?> show(BuildContext context) {
    return showContextMenu(context, contextMenu: this);
  }

  AppKitContextMenu<T> copyWith({
    Offset? position,
    List<AppKitContextMenuEntry<T>>? entries,
    double? maxWidth,
    double? minWidth,
    double? maxHeight,
    Size? size,
  }) {
    return AppKitContextMenu<T>(
      position: position ?? this.position,
      entries: entries ?? this.entries,
      maxWidth: maxWidth ?? this.maxWidth,
      minWidth: minWidth ?? this.minWidth,
      maxHeight: maxHeight ?? this.maxHeight,
      size: size ?? this.size,
    );
  }
}
