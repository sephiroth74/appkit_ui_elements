import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:example/widgets/widget_title.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';

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
              onSelected: (value) {
                _searchResults.clear();
                textFieldController.clear();
              },
            ),
          ],
        );
      };

  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      toolBar: const ToolBar(
        title: Text('Fields'),
        titleWidth: 200,
      ),
      children: [
        ContentArea(
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
                        borderStyle: AppKitTextFieldBorderStyle.none,
                        placeholder: 'Placeholder',
                        expands: false,
                        maxLines: 1,
                        autofillHints: const [AutofillHints.email],
                        autocorrect: true,
                        enableInteractiveSelection: true,
                        enableSuggestions: true,
                        textInputAction: TextInputAction.search,
                        keyboardType: TextInputType.text,
                        autofocus: false,
                        clearButtonMode: AppKitOverlayVisibilityMode.always,
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
                            AppKitColors.systemCyan.withOpacity(0.1),
                        controller: textFieldController,
                        padding: const EdgeInsets.all(8.0),
                        clearButtonPadding: const EdgeInsets.all(8.0),
                        enabled: textFieldEnabled,
                        borderStyle: AppKitTextFieldBorderStyle.line,
                        clearButtonMode: AppKitOverlayVisibilityMode.always,
                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                        placeholder: 'Placeholder',
                        autofocus: false,
                        expands: true,
                        onChanged: (value) {
                          debugPrint('on changed: $value');
                        },
                      )),
                      const SizedBox(height: 16.0),
                      // 3
                      Flexible(
                          child: AppKitTextField(
                        controller: textFieldController,
                        enabled: textFieldEnabled,
                        borderStyle: AppKitTextFieldBorderStyle.bezel,
                        placeholder: 'Placeholder',
                        expands: false,
                        maxLines: 1,
                        keyboardType: TextInputType.text,
                        clearButtonMode: AppKitOverlayVisibilityMode.notEditing,
                      )),
                      const SizedBox(height: 16.0),
                      // 4
                      Flexible(
                        child: AppKitTextField(
                          controller: textFieldController,
                          enabled: textFieldEnabled,
                          borderStyle: AppKitTextFieldBorderStyle.rounded,
                          textInputAction: TextInputAction.newline,
                          keyboardType: TextInputType.multiline,
                          enableSuggestions: false,
                          autocorrect: false,
                          placeholder: 'Placeholder',
                          clearButtonMode: AppKitOverlayVisibilityMode.always,
                          expands: true,
                        ),
                      ),
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
                          clearButtonMode: AppKitOverlayVisibilityMode.always,
                          autocorrect: false,
                          autofocus: true,
                          contextMenuBuilder: searchFieldMenuBuilder,
                          controller: textFieldController,
                          enabled: textFieldEnabled,
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
                            const Flexible(
                                child: Text('Enable/Disable text fields')),
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
                          const Flexible(child: Text('Search Field Size')),
                          const SizedBox(width: 16.0),
                          AppKitPopupButton(
                            selectedItem: AppKitContextMenuItem(
                              title: textFieldSize.name,
                              value: textFieldSize,
                              enabled: true,
                            ),
                            width: 150,
                            controlSize: AppKitControlSize.regular,
                            menuEdge: AppKitMenuEdge.bottom,
                            menuBuilder: (context) {
                              return AppKitContextMenu<AppKitControlSize>(
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
