import 'package:appkit_ui_elements/appkit_ui_elements.dart';

class AppKitContextMenu<T> {
  Offset? position;
  Size? size;
  double maxWidth;
  double minWidth;
  double? maxHeight;
  bool? scrollbars;
  List<AppKitContextMenuEntry<T>> entries;

  AppKitContextMenu({
    required this.entries,
    this.position,
    this.maxWidth = 350,
    this.minWidth = 50,
    this.maxHeight,
    this.size,
    this.scrollbars,
  });

  @override
  String toString() {
    return 'AppKitContextMenu{position: $position, size: $size, maxWidth: $maxWidth, minWidth: $minWidth, maxHeight: $maxHeight, scrollbars: $scrollbars, entries: ${entries.length}}';
  }

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
    return _firstWhereOrNull(
        entries, (e) => e.value != null && e.value == value);
  }

  AppKitContextMenu<T> copyWith({
    Offset? position,
    List<AppKitContextMenuEntry<T>>? entries,
    double? maxWidth,
    double? minWidth,
    double? maxHeight,
    Size? size,
    bool? scrollbars,
  }) {
    return AppKitContextMenu<T>(
      position: position ?? this.position,
      entries: entries ?? this.entries,
      maxWidth: maxWidth ?? this.maxWidth,
      minWidth: minWidth ?? this.minWidth,
      maxHeight: maxHeight ?? this.maxHeight,
      size: size ?? this.size,
      scrollbars: scrollbars ?? this.scrollbars,
    );
  }
}
