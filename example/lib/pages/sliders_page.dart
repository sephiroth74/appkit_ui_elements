import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:example/widgets/theme_toolbar_item.dart';
import 'package:example/widgets/widget_title.dart';
import 'package:flutter/material.dart';

class SlidersPage extends StatefulWidget {
  const SlidersPage({super.key});

  @override
  State<SlidersPage> createState() => _SlidersPageState();
}

class _SlidersPageState extends State<SlidersPage> {
  double slider1Value = .5;
  double slider2Value = 5;
  int rating1Value = 3;

  @override
  Widget build(BuildContext context) {
    return AppKitScaffold(
      toolBar: AppKitToolBar(
        title: const Text('Sliders'),
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
                      const WidgetTitle(label: 'Level Indicators'),
                      const SizedBox(height: 20.0),
                      AppKitLevelIndicator(
                        tickMarkPosition:
                            AppKitLevelIndicatorTickMarkPosition.below,
                        majorTickMarks: 11,
                        minorTickMarks: 21,
                        drawsTieredCapacityLevels: false,
                        continuous: true,
                        value: slider2Value,
                        style: AppKitLevelIndicatorStyle.continuous,
                        min: 0,
                        max: 10,
                        onChanged: (value) {
                          debugPrint('Level Indicator: $value');
                          setState(() => slider2Value = value);
                        },
                      ),
                      const SizedBox(height: 20.0),
                      AppKitLevelIndicator(
                        tickMarkPosition:
                            AppKitLevelIndicatorTickMarkPosition.none,
                        majorTickMarks: 3,
                        minorTickMarks: 21,
                        drawsTieredCapacityLevels: false,
                        continuous: false,
                        value: slider2Value,
                        style: AppKitLevelIndicatorStyle.discrete,
                        min: 0,
                        max: 10,
                        onChanged: (value) {
                          debugPrint('Level Indicator: $value');
                          setState(() => slider2Value = value);
                        },
                      ),
                      const SizedBox(height: 20.0),
                      const Divider(thickness: 0.5),
                      const WidgetTitle(label: 'Rating Indicators'),
                      const SizedBox(height: 20.0),
                      AppKitRatingIndicator(
                        min: 0,
                        max: 10,
                        value: rating1Value,
                        continuous: false,
                        semanticLabel: 'Rating Indicator 1',
                        placeholderAlwaysVisible: true,
                        onChanged: (value) {
                          setState(() => rating1Value = value);
                        },
                      ),
                      const SizedBox(height: 16.0),
                      AppKitRatingIndicator(
                        min: 0,
                        max: 10,
                        value: rating1Value,
                        continuous: true,
                        semanticLabel: 'Rating Indicator 2',
                        placeholderAlwaysVisible: false,
                        imageColor: AppKitColors.systemYellow,
                        onChanged: (value) {
                          setState(() => rating1Value = value);
                        },
                      ),
                      const SizedBox(height: 16.0),
                      AppKitRatingIndicator(
                        min: 0,
                        max: 10,
                        value: rating1Value,
                        continuous: true,
                        icon: Icons.check_box,
                        placeholderIcon: Icons.check_box_outline_blank_sharp,
                        imageColor: AppKitColors.secondaryLabelColor,
                        semanticLabel: 'Rating Indicator 3',
                        placeholderAlwaysVisible: false,
                        iconsPadding: -1,
                        onChanged: (value) {
                          setState(() => rating1Value = value);
                        },
                      ),
                      const SizedBox(height: 20.0),
                      const Divider(thickness: 0.5),
                      const WidgetTitle(label: 'Linear Sliders'),
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
                          const SizedBox(height: 16.0),
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
                          const SizedBox(height: 16.0),
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
                      const SizedBox(height: 20.0),
                      const Divider(thickness: 0.5),
                      const WidgetTitle(label: 'Circular Sliders'),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          AppKitCircularSlider(
                            min: 0.0,
                            max: 1.0,
                            semanticLabel: 'Circular Slider',
                            tickMarks: 0,
                            value: slider1Value,
                            continuous: true,
                            onChanged: (value) {
                              setState(() => slider1Value = value);
                            },
                          ),
                          const SizedBox(width: 16.0),
                          AppKitCircularSlider(
                            min: 0.0,
                            max: 1.0,
                            semanticLabel: 'Circular Slider',
                            continuous: false,
                            color: AppKitColors.systemGreen,
                            tickMarks: 20,
                            value: slider1Value,
                            onChanged: (value) {
                              setState(() => slider1Value = value);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          SizedBox.square(
                            dimension: 48,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Text('${(slider1Value * 100).toInt()}',
                                      style: AppKitTheme.of(context)
                                          .typography
                                          .body
                                          .copyWith(fontSize: 10)),
                                ),
                                AppKitArcSlider(
                                  size: 48,
                                  value: slider1Value,
                                  onChanged: (value) =>
                                      setState(() => slider1Value = value),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20.0),
                          SizedBox.square(
                            dimension: 84,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.center,
                                  child: Text('${(slider1Value * 100).toInt()}',
                                      style: AppKitTheme.of(context)
                                          .typography
                                          .body
                                          .copyWith(
                                              fontSize: 16,
                                              color: AppKitDynamicColor.resolve(
                                                  context,
                                                  AppKitColors
                                                      .text.opaque.tertiary))),
                                ),
                                AppKitArcSlider(
                                  sweepAngle: 40,
                                  size: 84,
                                  progressWidth: 4,
                                  thumbRadius: 7,
                                  trackWidth: 0.5,
                                  trackColor:
                                      AppKitColors.systemGray.withOpacity(0.3),
                                  progressColor: AppKitColors.appleGreen,
                                  value: slider1Value,
                                  onChanged: (value) =>
                                      setState(() => slider1Value = value),
                                ),
                              ],
                            ),
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
                              width: 100,
                              child: Text(
                                  'Value: ${(slider1Value * 100).floor()}')),
                          const SizedBox(width: 16.0),
                          AppKitStepper(
                            controlSize: AppKitControlSize.regular,
                            value: (slider1Value * 100).floorToDouble(),
                            increment: 1,
                            onChanged: (value) {
                              debugPrint('onChanged($value)');
                              setState(() {
                                slider1Value = value / 100;
                              });
                            },
                          ),
                          const SizedBox(width: 16.0),
                          AppKitStepper(
                            value: (slider1Value * 100).floorToDouble(),
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
