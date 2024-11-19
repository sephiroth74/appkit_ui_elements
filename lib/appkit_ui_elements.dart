library appkit_ui_elements;

import 'package:appkit_ui_elements/src/utils/main_window_listener.dart';

export 'src/controls/push_button.dart';
export 'src/controls/toggle_button.dart';
export 'src/controls/checkbox.dart';
export 'src/controls/radio_button.dart';
export 'src/controls/help_button.dart';
export 'src/controls/arrow_button.dart';
export 'src/controls/custom_painter_button.dart';
export 'src/controls/disclosure_button.dart';
export 'src/controls/stepper.dart';
export 'src/controls/slider.dart';
export 'src/controls/segmented_control.dart';
export 'src/controls/switch.dart';
export 'src/controls/progress_bar.dart';
export 'src/controls/progress_circle.dart';
export 'src/controls/color_well.dart';

export 'src/enums/enums.dart';

export 'src/theme/appkit_theme.dart';
export 'src/theme/appkit_push_button_theme.dart';
export 'src/theme/appkit_toggle_button_theme.dart';
export 'src/theme/appkit_help_button_theme.dart';
export 'src/theme/appkit_slider_theme.dart';
export 'src/theme/appkit_segmented_control_theme.dart';
export 'src/theme/appkit_switch_theme.dart';
export 'src/theme/appkit_progress_theme.dart';
export 'src/theme/appkit_color_well_theme.dart';

class AppKitUiElements {
  static Future<void> ensureInitialized() async {
    MainWindowStateListener.instance;
  }
}
