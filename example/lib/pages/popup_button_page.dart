import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:example/widgets/widget_title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PopupButtonPage extends StatefulWidget {
  const PopupButtonPage({super.key});

  @override
  State<PopupButtonPage> createState() => _PopupButtonPageState();
}

class _PopupButtonPageState extends State<PopupButtonPage> {
  bool? checkboxValue1 = true;
  bool radioButtonValue2 = true;
  bool radioButtonValue3 = false;
  double stepperValue = 50;
  bool disclosureValue = false;
  double sliderValue1 = 0.5;
  bool switchValue1 = true;
  double popupButtonWidth = 125.0;

  AppKitContextMenuItem<String>? popupSelectedItem;

  ContextMenuBuilder<String> get popupMenuBuilder => (context) {
        return AppKitContextMenu<String>(
          maxWidth: 200,
          entries: [
            for (var i = 0; i < 7; i++)
              if (i % 5 == 0 && i > 0)
                const AppKitContextMenuDivider()
              else
                AppKitContextMenuItem(
                  title: i == 6 ? 'Very long item with value $i' : 'Item $i',
                  enabled: i != 4,
                  value: '$i',
                  image: i == 0 ? CupertinoIcons.alarm : null,
                  itemState: popupSelectedItem?.value == '$i'
                      ? AppKitItemState.on
                      : AppKitItemState.off,
                ),
          ],
        );
      };

  ContextMenuBuilder<int> get pullDownMenuBuilder => (context) {
        return AppKitContextMenu<int>(
          maxWidth: 200,
          entries: [
            const AppKitContextMenuItem(
                title: 'Cut', value: 0, enabled: true, image: Icons.cut),
            const AppKitContextMenuItem(
                title: 'Copy', value: 1, enabled: true, image: Icons.copy),
            const AppKitContextMenuItem(
                title: 'Paste', value: 2, enabled: true, image: Icons.paste),
            const AppKitContextMenuDivider(),
            const AppKitContextMenuItem(
                title: 'Select All', value: 3, enabled: true),
            const AppKitContextMenuItem(
                title: 'Select None', value: 3, enabled: true),
            const AppKitContextMenuDivider(),
            AppKitContextMenuItem(
                title: 'Other...',
                value: 6,
                enabled: true,
                items: [
                  AppKitContextMenuItem(
                    title: 'Submenu Item 1',
                    value: 7,
                    enabled: true,
                    onPressed: (value) {
                      debugPrint('Selected: ${value.title}');
                    },
                  ),
                  const AppKitContextMenuItem(
                      title: 'Submenu Item 2', value: 12, enabled: true),
                  const AppKitContextMenuItem(
                      title: 'Submenu Item 3', value: 13, enabled: true),
                  const AppKitContextMenuItem(
                      title: 'Submenu Item 4', value: 14, enabled: true),
                  const AppKitContextMenuItem(
                      title: 'Submenu Item 5', value: 15, enabled: true),
                  const AppKitContextMenuItem(
                      title: 'Submenu Item 6', value: 16, enabled: true),
                  const AppKitContextMenuItem(
                      title: 'Submenu Item 7', value: 17, enabled: true),
                  const AppKitContextMenuItem(
                      title: 'Submenu Item 8', value: 18, enabled: true),
                  const AppKitContextMenuItem(
                      title: 'Submenu Item 9', value: 19, enabled: true),
                  const AppKitContextMenuDivider(),
                  const AppKitContextMenuItem(
                      title: 'Submenu Item 10', value: 20, enabled: false),
                ]),
          ],
        );
      };

  void _onPopupItemSelected(AppKitContextMenuItem<String>? value) {
    setState(() {
      if (value != null) {
        popupSelectedItem =
            popupMenuBuilder(context).findItemByValue(value.value);
      }
    });
  }

  @override
  void initState() {
    // popupSelectedItem = popupMenuBuilder(context).entries.elementAt(1)
    // as AppKitContextMenuItem<String>?;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppKitScaffold(
      toolBar: const AppKitToolBar(
        title: Text('Popup/Pull Down Button'),
        titleWidth: 300,
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
                      const WidgetTitle(label: 'Popup Button'),
                      const SizedBox(height: 20.0),
                      Column(
                        children: [AppKitControlSize.regular]
                            .map((controlSize) => [
                                  Row(
                                    children: [
                                      AppKitPopupButtonStyle.push,
                                      AppKitPopupButtonStyle.bevel,
                                      AppKitPopupButtonStyle.plain,
                                      AppKitPopupButtonStyle.inline,
                                    ]
                                        .map((style) => [
                                              AppKitPopupButton(
                                                canRequestFocus: true,
                                                hint: 'Select an item',
                                                controlSize: controlSize,
                                                width: popupButtonWidth,
                                                selectedItem: popupSelectedItem,
                                                onItemSelected: switchValue1
                                                    ? _onPopupItemSelected
                                                    : null,
                                                menuBuilder: popupMenuBuilder,
                                                style: style,
                                              ),
                                              const SizedBox(width: 8.0)
                                            ])
                                        .expand((element) => element)
                                        .toList(),
                                  ),
                                  const SizedBox(height: 16.0)
                                ])
                            .expand((element) => element)
                            .toList(),
                      ),
                      const SizedBox(width: 16.0, height: 16.0),
                      const Divider(
                        thickness: 0.5,
                      ),
                      const WidgetTitle(label: 'Pull Down Button'),
                      const SizedBox(height: 20.0),
                      Column(children: [
                        Row(
                          children: [
                            AppKitPulldownButtonStyle.push,
                            AppKitPulldownButtonStyle.bevel,
                            AppKitPulldownButtonStyle.plain,
                            AppKitPulldownButtonStyle.inline,
                          ]
                              .map((style) => [
                                    AppKitPulldownButton(
                                      canRequestFocus: true,
                                      title: 'Open...',
                                      textAlign: TextAlign.start,
                                      imageAlignment:
                                          AppKitMenuImageAlignment.leading,
                                      icon: Icons.open_in_new,
                                      minWidth: popupButtonWidth,
                                      onItemSelected: (value) {
                                        debugPrint('onItemSelected: $value');
                                      },
                                      menuBuilder: pullDownMenuBuilder,
                                      style: style,
                                    ),
                                    const SizedBox(width: 8.0)
                                  ])
                              .expand((element) => element)
                              .toList(),
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          children: [
                            AppKitPulldownButtonStyle.push,
                            AppKitPulldownButtonStyle.bevel,
                            AppKitPulldownButtonStyle.plain,
                            AppKitPulldownButtonStyle.inline,
                          ]
                              .map((style) => [
                                    AppKitPulldownButton(
                                      controlSize: AppKitControlSize.regular,
                                      canRequestFocus: false,
                                      imageAlignment:
                                          AppKitMenuImageAlignment.start,
                                      icon: Icons.add,
                                      minWidth: 55,
                                      onItemSelected: (value) {},
                                      menuBuilder: pullDownMenuBuilder,
                                      style: style,
                                    ),
                                    const SizedBox(width: 8.0)
                                  ])
                              .expand((element) => element)
                              .toList(),
                        ),
                        const SizedBox(height: 16.0)
                      ]),
                      const SizedBox(width: 16.0, height: 16.0),
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
