import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/cupertino.dart';

class AppKitToolbarOverflowButton extends StatefulWidget {
  const AppKitToolbarOverflowButton({
    super.key,
    required this.overflowContentBuilder,
    required this.brightness,
    this.isDense = false,
  });

  final ContextMenuBuilder<String> overflowContentBuilder;

  final Brightness brightness;

  final bool isDense;

  @override
  State<AppKitToolbarOverflowButton> createState() =>
      _AppKitToolbarOverflowButtonState();
}

class _AppKitToolbarOverflowButtonState
    extends State<AppKitToolbarOverflowButton> {
  void _showOverflowMenu() async {
    final itemRect = context.getWidgetBounds();
    const menuEdge = AppKitMenuEdge.bottom;
    final contextMenu = widget.overflowContentBuilder(context);

    if (null != itemRect) {
      final menu = contextMenu.copyWith(
          position: contextMenu.position ?? menuEdge.getRectPosition(itemRect));
      setState(() {});

      final _ = await showContextMenu<String>(
        context,
        contextMenu: menu,
        transitionDuration: kContextMenuTrasitionDuration,
        barrierDismissible: true,
        opaque: false,
        menuEdge: menuEdge,
        enableWallpaperTinting: false,
      );

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppKitToolBarIconButton(
      label: "",
      icon: CupertinoIcons.chevron_right_2,
      showLabel: widget.isDense,
      onPressed: _showOverflowMenu,
    ).build(context, brightness: widget.brightness);
  }
}
