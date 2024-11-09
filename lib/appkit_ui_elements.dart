library appkit_ui_elements;

import 'package:appkit_ui_elements/src/utils/main_window_listener.dart';

export 'src/buttons/push_button.dart';
export 'src/buttons/toggle_button.dart';
export 'src/control/checkbox.dart';
export 'src/enums/enums.dart';
export 'src/theme/appkit_theme.dart';
export 'src/theme/appkit_push_button_theme.dart';
export 'src/theme/appkit_toggle_button_theme.dart';
export 'src/theme/appkit_checkbox_theme.dart';

class AppKitUiElements {
  static Future<void> ensureInitialized() async {
    MainWindowStateListener.instance;
  }
}
