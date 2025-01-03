import 'dart:async';
import 'dart:collection';

import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/services.dart';

const _kAnimationDuration = Duration(milliseconds: 64);
const _kAnimationCount = 4;

class AppKitContextMenuState<T> extends ChangeNotifier {
  late final focusScopeNode = FocusScopeNode(
    onKeyEvent: (node, event) {
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        this._handleItemSelection(node.context, focusedEntry);
      }
      return KeyEventResult.ignored;
    },
  );

  final overlayController = OverlayPortalController(debugLabel: 'ContextMenu');

  final bool enableWallpaperTinting;

  AppKitContextMenuEntry<T>? _futureSelectedEntry;

  AppKitContextMenuEntry<T>? _focusedEntry;

  AppKitContextMenuItem<T>? _selectedItem;

  bool _isPositionVerified = false;

  final AppKitMenuEdge _menuEdge;

  AlignmentGeometry _spawnAlignment = AlignmentDirectional.topEnd;

  final Rect? _parentItemRect;

  final bool _isSubmenu;

  final AppKitContextMenu<T> menu;

  final AppKitContextMenuItem? parentItem;

  final VoidCallback? selfClose;

  WidgetBuilder submenuBuilder = (context) => const SizedBox.shrink();

  Timer? _selectionTimer;

  int _selectionTicks = -1;

  final HashMap<AppKitContextMenuEntry<T>, Rect> _itemLayouts = HashMap();

  AppKitContextMenuState({
    required this.menu,
    this.parentItem,
    this.enableWallpaperTinting = true,
    AppKitContextMenuItem<T>? focusedEntry,
    AppKitMenuEdge menuEdge = AppKitMenuEdge.auto,
  })  : _parentItemRect = null,
        _isSubmenu = false,
        _focusedEntry = focusedEntry,
        selfClose = null,
        _menuEdge = menuEdge;

  AppKitContextMenuState.submenu({
    required this.menu,
    required this.selfClose,
    this.parentItem,
    this.enableWallpaperTinting = true,
    AlignmentGeometry? spawnAlignmen,
    Rect? parentItemRect,
    AppKitMenuEdge menuEdge = AppKitMenuEdge.auto,
  })  : _spawnAlignment = spawnAlignmen ?? AlignmentDirectional.topEnd,
        _parentItemRect = parentItemRect,
        _isSubmenu = true,
        _menuEdge = menuEdge;

  List<AppKitContextMenuEntry<T>> get entries => menu.entries;

  Offset get position => menu.position ?? Offset.zero;

  Size? get size => menu.size;

  double get maxWidth => menu.maxWidth;

  double get minWidth => menu.minWidth;

  double? get maxHeight => menu.maxHeight;

  AppKitContextMenuEntry<T>? get focusedEntry => _focusedEntry;

  AppKitContextMenuEntry<T>? get futureSelectedEntry => _futureSelectedEntry;

  AppKitContextMenuItem<T>? get selectedItem => _selectedItem;

  int get selectionTicks => _selectionTicks;

  bool get isSelectionAnimating => _futureSelectedEntry != null;

  bool get isPositionVerified => _isPositionVerified;

  bool get isVerified => isPositionVerified;

  bool get isSubmenuOpen => overlayController.isShowing;

  AlignmentGeometry get spawnAlignment => _spawnAlignment;

  Rect? get parentItemRect => _parentItemRect;

  bool get hasSubmenu => _isSubmenu;

  static AppKitContextMenuState of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<AppKitContextMenuProvider>()!
            as AppKitContextMenuProvider?;

    if (provider == null) {
      throw 'No ContextMenuProvider found in context';
    }
    return provider.notifier!;
  }

  void setFocusedEntry(AppKitContextMenuEntry<T>? value) {
    if (value == _focusedEntry || _futureSelectedEntry != null) return;
    _focusedEntry = value;
    _futureSelectedEntry = null;
    _selectionTimer?.cancel();
    notifyListeners();
  }

  void _handleItemSelection(
      BuildContext? context, AppKitContextMenuEntry<T>? item) {
    if (null == item || null == context) return;
    if (item is! AppKitContextMenuItem<T>) return;
    if (item.hasSubmenu) return;
    item.handleItemSelection(context);
  }

  void animateSelectedItem(
      AppKitContextMenuItem<T>? value, VoidCallback? action) {
    if (_futureSelectedEntry != null) return;

    _selectionTimer?.cancel();

    _futureSelectedEntry = value;
    _selectionTicks = 0;

    _selectionTimer = Timer.periodic(_kAnimationDuration, (timer) {
      _selectionTicks++;
      if (_selectionTicks > _kAnimationCount) {
        _selectionTimer?.cancel();
        _selectionTimer = null;
        action?.call();
        return;
      }
      notifyListeners();
    });
  }

  void setSelectedItem(AppKitContextMenuItem<T>? value) {
    if (value == _selectedItem ||
        (_futureSelectedEntry != null && _futureSelectedEntry != value)) {
      return;
    }
    _selectedItem = value;
    _futureSelectedEntry = null;
    _selectionTimer?.cancel();
    notifyListeners();
  }

  void setSpawnAlignment(AlignmentGeometry value) {
    _spawnAlignment = value;
    notifyListeners();
  }

  /// Determines whether the entry is focused.
  bool isFocused(AppKitContextMenuEntry<T> entry) => entry == focusedEntry;

  /// Determines whether the entry is opened as a submenu.
  bool isOpened(AppKitContextMenuItem<T> item) => item == selectedItem;

  Offset _calculateSubmenuPosition(
    Rect parentRect,
    AlignmentGeometry? spawnAlignmen,
  ) {
    double left = parentRect.left + parentRect.width;
    double top = parentRect.top;
    return Offset(left, top);
  }

  /// Shows the submenu at the specified position.
  void showSubmenu({
    required BuildContext context,
    required AppKitContextMenuItem<T> parent,
  }) {
    closeSubmenu();

    final items = parent.items;
    final submenuParentRect = context.getWidgetBounds();
    if (submenuParentRect == null) return;

    final submenuPosition =
        _calculateSubmenuPosition(submenuParentRect, spawnAlignment);

    submenuBuilder = (BuildContext context) {
      final subMenuState = AppKitContextMenuState.submenu(
        menu: menu.copyWith(
          entries: items,
          position: submenuPosition,
          size: Size.infinite,
        ),
        spawnAlignmen: spawnAlignment,
        parentItemRect: submenuParentRect,
        selfClose: closeSubmenu,
        parentItem: parent,
        enableWallpaperTinting: enableWallpaperTinting,
      );

      return AppKitContextMenuWidget(menuState: subMenuState);
    };

    overlayController.show();
    setSelectedItem(parent);
  }

  /// Verifies the position of the context menu and updates it if necessary.
  void verifyPosition(BuildContext context) {
    if (isPositionVerified) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final boundaries = calculateContextMenuBoundaries(
          context: context,
          menu: menu,
          parentRect: parentItemRect,
          spawnAlignment: _spawnAlignment,
          isSubmenu: _isSubmenu,
          menuEdge: _menuEdge,
          maxHeight: maxHeight);

      menu.position = boundaries.pos;
      menu.size = boundaries.size;
      _spawnAlignment = boundaries.alignment;

      notifyListeners();
      _isPositionVerified = true;
      if (isVerified) focusScopeNode.requestFocus();
    });
  }

  /// Closes the current submenu and removes the overlay.
  void closeSubmenu() {
    if (!isSubmenuOpen) return;
    _selectedItem = null;
    overlayController.hide();
    notifyListeners();
  }

  /// Closes the context menu and removes the overlay.
  void close() {
    try {
      focusScopeNode.dispose();
    } catch (e) {
      debugPrint('[$this] error: $e');
    }
    closeSubmenu();
  }

  @override
  void dispose() {
    close();
    super.dispose();
  }

  void setItemLayout(AppKitContextMenuItem<T> item, Rect bounds) {
    if (_itemLayouts[item] == bounds) return;
    _itemLayouts[item] = bounds;
    notifyListeners();
  }
}
