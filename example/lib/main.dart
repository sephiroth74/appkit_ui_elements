import 'dart:io';

import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:example/pages/push_button_page.dart';
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
            builder: (context, scrollController) {
              return SidebarItems(
                  scrollController: scrollController,
                  items: const [
                    SidebarItem(label: Text('Push Button')),
                    SidebarItem(label: Text('Toggle Button')),
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
        ][pageIndex],
      ),
    );
  }
}
