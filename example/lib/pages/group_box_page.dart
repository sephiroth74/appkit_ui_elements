import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:example/widgets/theme_toolbar_item.dart';
import 'package:example/widgets/widget_title.dart';

const groupMessage =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.';

class GroupedBoxPage extends StatefulWidget {
  const GroupedBoxPage({super.key});

  @override
  State<GroupedBoxPage> createState() => _GroupedBoxPageState();
}

class _GroupedBoxPageState extends State<GroupedBoxPage> {
  @override
  Widget build(BuildContext context) {
    return AppKitScaffold(
      toolBar: AppKitToolBar(
        title: const Text('Group Box'),
        titleWidth: 200,
        actions: [
          ThemeSwitcherToolbarItem.build(context),
        ],
      ),
      children: [
        AppKitContentArea(
          builder: (context, ScrollController scrollController) {
            final theme = AppKitTheme.of(context);
            final textStyle = theme.typography.body;
            final disabledTextStyle = textStyle.copyWith(
                color: textStyle.color?.withValues(alpha: 0.5));
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const WidgetTitle(label: 'GroupBox'),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          child: AppKitGroupBox(
                            height: 200,
                            style: AppKitGroupBoxStyle.defaultScrollBox,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: DefaultTextStyle(
                                  style: textStyle,
                                  child: const Text(groupMessage)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          child: AppKitGroupBox(
                            height: 200,
                            style: AppKitGroupBoxStyle.roundedScrollBox,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: DefaultTextStyle(
                                  style: textStyle,
                                  child: const Text(groupMessage)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          child: AppKitGroupBox(
                            height: 200,
                            style: AppKitGroupBoxStyle.standardScrollBox,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: DefaultTextStyle(
                                  style: textStyle,
                                  child: const Text(groupMessage)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const WidgetTitle(label: 'GroupBox (disbled)'),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          child: AppKitGroupBox(
                            height: 200,
                            style: AppKitGroupBoxStyle.defaultScrollBox,
                            enabled: false,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: DefaultTextStyle(
                                  style: disabledTextStyle,
                                  child: const Text(groupMessage)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          child: AppKitGroupBox(
                            height: 200,
                            style: AppKitGroupBoxStyle.roundedScrollBox,
                            enabled: false,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: DefaultTextStyle(
                                  style: disabledTextStyle,
                                  child: const Text(groupMessage)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          child: AppKitGroupBox(
                            height: 200,
                            style: AppKitGroupBoxStyle.standardScrollBox,
                            enabled: false,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: DefaultTextStyle(
                                  style: disabledTextStyle,
                                  child: const Text(groupMessage)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
