library appkit_ui_elements;

import 'package:appkit_ui_elements/src/utils/main_window_listener.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

export 'package:dartz/dartz.dart' hide State;
export 'package:flutter/widgets.dart';

export 'src/controls/library.dart';
export 'src/enums/enums.dart';
export 'src/theme/library.dart';
export 'src/utils/library.dart';
export 'src/widgets/library.dart';

class AppKitUiElements {
  static Future<void> ensureInitialized() async {
    Intl.defaultLocale = 'en_US';
    // await findSystemLocale();
    await initializeDateFormatting();
    MainWindowStateListener.instance;
  }
}
