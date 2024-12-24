import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:example/widgets/widget_title.dart';

class ComboBoxButtonPage extends StatefulWidget {
  const ComboBoxButtonPage({super.key});

  @override
  State<ComboBoxButtonPage> createState() => _ComboBoxButtonPageState();
}

class _ComboBoxButtonPageState extends State<ComboBoxButtonPage> {
  @override
  Widget build(BuildContext context) {
    return AppKitScaffold(
      toolBar: const AppKitToolBar(
        title: Text('ComboBox Button'),
        titleWidth: 200,
      ),
      children: [
        AppKitContentArea(
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              child: Builder(
                builder: (context) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const WidgetTitle(label: 'ComboBox Button'),
                        const SizedBox(height: 16.0),
                        Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 100.0,
                                  child: AppKitLabel(text: Text('Select:')),
                                ),
                                SizedBox(
                                  width: 120.0,
                                  child: AppKitComboBox(
                                    style: AppKitComboBoxStyle.bordered,
                                    controlSize: AppKitControlSize.regular,
                                    items: _kLanguages,
                                    maxItemsMenuHeight: 200,
                                    placeholder: 'Select an item...',
                                    onChanged: (value) {
                                      debugPrint('combo-box changed: $value');
                                    },
                                    autocompletes: true,
                                    autofocus: false,
                                    canRequestFocus: true,
                                    enabled: true,
                                  ),
                                ),
                                const SizedBox(width: 16.0),
                                const SizedBox(
                                  width: 120.0,
                                  child: AppKitComboBox(
                                    style: AppKitComboBoxStyle.bordered,
                                    controlSize: AppKitControlSize.regular,
                                    items: _kLanguages,
                                    maxItemsMenuHeight: 200,
                                    placeholder: 'Select an item...',
                                    autocompletes: true,
                                    autofocus: false,
                                    canRequestFocus: false,
                                    enabled: false,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 100.0,
                                  child: AppKitLabel(text: Text('Select:')),
                                ),
                                SizedBox(
                                  width: 120.0,
                                  child: AppKitComboBox(
                                    style: AppKitComboBoxStyle.plain,
                                    controlSize: AppKitControlSize.regular,
                                    behavior: AppKitTextFieldBehavior.editable,
                                    items: _kLanguages,
                                    maxItemsMenuHeight: 200,
                                    placeholder: 'Select an item...',
                                    onChanged: (value) {
                                      debugPrint('combo-box changed: $value');
                                    },
                                    autocompletes: true,
                                    autofocus: false,
                                    canRequestFocus: true,
                                    enabled: true,
                                  ),
                                ),
                                const SizedBox(width: 16.0),
                                const SizedBox(
                                  width: 120.0,
                                  child: AppKitComboBox(
                                    style: AppKitComboBoxStyle.plain,
                                    controlSize: AppKitControlSize.regular,
                                    behavior: AppKitTextFieldBehavior.editable,
                                    items: _kLanguages,
                                    maxItemsMenuHeight: 200,
                                    placeholder: 'Select an item...',
                                    autocompletes: true,
                                    autofocus: false,
                                    canRequestFocus: false,
                                    enabled: false,
                                  ),
                                ),
                              ],
                            )
                          ],
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

const _kLanguages = [
  'Mandarin Chinese',
  'Spanish',
  'English',
  'Hindi/Urdu',
  'Arabic',
  'Bengali',
  'Portuguese',
  'Russian',
  'Japanese',
  'German',
  'Thai',
  'Greek',
  'Nepali',
  'Punjabi',
  'Wu',
  'French',
  'Telugu',
  'Vietnamese',
  'Marathi',
  'Korean',
  'Tamil',
  'Italian',
  'Turkish',
  'Cantonese/Yue',
  'Urdu',
  'Javanese',
  'Egyptian Arabic',
  'Gujarati',
  'Iranian Persian',
  'Indonesian',
  'Polish',
  'Ukrainian',
  'Romanian',
  'Dutch'
];
