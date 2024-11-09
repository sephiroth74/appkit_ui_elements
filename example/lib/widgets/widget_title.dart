import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:macos_ui/macos_ui.dart';

class WidgetTitle extends StatelessWidget {
  const WidgetTitle({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: MacosColors.systemGrayColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: Text(
          label,
          style: MacosTypography.of(context).title2.copyWith(
                fontFamily: GoogleFonts.jetBrainsMono().fontFamily,
              ),
        ),
      ),
    );
  }
}
