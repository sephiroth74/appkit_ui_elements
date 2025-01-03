import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:example/widgets/theme_toolbar_item.dart';
import 'package:example/widgets/widget_title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const _kLabelSize = 160.0;

class FieldsPage extends StatefulWidget {
  const FieldsPage({super.key});

  @override
  State<FieldsPage> createState() => _FieldsPageState();
}

class _FieldsPageState extends State<FieldsPage> {
  bool textFieldEnabled = true;

  final textFieldController = TextEditingController(text: '');

  final List<String> _searchResults = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5'
  ];

  AppKitControlSize textFieldSize = AppKitControlSize.regular;

  AppKitOverlayVisibilityMode clearButtonMode =
      AppKitOverlayVisibilityMode.always;

  AppKitTextFieldBorderStyle textFieldBorderStyle =
      AppKitTextFieldBorderStyle.rounded;

  // ignore: prefer_function_declarations_over_variables
  ContextMenuBuilder<String> get searchFieldMenuBuilder => (context) {
        if (_searchResults.isEmpty) {
          return AppKitContextMenu<String>(
            maxWidth: 200,
            entries: [],
          );
        }

        return AppKitContextMenu<String>(
          maxWidth: 200,
          entries: [
            for (final item in _searchResults)
              AppKitContextMenuItem(
                title: item,
                value: item,
                enabled: true,
              ),
            const AppKitContextMenuDivider(),
            AppKitContextMenuItem(
              title: 'Clear',
              value: null,
              enabled: true,
              onPressed: (value) {
                _searchResults.clear();
                textFieldController.clear();
              },
            ),
          ],
        );
      };

  @override
  Widget build(BuildContext context) {
    return AppKitScaffold(
      toolBar: AppKitToolBar(
        title: const Text('Fields'),
        titleWidth: 200,
        actions: [
          ThemeSwitcherToolbarItem.build(context),
        ],
      ),
      children: [
        AppKitContentArea(
          builder: (context, ScrollController scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const WidgetTitle(label: 'Text Fields'),
                  const SizedBox(height: 20.0),
                  // 1
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                          child: AppKitTextField(
                        controller: textFieldController,
                        enabled: textFieldEnabled,
                        borderStyle: textFieldBorderStyle,
                        placeholder: 'Placeholder',
                        expands: false,
                        minLines: 1,
                        maxLines: 1,
                        autofillHints: const [AutofillHints.email],
                        autocorrect: true,
                        enableInteractiveSelection: true,
                        textInputAction: TextInputAction.search,
                        keyboardType: TextInputType.text,
                        autofocus: false,
                        clearButtonMode: clearButtonMode,
                        behavior: AppKitTextFieldBehavior.editable,
                        onChanged: (value) => debugPrint('on changed: $value'),
                        onEditingComplete: () =>
                            debugPrint('on editing complete'),
                        onSubmitted: (value) =>
                            debugPrint('on submitted: $value'),
                        onTap: () => debugPrint('on tap'),
                      )),
                      const SizedBox(height: 16.0),
                      // 2
                      Flexible(
                          child: AppKitTextField(
                        backgroundColor:
                            AppKitColors.systemCyan.withValues(alpha: 0.1),
                        controller: textFieldController,
                        padding: const EdgeInsets.all(8.0),
                        enabled: textFieldEnabled,
                        borderStyle: textFieldBorderStyle,
                        clearButtonMode: clearButtonMode,
                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                        placeholder: 'Placeholder',
                        autofocus: false,
                        expands: true,
                        onChanged: (value) {
                          debugPrint('on changed: $value');
                        },
                      )),
                    ],
                  ),

                  const SizedBox(height: 16.0),
                  const Divider(thickness: 0.5),
                  const SizedBox(height: 16.0),
                  const WidgetTitle(label: 'Search Field'),
                  const SizedBox(height: 20.0),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: AppKitSearchField(
                          controlSize: textFieldSize,
                          clearButtonMode: clearButtonMode,
                          autocorrect: false,
                          autofocus: true,
                          contextMenuBuilder: searchFieldMenuBuilder,
                          controller: textFieldController,
                          enabled: textFieldEnabled,
                          borderStyle: textFieldBorderStyle,
                          continuous: false,
                          onTap: () {
                            debugPrint('search field tapped');
                          },
                          onChanged: (value) {
                            debugPrint('search field text changed => $value');
                          },
                          onEditingComplete: () {
                            debugPrint('search field editing complete');
                          },
                          onSubmitted: (value) {
                            debugPrint('search field submitted => $value');

                            if (!_searchResults.contains(value)) {
                              _searchResults.add(value);
                              // resize the search results if it's more than 5
                              if (_searchResults.length > 5) {
                                _searchResults.removeAt(0);
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16.0),
                  const Divider(thickness: 0.5),
                  const SizedBox(height: 16.0),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppKitTooltip.plain(
                        message: 'Enable/Disable text fields',
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                                width: _kLabelSize,
                                child:
                                    AppKitLabel(text: Text('Enable Fields'))),
                            const SizedBox(width: 16.0),
                            AppKitSwitch(
                                checked: textFieldEnabled,
                                onChanged: (value) =>
                                    setState(() => textFieldEnabled = value)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                              width: _kLabelSize,
                              child: AppKitLabel(
                                  icon: Icon(
                                    CupertinoIcons.eye_slash,
                                    size: 14,
                                  ),
                                  text: Text('Clear Button Mode'))),
                          const SizedBox(width: 16.0),
                          AppKitPopupButton(
                            selectedItem: AppKitContextMenuItem(
                              title: clearButtonMode.name,
                              value: clearButtonMode,
                              enabled: true,
                            ),
                            width: _kLabelSize,
                            controlSize: AppKitControlSize.regular,
                            menuEdge: AppKitMenuEdge.bottom,
                            menuBuilder: (context) {
                              return AppKitContextMenu<
                                      AppKitOverlayVisibilityMode>(
                                  minWidth: 150,
                                  entries: [
                                    for (final size
                                        in AppKitOverlayVisibilityMode.values)
                                      AppKitContextMenuItem(
                                        title: size.name,
                                        value: size,
                                        enabled: true,
                                      ),
                                  ]);
                            },
                            onItemSelected: (value) {
                              setState(() {
                                if (null != value?.value) {
                                  clearButtonMode = value?.value
                                      as AppKitOverlayVisibilityMode;
                                }
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                              width: _kLabelSize,
                              child: AppKitLabel(
                                  icon: Icon(
                                    Icons.border_bottom,
                                    size: 14,
                                  ),
                                  text: Text('Border Style'))),
                          const SizedBox(width: 16.0),
                          AppKitPopupButton(
                            selectedItem: AppKitContextMenuItem(
                              title: textFieldBorderStyle.name,
                              value: textFieldBorderStyle,
                              enabled: true,
                            ),
                            width: _kLabelSize,
                            controlSize: AppKitControlSize.regular,
                            menuEdge: AppKitMenuEdge.bottom,
                            menuBuilder: (context) {
                              return AppKitContextMenu<
                                      AppKitTextFieldBorderStyle>(
                                  minWidth: 150,
                                  entries: [
                                    for (final size
                                        in AppKitTextFieldBorderStyle.values)
                                      AppKitContextMenuItem(
                                        title: size.name,
                                        value: size,
                                        enabled: true,
                                      ),
                                  ]);
                            },
                            onItemSelected: (value) {
                              setState(() {
                                if (null != value?.value) {
                                  textFieldBorderStyle = value?.value
                                      as AppKitTextFieldBorderStyle;
                                }
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: _kLabelSize,
                            child: AppKitLabel(
                                icon: Icon(
                                  CupertinoIcons.textformat_size,
                                  size: 14,
                                ),
                                text: Text('Search Field Size')),
                          ),
                          const SizedBox(width: 16.0),
                          AppKitPopupButton(
                            selectedItem: AppKitContextMenuItem(
                              title: textFieldSize.name,
                              value: textFieldSize,
                              enabled: true,
                            ),
                            width: _kLabelSize,
                            controlSize: AppKitControlSize.regular,
                            menuEdge: AppKitMenuEdge.bottom,
                            menuBuilder: (context) {
                              return AppKitContextMenu<AppKitControlSize>(
                                  minWidth: 150,
                                  entries: [
                                    for (final size in AppKitControlSize.values)
                                      AppKitContextMenuItem(
                                        title: size.name,
                                        value: size,
                                        enabled: true,
                                      ),
                                  ]);
                            },
                            onItemSelected: (value) {
                              setState(() {
                                if (null != value?.value) {
                                  textFieldSize =
                                      value?.value as AppKitControlSize;
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16.0),
                ],
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
