import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:example/theme.dart';
import 'package:example/widgets/theme_toolbar_item.dart';
import 'package:example/widgets/widget_title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ControlsPage extends StatefulWidget {
  const ControlsPage({super.key});

  @override
  State<ControlsPage> createState() => _ControlsPageState();
}

Widget titleWithIconMenuItem(String label, IconData icon) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      AppKitIcon(icon, size: 12),
      const SizedBox(width: 8.0),
      Flexible(child: Text(label, overflow: TextOverflow.ellipsis)),
    ],
  );
}

class _ControlsPageState extends State<ControlsPage> {
  bool? checkboxValue1 = true;
  bool radioButtonValue2 = true;
  bool radioButtonValue3 = false;
  bool disclosureValue = false;
  double sliderValue1 = 0.5;
  bool switchValue1 = true;
  double popupButtonWidth = 125.0;

  AppKitContextMenuItem<String>? popupSelectedItem;

  ContextMenuBuilder<String> get popupMenuBuilder => (context) {
        return AppKitContextMenu<String>(
          maxWidth: 200,
          entries: [
            for (var i = 0; i < 7; i++)
              if (i % 5 == 0 && i > 0)
                const AppKitContextMenuDivider()
              else
                AppKitContextMenuItem(
                  child: i == 0
                      ? const Row(
                          children: [
                            AppKitIcon(CupertinoIcons.alarm),
                            SizedBox(width: 8.0),
                            Text('Alarm'),
                          ],
                        )
                      : Text(
                          i == 6 ? 'Very long item with value $i' : 'Item $i'),
                  enabled: i != 4,
                  value: '$i',
                  itemState: popupSelectedItem?.value == '$i'
                      ? AppKitItemState.on
                      : AppKitItemState.off,
                ),
          ],
        );
      };

  ContextMenuBuilder<int> get pullDownMenuBuilder => (context) {
        return AppKitContextMenu<int>(
          maxWidth: 200,
          entries: [
            AppKitContextMenuItem(
                child: titleWithIconMenuItem('Cut', Icons.cut),
                value: 0,
                enabled: true),
            AppKitContextMenuItem(
                child: titleWithIconMenuItem('Copy', Icons.copy),
                value: 1,
                enabled: true),
            AppKitContextMenuItem(
                child: titleWithIconMenuItem('Paste', Icons.paste),
                value: 2,
                enabled: true),
            const AppKitContextMenuDivider(),
            const AppKitContextMenuItem(
                child: Text('Select All'), value: 3, enabled: true),
            const AppKitContextMenuItem(
                child: Text('Select None'), value: 3, enabled: true),
            const AppKitContextMenuDivider(),
            AppKitContextMenuItem(
                child: const Text('Other...'),
                value: 6,
                enabled: true,
                items: [
                  const AppKitContextMenuItem(
                      child: Text('Submenu Item 1'), value: 7, enabled: true),
                  const AppKitContextMenuItem(
                      child: Text('Submenu Item 2'), value: 8, enabled: true),
                  const AppKitContextMenuDivider(),
                  AppKitContextMenuItem.plain('Submenu Item 3',
                      value: 9, enabled: false),
                ]),
          ],
        );
      };

  @override
  void initState() {
    // popupSelectedItem = popupMenuBuilder(context).entries.elementAt(1)
    // as AppKitContextMenuItem<String>?;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppKitScaffold(
      toolBar: AppKitToolBar(
        title: const Text('Controls'),
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
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const WidgetTitle(label: 'Switches'),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          AppKitTooltip.plain(
                            message: 'This is a tooltip',
                            child: AppKitSwitch(
                                size: AppKitControlSize.large,
                                checked: switchValue1,
                                onChanged: (value) {
                                  setState(() => switchValue1 = value);
                                }),
                          ),
                          const SizedBox(width: 16.0),
                          AppKitSwitch(
                              size: AppKitControlSize.regular,
                              checked: switchValue1,
                              onChanged: (value) {
                                setState(() => switchValue1 = value);
                              }),
                          const SizedBox(width: 16.0),
                          AppKitSwitch(
                              size: AppKitControlSize.small,
                              checked: switchValue1,
                              color: AppKitColors.systemOrange,
                              onChanged: (value) {
                                setState(() => switchValue1 = value);
                              }),
                          const SizedBox(width: 16.0),
                          AppKitSwitch(
                            size: AppKitControlSize.mini,
                            checked: switchValue1,
                          ),
                        ],
                      ),
                      const SizedBox(width: 16.0, height: 16.0),
                      const Divider(
                        thickness: 0.5,
                      ),
                      const WidgetTitle(label: 'Checkboxes'),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          AppKitCheckbox(
                            value: checkboxValue1,
                            onChanged: (value) {
                              setState(() {
                                if (checkboxValue1 == false && value == true) {
                                  checkboxValue1 = null;
                                } else {
                                  checkboxValue1 = value;
                                  if (checkboxValue1 == false) {
                                    popupSelectedItem = null;
                                  }
                                }
                              });
                            },
                          ),
                          const SizedBox(width: 16.0),
                          AppKitCheckbox(
                            color: AppKitColors.systemOrange,
                            value: checkboxValue1,
                            onChanged: (value) {
                              setState(() {
                                if (checkboxValue1 == false && value == true) {
                                  checkboxValue1 = null;
                                } else {
                                  checkboxValue1 = value;
                                }
                              });
                            },
                          ),
                          const SizedBox(width: 16.0),
                          AppKitCheckbox(
                            value: checkboxValue1,
                          ),
                        ],
                      ),
                      const SizedBox(width: 16.0, height: 16.0),
                      const Divider(
                        thickness: 0.5,
                      ),
                      const WidgetTitle(label: 'RadioButton'),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  AppKitRadioButton<ThemeMode>(
                                    groupValue: context.watch<AppTheme>().mode,
                                    value: ThemeMode.system,
                                    onChanged: (value) {
                                      context.read<AppTheme>().mode = value;
                                    },
                                  ),
                                  const SizedBox(width: 8.0),
                                  const Text('System Theme'),
                                ],
                              ),
                              const SizedBox(height: 6.0),
                              Row(
                                children: [
                                  AppKitRadioButton<ThemeMode>(
                                    groupValue: context.watch<AppTheme>().mode,
                                    value: ThemeMode.light,
                                    onChanged: (value) {
                                      context.read<AppTheme>().mode = value;
                                    },
                                  ),
                                  const SizedBox(width: 8.0),
                                  const Text('Light Theme'),
                                ],
                              ),
                              const SizedBox(height: 6.0),
                              Row(
                                children: [
                                  AppKitRadioButton<ThemeMode>(
                                    groupValue: context.watch<AppTheme>().mode,
                                    value: ThemeMode.dark,
                                    onChanged: (value) {
                                      context.read<AppTheme>().mode = value;
                                    },
                                  ),
                                  const SizedBox(width: 8.0),
                                  const Text('Dark Theme'),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(width: 16.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  AppKitRadioButton<bool>(
                                    groupValue:
                                        radioButtonValue2 && radioButtonValue3
                                            ? true
                                            : !radioButtonValue2 &&
                                                    !radioButtonValue3
                                                ? false
                                                : null,
                                    value: true,
                                    onChanged: (value) {
                                      setState(() {
                                        radioButtonValue2 = value;
                                        radioButtonValue3 = value;
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 8.0),
                                  const Text('Select All'),
                                ],
                              ),
                              const SizedBox(height: 6.0),
                              Row(
                                children: [
                                  AppKitRadioButton<bool>(
                                    groupValue: !radioButtonValue2 &&
                                        !radioButtonValue3,
                                    value: true,
                                    onChanged: (value) {
                                      setState(() {
                                        radioButtonValue2 = false;
                                        radioButtonValue3 = false;
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 8.0),
                                  const Text('Select None'),
                                ],
                              ),
                              const SizedBox(height: 6.0),
                              Row(
                                children: [
                                  AppKitRadioButton<bool>(
                                    color: AppKitColors.systemOrange,
                                    groupValue: radioButtonValue2,
                                    value: true,
                                    onChanged: (value) {
                                      setState(() {
                                        radioButtonValue2 = value;
                                        radioButtonValue3 = false;
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 8.0),
                                  const Text('First'),
                                ],
                              ),
                              const SizedBox(height: 6.0),
                              Row(
                                children: [
                                  AppKitRadioButton<bool>(
                                    groupValue: radioButtonValue3,
                                    value: true,
                                    onChanged: (value) {
                                      setState(() {
                                        radioButtonValue3 = value;
                                        radioButtonValue2 = false;
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 8.0),
                                  const Text('Second'),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(width: 16.0),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  AppKitRadioButton<bool>(
                                    groupValue: true,
                                    value: true,
                                  ),
                                  SizedBox(width: 8.0),
                                  Text('Checked'),
                                ],
                              ),
                              SizedBox(height: 6.0),
                              Row(
                                children: [
                                  AppKitRadioButton<bool>(
                                    groupValue: true,
                                    value: false,
                                  ),
                                  SizedBox(width: 8.0),
                                  Text('Unchecked'),
                                ],
                              ),
                              SizedBox(height: 6.0),
                              Row(
                                children: [
                                  AppKitRadioButton<bool>(
                                    groupValue: null,
                                    value: true,
                                  ),
                                  SizedBox(width: 8.0),
                                  Text('Indeterminate'),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(width: 16.0, height: 16.0),
                      const Divider(
                        thickness: 0.5,
                      ),
                      const WidgetTitle(label: 'HelpButton'),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          AppKitHelpButton(
                            onPressed: () {},
                          ),
                          const SizedBox(width: 16.0),
                          const AppKitHelpButton(),
                        ],
                      ),
                      const SizedBox(width: 16.0, height: 16.0),
                      const Divider(
                        thickness: 0.5,
                      ),
                      const WidgetTitle(label: 'ArrowButton'),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          AppKitArrowButton(
                            onPressed: () {},
                          ),
                          const SizedBox(width: 16.0),
                          const AppKitArrowButton(),
                        ],
                      ),
                      const SizedBox(width: 16.0, height: 16.0),
                      const Divider(thickness: 0.5),
                      const WidgetTitle(label: 'DisclosureButton'),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          AppKitDisclosureButton(
                            isDown: disclosureValue,
                            onPressed: () {
                              setState(() {
                                disclosureValue = !disclosureValue;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(width: 16.0, height: 16.0),
                      const Divider(thickness: 0.5),
                      const WidgetTitle(label: 'IconButton'),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          AppKitIconButton(
                            icon: Icons.add,
                            onPressed: () {},
                          ),
                          const SizedBox(width: 16.0),
                          AppKitIconButton(
                            icon: Icons.remove,
                            onPressed: () {},
                          ),
                          const SizedBox(width: 16.0),
                          const AppKitIconButton(
                            icon: Icons.remove,
                          ),
                          const SizedBox(width: 16.0),
                          AppKitIconButton(
                            icon: Icons.add,
                            onPressed: () {},
                            color: AppKitColors.systemOrange,
                          ),
                          const SizedBox(width: 16.0),
                          AppKitIconButton(
                            icon: Icons.remove,
                            onPressed: () {},
                            color: AppKitColors.systemOrange,
                          ),
                          const SizedBox(width: 16.0),
                          const AppKitIconButton(
                            icon: Icons.remove,
                            color: AppKitColors.systemOrange,
                          ),
                        ],
                      ),
                      const SizedBox(width: 16.0, height: 16.0),
                      Row(
                        children: [
                          AppKitIconButton(
                            type: AppKitIconButtonType.flat,
                            icon: Icons.copy,
                            onPressed: () {},
                          ),
                          const SizedBox(width: 16.0),
                          AppKitIconButton(
                            type: AppKitIconButtonType.flat,
                            icon: Icons.paste,
                            onPressed: () {},
                          ),
                          const SizedBox(width: 16.0),
                          const AppKitIconButton(
                            type: AppKitIconButtonType.flat,
                            icon: Icons.paste,
                          ),
                          const SizedBox(width: 16.0),
                          AppKitIconButton(
                            type: AppKitIconButtonType.flat,
                            icon: Icons.copy,
                            onPressed: () {},
                            color: AppKitColors.systemOrange,
                          ),
                          const SizedBox(width: 16.0),
                          AppKitIconButton(
                            type: AppKitIconButtonType.flat,
                            icon: Icons.paste,
                            onPressed: () {},
                            color: AppKitColors.systemOrange,
                          ),
                          const SizedBox(width: 16.0),
                          const AppKitIconButton(
                            type: AppKitIconButtonType.flat,
                            icon: Icons.paste,
                            color: AppKitColors.systemOrange,
                          ),
                        ],
                      ),
                    ],
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
