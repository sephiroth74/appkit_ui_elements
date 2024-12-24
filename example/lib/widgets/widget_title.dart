import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:google_fonts/google_fonts.dart';

class WidgetTitle extends StatelessWidget {
  const WidgetTitle({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppKitColors.systemGray.withOpacity(0.5),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: Text(
            label,
            style: AppKitTypography.of(context).title2.copyWith(
                  fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
                ),
          ),
        ),
      ),
    );
  }
}
