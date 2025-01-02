import 'dart:math';

import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:example/widgets/theme_toolbar_item.dart';
import 'package:example/widgets/widget_title.dart';

class SelectorsPage extends StatefulWidget {
  const SelectorsPage({super.key});

  @override
  State<SelectorsPage> createState() => _SelectorsPageState();
}

class _SelectorsPageState extends State<SelectorsPage> {
  DateTime _selectedDate = DateTime.now();

  DateTimeRange _selectedDateRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now().add(const Duration(days: 4)),
  );

  late final DateTime _minimumDate =
      _selectedDate.subtract(const Duration(days: 365));

  late final DateTime _maximumDate =
      _selectedDate.add(const Duration(days: 365));

  set selectedDate(DateTime value) {
    setState(() {
      _selectedDate = value;
      _selectedDateRange = _selectedDateRange.copyWith(start: value);
    });
  }

  set selectedDateRange(DateTimeRange value) {
    setState(() {
      _selectedDateRange = value;
      _selectedDate = value.start;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppKitScaffold(
      toolBar: AppKitToolBar(
        title: const Text('Selectors'),
        titleWidth: 200,
        actions: [
          ThemeSwitcherToolbarItem.build(context),
        ],
      ),
      children: [
        AppKitContentArea(
          builder: (context, ScrollController scrollController) {
            return SingleChildScrollView(
              clipBehavior: Clip.none,
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              child: Builder(
                builder: (context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const WidgetTitle(label: 'Date Time Picker'),
                      const SizedBox(height: 20.0),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const AppKitLabel(text: Text('Textual (start)')),
                              const SizedBox(height: 8.0),
                              SizedBox(
                                width: 190,
                                child: AppKitDatePicker(
                                  canRequestFocus: true,
                                  autofocus: false,
                                  date: left(_selectedDateRange.start),
                                  minimumDate: _minimumDate,
                                  maximumDate: _maximumDate,
                                  dateElements: AppKitDateElements.monthDayYear,
                                  timeElements:
                                      AppKitTimeElements.hourMinuteSecond,
                                  semanticLabel: 'Date Picker',
                                  type: AppKitDatePickerType.textual,
                                  onChanged:
                                      (Either<DateTime, DateTimeRange> d) {
                                    debugPrint('[1] Date Changed ($d)');
                                    final pickedDate = d.left;

                                    if (pickedDate
                                        .isAfter(_selectedDateRange.end)) {
                                      selectedDateRange =
                                          _selectedDateRange.copyWith(
                                        start: pickedDate,
                                        end: pickedDate
                                            .add(const Duration(days: 1)),
                                      );
                                    } else {
                                      selectedDateRange = _selectedDateRange
                                          .copyWith(start: pickedDate);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const AppKitLabel(
                                  text: Text('Textual with Stepper (end)')),
                              const SizedBox(height: 8.0),
                              SizedBox(
                                width: 190,
                                child: AppKitDatePicker(
                                  canRequestFocus: true,
                                  autofocus: true,
                                  date: left(_selectedDateRange.end),
                                  minimumDate: _minimumDate,
                                  maximumDate: _maximumDate,
                                  dateElements: AppKitDateElements.monthDayYear,
                                  timeElements:
                                      AppKitTimeElements.hourMinuteSecond,
                                  type: AppKitDatePickerType.textualWithStepper,
                                  onChanged:
                                      (Either<DateTime, DateTimeRange> d) {
                                    debugPrint('[2] Date Changed ($d)');
                                    final pickedDate = d.left;

                                    if (pickedDate
                                        .isBefore(_selectedDateRange.start)) {
                                      selectedDateRange =
                                          _selectedDateRange.copyWith(
                                        start: pickedDate,
                                        end: pickedDate
                                            .add(const Duration(days: 1)),
                                      );
                                    } else {
                                      selectedDateRange = _selectedDateRange
                                          .copyWith(end: pickedDate);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const AppKitLabel(
                                      text: Text('Graphical (start date)')),
                                  const SizedBox(height: 8.0),
                                  AppKitDatePicker(
                                    autofocus: true,
                                    dateElements:
                                        AppKitDateElements.monthDayYear,
                                    timeElements: AppKitTimeElements.none,
                                    semanticLabel:
                                        'Date Picker (single - graphical)',
                                    date: left(_selectedDateRange.start),
                                    type: AppKitDatePickerType.graphical,
                                    drawBackground: true,
                                    drawBorder: true,
                                    minimumDate: _minimumDate,
                                    maximumDate: _maximumDate,
                                    selectionType:
                                        AppKitDatePickerSelectionType.single,
                                    onChanged: (d) {
                                      debugPrint('[3] Date Changed ($d)');
                                      final pickedDate = d.left;

                                      if (pickedDate
                                          .isAfter(_selectedDateRange.end)) {
                                        selectedDateRange =
                                            _selectedDateRange.copyWith(
                                          start: pickedDate,
                                          end: pickedDate
                                              .add(const Duration(days: 1)),
                                        );
                                      } else {
                                        selectedDateRange = _selectedDateRange
                                            .copyWith(start: pickedDate);
                                      }
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(width: 20.0),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const AppKitLabel(
                                      text: Text('Graphical (start time)')),
                                  const SizedBox(height: 8.0),
                                  AppKitDatePicker(
                                    autofocus: true,
                                    dateElements: AppKitDateElements.none,
                                    timeElements:
                                        AppKitTimeElements.hourMinuteSecond,
                                    semanticLabel:
                                        'Time Picker (single - graphical)',
                                    date: left(_selectedDateRange.start),
                                    minimumDate: _minimumDate,
                                    maximumDate: _maximumDate,
                                    type: AppKitDatePickerType.graphical,
                                    drawBackground: true,
                                    drawBorder: true,
                                    selectionType:
                                        AppKitDatePickerSelectionType.single,
                                    onChanged: (d) {
                                      debugPrint('[3] Date Changed ($d)');
                                      selectedDateRange = _selectedDateRange
                                          .copyWith(start: d.left);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const AppKitLabel(
                                  text: Text('Graphical (date range)')),
                              const SizedBox(height: 8.0),
                              AppKitDatePicker(
                                autofocus: true,
                                dateElements: AppKitDateElements.monthDayYear,
                                timeElements: AppKitTimeElements.none,
                                minimumDate: _minimumDate,
                                maximumDate: _maximumDate,
                                type: AppKitDatePickerType.graphical,
                                drawBackground: true,
                                drawBorder: true,
                                selectionType:
                                    AppKitDatePickerSelectionType.range,
                                date: right(_selectedDateRange),
                                onChanged: (d) {
                                  debugPrint('[3] Date Changed ($d)');
                                  final date = d.right;
                                  selectedDateRange = date;
                                  selectedDate = date.start;
                                },
                              ),
                            ],
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
