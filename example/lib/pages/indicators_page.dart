import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:example/widgets/theme_toolbar_item.dart';
import 'package:example/widgets/widget_title.dart';
import 'package:flutter/material.dart';

class IndicatorsPage extends StatefulWidget {
  const IndicatorsPage({super.key});

  @override
  State<IndicatorsPage> createState() => _IndicatorsPageState();
}

class _IndicatorsPageState extends State<IndicatorsPage> {
  double slider1Value = .65;

  @override
  Widget build(BuildContext context) {
    return AppKitScaffold(
      toolBar: AppKitToolBar(
        title: const Text('Indicators'),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const WidgetTitle(label: 'Progress Bars Linear'),
                      const SizedBox(height: 20.0),
                      Column(
                        children: [
                          AppKitProgress.linear(
                            value: slider1Value,
                            height: 12,
                            color: AppKitColors.appleMagenta,
                          ),
                          const SizedBox(height: 16.0),
                          AppKitProgress.linear(value: slider1Value),
                          const SizedBox(height: 16.0),
                          AppKitProgress.linear(value: slider1Value, height: 3),
                          const SizedBox(height: 16.0),
                          AppKitProgress.linear(),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      const Divider(
                        thickness: 0.5,
                      ),
                      const SizedBox(height: 20.0),
                      const WidgetTitle(label: 'Progress Bars Circular'),
                      const SizedBox(height: 20.0),
                      Column(
                        children: [
                          Row(
                            children: [
                              AppKitProgress.circle(),
                              const SizedBox(width: 20.0),
                              AppKitProgress.circle(size: 24),
                              const SizedBox(width: 20.0),
                              AppKitProgress.circle(
                                  size: 24, color: AppKitColors.appleOrange),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          Row(
                            children: [
                              AppKitProgress.circle(value: slider1Value),
                              const SizedBox(width: 20.0),
                              AppKitProgress.circle(
                                value: slider1Value,
                                color: AppKitColors.appleMagenta,
                                size: 24.0,
                                strokeWidth: 6,
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
