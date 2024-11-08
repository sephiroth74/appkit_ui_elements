import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class ToggleButtonPage extends StatefulWidget {
  const ToggleButtonPage({super.key});

  @override
  State<ToggleButtonPage> createState() => _ToggleButtonPageState();
}

class _ToggleButtonPageState extends State<ToggleButtonPage> {
  AppKitToggleButtonController button1Controller =
      AppKitToggleButtonController();
  AppKitToggleButtonController button2Controller =
      AppKitToggleButtonController();
  AppKitToggleButtonController button3Controller =
      AppKitToggleButtonController();
  AppKitToggleButtonController button4Controller =
      AppKitToggleButtonController();

  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      toolBar: const ToolBar(
        title: Text('Toggle Button'),
        titleWidth: 200,
      ),
      children: [
        ContentArea(
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
                              controller: button1Controller,
                              onChanged: (value) {
                                setState(() {});
                              },
                              controlSize: AppKitControlSize.large,
                              type: AppKitToggleButtonType.primary,
                              childOff: const Text('Label (off)'),
                              childOn: const Text('Label (on)'),
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
                              controller: button2Controller,
                              onChanged: (value) {
                                setState(() {});
                              },
                              controlSize: AppKitControlSize.large,
                              type: AppKitToggleButtonType.secondary,
                              childOff: const Text('Label (off)'),
                              childOn: const Text('Label (on)'),
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
                              controller: button3Controller,
                              onChanged: (value) => setState(() {}),
                              controlSize: AppKitControlSize.large,
                              type: AppKitToggleButtonType.primary,
                              color: MacosColors.applePurple,
                              childOff: const Text('Label (off)'),
                              childOn: const Text('Label (on)'),
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
                              controller: button4Controller,
                              onChanged: (value) => setState(() {}),
                              controlSize: AppKitControlSize.large,
                              type: AppKitToggleButtonType.secondary,
                              color: MacosColors.applePurple,
                              childOff: const Text('Label (off)'),
                              childOn: const Text('Label (on)'),
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
                                  button1Controller.isOn = true;
                                  button2Controller.isOn = true;
                                  button3Controller.isOn = true;
                                  button4Controller.isOn = true;
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
                                  button1Controller.isOn = false;
                                  button2Controller.isOn = false;
                                  button3Controller.isOn = false;
                                  button4Controller.isOn = false;
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
