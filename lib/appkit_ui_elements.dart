library appkit_ui_elements;

import 'package:appkit_ui_elements/src/utils/main_window_listener.dart';

export 'src/controls/push_button.dart';
export 'src/controls/toggle_button.dart';
export 'src/controls/checkbox.dart';
export 'src/controls/radio_button.dart';
export 'src/enums/enums.dart';
export 'src/theme/appkit_theme.dart';
export 'src/theme/appkit_push_button_theme.dart';
export 'src/theme/appkit_toggle_button_theme.dart';

class AppKitUiElements {
  static Future<void> ensureInitialized() async {
    MainWindowStateListener.instance;
  }
}
