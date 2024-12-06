import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:example/widgets/widget_title.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class ColorsPage extends StatefulWidget {
  const ColorsPage({super.key});

  @override
  State<ColorsPage> createState() => _ColorsPageState();
}

class _ColorsPageState extends State<ColorsPage> {
  Color color1 = AppKitColors.controlAccentColor;
  Color color2 = AppKitColors.systemGreen;
  Color color3 = AppKitColors.systemPurple;

  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      toolBar: const ToolBar(
        title: Text('Colors'),
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
                      const WidgetTitle(label: 'Color Well'),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Regular: '),
                          const SizedBox(width: 8.0),
                          AppKitColorWell(
                            onChanged: (value) {
                              setState(() => color1 = value);
                            },
                            color: color1,
                            mode: AppKitColorPickerMode.wheel,
                            semanticLabel: 'color-well',
                            style: AppKitColorWellStyle.regular,
                            withAlpha: false,
                          ),
                          const SizedBox(width: 8.0),
                          AppKitColorWell(
                            onChanged: null,
                            color: color1,
                            mode: AppKitColorPickerMode.wheel,
                            semanticLabel: 'color-well',
                            style: AppKitColorWellStyle.regular,
                            withAlpha: false,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Minimal: '),
                          const SizedBox(width: 8.0),
                          AppKitColorWell(
                            onChanged: (value) {
                              setState(() => color2 = value);
                            },
                            color: color2,
                            mode: AppKitColorPickerMode.cmyk,
                            semanticLabel: 'color-well',
                            style: AppKitColorWellStyle.minimal,
                            withAlpha: false,
                          ),
                          const SizedBox(width: 8.0),
                          AppKitColorWell(
                            onChanged: null,
                            color: color2,
                            mode: AppKitColorPickerMode.cmyk,
                            semanticLabel: 'color-well',
                            style: AppKitColorWellStyle.minimal,
                            withAlpha: false,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Expanded: '),
                          const SizedBox(width: 8.0),
                          AppKitColorWell(
                            onChanged: (value) {
                              setState(() => color3 = value);
                            },
                            color: color3,
                            mode: AppKitColorPickerMode.colorList,
                            semanticLabel: 'color-well',
                            style: AppKitColorWellStyle.expanded,
                            withAlpha: false,
                          ),
                          const SizedBox(width: 8.0),
                          AppKitColorWell(
                            onChanged: null,
                            color: color3,
                            mode: AppKitColorPickerMode.colorList,
                            semanticLabel: 'color-well',
                            style: AppKitColorWellStyle.expanded,
                            withAlpha: false,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
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

extension ColorX on Color {
  String toHex() => '#${value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
}
