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
              AppKitContextMenuItem(
                  title: 'New Folder',
                  onPressed: (value) => debugPrint('onPressed: $value')),
              AppKitContextMenuItem(
                  title: 'Open',
                  onPressed: (value) => debugPrint('onPressed: $value')),
              AppKitContextMenuItem(
                title: 'Open with...',
                onPressed: (value) =>
                    debugPrint('[toolbar_page] Selected: $value'),
              ),
              AppKitContextMenuItem(
                  title: 'Import from iPhone...',
                  onPressed: (value) => debugPrint('onPressed: $value')),
              const AppKitContextMenuDivider(),
              AppKitContextMenuItem(
                  title: 'Remove',
                  onPressed: (value) => debugPrint('onPressed: $value')),
              AppKitContextMenuItem(
                  title: 'Move to Bin',
                  onPressed: (value) => debugPrint('onPressed: $value')),
              const AppKitContextMenuDivider(),
              AppKitContextMenuItem(
                  title: 'Tags...',
                  onPressed: (value) => debugPrint('onPressed: $value')),
            ],
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
          AppKitToolBarIconButton(
            label: 'Airplane',
            icon: CupertinoIcons.airplane,
            showLabel: true,
            onPressed: () {
              debugPrint('onPressed: Airplane');
            },
          ),
          const AppKitToolBarDivider(),
          AppKitToolBarIconButton(
            label: 'Share',
            icon: CupertinoIcons.share,
            showLabel: true,
            onPressed: () {
              debugPrint('onPressed: Share');
            },
          ),
          AppKitToolBarPullDownButton(
            label: 'Other',
            icon: CupertinoIcons.ellipsis_vertical,
            tooltipMessage: 'Perform tasks with the selected items',
            items: [
              AppKitContextMenuItem(
                  title: 'Action 1', onPressed: (_) => debugPrint('Action 1')),
              AppKitContextMenuItem(
                  title: 'Action 2', onPressed: (_) => debugPrint('Action 2')),
              AppKitContextMenuItem(
                  title: 'Action 3', onPressed: (_) => debugPrint('Action 3')),
              const AppKitContextMenuDivider(),
              AppKitContextMenuItem(
                  title: 'Action 4', onPressed: (_) => debugPrint('Action 4')),
            ],
          ),
          const AppKitToolBarDivider(),
          AppKitToolBarIconButton(
            label: 'Right Sidebar',
            icon: CupertinoIcons.sidebar_right,
            tooltipMessage: 'Toggle right sidebar',
            showLabel: false,
            onPressed: () {
              debugPrint('onPressed: Right Sidebar');
            },
          ),
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
