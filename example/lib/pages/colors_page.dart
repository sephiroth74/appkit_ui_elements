import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:example/widgets/widget_title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ColorsPage extends StatefulWidget {
  const ColorsPage({super.key});

  @override
  State<ColorsPage> createState() => _ColorsPageState();
}

class _ColorsPageState extends State<ColorsPage> {
  Color color1 = AppKitColors.systemBlue;
  Color color2 = AppKitColors.systemGreen;
  Color color3 = AppKitColors.systemPurple;

  late bool isDark = AppKitTheme.of(context).brightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    return AppKitScaffold(
      toolBar: const AppKitToolBar(
        title: Text('Colors'),
        titleWidth: 200,
      ),
      children: [
        AppKitContentArea(
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
                      const SizedBox(height: 16.0),
                      const Divider(
                        height: 0.5,
                        thickness: 0.5,
                      ),
                      const SizedBox(height: 16.0),
                      const WidgetTitle(label: 'Colors'),
                      const SizedBox(height: 16.0),
                      Row(
                        children: [
                          AppKitSwitch(
                              checked: isDark,
                              onChanged: (value) =>
                                  setState(() => isDark = value)),
                          const SizedBox(width: 8.0),
                          Text(isDark ? 'Light Mode' : 'Dark Mode'),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      AppKitGroupBox(
                        style: AppKitGroupBoxStyle.defaultScrollBox,
                        child: ListView(
                          primary: false,
                          shrinkWrap: true,
                          children: [
                            ColorBox(
                              isFirst: true,
                              color: AppKitColors.systemRed,
                              colorName: 'System Red',
                              isDark: isDark,
                            ),
                            ColorBox(
                              color: AppKitColors.systemGreen,
                              colorName: 'System Green',
                              isDark: isDark,
                            ),
                            ColorBox(
                              color: AppKitColors.systemBlue,
                              colorName: 'System Blue',
                              isDark: isDark,
                            ),
                            ColorBox(
                              color: AppKitColors.systemOrange,
                              colorName: 'System Orange',
                              isDark: isDark,
                            ),
                            ColorBox(
                              color: AppKitColors.systemYellow,
                              colorName: 'System Yellow',
                              isDark: isDark,
                            ),
                            ColorBox(
                              color: AppKitColors.systemBrown,
                              colorName: 'System Brown',
                              isDark: isDark,
                            ),
                            ColorBox(
                              color: AppKitColors.systemPink,
                              colorName: 'System Pink',
                              isDark: isDark,
                            ),
                            ColorBox(
                              color: AppKitColors.systemPurple,
                              colorName: 'System Purple',
                              isDark: isDark,
                            ),
                            ColorBox(
                              color: AppKitColors.systemTeal,
                              colorName: 'System Teal',
                              isDark: isDark,
                            ),
                            ColorBox(
                              color: AppKitColors.systemIndigo,
                              colorName: 'System Indigo',
                              isDark: isDark,
                            ),
                            ColorBox(
                              color: AppKitColors.systemGray,
                              colorName: 'System Gray',
                              isDark: isDark,
                            ),
                            ColorBox(
                                color: AppKitColors
                                    .alternateSelectedControlTextColor,
                                colorName: 'Alternate Selected Control Text',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.controlBackgroundColor,
                                colorName: 'Control Background',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.controlColor,
                                colorName: 'Control',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.controlTextColor,
                                colorName: 'Control Text',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.disabledControlTextColor,
                                colorName: 'Disabled Control Text',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.dividerColor,
                                colorName: 'Divider',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.findHighlightColor,
                                colorName: 'Find Highlight',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.gridColor,
                                colorName: 'Grid',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.headerTextColor,
                                colorName: 'Header Text',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.highlightColor,
                                colorName: 'Highlight',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.keyboardFocusIndicatorColor,
                                colorName: 'Keyboard Focus Indicator',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.labelColor,
                                colorName: 'Label',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.linkColor,
                                colorName: 'Link',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.placeholderTextColor,
                                colorName: 'PlaceHolder Text',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.quaternaryLabelColor,
                                colorName: 'Quaternary Label',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.scrollbarColor,
                                colorName: 'Scrollbar',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.secondaryLabelColor,
                                colorName: 'Secondary Label',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.selectedControlColor,
                                colorName: 'Selected Control',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.selectedControlTextColor,
                                colorName: 'Selected Control Text',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.selectedMenuItemTextColor,
                                colorName: 'Selected Menu Item Text',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.selectedTextBackgroundColor,
                                colorName: 'Selected Text Background',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.selectedTextColor,
                                colorName: 'Selected Text',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.separatorColor,
                                colorName: 'Separator',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.shadowColor,
                                colorName: 'Shadow',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.tertiaryLabelColor,
                                colorName: 'Tertiary Label',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.textBackgroundColor,
                                colorName: 'Text Background',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.textColor,
                                colorName: 'Text',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.toolbarIconColor,
                                colorName: 'Toolbar Icon',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.underPageBackgroundColor,
                                colorName: 'Under Page Background',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors
                                    .unemphasizedSelectedContentBackgroundColor,
                                colorName:
                                    'Unemphasized Selected Content Background',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors
                                    .unemphasizedSelectedTextBackgroundColor,
                                colorName:
                                    'Unemphasized Selected Text Background',
                                isDark: isDark),
                            ColorBox(
                                color:
                                    AppKitColors.unemphasizedSelectedTextColor,
                                colorName: 'Unemphasized Selected Text',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.windowBackgroundColor,
                                colorName: 'Window Background',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.canvasColor,
                                colorName: 'Canvas',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.windowFrameTextColor,
                                colorName: 'Window Frame',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors
                                    .alternatingContentBackgroundColors[0],
                                colorName: 'Alternating Content Background 0',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors
                                    .alternatingContentBackgroundColors[1],
                                colorName: 'Alternating Content Background 1',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.text.opaque.primary,
                                colorName: 'Text Opaque Primary',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.text.opaque.secondary,
                                colorName: 'Text Opaque Secondary',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.text.opaque.tertiary,
                                colorName: 'Text Opaque Tertiary',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.text.opaque.quaternary,
                                colorName: 'Text Opaque Quaternary',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.text.opaque.quinary,
                                colorName: 'Text Opaque Quinary',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.text.vibrant.primary,
                                colorName: 'Text Vibrant Primary',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.text.vibrant.secondary,
                                colorName: 'Text Vibrant Secondary',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.text.vibrant.tertiary,
                                colorName: 'Text Vibrant Tertiary',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.text.vibrant.quaternary,
                                colorName: 'Text Vibrant Quaternary',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.text.vibrant.quinary,
                                colorName: 'Text Vibrant Quinary',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.fills.opaque.primary,
                                colorName: 'Fills Opaque Primary',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.fills.opaque.secondary,
                                colorName: 'Fills Opaque Secondary',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.fills.opaque.tertiary,
                                colorName: 'Fills Opaque Tertiary',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.fills.opaque.quaternary,
                                colorName: 'Fills Opaque Quaternary',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.fills.opaque.quinary,
                                colorName: 'Fills Opaque Quinary',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.fills.vibrant.primary,
                                colorName: 'Fills Vibrant Primary',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.fills.vibrant.secondary,
                                colorName: 'Fills Vibrant Secondary',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.fills.vibrant.tertiary,
                                colorName: 'Fills Vibrant Tertiary',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.fills.vibrant.quaternary,
                                colorName: 'Fills Vibrant Quaternary',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.fills.vibrant.quinary,
                                colorName: 'Fills Vibrant Quinary',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.materials.medium,
                                colorName: 'Material Medium',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.materials.thick,
                                colorName: 'Material Thick',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.materials.thin,
                                colorName: 'Material Thin',
                                isDark: isDark),
                            ColorBox(
                                color: AppKitColors.materials.ultraThick,
                                colorName: 'Material Ultra Thick',
                                isDark: isDark),
                            ColorBox(
                              color: AppKitColors.materials.ultraThin,
                              colorName: 'Material Ultra Thin',
                              isDark: isDark,
                              isLast: true,
                            ),
                          ],
                        ),
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

extension ColorX on Color {
  String toHex() => '#${value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
}

class ColorBox extends StatelessWidget {
  final bool isDark;
  final CupertinoDynamicColor color;
  final String colorName;
  final bool isFirst;
  final bool isLast;

  const ColorBox(
      {super.key,
      required this.color,
      required this.colorName,
      required this.isDark,
      this.isFirst = false,
      this.isLast = false});

  @override
  Widget build(BuildContext context) {
    final c = isDark ? color.darkColor : color.color;

    return Padding(
      padding: EdgeInsets.only(top: isFirst ? 0.0 : 4.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              _ColorBox(color: c),
              const SizedBox(width: 12.0),
              Flexible(
                flex: 1,
                child: DefaultTextStyle(
                    style: AppKitTheme.of(context).typography.callout,
                    child: Text(
                        '$colorName ${isDark ? 'Dark' : 'Light'}\n${c.toHex()}')),
              ),
            ],
          ),
          if (!isLast) ...[
            const SizedBox(height: 8.0),
            Divider(
              color: AppKitColors.separatorColor.resolveFrom(context),
              height: 0.5,
              thickness: 0.5,
              indent: 12,
              endIndent: 12,
            ),
          ],
        ],
      ),
    );
  }
}

class _ColorBox extends StatelessWidget {
  const _ColorBox({
    required this.color,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black.withOpacity(0.1)),
        borderRadius: BorderRadius.circular(5.0),
        color: color,
      ),
    );
  }
}
