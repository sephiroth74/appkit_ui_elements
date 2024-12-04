import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:appkit_ui_elements/appkit_ui_elements_method_channel.dart';
import 'package:example/widgets/widget_title.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class PushButtonPage extends StatefulWidget {
  const PushButtonPage({super.key});

  @override
  State<PushButtonPage> createState() => _PushButtonPageState();
}

class _PushButtonPageState extends State<PushButtonPage> {
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
        title: Text('Push Button'),
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
                                    const Text('Combo Button'),
                                  ],
                                ),
                              ),
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
                        const Divider(thickness: 0.5),
                        const WidgetTitle(label: 'Push Button'),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppKitTooltip.plain(
                              message:
                                  'This is a tooltip with a somewhat long message.',
                              child: AppKitPushButton(
                                onPressed: () {},
                                controlSize: AppKitControlSize.large,
                                color: MacosColors.systemYellowColor
                                    .resolveFrom(context),
                                type: AppKitPushButtonType.primary,
                                child: const Text('Label'),
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            AppKitTooltip.rich(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 12.0),
                              softWrap: false,
                              useMousePosition: false,
                              message: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Rich Tooltip: \n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppKitColors.systemGray
                                          .resolveFrom(context),
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  const TextSpan(text: 'This is a '),
                                  TextSpan(
                                    text: 'tooltip',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        backgroundColor:
                                            Colors.yellow.withOpacity(0.5)),
                                  ),
                                  const TextSpan(
                                      text:
                                          ' with a somewhat long message.\n\n'),
                                  const TextSpan(
                                    text:
                                        'Tooltip can also contains rich text.',
                                    style: TextStyle(
                                        decoration: TextDecoration.underline),
                                  ),
                                ],
                              ),
                              child: AppKitPushButton(
                                onPressed: () {},
                                controlSize: AppKitControlSize.large,
                                type: AppKitPushButtonType.primary,
                                child: const Text('Label'),
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            AppKitPushButton(
                              onPressed: () {},
                              controlSize: AppKitControlSize.regular,
                              type: AppKitPushButtonType.primary,
                              child: const Text('Label'),
                            ),
                            const SizedBox(width: 16.0),
                            AppKitPushButton(
                              onPressed: () {},
                              controlSize: AppKitControlSize.small,
                              type: AppKitPushButtonType.primary,
                              child: const Text('Label'),
                            ),
                            const SizedBox(width: 16.0),
                            AppKitPushButton(
                              onPressed: () {},
                              controlSize: AppKitControlSize.mini,
                              type: AppKitPushButtonType.primary,
                              child: const Text('Label'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppKitPushButton(
                              onPressed: () {},
                              type: AppKitPushButtonType.secondary,
                              controlSize: AppKitControlSize.large,
                              color: MacosColors.systemYellowColor
                                  .resolveFrom(context),
                              child: const Text('Label'),
                            ),
                            const SizedBox(width: 16.0),
                            AppKitPushButton(
                              onPressed: () {},
                              type: AppKitPushButtonType.secondary,
                              controlSize: AppKitControlSize.large,
                              child: const Text('Label'),
                            ),
                            const SizedBox(width: 16.0),
                            AppKitPushButton(
                              onPressed: () {},
                              type: AppKitPushButtonType.secondary,
                              controlSize: AppKitControlSize.regular,
                              child: const Text('Label'),
                            ),
                            const SizedBox(width: 16.0),
                            AppKitPushButton(
                              onPressed: () {},
                              type: AppKitPushButtonType.secondary,
                              controlSize: AppKitControlSize.small,
                              child: const Text('Label'),
                            ),
                            const SizedBox(width: 16.0),
                            AppKitPushButton(
                              onPressed: () {},
                              type: AppKitPushButtonType.secondary,
                              controlSize: AppKitControlSize.mini,
                              child: const Text('Label'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppKitPushButton(
                              onPressed: () {},
                              type: AppKitPushButtonType.destructive,
                              controlSize: AppKitControlSize.large,
                              child: const Text('Label'),
                            ),
                            const SizedBox(width: 16.0),
                            AppKitPushButton(
                              onPressed: () {},
                              type: AppKitPushButtonType.destructive,
                              controlSize: AppKitControlSize.regular,
                              child: const Text('Label'),
                            ),
                            const SizedBox(width: 16.0),
                            AppKitPushButton(
                              onPressed: () {},
                              type: AppKitPushButtonType.destructive,
                              controlSize: AppKitControlSize.small,
                              child: const Text('Label'),
                            ),
                            const SizedBox(width: 16.0),
                            AppKitPushButton(
                              onPressed: () {},
                              type: AppKitPushButtonType.destructive,
                              controlSize: AppKitControlSize.mini,
                              child: const Text('Label'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8.0),
                        const Divider(
                          thickness: 0.5,
                        ),
                        const SizedBox(height: 8.0),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppKitPushButton(
                              onPressed: null,
                              type: AppKitPushButtonType.primary,
                              controlSize: AppKitControlSize.large,
                              child: Text('Label'),
                            ),
                            SizedBox(width: 16.0),
                            AppKitPushButton(
                              onPressed: null,
                              type: AppKitPushButtonType.primary,
                              controlSize: AppKitControlSize.regular,
                              child: Text('Label'),
                            ),
                            SizedBox(width: 16.0),
                            AppKitPushButton(
                              onPressed: null,
                              type: AppKitPushButtonType.primary,
                              controlSize: AppKitControlSize.small,
                              child: Text('Label'),
                            ),
                            SizedBox(width: 16.0),
                            AppKitPushButton(
                              onPressed: null,
                              type: AppKitPushButtonType.primary,
                              controlSize: AppKitControlSize.mini,
                              child: Text('Label'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppKitPushButton(
                              onPressed: null,
                              type: AppKitPushButtonType.secondary,
                              controlSize: AppKitControlSize.large,
                              child: Text('Label'),
                            ),
                            SizedBox(width: 16.0),
                            AppKitPushButton(
                              onPressed: null,
                              type: AppKitPushButtonType.secondary,
                              controlSize: AppKitControlSize.regular,
                              child: Text('Label'),
                            ),
                            SizedBox(width: 16.0),
                            AppKitPushButton(
                              onPressed: null,
                              type: AppKitPushButtonType.secondary,
                              controlSize: AppKitControlSize.small,
                              child: Text('Label'),
                            ),
                            SizedBox(width: 16.0),
                            AppKitPushButton(
                              onPressed: null,
                              type: AppKitPushButtonType.secondary,
                              controlSize: AppKitControlSize.mini,
                              child: Text('Label'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppKitPushButton(
                              onPressed: null,
                              type: AppKitPushButtonType.destructive,
                              controlSize: AppKitControlSize.large,
                              child: Text('Label'),
                            ),
                            SizedBox(width: 16.0),
                            AppKitPushButton(
                              onPressed: null,
                              type: AppKitPushButtonType.destructive,
                              controlSize: AppKitControlSize.regular,
                              child: Text('Label'),
                            ),
                            SizedBox(width: 16.0),
                            AppKitPushButton(
                              onPressed: null,
                              type: AppKitPushButtonType.destructive,
                              controlSize: AppKitControlSize.small,
                              child: Text('Label'),
                            ),
                            SizedBox(width: 16.0),
                            AppKitPushButton(
                              onPressed: null,
                              type: AppKitPushButtonType.destructive,
                              controlSize: AppKitControlSize.mini,
                              child: Text('Label'),
                            ),
                          ],
                        ),
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
