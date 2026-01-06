import 'package:flutter/widgets.dart';

class AppKitContentArea extends StatelessWidget {
  const AppKitContentArea({required this.builder, this.minWidth = 300})
    : super(key: const Key('appkit_scaffold_content_area'));

  final ScrollableWidgetBuilder? builder;

  final double minWidth;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.expand().copyWith(minWidth: minWidth),
      child: SafeArea(left: false, right: false, child: builder!(context, ScrollController())),
    );
  }
}
