import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:example/widgets/widget_title.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class IndicatorsPage extends StatefulWidget {
  const IndicatorsPage({super.key});

  @override
  State<IndicatorsPage> createState() => _IndicatorsPageState();
}

class _IndicatorsPageState extends State<IndicatorsPage> {
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
                      const WidgetTitle(label: 'Sliders'),
                      const SizedBox(height: 20.0),
                      Column(
                        children: [
                          AppKitSlider(
                            min: 0.0,
                            max: 1.0,
                            value: slider1Value,
                            onChanged: (value) {
                              debugPrint('Slider 1: $value');
                              setState(() => slider1Value = value);
                            },
                          ),
                          const SizedBox(height: 20.0),
                          AppKitSlider(
                            style: AppKitSliderStyle.discreteFree,
                            min: 0.0,
                            max: 1.0,
                            stops: const [
                              0,
                              .1,
                              .2,
                              .3,
                              .4,
                              .5,
                              .6,
                              .7,
                              .8,
                              .9,
                              1.0
                            ],
                            value: slider1Value,
                            onChanged: (value) {
                              debugPrint('Slider 2: $value');
                              setState(() => slider1Value = value);
                            },
                          ),
                          const SizedBox(height: 20.0),
                          AppKitSlider(
                            style: AppKitSliderStyle.discreteFixed,
                            stops: const [0.0, 0.1, 0.15, 0.2, 0.9, 1.0],
                            value: slider1Value,
                            onChanged: (value) {
                              debugPrint('Slider 3: $value');
                              setState(() => slider1Value = value);
                            },
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