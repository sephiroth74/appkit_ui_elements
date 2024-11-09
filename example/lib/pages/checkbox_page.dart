import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:example/widgets/widget_title.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class CheckboxPage extends StatefulWidget {
  const CheckboxPage({super.key});

  @override
  State<CheckboxPage> createState() => _CheckboxPageState();
}

class _CheckboxPageState extends State<CheckboxPage> {
  bool? value1 = true;

  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      toolBar: const ToolBar(
        title: Text('Checkboxes'),
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
                  debugPrint('value1: $value1');
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const WidgetTitle(label: 'Checkboxes'),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          AppKitCheckbox(
                            value: value1,
                            onChanged: (value) {
                              setState(() {
                                final oldValue = value1;
                                if (value1 == false && value == true) {
                                  value1 = null;
                                } else {
                                  value1 = value;
                                }
                                debugPrint('onChanged: $oldValue ==> $value1');
                              });
                            },
                          ),
                          const SizedBox(width: 16.0),
                          AppKitCheckbox(
                            value: value1,
                          ),
                        ],
                      ),
                      const SizedBox(width: 16.0, height: 16.0),
                      const Divider(
                        thickness: 0.5,
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
