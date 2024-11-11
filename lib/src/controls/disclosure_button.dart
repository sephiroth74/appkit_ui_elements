import 'package:appkit_ui_elements/src/controls/custom_painter_button.dart';

class AppKitDisclosureButton extends AppKitCustomPainterButton {
  const AppKitDisclosureButton({
    super.key,
    super.color,
    super.size,
    super.semanticLabel,
    super.onPressed,
    required bool isDown,
  }) : super(
            icon: isDown
                ? AppKitControlButtonIcon.disclosureDown
                : AppKitControlButtonIcon.disclosureUp);
}
