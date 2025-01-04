import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:example/widgets/theme_toolbar_item.dart';
import 'package:example/widgets/widget_title.dart';
import 'package:flutter/cupertino.dart';
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
      toolBar: AppKitToolBar(
        title: const Text('Toggle Buttons'),
        titleWidth: 200,
        actions: [
          ThemeSwitcherToolbarItem.build(context),
        ],
      ),
      children: [
        AppKitContentArea(
          builder: (context, ScrollController scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              child: Builder(
                builder: (context) {
                  final isDark =
                      AppKitTheme.of(context).brightness == Brightness.dark;
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
                              size: AppKitControlSize.large,
                              type: AppKitButtonType.primary,
                              childOff: Icon(
                                CupertinoIcons.volume_off,
                                size: 16,
                                color: AppKitDynamicColor.resolve(
                                    context, AppKitColors.text.opaque.primary),
                              ),
                              childOn: Icon(CupertinoIcons.volume_mute,
                                  size: 16,
                                  color: AppKitDynamicColor.resolve(
                                      context,
                                      isDark
                                          ? AppKitColors.text.opaque.tertiary
                                          : AppKitColors
                                              .text.opaque.secondary)),
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
                              size: AppKitControlSize.large,
                              type: AppKitButtonType.secondary,
                              childOff: const Text(
                                'Off',
                                style: TextStyle(
                                    fontWeight: AppKitFontWeight.w590),
                              ),
                              childOn: const Text(
                                'On',
                                style: TextStyle(
                                    fontWeight: AppKitFontWeight.w590),
                              ),
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
                            AppKitButton(
                              type: AppKitButtonType.secondary,
                              size: AppKitControlSize.large,
                              onTap: () {
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
                            AppKitButton(
                              type: AppKitButtonType.secondary,
                              size: AppKitControlSize.large,
                              onTap: () {
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
