import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppKitToolbarOverflowMenuItem extends StatefulWidget {
  const AppKitToolbarOverflowMenuItem({
    super.key,
    this.onPressed,
    required this.label,
    this.subMenuItems,
    this.isSelected,
  });

  final VoidCallback? onPressed;

  final String label;

  final List<AppKitToolbarOverflowMenuItem>? subMenuItems;

  final bool? isSelected;

  @override
  State<AppKitToolbarOverflowMenuItem> createState() =>
      _AppKitToolbarOverflowMenuItemState();
}

class _AppKitToolbarOverflowMenuItemState
    extends State<AppKitToolbarOverflowMenuItem> {
  bool _isHovered = false;

  void _handleFocusChange(bool focused) {
    setState(() {
      if (focused) {
        _isHovered = true;
      } else {
        _isHovered = false;
      }
    });
  }

  void _handleOnTap() {
    Navigator.pop(context);
    widget.onPressed?.call();
  }

  bool get _isHighlighted => _isHovered || widget.isSelected == true;

  Color get _textColor => _isHighlighted
      ? Colors.white
      : AppKitTheme.brightnessOf(context).resolve(
          Colors.black,
          Colors.white,
        );

  @override
  Widget build(BuildContext context) {
    final theme = AppKitTheme.of(context);
    final hasSubMenu =
        widget.subMenuItems != null && widget.subMenuItems!.isNotEmpty;

    Widget child = Container(
      padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
      height: 20.0,
      child: Text(widget.label),
    );
    if (widget.onPressed != null) {
      child = MouseRegion(
        onEnter: (_) {
          setState(() => _isHovered = true);
        },
        onExit: (_) {
          setState(() => _isHovered = false);
        },
        child: GestureDetector(
          onTap: _handleOnTap,
          child: Focus(
            onKeyEvent: (FocusNode node, KeyEvent event) {
              if (event.logicalKey == LogicalKeyboardKey.enter) {
                _handleOnTap();
                return KeyEventResult.handled;
              }
              return KeyEventResult.ignored;
            },
            onFocusChange: _handleFocusChange,
            child: Container(
              decoration: BoxDecoration(
                color: _isHighlighted
                    ? Colors.amber.withOpacity(0.5)
                    : Colors.transparent,
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              ),
              child: DefaultTextStyle(
                style: TextStyle(
                  fontSize: 13.0,
                  color: _textColor,
                ),
                child: (hasSubMenu)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          child,
                          Icon(
                            CupertinoIcons.chevron_right,
                            size: 12.0,
                            color: _textColor,
                          ),
                        ],
                      )
                    : child,
              ),
            ),
          ),
        ),
      );
    } else {
      child = DefaultTextStyle(
        style: theme.typography.body.copyWith(
            color: theme.typography.body.color?.multiplyOpacity(0.25)),
        child: child,
      );
    }
    return child;
  }
}
