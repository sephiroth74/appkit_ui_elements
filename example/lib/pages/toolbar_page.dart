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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Toolbar'),
            const SizedBox(
              height: 2.0,
            ),
            Text('Subtitle',
                style: theme.typography.caption1.copyWith(
                    color: AppKitColors.text.opaque.secondary
                        .resolveFrom(context))),
          ],
        ),
        titleWidth: 200,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppKitIconTheme.toolbar(
            context,
            icon: CupertinoIcons.sidebar_left,
            onPressed: () {
              AppKitWindowScope.of(context).toggleSidebar();
            },
          ),
        ),
        actions: [
          AppKitToolBarIconButton(
            label: 'Toggle Sidebar',
            icon: CupertinoIcons.sidebar_left,
            onPressed: () => AppKitWindowScope.of(context).toggleSidebar(),
            showLabel: false,
          ),
          AppKitToolBarIconButton(
            tooltipMessage: 'Add new item',
            label: 'Add',
            icon: CupertinoIcons.add,
            showLabel: false,
            onPressed: () {
              debugPrint('onPressed: Add');
            },
          ),
          AppKitToolBarPullDownButton(
            label: 'Actions',
            icon: CupertinoIcons.ellipsis_circle,
            tooltipMessage: 'Perform tasks with the selected items',
            items: [
              const AppKitContextMenuItem(title: 'New Folder'),
              const AppKitContextMenuItem(title: 'Open'),
              const AppKitContextMenuItem(title: 'Open with...'),
              const AppKitContextMenuItem(title: 'Import from iPhone...'),
              const AppKitContextMenuDivider(),
              const AppKitContextMenuItem(title: 'Remove'),
              const AppKitContextMenuItem(title: 'Move to Bin'),
              const AppKitContextMenuDivider(),
              const AppKitContextMenuItem(title: 'Tags...'),
            ],
            onItemSelected: (item) {
              debugPrint('onItemSelected: ${item?.title}');
            },
          ),
          const AppKitToolBarDivider(),
          AppKitToolBarIconButton(
            label: 'Print',
            icon: CupertinoIcons.printer,
            showLabel: true,
            onPressed: () {
              debugPrint('onPressed: Print');
            },
          ),
          const AppKitToolBarSpacer(),
        ],
      ),
      children: [
        AppKitContentArea(builder: (context, scrollController) {
          return Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppKitIconButton(
                  icon: CupertinoIcons.add,
                  onPressed: () {
                    debugPrint('onPressed: Add');
                  },
                ),
                const SizedBox(
                  width: 8.0,
                ),
                AppKitIconButton(
                  icon: CupertinoIcons.back,
                  onPressed: () {
                    debugPrint('onPressed: Back');
                  },
                ),
              ],
            ),
          );
        })
      ],
    );
  }
}
