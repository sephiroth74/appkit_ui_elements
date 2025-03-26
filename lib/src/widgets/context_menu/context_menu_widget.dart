import 'dart:math';

import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AppKitContextMenuWidget extends StatelessWidget {
  final AppKitContextMenuState menuState;
  final Duration transitionDuration;
  const AppKitContextMenuWidget({
    super.key,
    required this.menuState,
    Duration? transitionDuration,
  }) : transitionDuration =
            transitionDuration ?? const Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    return AppKitContextMenuProvider(
      state: menuState,
      child: Builder(
        builder: (context) {
          final state = AppKitContextMenuState.of(context);
          state.verifyPosition(context);

          return Positioned(
            left: state.position.dx,
            top: state.position.dy,
            child: OverlayPortal(
              controller: state.overlayController,
              overlayChildBuilder: state.submenuBuilder,
              child: FocusScope(
                autofocus: true,
                node: state.focusScopeNode,
                child: Opacity(
                  opacity: state.isPositionVerified ? 1.0 : 0.0,
                  child: _buildMenuView(context, state),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Builds the context menu view.
  Widget _buildMenuView(BuildContext context, AppKitContextMenuState state) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: transitionDuration,
      builder: (context, value, child) {
        final theme = AppKitContextMenuTheme.of(context);
        final isDark = AppKitTheme.of(context).brightness == Brightness.dark;
        final backgroundColor = theme.backgroundColor ??
            AppKitDynamicColor.resolve(context, AppKitColors.materials.medium);
        final borderRadius = theme.borderRadius;

        return AppKitOverlayFilterWidget(
          enableWallpaperTinting: menuState.enableWallpaperTinting,
          backgroundBlur: 0.0,
          borderRadius: BorderRadius.circular(borderRadius),
          color: backgroundColor,
          child: Opacity(
            opacity: value,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(
                  color: isDark ? Colors.white54 : Colors.white,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: Container(
                constraints: BoxConstraints(
                    maxWidth: state.maxWidth,
                    minWidth: state.minWidth,
                    maxHeight: state.size?.height.abs() ?? double.infinity),
                child: _InnerMenu(
                    menuState: menuState,
                    backgroundColor: backgroundColor,
                    borderRadius: borderRadius),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _InnerMenu extends StatefulWidget {
  const _InnerMenu({
    required this.menuState,
    required this.backgroundColor,
    required this.borderRadius,
  });

  final AppKitContextMenuState menuState;
  final Color backgroundColor;
  final double borderRadius;

  @override
  State<_InnerMenu> createState() => _InnerMenuState();
}

const _kScrollThreshold = 10.0;
const _kScrollArrowSize = 10.0;

class _InnerMenuState extends State<_InnerMenu> {
  bool _arrowUpVisible = false;
  bool _arrowDownVisible = false;
  bool _isScrollVerified = false;

  double get paddingRight =>
      (widget.menuState.scrollbarsRequired ?? false) ? 12.0 : 4.0;

  EdgeInsetsGeometry get padding =>
      EdgeInsets.only(top: 4.0, left: 4.0, right: paddingRight, bottom: 4.0);

  @override
  void initState() {
    super.initState();
    widget.menuState.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.menuState.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _verifyScroll() {
    if (widget.menuState.isPositionVerified &&
        !_isScrollVerified &&
        (widget.menuState.scrollbarsRequired ?? false)) {
      _isScrollVerified = true;
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _onScroll();
      });
    }
  }

  void _onScroll() {
    setState(() {
      _updateScrollVariables();
    });
  }

  void _updateScrollVariables() {
    if (widget.menuState.isPositionVerified) {
      _arrowUpVisible = widget.menuState.scrollController.hasClients &&
          widget.menuState.scrollController.offset > _kScrollThreshold;
      _arrowDownVisible = widget.menuState.scrollController.hasClients &&
          widget.menuState.scrollController.offset <
              widget.menuState.scrollController.position.maxScrollExtent -
                  _kScrollThreshold;
    }
  }

  @override
  Widget build(BuildContext context) {
    _verifyScroll();

    final menuSize = widget.menuState.size;
    // debugPrint('menu size: $menuSize');

    final arrowsColor =
        AppKitDynamicColor.resolve(context, AppKitColors.labelColor);
    final arrowWidth = widget.menuState.size != null
        ? max(menuSize!.width.abs() - 2, 0.0)
        : 0.0;

    final child = SingleChildScrollView(
      clipBehavior: Clip.hardEdge,
      primary: true,
      child: Padding(
        padding: padding,
        child: IntrinsicWidth(
          child: Column(
            children: [
              for (final item in widget.menuState.entries)
                AppKitMenuEntryWidget(
                    enabled: widget.menuState.isVerified,
                    entry: item,
                    focused: widget.menuState.focusedEntry == item),
            ],
          ),
        ),
      ),
    );

    if (widget.menuState.scrollbarsRequired == false) {
      return child;
    }
    // debugPrint('scrollbars required: ${widget.menuState.scrollbarsRequired}');

    return Stack(
      fit: StackFit.passthrough,
      children: [
        ScrollConfiguration(
          behavior: ScrollConfiguration.of(context)
              .copyWith(scrollbars: widget.menuState.scrollbarsRequired),
          child: PrimaryScrollController(
            controller: widget.menuState.scrollController,
            child: child,
          ),
        ),
        if (_arrowUpVisible) ...[
          Positioned(
            top: 0.5,
            child: Padding(
              padding: const EdgeInsets.only(left: 1.0, right: 1.0),
              child: Container(
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(widget.borderRadius - 1),
                    ),
                  ),
                  width: arrowWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      AppKitIcon(CupertinoIcons.chevron_compact_up,
                          size: _kScrollArrowSize, color: arrowsColor),
                    ],
                  )),
            ),
          )
        ],
        if (_arrowDownVisible) ...[
          Positioned(
            bottom: 0.5,
            child: Padding(
              padding: const EdgeInsets.only(left: 1.0, right: 1.0),
              child: Container(
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(widget.borderRadius - 1),
                    ),
                  ),
                  width: arrowWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppKitIcon(CupertinoIcons.chevron_compact_down,
                          size: _kScrollArrowSize, color: arrowsColor),
                    ],
                  )),
            ),
          )
        ],
      ],
    );
  }
}
