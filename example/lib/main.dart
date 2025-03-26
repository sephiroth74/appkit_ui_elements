import 'dart:io';

import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:example/pages/colors_page.dart';
import 'package:example/pages/combo_box_button_page.dart';
import 'package:example/pages/combo_button_page.dart';
import 'package:example/pages/context_menu_page.dart';
import 'package:example/pages/controls_page.dart';
import 'package:example/pages/dialogs_page.dart';
import 'package:example/pages/fields_page.dart';
import 'package:example/pages/group_box_page.dart';
import 'package:example/pages/indicators_page.dart';
import 'package:example/pages/popup_button_page.dart';
import 'package:example/pages/push_button_page.dart';
import 'package:example/pages/resizable_panel_page.dart';
import 'package:example/pages/segmented_controls_page.dart';
import 'package:example/pages/selectors_page.dart';
import 'package:example/pages/sliver_toolbar_page.dart';
import 'package:example/pages/sliders_page.dart';
import 'package:example/pages/tab_view_page.dart';
import 'package:example/pages/toggle_button_page.dart';
import 'package:example/pages/toolbar_page.dart';
import 'package:example/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:flutter/rendering.dart';

Future<void> _configureMacosWindowUtils() async {
  const config = AppKitWindowUtilsConfig(
      makeTitlebarTransparent: true,
      toolbarStyle: NSWindowToolbarStyle.automatic,
      autoHideToolbarAndMenuBarInFullScreenMode: false,
      enableFullSizeContentView: true,
      hideTitle: true,
      removeMenubarInFullScreenMode: true);
  config.apply();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  assert(Platform.isMacOS && !kIsWeb,
      'This example is intended to run on macOS desktop only.');
  await _configureMacosWindowUtils();
  await AppKitUiElements.ensureInitialized(debug: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    debugPaintSizeEnabled = false;

    return ChangeNotifierProvider(
      create: (_) => AppTheme(),
      builder: (context, child) {
        final appTheme = context.watch<AppTheme>();
        return AppKitMacosApp(
          debugShowCheckedModeBanner: false,
          themeMode: appTheme.mode,
          title: 'AppKit Elements Demo',
          home: const MyHomePage(title: 'Flutter Demo Home Page'),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int pageIndex = 0;
  late final searchFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PlatformMenuBar(
      menus: const [],
      child: AppKitWindow(
        endSidebar: AppKitSidebar(
            shownByDefault: false,
            builder: (context, scrollController) {
              return Container();
            },
            minWidth: 150),
        sidebar: AppKitSidebar(
            top: AppKitComboBox(
              placeholder: 'Search...',
              items: const [
                'Push Button',
                'Toggle Button',
                'Combo Button',
                'ComboBox Button',
                'Popup/Pulldown Button',
                'Controls',
                'Indicators',
                'Sliders',
                'Dialogs',
                'Context Menu',
                'Segmented Controls',
                'Tab View',
                'Group Box',
                'Resizable Panel',
                'Toolbar',
                'Sliver Toolbar',
                'Selectors',
                'Colors',
                'Fields',
              ],
              onChanged: (value) {
                if (value.isEmpty) return;
                setState(() {
                  final index = [
                    'Push Button',
                    'Toggle Button',
                    'Combo Button',
                    'ComboBox Button',
                    'Popup/Pulldown Button',
                    'Controls',
                    'Indicators',
                    'Sliders',
                    'Dialogs',
                    'Context Menu',
                    'Segmented Controls',
                    'Tab View',
                    'Group Box',
                    'Resizable Panel',
                    'Toolbar',
                    'Sliver Toolbar',
                    'Selectors',
                    'Colors',
                    'Fields',
                  ].indexOf(value);

                  if (index != -1) {
                    pageIndex = index;
                  }
                });
              },
            ),
            builder: (context, scrollController) {
              return AppKitSidebarItems(
                  scrollController: scrollController,
                  itemSize: AppKitSidebarItemSize.large,
                  items: const [
                    AppKitSidebarItem(
                        label: Text('Buttons'),
                        expandDisclosureItems: true,
                        disclosureItems: [
                          AppKitSidebarItem(label: Text('Push Button')),
                          AppKitSidebarItem(label: Text('Toggle Button')),
                          AppKitSidebarItem(label: Text('Combo Button')),
                          AppKitSidebarItem(label: Text('ComboBox Button')),
                          AppKitSidebarItem(
                              label: Text('Popup/Pulldown Button')),
                        ]),
                    AppKitSidebarItem(
                      label: Text('Controls'),
                    ),
                    AppKitSidebarItem(
                      label: Text('Indicators'),
                    ),
                    AppKitSidebarItem(
                      label: Text('Sliders'),
                    ),
                    AppKitSidebarItem(
                      label: Text('Dialogs'),
                    ),
                    AppKitSidebarItem(
                      label: Text('Context Menu'),
                    ),
                    AppKitSidebarItem(label: Text('Layout'), disclosureItems: [
                      AppKitSidebarItem(
                        label: Text('Segmented Controls'),
                      ),
                      AppKitSidebarItem(
                        label: Text('Tab View'),
                      ),
                      AppKitSidebarItem(
                        label: Text('Group Box'),
                      ),
                      AppKitSidebarItem(label: Text('Resizable Panel')),
                      AppKitSidebarItem(label: Text('Toolbar')),
                      AppKitSidebarItem(label: Text('Sliver Toolbar')),
                    ]),
                    AppKitSidebarItem(label: Text('Selectors')),
                    AppKitSidebarItem(label: Text('Colors')),
                    AppKitSidebarItem(label: Text('Fields')),
                  ],
                  currentIndex: pageIndex,
                  onChanged: (index) {
                    setState(() {
                      pageIndex = index;
                    });
                  });
            },
            minWidth: 200),
        child: [
          const PushButtonPage(),
          const ToggleButtonPage(),
          const ComboButtonPage(),
          const ComboBoxButtonPage(),
          const PopupButtonPage(),
          const ControlsPage(),
          const IndicatorsPage(),
          const SlidersPage(),
          const DialogsViewPage(),
          const ContextMenuPage(),
          const SegmentedControlsPage(),
          const TabViewPage(),
          const GroupedBoxPage(),
          const ResizablePanelPage(),
          const ToolbarPage(),
          const SliverToolbarPage(),
          const SelectorsPage(),
          const ColorsPage(),
          const FieldsPage(),
        ][pageIndex],
      ),
    );
  }
}
