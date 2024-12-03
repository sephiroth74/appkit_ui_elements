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
                  return const Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WidgetTitle(label: 'Text Fields'),
                      SizedBox(height: 20.0),
                      SizedBox(
                          width: 200,
                          child: AppKitTextField(
                            placeholder: 'Placeholder',
                            expands: false,
                            maxLines: 1,
                            keyboardType: TextInputType.text,
                          )),
                      SizedBox(height: 16.0),
                      Divider(
                        thickness: 0.5,
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
