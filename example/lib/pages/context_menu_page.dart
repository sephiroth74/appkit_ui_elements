import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:example/widgets/theme_toolbar_item.dart';
import 'package:flutter/material.dart';

class ContextMenuPage extends StatefulWidget {
  const ContextMenuPage({super.key});

  @override
  State<ContextMenuPage> createState() => _ContextMenuPageState();
}

class _ContextMenuPageState extends State<ContextMenuPage> {
  @override
  Widget build(BuildContext context) {
    return AppKitScaffold(
      toolBar: AppKitToolBar(
        title: const Text('Context Menu'),
        titleWidth: 200,
        actions: [
          ThemeSwitcherToolbarItem.build(context),
        ],
      ),
      children: [
        AppKitContentArea(
          builder: (context, scrollController) {
            return AppKitContextMenuRegion(
              onItemSelected: (value) {
                debugPrint('Selected: $value');
              },
              menuBuilder: (context) => AppKitContextMenu<String>(
                entries: [
                  const AppKitContextMenuItem(
                      value: 'cut',
                      child: Row(children: [
                        AppKitIcon(
                          Icons.cut,
                          size: 12,
                        ),
                        SizedBox(width: 6),
                        Text('Cut'),
                      ])),
                  const AppKitContextMenuItem(
                      value: 'copy',
                      child: Row(children: [
                        AppKitIcon(Icons.copy, size: 12),
                        SizedBox(width: 6),
                        Text('Copy'),
                      ])),
                  const AppKitContextMenuItem(
                    value: 'paste',
                    child: Row(
                      children: [
                        AppKitIcon(Icons.paste, size: 12),
                        SizedBox(width: 6),
                        Text('Paste'),
                      ],
                    ),
                  ),
                  const AppKitContextMenuDivider(),
                  const AppKitContextMenuItem(
                      child: Text('Select All'), value: 'select_all'),
                  const AppKitContextMenuDivider(),
                  AppKitContextMenuItem.submenu('Sub menu long 1',
                      items: const [
                        AppKitContextMenuItem(
                            child: Text('Sub menu 1'),
                            value: 'sub_menu_1',
                            itemState: AppKitItemState.on),
                        AppKitContextMenuItem(
                            child: Text('Sub menu 2'), value: 'sub_menu_2'),
                        AppKitContextMenuItem(
                            child: Text('Sub menu 3'), value: 'sub_menu_3'),
                      ]),
                  AppKitContextMenuItem.submenu('Sub menu 2', items: const [
                    AppKitContextMenuItem(
                        child: Text('Sub menu 2.1'), value: 'sub_menu2_1'),
                    AppKitContextMenuItem(
                        child: Text('Sub menu 2.2'), value: 'sub_menu2_2'),
                    AppKitContextMenuItem(
                        child: Text('Sub menu 2.3'), value: 'sub_menu2_3'),
                  ]),
                ],
                maxHeight: 300,
                minWidth: 100,
              ),
              child: const SizedBox.expand(
                child: Center(
                    child: AppKitLabel(
                        text: Text(
                            'Rich click anywhere to open the context menu'))),
              ),
            );
          },
        )
      ],
    );
  }
}
