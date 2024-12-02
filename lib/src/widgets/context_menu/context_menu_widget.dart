import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/material.dart';

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

        return AppKitOverlayFilterWidget(
          backgroundBlur: theme.backgroundBlur,
          borderRadius: BorderRadius.circular(theme.borderRadius),
          color: theme.backgroundColor ??
              AppKitColors.materials.medium
                  .resolveFrom(context)
                  .withOpacity(0.9),
          child: Opacity(
            opacity: value,
            child: Container(
              padding: const EdgeInsets.all(5),
              constraints: BoxConstraints(
                  maxWidth: state.maxWidth,
                  minWidth: state.minWidth,
                  maxHeight: state.size?.height.abs() ?? double.infinity),
              child: ScrollConfiguration(
                behavior:
                    ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  clipBehavior: Clip.antiAlias,
                  primary: true,
                  child: IntrinsicWidth(
                    child: Column(
                      children: [
                        for (final item in state.entries)
                          MenuEntryWidget(
                              enabled: menuState.isVerified,
                              entry: item,
                              focused: menuState.focusedEntry == item),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
