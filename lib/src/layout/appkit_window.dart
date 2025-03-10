import 'dart:math' as math;

import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:macos_window_utils/widgets/transparent_macos_sidebar.dart';

class AppKitWindow extends StatefulWidget {
  const AppKitWindow({
    super.key,
    this.child,
    this.titleBar,
    this.sidebar,
    this.backgroundColor,
    this.endSidebar,
    this.disableWallpaperTinting = false,
    this.sidebarState = NSVisualEffectViewState.followsWindowActiveState,
  });

  final Color? backgroundColor;
  final Widget? child;
  final AppKitTitleBar? titleBar;
  final AppKitSidebar? sidebar;
  final AppKitSidebar? endSidebar;

  /// Whether wallpaper tinting should be disabled.
  ///
  /// By default, `macos_ui` applies wallpaper tinting to the application's
  /// window to match macOS' native appearance:
  ///
  /// <img src="https://user-images.githubusercontent.com/86920182/220182724-d78319d7-5c41-4e8c-b785-a73a6ea24927.jpg" width=640/>
  ///
  /// However, this effect is realized by inserting `NSVisualEffectView`s behind
  /// Flutter's canvas and turning the background of areas that are meant to be
  /// affected by wallpaper tinting transparent. Since Flutter's
  /// [`ImageFilter.blur`](https://api.flutter.dev/flutter/dart-ui/ImageFilter/ImageFilter.blur.html)
  /// does not support transparency, wallpaper tinting is disabled automatically
  /// when a [AppKitOverlayFilter] is present in the widget tree.
  ///
  /// This is meant to be a temporary solution until
  /// [#16296](https://github.com/flutter/flutter/issues/16296) is resolved in
  /// the Flutter project.
  ///
  /// Since the disabling of wallpaper tinting may be found to be too noticeable,
  /// this property may be used to disable wallpaper tinting outright.
  final bool disableWallpaperTinting;

  final NSVisualEffectViewState sidebarState;

  @override
  State<AppKitWindow> createState() => _AppKitWindowState();
}

class _AppKitWindowState extends State<AppKitWindow> {
  var _sidebarScrollController = ScrollController();
  var _endSidebarScrollController = ScrollController();
  double _sidebarWidth = 0.0;
  double _sidebarDragStartWidth = 0.0;
  double _sidebarDragStartPosition = 0.0;
  double _endSidebarWidth = 0.0;
  double _endSidebarDragStartWidth = 0.0;
  double _endSidebarDragStartPosition = 0.0;
  bool _showSidebar = true;
  late bool _showEndSidebar = widget.endSidebar?.shownByDefault ?? false;
  int _sidebarSlideDuration = 0;
  SystemMouseCursor _sidebarCursor = SystemMouseCursors.resizeColumn;
  SystemMouseCursor _endSidebarCursor = SystemMouseCursors.resizeLeft;

  @override
  void initState() {
    super.initState();
    _sidebarWidth = (widget.sidebar?.startWidth ?? widget.sidebar?.minWidth) ??
        _sidebarWidth;
    _endSidebarWidth =
        (widget.endSidebar?.startWidth ?? widget.endSidebar?.minWidth) ??
            _endSidebarWidth;

    widget.disableWallpaperTinting
        ? AppKitGlobalWallpaperTintingSettings.disableWallpaperTinting()
        : AppKitGlobalWallpaperTintingSettings.allowWallpaperTinting();

    _addSidebarScrollControllerListenerIfNeeded();
    _addEndSidebarScrollControllerListenerIfNeeded();
  }

  @override
  void didUpdateWidget(covariant AppKitWindow old) {
    super.didUpdateWidget(old);
    final sidebar = widget.sidebar;
    if (sidebar == null) {
      _sidebarWidth = 0.0;
    } else if (sidebar.minWidth != old.sidebar!.minWidth ||
        sidebar.maxWidth != old.sidebar!.maxWidth) {
      if (sidebar.minWidth > _sidebarWidth) {
        _sidebarWidth = sidebar.minWidth;
      }
      if (sidebar.maxWidth! < _sidebarWidth) {
        _sidebarWidth = sidebar.maxWidth!;
      }
    }
    if (sidebar?.key != old.sidebar?.key) {
      _sidebarScrollController.dispose();
      _sidebarScrollController = ScrollController();
      _addSidebarScrollControllerListenerIfNeeded();
    }
    final endSidebar = widget.endSidebar;
    if (endSidebar == null) {
      _endSidebarWidth = 0.0;
    } else if (endSidebar.minWidth != old.endSidebar!.minWidth ||
        endSidebar.maxWidth != old.endSidebar!.maxWidth) {
      if (endSidebar.minWidth > _endSidebarWidth) {
        _endSidebarWidth = endSidebar.minWidth;
      }
      if (endSidebar.maxWidth! < _endSidebarWidth) {
        _endSidebarWidth = endSidebar.maxWidth!;
      }
    }
    if (endSidebar?.key != old.endSidebar?.key) {
      _endSidebarScrollController.dispose();
      _endSidebarScrollController = ScrollController();
      _addEndSidebarScrollControllerListenerIfNeeded();
    }
  }

  void _addSidebarScrollControllerListenerIfNeeded() {
    if (widget.sidebar?.builder != null) {
      _sidebarScrollController.addListener(() => setState(() {}));
    }
  }

  void _addEndSidebarScrollControllerListenerIfNeeded() {
    if (widget.endSidebar?.builder != null) {
      _endSidebarScrollController.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _sidebarScrollController.dispose();
    _endSidebarScrollController.dispose();

    super.dispose();
  }

  @override
  // ignore: code-metrics
  Widget build(BuildContext context) {
    assert(debugCheckHasAppKitTheme(context));
    final sidebar = widget.sidebar;
    final endSidebar = widget.endSidebar;
    if (sidebar?.startWidth != null) {
      assert((sidebar!.startWidth! >= sidebar.minWidth) &&
          (sidebar.startWidth! <= sidebar.maxWidth!));
    }
    if (endSidebar?.startWidth != null) {
      assert((endSidebar!.startWidth! >= endSidebar.minWidth) &&
          (endSidebar.startWidth! <= endSidebar.maxWidth!));
    }
    final theme = AppKitTheme.of(context);
    late Color backgroundColor = widget.backgroundColor ?? theme.canvasColor;
    late Color sidebarBackgroundColor;
    late Color endSidebarBackgroundColor;
    Color dividerColor = theme.dividerColor;

    // Respect the sidebar color override from parent if one is given
    if (sidebar?.decoration?.color != null) {
      sidebarBackgroundColor = sidebar!.decoration!.color!;
    } else {
      sidebarBackgroundColor = Colors.transparent;
    }

    // Set the application window's brightness on macOS
    AppKitBrightnessOverrideHandler.ensureMatchingBrightness(theme.brightness);

    // Respect the end sidebar color override from parent if one is given
    if (endSidebar?.decoration?.color != null) {
      endSidebarBackgroundColor = endSidebar!.decoration!.color!;
    } else {
      endSidebarBackgroundColor = theme.canvasColor;
    }

    const curve = Curves.linearToEaseOut;
    final duration = Duration(milliseconds: _sidebarSlideDuration);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final isAtBreakpoint = width <= (sidebar?.windowBreakpoint ?? 0);
        final isAtEndBreakpoint = width <= (endSidebar?.windowBreakpoint ?? 0);
        final canShowSidebar =
            _showSidebar && !isAtBreakpoint && sidebar != null;
        final canShowEndSidebar =
            _showEndSidebar && !isAtEndBreakpoint && endSidebar != null;
        final visibleSidebarWidth = canShowSidebar ? _sidebarWidth : 0.0;
        final visibleEndSidebarWidth =
            canShowEndSidebar ? _endSidebarWidth : 0.0;
        final sidebarState = widget.sidebarState;

        final layout = Stack(
          children: [
            // Background color
            AnimatedPositioned(
              curve: curve,
              duration: duration,
              height: height,
              left: visibleSidebarWidth,
              width: width,
              child: ColoredBox(color: backgroundColor),
            ),

            // Sidebar
            if (sidebar != null)
              AnimatedPositioned(
                key: sidebar.key,
                curve: curve,
                duration: duration,
                height: height,
                width: _sidebarWidth,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  color: sidebarBackgroundColor,
                  constraints: BoxConstraints(
                    minWidth: sidebar.minWidth,
                    maxWidth: sidebar.maxWidth!,
                    minHeight: height,
                    maxHeight: height,
                  ).normalize(),
                  child: TransparentMacOSSidebar(
                    state: sidebarState,
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(0, 0, 0, 1.0),
                        backgroundBlendMode: BlendMode.clear,
                      ),
                      child: Column(
                        children: [
                          if (sidebar.topOffset > 0) ...[
                            SizedBox(height: sidebar.topOffset),
                          ] else if (sidebar.top != null) ...[
                            const SizedBox(height: 12),
                          ] else
                            const SizedBox.shrink(),
                          if (_sidebarScrollController.hasClients &&
                              _sidebarScrollController.offset > 0.0)
                            Divider(
                                thickness: 1, height: 1, color: dividerColor),
                          if (sidebar.top != null && constraints.maxHeight > 81)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: sidebar.top!,
                            ),
                          Expanded(
                            child: AppKitScrollbar(
                              controller: _sidebarScrollController,
                              child: Padding(
                                padding: sidebar.padding,
                                child: sidebar.builder(
                                  context,
                                  _sidebarScrollController,
                                ),
                              ),
                            ),
                          ),
                          if (sidebar.bottom != null &&
                              constraints.maxHeight > 141)
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: sidebar.bottom!,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            // Content Area
            AnimatedPositioned(
              curve: curve,
              duration: duration,
              left: visibleSidebarWidth,
              width: width - visibleSidebarWidth - visibleEndSidebarWidth,
              height: height,
              child: ClipRect(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: widget.titleBar != null ? widget.titleBar!.height : 0,
                  ),
                  child: widget.child ?? const SizedBox.shrink(),
                ),
              ),
            ),

            // Title bar Area
            Positioned(
              left: visibleSidebarWidth,
              width: width - visibleSidebarWidth,
              height: widget.titleBar?.height,
              child: ClipRect(
                child: widget.titleBar ?? const SizedBox.shrink(),
              ),
            ),

            // Sidebar resizer
            if (sidebar?.isResizable ?? false)
              AnimatedPositioned(
                curve: curve,
                duration: duration,
                left: visibleSidebarWidth - 4,
                width: 7,
                height: height,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onHorizontalDragStart: (details) {
                    _sidebarDragStartWidth = _sidebarWidth;
                    _sidebarDragStartPosition = details.globalPosition.dx;
                  },
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      var newWidth = _sidebarDragStartWidth +
                          details.globalPosition.dx -
                          _sidebarDragStartPosition;

                      if (sidebar!.startWidth != null &&
                          sidebar.snapToStartBuffer != null &&
                          (newWidth - sidebar.startWidth!).abs() <=
                              sidebar.snapToStartBuffer!) {
                        newWidth = sidebar.startWidth!;
                      }

                      if (sidebar.dragClosed) {
                        final closeBelow =
                            sidebar.minWidth - sidebar.dragClosedBuffer;
                        _showSidebar = newWidth >= closeBelow;
                      }

                      _sidebarWidth = math.max(
                        sidebar.minWidth,
                        math.min(
                          sidebar.maxWidth!,
                          newWidth,
                        ),
                      );

                      if (_sidebarWidth == sidebar.minWidth) {
                        _sidebarCursor = SystemMouseCursors.resizeRight;
                      } else if (_sidebarWidth == sidebar.maxWidth) {
                        _sidebarCursor = SystemMouseCursors.resizeLeft;
                      } else {
                        _sidebarCursor = SystemMouseCursors.resizeColumn;
                      }
                    });
                  },
                  child: MouseRegion(
                    cursor: _sidebarCursor,
                    child: Align(
                      alignment: Alignment.center,
                      child: VerticalDivider(
                        thickness: 1,
                        width: 1,
                        color: dividerColor,
                      ),
                    ),
                  ),
                ),
              ),

            // End sidebar
            if (endSidebar != null)
              AnimatedPositioned(
                key: endSidebar.key,
                left: width - visibleEndSidebarWidth,
                curve: curve,
                duration: duration,
                height: height,
                width: _endSidebarWidth,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  color: endSidebarBackgroundColor,
                  constraints: BoxConstraints(
                    minWidth: endSidebar.minWidth,
                    maxWidth: endSidebar.maxWidth!,
                    minHeight: height,
                    maxHeight: height,
                  ).normalize(),
                  child: AppKitWallpaperTintedArea(
                    backgroundColor: endSidebarBackgroundColor,
                    insertRepaintBoundary: true,
                    child: Column(
                      children: [
                        if (endSidebar.topOffset > 0)
                          SizedBox(height: endSidebar.topOffset),
                        if (_endSidebarScrollController.hasClients &&
                            _endSidebarScrollController.offset > 0.0)
                          Divider(
                            thickness: 1,
                            height: 1,
                            color: dividerColor,
                          ),
                        if (endSidebar.top != null)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: endSidebar.top!,
                          ),
                        Expanded(
                          child: AppKitScrollbar(
                            controller: _endSidebarScrollController,
                            child: Padding(
                              padding: endSidebar.padding,
                              child: endSidebar.builder(
                                context,
                                _endSidebarScrollController,
                              ),
                            ),
                          ),
                        ),
                        if (endSidebar.bottom != null)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: endSidebar.bottom!,
                          ),
                      ],
                    ),
                  ),
                ),
              ),

            // End sidebar resizer
            if (endSidebar?.isResizable ?? false)
              AnimatedPositioned(
                curve: curve,
                duration: duration,
                right: visibleEndSidebarWidth - 4,
                width: 7,
                height: height,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onHorizontalDragStart: (details) {
                    _endSidebarDragStartWidth = _endSidebarWidth;
                    _endSidebarDragStartPosition = details.globalPosition.dx;
                  },
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      var newWidth = _endSidebarDragStartWidth -
                          details.globalPosition.dx +
                          _endSidebarDragStartPosition;

                      if (endSidebar!.startWidth != null &&
                          endSidebar.snapToStartBuffer != null &&
                          (newWidth + endSidebar.startWidth!).abs() <=
                              endSidebar.snapToStartBuffer!) {
                        newWidth = endSidebar.startWidth!;
                      }

                      if (endSidebar.dragClosed) {
                        final closeBelow =
                            endSidebar.minWidth - endSidebar.dragClosedBuffer;
                        _showEndSidebar = newWidth >= closeBelow;
                      }

                      _endSidebarWidth = math.max(
                        endSidebar.minWidth,
                        math.min(
                          endSidebar.maxWidth!,
                          newWidth,
                        ),
                      );

                      if (_endSidebarWidth == endSidebar.minWidth) {
                        _endSidebarCursor = SystemMouseCursors.resizeLeft;
                      } else if (_endSidebarWidth == endSidebar.maxWidth) {
                        _endSidebarCursor = SystemMouseCursors.resizeRight;
                      } else {
                        _endSidebarCursor = SystemMouseCursors.resizeColumn;
                      }
                    });
                  },
                  child: MouseRegion(
                    cursor: _endSidebarCursor,
                    child: Align(
                      alignment: Alignment.center,
                      child: VerticalDivider(
                        thickness: 1,
                        width: 1,
                        color: dividerColor,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );

        return AppKitWindowScope(
          constraints: constraints,
          isSidebarShown: canShowSidebar,
          isEndSidebarShown: canShowEndSidebar,
          sidebarToggler: () async {
            setState(() => _sidebarSlideDuration = 300);
            setState(() => _showSidebar = !_showSidebar);
            await Future.delayed(Duration(milliseconds: _sidebarSlideDuration));
            if (mounted) {
              setState(() => _sidebarSlideDuration = 0);
            }
          },
          endSidebarToggler: () async {
            setState(() => _sidebarSlideDuration = 300);
            setState(() => _showEndSidebar = !_showEndSidebar);
            await Future.delayed(Duration(milliseconds: _sidebarSlideDuration));
            if (mounted) {
              setState(() => _sidebarSlideDuration = 0);
            }
          },
          child: layout,
        );
      },
    );
  }
}

/// A [AppKitWindowScope] serves as a scope for its descendants to rely on
/// values needed for the layout of the descendants.
///
/// It is embedded in the [AppKitWindow] and available to the widgets just below
/// it in the widget tree. The [AppKitWindowScope] passes down the values which
/// are calculated inside [AppKitWindow] to its descendants.
///
/// Descendants of the [AppKitWindowScope] automatically work with the values
/// they need, so you will hardly need to manually use the [AppKitWindowScope].
class AppKitWindowScope extends InheritedWidget {
  /// Creates a widget that manages the layout of the [AppKitWindow].
  ///
  /// [ResizablePane] and [ContentArea] are other widgets that depend
  /// on the [AppKitWindowScope] for layout.
  ///
  /// The [constraints], [contentAreaWidth], [child], [valueNotifier]
  /// and [_scaffoldState] arguments are required and must not be null.
  const AppKitWindowScope({
    super.key,
    required this.constraints,
    required super.child,
    required this.isSidebarShown,
    required this.isEndSidebarShown,
    required VoidCallback sidebarToggler,
    required VoidCallback endSidebarToggler,
  })  : _sidebarToggler = sidebarToggler,
        _endSidebarToggler = endSidebarToggler;

  /// Provides the constraints from the [AppKitWindow] to its descendants.
  final BoxConstraints constraints;

  /// Provides a callback which will be used to privately toggle the sidebar.
  final Function _sidebarToggler;

  /// Provides a callback which will be used to privately toggle the sidebar.
  final Function _endSidebarToggler;

  /// Returns the [AppKitWindowScope] of the [AppKitWindow] that most tightly encloses
  /// the given [context].
  ///
  /// If the [context] does not have a [AppKitWindow] as its ancestor, an assertion
  /// is thrown.
  ///
  /// The [context] argument must not be null.
  static AppKitWindowScope of(BuildContext context) {
    final AppKitWindowScope? result =
        context.dependOnInheritedWidgetOfExactType<AppKitWindowScope>();
    assert(result != null, 'No MacosWindowScope found in context');
    return result!;
  }

  /// Returns a [AppKitWindowScope] of the [AppKitWindow] that most tightly
  /// encloses the given [context]. The result can be null.
  ///
  /// If this [context] does not have a [AppKitWindow] as its ancestor, the result
  /// returned is null.
  ///
  /// The [context] argument must not be null.
  static AppKitWindowScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppKitWindowScope>();
  }

  /// Provides the current visible state of the [Sidebar].
  final bool isSidebarShown;

  /// Provides the current visible state of the end [Sidebar].
  final bool isEndSidebarShown;

  /// Toggles the [Sidebar] of the [AppKitWindow].
  ///
  /// This does not change the current width of the [Sidebar]. It only
  /// hides or shows it.
  void toggleSidebar() {
    _sidebarToggler();
  }

  /// Toggles the [endSidebar] of the [AppKitWindow].
  ///
  /// This does not change the current width of the [endSidebar]. It only
  /// hides or shows it.
  void toggleEndSidebar() {
    _endSidebarToggler();
  }

  @override
  bool updateShouldNotify(AppKitWindowScope oldWidget) {
    return constraints != oldWidget.constraints ||
        isSidebarShown != oldWidget.isSidebarShown;
  }
}
