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
import 'package:example/pages/popup_button_page.dart';
import 'package:example/pages/push_button_page.dart';
import 'package:example/pages/resizable_panel_page.dart';
import 'package:example/pages/segmented_controls_page.dart';
import 'package:example/pages/selectors_page.dart';
import 'package:example/pages/sliders_page.dart';
import 'package:example/pages/tab_view_page.dart';
import 'package:example/pages/toggle_button_page.dart';
import 'package:example/pages/toolbar_page.dart';
import 'package:example/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> _configureMacosWindowUtils() async {
  const config2 = AppKitWindowUtilsConfig();
  config2.apply();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  assert(Platform.isMacOS && !kIsWeb,
      'This example is intended to run on macOS desktop only.');
  await _configureMacosWindowUtils();
  await AppKitUiElements.ensureInitialized();
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

  @override
  Widget build(BuildContext context) {
    return PlatformMenuBar(
      menus: const [],
      child: AppKitWindow(
        sidebar: AppKitSidebar(
            // top: const AppKitSearchField(),
            builder: (context, scrollController) {
              return AppKitSidebarItems(
                  scrollController: scrollController,
                  itemSize: AppKitSidebarItemSize.large,
                  textColor:
                      AppKitColors.text.opaque.primary.resolveFrom(context),
                  selectedTextColor:
                      AppKitColors.text.opaque.primary.resolveFrom(context),
                  iconColor: AppKitTheme.of(context).primaryColor,
                  selectedIconColor: AppKitTheme.of(context).primaryColor,
                  selectedColor:
                      AppKitColors.text.opaque.quaternary.resolveFrom(context),
                  items: const [
                    AppKitSidebarItem(label: Text('Buttons'), disclosureItems: [
                      AppKitSidebarItem(label: Text('Push Button')),
                      AppKitSidebarItem(label: Text('Toggle Button')),
                      AppKitSidebarItem(label: Text('Combo Button')),
                      AppKitSidebarItem(label: Text('ComboBox Button')),
                      AppKitSidebarItem(label: Text('Popup/Pulldown Button')),
                    ]),
                    AppKitSidebarItem(
                        label: Text('Controls'),
                        leading: AppKitIcon(
                            icon: Icons.radio_button_checked, size: 13)),
                    AppKitSidebarItem(
                        label: Text('Indicators'),
                        leading: AppKitIcon(
                            icon: CupertinoIcons.circle_grid_hex, size: 13)),
                    AppKitSidebarItem(
                        label: Text('Sliders'),
                        leading: AppKitIcon(
                            icon: CupertinoIcons.slider_horizontal_3,
                            size: 13)),
                    AppKitSidebarItem(
                        label: Text('Dialogs'),
                        leading:
                            AppKitIcon(icon: Icons.window_outlined, size: 13)),
                    AppKitSidebarItem(label: Text('Layout'), disclosureItems: [
                      AppKitSidebarItem(
                        label: Text('Segmented Controls'),
                        leading: AppKitIcon(
                            icon: CupertinoIcons.rectangle_stack_badge_minus,
                            size: 13),
                      ),
                      AppKitSidebarItem(
                        label: Text('Tab View'),
                        leading: AppKitIcon(
                            icon: CupertinoIcons.uiwindow_split_2x1, size: 13),
                      ),
                      AppKitSidebarItem(
                        label: Text('Group Box'),
                        leading: AppKitIcon(
                            icon: CupertinoIcons.rectangle_3_offgrid_fill,
                            size: 13),
                      ),
                      AppKitSidebarItem(
                          leading: AppKitIcon(
                              icon: CupertinoIcons.rectangle_split_3x1,
                              size: 13),
                          label: Text('Resizable Panel')),
                      AppKitSidebarItem(
                          leading: AppKitIcon(
                              icon: CupertinoIcons.macwindow, size: 13),
                          label: Text('Toolbar')),
                    ]),
                    AppKitSidebarItem(
                        label: Text('Selectors'),
                        leading: AppKitIcon(
                            icon: Icons.date_range_outlined, size: 13)),
                    AppKitSidebarItem(
                        label: Text('Colors'),
                        leading: AppKitIcon(
                            icon: CupertinoIcons.paintbrush, size: 13)),
                    AppKitSidebarItem(
                        leading: AppKitIcon(
                          icon: Icons.text_fields,
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
          const ToolbarPage(),
          const SelectorsPage(),
          const ColorsPage(),
          const FieldsPage(),
        ][pageIndex],
      ),
    );
  }
}
