import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:example/widgets/widget_title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class SegmentedControlsPage extends StatefulWidget {
  const SegmentedControlsPage({super.key});

  @override
  State<SegmentedControlsPage> createState() => _SegmentedControlsPageState();
}

class _SegmentedControlsPageState extends State<SegmentedControlsPage> {
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
        title: Text('Indicators'),
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
                        const WidgetTitle(label: 'Multiple Selection'),
                        const SizedBox(height: 20.0),
                        Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const SizedBox(
                                    width: 100, child: Text('Regular Size: ')),
                                Flexible(
                                  flex: 1,
                                  child: AppKitSegmentedControl(
                                    controller: multipleController1,
                                    icons: const [
                                      CupertinoIcons.star_fill,
                                      CupertinoIcons.star_fill,
                                      CupertinoIcons.star_fill,
                                      CupertinoIcons.star_fill,
                                      CupertinoIcons.star_fill,
                                      CupertinoIcons.star_fill,
                                      CupertinoIcons.star_fill,
                                      CupertinoIcons.star_fill,
                                    ],
                                    onSelectionChanged: (selection, index) {
                                      debugPrint(
                                          'Multiple Selection: $selection, $index');
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20.0),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const SizedBox(
                                    width: 100, child: Text('Small Size: ')),
                                Flexible(
                                  flex: 1,
                                  child: AppKitSegmentedControl(
                                    size: AppKitSegmentedControlSize.small,
                                    color: Colors.amber.shade900,
                                    controller: multipleController1,
                                    icons: const [
                                      CupertinoIcons.star_fill,
                                      CupertinoIcons.star_fill,
                                      CupertinoIcons.star_fill,
                                      CupertinoIcons.star_fill,
                                      CupertinoIcons.star_fill,
                                      CupertinoIcons.star_fill,
                                      CupertinoIcons.star_fill,
                                      CupertinoIcons.star_fill,
                                    ],
                                    onSelectionChanged: (p0, p1) {},
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20.0),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const SizedBox(
                                    width: 100, child: Text('Mini Size: ')),
                                Flexible(
                                  flex: 1,
                                  child: AppKitSegmentedControl(
                                    size: AppKitSegmentedControlSize.mini,
                                    controller: multipleController1,
                                    icons: const [
                                      CupertinoIcons.star_fill,
                                      CupertinoIcons.star_fill,
                                      CupertinoIcons.star_fill,
                                      CupertinoIcons.star_fill,
                                      CupertinoIcons.star_fill,
                                      CupertinoIcons.star_fill,
                                      CupertinoIcons.star_fill,
                                      CupertinoIcons.star_fill,
                                    ],
                                    onSelectionChanged: (p0, p1) {},
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20.0),
                            AppKitSegmentedControl(
                              size: AppKitSegmentedControlSize.regular,
                              controller: multipleController2,
                              labels: const [
                                'Pizza',
                                'Pasta',
                                'Coke',
                                'Beer',
                                'Cake',
                              ],
                              onSelectionChanged: (p0, p1) {},
                            ),
                            const SizedBox(height: 20.0),
                            AppKitSegmentedControl(
                              size: AppKitSegmentedControlSize.small,
                              color: Colors.teal.shade600,
                              controller: multipleController2,
                              labels: const [
                                'Pizza',
                                'Pasta',
                                'Coke',
                                'Beer',
                                'Cake',
                              ],
                              onSelectionChanged: (p0, p1) {},
                            ),
                            const SizedBox(height: 20.0),
                            AppKitSegmentedControl(
                              size: AppKitSegmentedControlSize.mini,
                              controller: multipleController2,
                              labels: const [
                                'Pizza',
                                'Pasta',
                                'Coke',
                                'Beer',
                                'Cake',
                              ],
                              onSelectionChanged: (p0, p1) {},
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        const WidgetTitle(label: 'Single Selection'),
                        const SizedBox(height: 20.0),
                        Column(
                          children: [
                            AppKitSegmentedControl(
                              controller: singleController1,
                              icons: const [
                                CupertinoIcons.text_alignleft,
                                CupertinoIcons.text_aligncenter,
                                CupertinoIcons.text_alignright,
                                CupertinoIcons.bold_italic_underline,
                                CupertinoIcons.strikethrough,
                              ],
                              onSelectionChanged: (p0, p1) {
                                debugPrint('Single Selection: $p0, $p1');
                              },
                            ),
                            const SizedBox(height: 20.0),
                            AppKitSegmentedControl(
                              controller: singleController1,
                              labels: const [
                                'Left',
                                'Center',
                                'Right',
                                'Underline',
                                'Strikethrough',
                              ],
                              onSelectionChanged: (p0, p1) {},
                            ),
                            const SizedBox(height: 20.0),
                            AppKitSegmentedControl(
                              size: AppKitSegmentedControlSize.small,
                              controller: singleController1,
                              labels: const [
                                'Left',
                                'Center',
                                'Right',
                                'Underline',
                                'Strikethrough',
                              ],
                              onSelectionChanged: (p0, p1) {},
                            ),
                            const SizedBox(height: 20.0),
                            AppKitSegmentedControl(
                              size: AppKitSegmentedControlSize.mini,
                              controller: singleController1,
                              labels: const [
                                'Left',
                                'Center',
                                'Right',
                                'Underline',
                                'Strikethrough',
                              ],
                              onSelectionChanged: (p0, p1) {},
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
