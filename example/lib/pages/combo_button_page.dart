import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:example/widgets/widget_title.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class ComboButtonPage extends StatefulWidget {
  const ComboButtonPage({super.key});

  @override
  State<ComboButtonPage> createState() => _ComboButtonPageState();
}

class _ComboButtonPageState extends State<ComboButtonPage> {
  final _comboButtonContextMenu = AppKitContextMenu<String>(
    minWidth: 150.0,
    entries: [
      const AppKitContextMenuItem(title: 'Item 1'),
      const AppKitContextMenuItem(title: 'Item 2'),
      const AppKitContextMenuItem(title: 'Item 3'),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      toolBar: const ToolBar(
        title: Text('Combo Button'),
        titleWidth: 200,
      ),
      children: [
        ContentArea(
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              child: Builder(
                builder: (context) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const WidgetTitle(label: 'Combo Button'),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppKitComboButton<String>(
                              style: AppKitComboButtonStyle.split,
                              onPressed: () {},
                              controlSize: AppKitControlSize.large,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.access_alarm,
                                      size: 14,
                                      color: AppKitColors.controlAccentColor
                                          .withOpacity(0.85),
                                    ),
                                    const SizedBox(width: 6.0),
                                    const Text('Button'),
                                  ],
                                ),
                              ),
                              onItemSelected: (value) {},
                              menuBuilder: (context) => _comboButtonContextMenu,
                            ),
                            const SizedBox(width: 16.0),
                            AppKitComboButton<String>(
                              style: AppKitComboButtonStyle.split,
                              onPressed: () {},
                              controlSize: AppKitControlSize.large,
                              child: const Text('Button'),
                              onItemSelected: (value) {},
                              menuBuilder: (context) => _comboButtonContextMenu,
                            ),
                            const SizedBox(width: 16.0),
                            AppKitComboButton<String>(
                              onPressed: () {},
                              controlSize: AppKitControlSize.regular,
                              child: const Text('Label'),
                              menuBuilder: (context) => _comboButtonContextMenu,
                            ),
                            const SizedBox(width: 16.0),
                            AppKitComboButton<String>(
                              onPressed: () {},
                              controlSize: AppKitControlSize.small,
                              child: const Text('Label'),
                              menuBuilder: (context) => _comboButtonContextMenu,
                            ),
                            const SizedBox(width: 16.0),
                            AppKitComboButton<String>(
                              onPressed: () {},
                              controlSize: AppKitControlSize.mini,
                              child: const Text('Label'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppKitComboButton<String>(
                              style: AppKitComboButtonStyle.unified,
                              onPressed: () {},
                              controlSize: AppKitControlSize.large,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.access_alarm,
                                      size: 15,
                                      color: AppKitColors.controlAccentColor
                                          .withOpacity(0.85),
                                    ),
                                    const SizedBox(width: 6.0),
                                    const Text('Combo Button'),
                                  ],
                                ),
                              ),
                              onItemSelected: (value) {},
                              menuBuilder: (context) => _comboButtonContextMenu,
                            ),
                            const SizedBox(width: 16.0),
                            AppKitComboButton<String>(
                              style: AppKitComboButtonStyle.unified,
                              onPressed: () {},
                              controlSize: AppKitControlSize.regular,
                              child: const Text('Label'),
                              menuBuilder: (context) => _comboButtonContextMenu,
                            ),
                            const SizedBox(width: 16.0),
                            AppKitComboButton<String>(
                              style: AppKitComboButtonStyle.unified,
                              onPressed: () {},
                              controlSize: AppKitControlSize.small,
                              child: const Text('Label'),
                              menuBuilder: (context) => _comboButtonContextMenu,
                            ),
                            const SizedBox(width: 16.0),
                            AppKitComboButton<String>(
                              style: AppKitComboButtonStyle.unified,
                              onPressed: () {},
                              controlSize: AppKitControlSize.mini,
                              menuBuilder: (context) => _comboButtonContextMenu,
                              child: const Text('Label'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        )
      ],
    );
  }
}
