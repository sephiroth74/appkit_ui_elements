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
  double popupButtonWidth = 125.0;

  FocusNode? focusNode;

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
                  title: i == 6 ? 'Very long item with value $i' : 'Item $i',
                  enabled: i != 4,
                  value: '$i',
                  image: i == 0 ? CupertinoIcons.alarm : null,
                  itemState: popupSelectedItem?.value == '$i' ? AppKitItemState.on : AppKitItemState.off,
                ),
          ],
        );
      };

  void _onPopupItemSelected(AppKitContextMenuItem<String>? value) {
    setState(() {
      if (value != null) {
        popupSelectedItem = popupMenuBuilder(context).findItemByValue(value.value);
      }
    });
  }

  @override
  void initState() {
    // popupSelectedItem = popupMenuBuilder(context).entries.elementAt(1)
    // as AppKitContextMenuItem<String>?;
    super.initState();
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
                      Column(
                        children: [AppKitControlSize.regular]
                            .map((controlSize) => [
                                  Row(
                                    children: AppKitPopupButtonStyle.values
                                        .map((style) => [
                                              AppKitPopupButton(
                                                hint: 'Select an item',
                                                controlSize: controlSize,
                                                width: popupButtonWidth,
                                                selectedItem: popupSelectedItem,
                                                onItemSelected: switchValue1 ? _onPopupItemSelected : null,
                                                menuBuilder: popupMenuBuilder,
                                                style: style,
                                              ),
                                              const SizedBox(width: 8.0)
                                            ])
                                        .expand((element) => element)
                                        .toList(),
                                  ),
                                  const SizedBox(height: 16.0)
                                ])
                            .expand((element) => element)
                            .toList(),
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
                                  if (checkboxValue1 == false) {
                                    popupSelectedItem = null;
                                  }
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
                                    groupValue: radioButtonValue2 && radioButtonValue3
                                        ? true
                                        : !radioButtonValue2 && !radioButtonValue3
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
                                    groupValue: !radioButtonValue2 && !radioButtonValue3,
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
                          SizedBox(width: 100, child: Text('Value: $stepperValue')),
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
