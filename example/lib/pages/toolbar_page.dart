import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/cupertino.dart';

const groupMessage =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.';

class ToolbarPage extends StatefulWidget {
  const ToolbarPage({super.key});

  @override
  State<ToolbarPage> createState() => _ToolbarPageState();
}

class _ToolbarPageState extends State<ToolbarPage> {
  @override
  Widget build(BuildContext context) {
    final theme = AppKitTheme.of(context);
    return AppKitScaffold(
      toolBar: AppKitToolBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Toolbar'),
            Text('Subtitle', style: theme.typography.caption1),
          ],
        ),
        titleWidth: 200,
        actions: [
          AppKitToolBarIconButton(
            label: 'Add',
            icon: const AppKitIcon(icon: CupertinoIcons.add),
            showLabel: false,
            onPressed: () {
              debugPrint('onPressed: Add');
            },
          ),
        ],
      ),
      children: [
        AppKitContentArea(builder: (context, scrollController) {
          return Center(
            child: AppKitIconButton(
              icon: const AppKitIcon(icon: CupertinoIcons.add),
              onPressed: () {
                debugPrint('onPressed: Add');
              },
            ),
          );
        })
      ],
    );
  }
}
