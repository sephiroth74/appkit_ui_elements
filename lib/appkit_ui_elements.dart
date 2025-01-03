library appkit_ui_elements;

import 'package:appkit_ui_elements/src/utils/appkit_main_window_listener.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/find_locale.dart';

export 'package:dartz/dartz.dart' hide State;
export 'package:flutter/widgets.dart';
export 'package:macos_window_utils/macos_window_utils.dart';

export 'src/library.dart';

class AppKitUiElements {
  static Future<void> ensureInitialized() async {
    await findSystemLocale();
    await initializeDateFormatting();
    MainWindowStateListener.instance;
  }
}
