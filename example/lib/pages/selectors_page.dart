import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:example/widgets/widget_title.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

class SelectorsPage extends StatefulWidget {
  const SelectorsPage({super.key});

  @override
  State<SelectorsPage> createState() => _SelectorsPageState();
}

class _SelectorsPageState extends State<SelectorsPage> {
  List<Color> colors = AppKitColorPickerMode.values.map((e) {
    switch (e) {
      case AppKitColorPickerMode.wheel:
        return const Color.fromARGB(255, 31, 68, 230);
      case AppKitColorPickerMode.gray:
        return const Color(0xFFA9A9A9);
      case AppKitColorPickerMode.none:
        return const Color.fromARGB(0, 0, 0, 255);
      case AppKitColorPickerMode.rgb:
        return const Color.fromARGB(255, 217, 0, 255);
      case AppKitColorPickerMode.cmyk:
        return const Color.fromARGB(255, 0, 255, 229);
      case AppKitColorPickerMode.hsb:
        return const Color.fromARGB(255, 255, 230, 0);
      case AppKitColorPickerMode.customPalette:
        return const Color.fromARGB(255, 0, 225, 255);
      case AppKitColorPickerMode.colorList:
        return const Color.fromARGB(255, 119, 127, 171);
      case AppKitColorPickerMode.crayon:
        return const Color.fromARGB(255, 176, 185, 98);
    }
  }).toList();

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
                      Column(
                        children: AppKitColorPickerMode.values.map((mode) {
                          final index = mode.index;
                          return Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      '${mode.name}: ',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  AppKitColorWell(
                                    withAlpha: true,
                                    mode: mode,
                                    uuid: mode.name,
                                    color: colors[index],
                                    onChanged: (Color color) {
                                      setState(() {
                                        // debugPrint('Color changed from ${colors[index]} to $color');
                                        colors[index] = color;
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 8.0),
                                  Text('Color: ${colors[index].toHex()}'),
                                ],
                              ),
                              const SizedBox(height: 20.0),
                            ],
                          );
                        }).toList(),
                      ),
                      AppKitColorWell(onChanged: null),
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
