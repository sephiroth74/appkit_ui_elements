import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:example/widgets/theme_toolbar_item.dart';
import 'package:flutter/cupertino.dart';
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
                          size: 14,
                        ),
                        SizedBox(width: 6),
                        Text('Cut'),
                      ])),
                  const AppKitContextMenuItem(
                      value: 'copy',
                      child: Row(children: [
                        AppKitIcon(Icons.copy, size: 14),
                        SizedBox(width: 6),
                        Text('Copy'),
                      ])),
                  const AppKitContextMenuItem(
                    value: 'paste',
                    child: Row(
                      children: [
                        AppKitIcon(Icons.paste, size: 14),
                        SizedBox(width: 6),
                        Text('Paste'),
                      ],
                    ),
                  ),
                  const AppKitContextMenuDivider(),
                  const AppKitContextMenuItem(
                      child: Text('Select All'), value: 'select_all'),
                ],
                maxHeight: 300,
                minWidth: 200,
              ),
              child: SizedBox.expand(
                child: const Center(
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
