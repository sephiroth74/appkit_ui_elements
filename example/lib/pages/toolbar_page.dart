import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:example/widgets/theme_toolbar_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    final isDark = theme.brightness == Brightness.dark;
    return AppKitScaffold(
      toolBar: AppKitToolBar(
        isDark: !isDark,
        decoration: BoxDecoration(
            color: isDark
                ? AppKitColors.systemMint.darkColor
                : AppKitColors.systemIndigo.color),
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
                style: TextStyle(fontSize: theme.typography.caption1.fontSize)),
          ],
        ),
        titleWidth: 200,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppKitIconButton.toolbar(context,
                brightness: isDark ? Brightness.light : Brightness.dark,
                icon: CupertinoIcons.chevron_back,
                onPressed: () {}),
            AppKitIconButton.toolbar(context,
                brightness: isDark ? Brightness.light : Brightness.dark,
                icon: CupertinoIcons.chevron_forward,
                onPressed: () {}),
          ],
        ),
        actions: [
          AppKitToolBarIconButton(
            label: 'Toggle Sidebar',
            icon: CupertinoIcons.sidebar_left,
            onPressed: () => AppKitWindowScope.of(context).toggleSidebar(),
            showLabel: false,
          ),
          AppKitToolBarPullDownButton(
            label: 'Actions',
            icon: CupertinoIcons.ellipsis_circle,
            tooltipMessage: 'Perform tasks with the selected items',
            items: [
              AppKitContextMenuItem.plain('New Folder',
                  onTap: () => debugPrint('onPressed: New Folder')),
              AppKitContextMenuItem.plain('Open',
                  onTap: () => debugPrint('onPressed: Open')),
              AppKitContextMenuItem.plain(
                'Open with...',
                onTap: () =>
                    debugPrint('[toolbar_page] Selected: Open with...'),
              ),
              AppKitContextMenuItem.plain('Import from iPhone...',
                  onTap: () => debugPrint('onPressed: Import from iPhone...')),
              const AppKitContextMenuDivider(),
              AppKitContextMenuItem.plain('Remove',
                  onTap: () => debugPrint('onPressed: Remove')),
              AppKitContextMenuItem.plain('Move to Bin',
                  onTap: () => debugPrint('onPressed: Move to Bin')),
              const AppKitContextMenuDivider(),
              AppKitContextMenuItem.plain('Tags...',
                  onTap: () => debugPrint('onPressed: Tags...')),
            ],
          ),
          const AppKitToolBarDivider(color: Colors.white24),
          AppKitToolBarIconButton(
            label: 'Airplane',
            icon: CupertinoIcons.airplane,
            showLabel: true,
            onPressed: () {
              debugPrint('onPressed: Airplane');
            },
          ),
          AppKitToolBarIconButton(
            label: 'Share',
            icon: CupertinoIcons.share,
            showLabel: true,
            onPressed: () {
              debugPrint('onPressed: Share');
            },
          ),
          ThemeSwitcherToolbarItem.build(context),
          const AppKitToolBarDivider(),
          AppKitToolBarIconButton(
            label: 'Right Sidebar',
            icon: CupertinoIcons.sidebar_right,
            tooltipMessage: 'Toggle right sidebar',
            showLabel: false,
            onPressed: () {
              AppKitWindowScope.of(context).toggleEndSidebar();
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
