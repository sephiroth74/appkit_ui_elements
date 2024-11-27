library appkit_ui_elements;

import 'package:appkit_ui_elements/src/utils/main_window_listener.dart';

export 'src/controls/library.dart';
export 'src/enums/enums.dart';
export 'src/theme/library.dart';
export 'src/widgets/library.dart';

class AppKitUiElements {
  static Future<void> ensureInitialized() async {
    MainWindowStateListener.instance;
  }
}
