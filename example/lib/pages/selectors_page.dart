import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:example/widgets/widget_title.dart';
import 'package:macos_ui/macos_ui.dart';

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
    });
  }

  set selectedDateRange(DateTimeRange value) {
    setState(() {
      _selectedDateRange = value;
    });
  }

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
                            // Column(
                            //   mainAxisSize: MainAxisSize.min,
                            //   mainAxisAlignment: MainAxisAlignment.start,
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     const Label(text: Text('Textual')),
                            //     const SizedBox(height: 8.0),
                            //     SizedBox(
                            //       width: 190,
                            //       child: AppKitDatePicker(
                            //         canRequestFocus: true,
                            //         autofocus: false,
                            //         date: left(_selectedDate),
                            //         minimumDate: _minimumDate,
                            //         maximumDate: _maximumDate,
                            //         dateElements:
                            //             AppKitDateElements.monthDayYear,
                            //         timeElements:
                            //             AppKitTimeElements.hourMinuteSecond,
                            //         semanticLabel: 'Date Picker',
                            //         type: AppKitDatePickerType.textual,
                            //         onChanged: (Either<DateTime, DateTimeRange>
                            //             range) {
                            //           debugPrint('[1] Date Changed ($range)');
                            //           selectedDate = range.getLeft();
                            //         },
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            // const SizedBox(height: 20.0),
                            // Column(
                            //   mainAxisSize: MainAxisSize.min,
                            //   mainAxisAlignment: MainAxisAlignment.start,
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     const Label(text: Text('Textual with Stepper')),
                            //     const SizedBox(height: 8.0),
                            //     SizedBox(
                            //       width: 190,
                            //       child: AppKitDatePicker(
                            //         canRequestFocus: true,
                            //         autofocus: true,
                            //         date: _selectedDate,
                            //         minimumDate: _minimumDate,
                            //         maximumDate: _maximumDate,
                            //         dateElements:
                            //             AppKitDateElements.monthDayYear,
                            //         timeElements:
                            //             AppKitTimeElements.hourMinuteSecond,
                            //         semanticLabel: 'Date Picker',
                            //         type:
                            //             AppKitDatePickerType.textualWithStepper,
                            //         onChanged: (d1, d2) {
                            //           debugPrint('[1] Date Changed ($d1, $d2)');
                            //           debugPrint(
                            //               'minimumDate: $_minimumDate, maximumDate: $_maximumDate');
                            //           selectedDate = d1;
                            //         },
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            // const SizedBox(height: 20.0),
                            // Column(
                            //   mainAxisSize: MainAxisSize.min,
                            //   mainAxisAlignment: MainAxisAlignment.start,
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     const Label(text: Text('Graphical (date)')),
                            //     const SizedBox(height: 8.0),
                            //     AppKitDatePicker(
                            //       autofocus: true,
                            //       canRequestFocus: true,
                            //       dateElements: AppKitDateElements.monthYear,
                            //       timeElements: AppKitTimeElements.none,
                            //       semanticLabel: 'Date Picker (graphical)',
                            //       date: _selectedDate,
                            //       minimumDate: _minimumDate,
                            //       maximumDate: _maximumDate,
                            //       type: AppKitDatePickerType.graphical,
                            //       drawBackground: true,
                            //       drawBorder: true,
                            //       selectionType:
                            //           AppKitDatePickerSelectionType.single,
                            //       onChanged: (d1, d2) {
                            //         debugPrint('[2] Date Changed ($d1, $d2)');
                            //         selectedDate = d1;
                            //       },
                            //     ),
                            //   ],
                            // ),
                            // const SizedBox(height: 20.0),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Label(text: Text('Graphical (time)')),
                                const SizedBox(height: 8.0),
                                AppKitDatePicker(
                                  autofocus: true,
                                  dateElements: AppKitDateElements.monthDayYear,
                                  timeElements: AppKitTimeElements.none,
                                  semanticLabel: 'Date Picker (graphical)',
                                  // date: left(_selectedDate),
                                  date: right(_selectedDateRange),
                                  minimumDate: _minimumDate,
                                  maximumDate: _maximumDate,
                                  type: AppKitDatePickerType.graphical,
                                  drawBackground: true,
                                  drawBorder: true,
                                  selectionType:
                                      AppKitDatePickerSelectionType.range,
                                  onChanged: (d) {
                                    debugPrint('[2] Date Changed ($d)');
                                    selectedDateRange = d.right;
                                    // selectedDate = d.left;
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
              ),
            );
          },
        )
      ],
    );
  }
}
