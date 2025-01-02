import 'package:appkit_ui_elements/src/controls/appkit_custom_painter_button.dart';

class AppKitArrowButton extends AppKitCustomPainterButton {
  const AppKitArrowButton({
    super.key,
    super.color,
    super.size,
    super.semanticLabel,
    super.onPressed,
  }) : super(icon: AppKitControlButtonIcon.arrows);
}
