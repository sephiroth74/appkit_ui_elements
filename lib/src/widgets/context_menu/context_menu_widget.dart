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
        final isDark = AppKitTheme.of(context).brightness == Brightness.dark;

        return AppKitOverlayFilterWidget(
          enableWallpaperTinting: menuState.enableWallpaperTinting,
          backgroundBlur: theme.backgroundBlur,
          borderRadius: BorderRadius.circular(theme.borderRadius),
          color: theme.backgroundColor ??
              AppKitDynamicColor.resolve(
                  context, AppKitColors.materials.medium),
          child: Opacity(
            opacity: value,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: isDark ? Colors.white54 : Colors.white,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(theme.borderRadius),
              ),
              padding: const EdgeInsets.all(4),
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
                          AppKitMenuEntryWidget(
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
