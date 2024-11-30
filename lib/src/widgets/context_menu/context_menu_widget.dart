import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/material.dart';

const _kBorderRadius = BorderRadius.all(Radius.circular(6.0));

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
                child: Visibility(
                  visible: state.isPositionVerified,
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
        return AppKitOverlayFilterWidget(
          backgroundBlur: 2,
          borderRadius: _kBorderRadius,
          color: AppKitColors.materials.medium.withOpacity(0.9),
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
                          enabled: menuState.isVerified,
                          entry: item,
                          focused: menuState.focusedEntry == item),
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
