import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:example/widgets/widget_title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class SelectorsPage extends StatefulWidget {
  const SelectorsPage({super.key});

  @override
  State<SelectorsPage> createState() => _SelectorsPageState();
}

class _SelectorsPageState extends State<SelectorsPage> {
  double slider1Value = .65;
  AppKitSegmentedController multipleController1 =
      AppKitSegmentedController.multiple(length: 8, initialSelection: {0, 1});

  AppKitSegmentedController multipleController2 =
      AppKitSegmentedController.multiple(length: 5, initialSelection: {3, 4});

  AppKitSegmentedController singleController1 =
      AppKitSegmentedController.single(length: 5, initialSelection: 0);

  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      toolBar: const ToolBar(
        title: Text('Selectors'),
        titleWidth: 200,
      ),
      children: [
        ContentArea(
          builder: (context, ScrollController scrollController) {
            return Container(
              color: const Color(0xFFf0efef),
              child: SingleChildScrollView(
                clipBehavior: Clip.none,
                controller: scrollController,
                padding: const EdgeInsets.all(20),
                child: Builder(
                  builder: (context) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const WidgetTitle(label: 'Date Time Picker'),
                        const SizedBox(height: 20.0),
                        Column(
                          children: [
                            SizedBox(
                              width: 190,
                              child: AppKitDatePicker(
                                dateElements: AppKitDateElements.monthDayYear,
                                timeElements: AppKitTimeElements.hourMinute,
                                semanticLabel: 'Date Picker',
                                type: AppKitDatePickerType.textualWithStepper,
                                onChanged: () {
                                  debugPrint('[1] Date Changed');
                                },
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            AppKitDatePicker(
                              dateElements: AppKitDateElements.monthDayYear,
                              timeElements: AppKitTimeElements.none,
                              semanticLabel: 'Date Picker (graphical)',
                              date: DateTime.now(),
                              // minimumDate: DateTime(2024, 11, 10),
                              // maximumDate: DateTime(2025, 1, 6),
                              type: AppKitDatePickerType.graphical,
                              drawBackground: true,
                              drawBorder: true,
                              selectionType:
                                  AppKitDatePickerSelectionType.range,
                              onChanged: () {
                                debugPrint('[2] Date Changed');
                              },
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
