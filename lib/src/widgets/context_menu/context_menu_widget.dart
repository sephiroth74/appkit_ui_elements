import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/material.dart';

class AppKitContextMenuWidget extends StatelessWidget {
  final AppKitContextMenuState menuState;
  const AppKitContextMenuWidget({
    super.key,
    required this.menuState,
  });

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
      duration: const Duration(milliseconds: 150),
      builder: (context, value, child) {
        return AppKitOverlayFilterWidget(
          backgroundBlur: 80,
          borderRadius: BorderRadius.circular(6),
          color: AppKitColors.materials.medium.withOpacity(1.0),
          child: Opacity(
            opacity: value,
            child: Container(
              padding: const EdgeInsets.all(5),
              constraints: BoxConstraints(
                  maxWidth: state.maxWidth, minWidth: state.minWidth),
              child: IntrinsicWidth(
                child: Column(
                  children: [
                    for (final item in state.entries)
                      MenuEntryWidget(
                          entry: item, focused: menuState.focusedEntry == item),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
