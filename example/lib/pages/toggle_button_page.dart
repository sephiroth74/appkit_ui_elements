import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:example/widgets/widget_title.dart';
import 'package:flutter/material.dart';

class ToggleButtonPage extends StatefulWidget {
  const ToggleButtonPage({super.key});

  @override
  State<ToggleButtonPage> createState() => _ToggleButtonPageState();
}

class _ToggleButtonPageState extends State<ToggleButtonPage> {
  bool button1Value = false;
  bool button2Value = false;
  bool button3Value = false;
  bool button4Value = false;

  @override
  Widget build(BuildContext context) {
    return AppKitScaffold(
      toolBar: const AppKitToolBar(
        title: Text('Toggle Button'),
        titleWidth: 200,
      ),
      children: [
        AppKitContentArea(
          builder: (context, ScrollController scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              child: Builder(
                builder: (context) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const WidgetTitle(label: 'Toggle Button'),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const SizedBox(
                                width: 200,
                                child: Text('Primary',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis)),
                            const SizedBox(width: 16.0),
                            AppKitToggleButton(
                              key: const Key('button1'),
                              isOn: button1Value,
                              onChanged: (value) {
                                setState(() {
                                  button1Value = value;
                                });
                              },
                              controlSize: AppKitControlSize.regular,
                              type: AppKitToggleButtonType.primary,
                              childOff: const Text('Label'),
                              childOn: const Text('Label'),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16.0, height: 16.0),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const SizedBox(
                                width: 200,
                                child: Text('Secondary',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis)),
                            const SizedBox(width: 16.0),
                            AppKitToggleButton(
                              key: const Key('button2'),
                              isOn: button2Value,
                              onChanged: (value) {
                                setState(() {
                                  button2Value = value;
                                });
                              },
                              controlSize: AppKitControlSize.regular,
                              type: AppKitToggleButtonType.secondary,
                              childOff: const Text('Label'),
                              childOn: const Text('Label'),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16.0, height: 16.0),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const SizedBox(
                                width: 200,
                                child: Text('Primary (color)',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis)),
                            const SizedBox(width: 16.0),
                            AppKitToggleButton(
                              key: const Key('button3'),
                              isOn: button3Value,
                              onChanged: (value) => setState(() {
                                button3Value = value;
                              }),
                              controlSize: AppKitControlSize.regular,
                              type: AppKitToggleButtonType.primary,
                              color: AppKitColors.applePurple,
                              childOff: const Text('Label'),
                              childOn: const Text('Label'),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16.0, height: 16.0),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const SizedBox(
                                width: 200,
                                child: Text('Secondary (color)',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis)),
                            const SizedBox(width: 16.0),
                            AppKitToggleButton(
                              key: const Key('button4'),
                              isOn: button4Value,
                              onChanged: (value) => setState(() {
                                button4Value = value;
                              }),
                              controlSize: AppKitControlSize.regular,
                              type: AppKitToggleButtonType.secondary,
                              color: AppKitColors.applePurple,
                              childOff: const Text('Label'),
                              childOn: const Text('Label'),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16.0, height: 16.0),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const SizedBox(
                                width: 200,
                                child: Text('Secondary (color)',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis)),
                            const SizedBox(width: 16.0),
                            AppKitToggleButton(
                              key: const Key('button4'),
                              isOn: button4Value,
                              onChanged: null,
                              controlSize: AppKitControlSize.regular,
                              type: AppKitToggleButtonType.primary,
                              childOff: const Text('Label'),
                              childOn: const Text('Label'),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16.0, height: 16.0),
                        const Divider(
                          thickness: 0.5,
                        ),
                        const SizedBox(width: 16.0, height: 16.0),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            AppKitPushButton(
                              type: AppKitPushButtonType.secondary,
                              controlSize: AppKitControlSize.large,
                              onPressed: () {
                                setState(() {
                                  button1Value = true;
                                  button2Value = true;
                                  button3Value = true;
                                  button4Value = true;
                                });
                              },
                              child: const Text('Set All On'),
                            ),
                            const SizedBox(width: 16.0),
                            AppKitPushButton(
                              type: AppKitPushButtonType.secondary,
                              controlSize: AppKitControlSize.large,
                              onPressed: () {
                                setState(() {
                                  button1Value = false;
                                  button2Value = false;
                                  button3Value = false;
                                  button4Value = false;
                                });
                              },
                              child: const Text('Set All Off'),
                            ),
                          ],
                        )
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
