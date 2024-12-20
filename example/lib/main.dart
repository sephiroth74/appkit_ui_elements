import 'dart:io';

import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:example/pages/colors_page.dart';
import 'package:example/pages/combo_box_button_page.dart';
import 'package:example/pages/combo_button_page.dart';
import 'package:example/pages/controls_page.dart';
import 'package:example/pages/dialogs_page.dart';
import 'package:example/pages/fields_page.dart';
import 'package:example/pages/group_box_page.dart';
import 'package:example/pages/indicators_page.dart';
import 'package:example/pages/popup_button.dart';
import 'package:example/pages/push_button_page.dart';
import 'package:example/pages/resizable_panel_page.dart';
import 'package:example/pages/segmented_controls_page.dart';
import 'package:example/pages/selectors_page.dart';
import 'package:example/pages/sliders_page.dart';
import 'package:example/pages/tab_view_page.dart';
import 'package:example/pages/toggle_button_page.dart';
import 'package:example/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:provider/provider.dart';

Future<void> _configureMacosWindowUtils() async {
  const config = MacosWindowUtilsConfig();
  await config.apply();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    if (Platform.isMacOS) {
      await _configureMacosWindowUtils();

      await AppKitUiElements.ensureInitialized();
    }
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppTheme(),
      builder: (context, child) {
        final appTheme = context.watch<AppTheme>();
        return MacosApp(
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

  @override
  Widget build(BuildContext context) {
    return PlatformMenuBar(
      menus: const [],
      child: MacosWindow(
        sidebar: Sidebar(
            top: const MacosSearchField(),
            builder: (context, scrollController) {
              return SidebarItems(
                  scrollController: scrollController,
                  items: const [
                    SidebarItem(label: Text('Buttons'), disclosureItems: [
                      SidebarItem(label: Text('Push Button')),
                      SidebarItem(label: Text('Toggle Button')),
                      SidebarItem(label: Text('Combo Button')),
                      SidebarItem(label: Text('ComboBox Button')),
                      SidebarItem(label: Text('Popup/Pulldown Button')),
                    ]),
                    SidebarItem(
                        label: Text('Controls'),
                        leading: Icon(Icons.radio_button_checked, size: 13)),
                    SidebarItem(
                        label: Text('Indicators'),
                        leading:
                            Icon(CupertinoIcons.circle_grid_hex, size: 13)),
                    SidebarItem(
                        label: Text('Sliders'),
                        leading:
                            Icon(CupertinoIcons.slider_horizontal_3, size: 13)),
                    SidebarItem(
                        label: Text('Dialogs'),
                        leading: Icon(Icons.window_outlined, size: 13)),
                    SidebarItem(label: Text('Layout'), disclosureItems: [
                      SidebarItem(
                        label: Text('Segmented Controls'),
                        leading: Icon(
                            CupertinoIcons.rectangle_stack_badge_minus,
                            size: 13),
                      ),
                      SidebarItem(
                        label: Text('Tab View'),
                        leading:
                            Icon(CupertinoIcons.uiwindow_split_2x1, size: 13),
                      ),
                      SidebarItem(
                        label: Text('Group Box'),
                        leading: Icon(CupertinoIcons.rectangle_3_offgrid_fill,
                            size: 13),
                      ),
                      SidebarItem(
                          leading: Icon(CupertinoIcons.rectangle_split_3x1,
                              size: 13),
                          label: Text('Resizable Panel')),
                    ]),
                    SidebarItem(
                        label: Text('Selectors'),
                        leading: Icon(Icons.date_range_outlined, size: 13)),
                    SidebarItem(
                        label: Text('Colors'),
                        leading: Icon(CupertinoIcons.paintbrush, size: 13)),
                    SidebarItem(
                        leading: Icon(
                          Icons.text_fields,
                          size: 13,
                        ),
                        label: Text('Fields')),
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
          const SegmentedControlsPage(),
          const TabViewPage(),
          const GroupedBoxPage(),
          const ResizablePanelPage(),
          const SelectorsPage(),
          const ColorsPage(),
          const FieldsPage(),
        ][pageIndex],
      ),
    );
  }
}
