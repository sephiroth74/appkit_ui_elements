import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:example/theme.dart';
import 'package:example/widgets/widget_title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';

class ControlsPage extends StatefulWidget {
  const ControlsPage({super.key});

  @override
  State<ControlsPage> createState() => _ControlsPageState();
}

class _ControlsPageState extends State<ControlsPage> {
  bool? checkboxValue1 = true;
  bool radioButtonValue2 = true;
  bool radioButtonValue3 = false;
  double stepperValue = 50;
  bool disclosureValue = false;
  double sliderValue1 = 0.5;
  bool switchValue1 = true;

  FocusNode? focusNode;

  @override
  void initState() {
    super.initState();

    // focusNode = FocusNode();
    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   debugPrint('requestFocus()');
    //   focusNode?.requestFocus();
    // });
  }

  @override
  void dispose() {
    focusNode?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      toolBar: const ToolBar(
        title: Text('Controls'),
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
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const WidgetTitle(label: 'Popup Button'),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          AppKitPopupButton(
                            value: '2',
                            onSelected: (value) {
                              debugPrint('onSelected($value)');
                            },
                            menuBuilder: (context) {
                              return AppKitContextMenu<String>(entries: [
                                AppKitContextMenuItem(
                                    title: 'Item 1',
                                    value: '1',
                                    itemState: MenuItemState.on,
                                    image: CupertinoIcons.calendar_badge_minus),
                                AppKitContextMenuItem(
                                    title: 'Item 2',
                                    value: '2',
                                    itemState: MenuItemState.off),
                                AppKitContextMenuItem(
                                    title: 'Item 3',
                                    value: '3',
                                    itemState: MenuItemState.mixed),
                                AppKitContextMenuItem(
                                    title: 'Item 4', value: '4'),
                                const AppKitContextMenuDivider(),
                                AppKitContextMenuItem<String>(
                                    enabled: true,
                                    title: 'Submenu',
                                    items: [
                                      AppKitContextMenuItem(
                                          title: 'Submenu Item 1', value: '5'),
                                      AppKitContextMenuItem(
                                          title: 'Submenu Item 2', value: '6'),
                                      const AppKitContextMenuDivider(),
                                      AppKitContextMenuItem(
                                          title: 'Submenu Item 3', value: '7'),
                                    ])
                              ]);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(width: 16.0, height: 16.0),
                      const Divider(
                        thickness: 0.5,
                      ),
                      const WidgetTitle(label: 'Switches'),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          AppKitTooltip.plain(
                            message: 'This is a tooltip',
                            child: AppKitSwitch(
                                checked: switchValue1,
                                onChanged: (value) {
                                  setState(() {
                                    debugPrint('onChanged($value)');
                                    switchValue1 = value;
                                  });
                                }),
                          ),
                          const SizedBox(width: 16.0),
                          AppKitSwitch(
                              checked: switchValue1,
                              color: MacosColors.systemOrangeColor,
                              onChanged: (value) {
                                setState(() {
                                  debugPrint('onChanged($value)');
                                  switchValue1 = value;
                                });
                              }),
                          const SizedBox(width: 16.0),
                          AppKitSwitch(
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
                                }
                              });
                            },
                          ),
                          const SizedBox(width: 16.0),
                          AppKitCheckbox(
                            color: MacosColors.systemOrangeColor,
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
                                    color: MacosColors.systemOrangeColor,
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
                          AppKitHelpButton(
                            color: MacosColors.appleBlue,
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
                          AppKitArrowButton(
                            color: MacosColors.systemOrangeColor,
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
                      const WidgetTitle(label: 'Stepper'),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          SizedBox(
                              width: 100, child: Text('Value: $stepperValue')),
                          const SizedBox(width: 16.0),
                          AppKitStepper(
                            value: stepperValue,
                            increment: 1,
                            onChanged: (value) {
                              debugPrint('onChanged($value)');
                              setState(() {
                                stepperValue = value;
                              });
                            },
                          ),
                          const SizedBox(width: 16.0),
                          AppKitStepper(
                            value: stepperValue,
                          ),
                        ],
                      )
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
