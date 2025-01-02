import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:example/widgets/theme_toolbar_item.dart';

class TabViewPage extends StatefulWidget {
  const TabViewPage({super.key});

  @override
  State<TabViewPage> createState() => _TabViewPageState();
}

class _TabViewPageState extends State<TabViewPage> {
  final controller = AppKitTabController(length: 5);

  @override
  Widget build(BuildContext context) {
    return AppKitScaffold(
      toolBar: AppKitToolBar(
        title: const Text('Tab View'),
        titleWidth: 200,
        actions: [
          ThemeSwitcherToolbarItem.build(context),
        ],
      ),
      children: [
        AppKitContentArea(
          builder: (context, ScrollController scrollController) {
            return AppKitTabView(
              position: AppKitTabPosition.top,
              size: AppKitSegmentedControlSize.regular,
              controller: controller,
              onTabChanged: (index) {
                debugPrint('Tab changed to $index');
              },
              labels: const ['Tab 1', 'Tab 2', 'Tab 3', 'Tab 4', 'Tab 5'],
              children: const [
                Center(
                  child: Text('Tab 1'),
                ),
                Center(
                  child: Text('Tab 2'),
                ),
                Center(
                  child: Text('Tab 3'),
                ),
                Center(
                  child: Text('Tab 4'),
                ),
                Center(
                  child: Text('Tab 5'),
                ),
              ],
            );
          },
        )
      ],
    );
  }
}
