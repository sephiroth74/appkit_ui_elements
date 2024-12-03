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
              child: Builder(
                builder: (context) {
                  return ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const WidgetTitle(label: 'Text Fields'),
                        const SizedBox(height: 20.0),
                        // 1
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
                          behavior: AppKitTextFieldBehavior.editable,
                          onChanged: (value) =>
                              debugPrint('on changed: $value'),
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
                          enabled: textFieldEnabled,
                          borderStyle: AppKitTextFieldBorderStyle.line,
                          clearButtonMode: AppKitOverlayVisibilityMode.always,
                          textInputAction: TextInputAction.newline,
                          keyboardType: TextInputType.multiline,
                          placeholder: 'Placeholder',
                          autofocus: true,
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
                          clearButtonMode: AppKitOverlayVisibilityMode.always,
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
                        const SizedBox(height: 16.0),
                        const Divider(thickness: 0.5),
                        const SizedBox(height: 16.0),
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
                      ],
                    ),
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
