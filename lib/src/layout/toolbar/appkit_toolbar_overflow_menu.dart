import 'package:appkit_ui_elements/appkit_ui_elements.dart';

const BorderRadius _kBorderRadius = BorderRadius.all(Radius.circular(5.0));

class AppKitToolbarOverflowMenu extends StatelessWidget {
  const AppKitToolbarOverflowMenu({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = AppKitContextMenuTheme.of(context);
    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      child: IntrinsicWidth(
        child: AppKitOverlayFilterWidget(
          backgroundBlur: theme.backgroundBlur,
          color: theme.backgroundColor,
          borderRadius: _kBorderRadius,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ),
      ),
    );
  }
}
