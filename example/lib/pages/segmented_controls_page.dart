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
              color: Color(0xFFd9d9d9),
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
                            AppKitSegmentedControl(
                              style: AppKitSegmentedControlStyle.multiple,
                              controller: SegmentedControllerMultiple(length: 5, initialSelection: {0}),
                              icons: const [
                                CupertinoIcons.home,
                                CupertinoIcons.search,
                                CupertinoIcons.add,
                                CupertinoIcons.settings,
                                CupertinoIcons.profile_circled,
                              ],
                              children: const [
                                Text('One'),
                                Text('Two'),
                                Text('Three'),
                                Text('Four'),
                                Text('Five'),
                              ],
                              onSelectionChanged: (value) {
                                debugPrint('Multiple Selection: $value');
                              },
                            ),
                            const SizedBox(height: 20.0),
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
