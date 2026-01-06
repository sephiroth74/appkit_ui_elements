library appkit_ui_elements;

import 'package:appkit_ui_elements/src/utils/debugger.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/find_locale.dart';
import 'package:window_manager/window_manager.dart';

export 'package:dartz/dartz.dart' hide State;
export 'package:flutter/widgets.dart';
export 'package:macos_window_utils/macos_window_utils.dart';

export 'src/library.dart';

class AppKitUiElements {
  static bool useWindowManager = false;

  static Future<void> _initializeWindowManager() async {
    debugPrint('AppKitUiElements::_initializeWindowManager');
    await windowManager.ensureInitialized();
  }

  static Future<void> ensureInitialized({bool debug = false, bool useWindowManager = false}) async {
    debugPrint('AppKitUiElements::ensureInitialized(debug: $debug, useWindowManager: $useWindowManager)');

    AppKitUiElements.useWindowManager = useWindowManager;

    if (useWindowManager) {
      await _initializeWindowManager();
    }

    await findSystemLocale();
    await initializeDateFormatting();
    initLogging(isDebug: debug);
  }
}
