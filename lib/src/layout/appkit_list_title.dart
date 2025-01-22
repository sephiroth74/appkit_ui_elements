import 'package:appkit_ui_elements/appkit_ui_elements.dart';

/// A stateless widget that represents a list tile in the AppKit UI elements library.
///
/// This widget is used to display a single item in a list with a title and optional
/// leading and trailing widgets.
///
/// Example usage:
///
/// ```dart
/// AppKitListTile(
///   leading: Icon(Icons.star),
///   title: Text('List Tile Title'),
/// )
/// ```
///
/// See also:
///
///  * [ListTile], which is a similar widget in the Flutter framework.
class AppKitListTile extends StatelessWidget {
  const AppKitListTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.leadingWhitespace = 8,
    this.onClick,
    this.onLongPress,
    this.mouseCursor = MouseCursor.defer,
  });

  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final double? leadingWhitespace;
  final VoidCallback? onClick;
  final VoidCallback? onLongPress;
  final MouseCursor mouseCursor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      onLongPress: onLongPress,
      child: MouseRegion(
        cursor: mouseCursor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (leading != null) leading!,
            SizedBox(width: leadingWhitespace),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextStyle(
                    style: AppKitTheme.of(context)
                        .typography
                        .headline
                        .copyWith(fontWeight: FontWeight.w600),
                    child: title,
                  ),
                  if (subtitle != null)
                    DefaultTextStyle(
                      style: AppKitTheme.of(context)
                          .typography
                          .subheadline
                          .copyWith(
                            color: AppKitColors.text.opaque.secondary
                                .resolveFromContext(context),
                          ),
                      child: subtitle!,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
