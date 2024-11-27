import 'dart:math';

import 'package:appkit_ui_element_colors/appkit_ui_element_colors.dart';
import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:appkit_ui_elements/src/utils/appkit_logger.dart';
import 'package:appkit_ui_elements/src/utils/utils.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

typedef ContextMenuBuilder<T> = AppKitContextMenu<T> Function(
    BuildContext context);

class AppKitPopupButton<T> extends StatefulWidget {
  final ContextMenuBuilder<T>? menuBuilder;
  final T? value;
  final ValueChanged<T?>? onSelected;

  const AppKitPopupButton({
    super.key,
    this.menuBuilder,
    this.value,
    this.onSelected,
  });

  @override
  State<AppKitPopupButton<T>> createState() => _AppKitPopupButtonState<T>();
}

class _AppKitPopupButtonState<T> extends State<AppKitPopupButton<T>> {
  _PopupRoute<T>? _route;

  bool get enabled => widget.onSelected != null && widget.menuBuilder != null;

  @override
  void dispose() {
    _route?._dismiss();
    _route = null;
    super.dispose();
  }

  void handleTap() async {
    logger.i('handleTap');
    final itemRect = context.getWidgetBounds();
    if (null != itemRect && widget.menuBuilder != null) {
      final contextMenu = widget.menuBuilder!(context);
      final menu = contextMenu.copyWith(
          position: contextMenu.position ?? itemRect.bottomLeft);
      final value = await showContextMenu(
        context,
        contextMenu: menu,
        transitionDuration: const Duration(milliseconds: 1000),
        barrierDismissible: true,
        opaque: false,
      );
      logger.t('value: $value');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? handleTap : null,
      child: Container(
        width: 100,
        height: 22,
        decoration: BoxDecoration(
          color: const Color(0xFFE0E0E0),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

class _PopupRoute<T> extends PopupRoute {
  final Rect parentRect;
  final ContextMenuBuilder menuBuilder;
  final T? value;

  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String? barrierLabel;

  _PopupRoute({
    required this.parentRect,
    required this.menuBuilder,
    this.value,
  });

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        logger.i('_PopupRoute:LayoutBuilder:constraints: $constraints');

        return MediaQuery.removePadding(
          context: context,
          removeTop: true,
          removeBottom: true,
          removeLeft: true,
          removeRight: true,
          child: _PopupMenu(
              parentRect: parentRect,
              /*route: this, */ menuBuilder: menuBuilder,
              value: value),
        );
      },
    );
  }

  void _dismiss() {
    if (isActive) navigator?.removeRoute(this);
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);
}

class _PopupMenu<T> extends StatefulWidget {
  final Rect parentRect;
  // final PopupRoute<dynamic> route;
  final ContextMenuBuilder<T> menuBuilder;
  final T? value;

  const _PopupMenu({
    required this.parentRect,
    // required this.route,
    required this.menuBuilder,
    this.value,
  });

  @override
  State<_PopupMenu> createState() => _PopupMenuState<T>();
}

class _PopupMenuState<T> extends State<_PopupMenu>
    with SingleTickerProviderStateMixin {
  Size? _childSize;
  late CurvedAnimation _fadeOpacity;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _fadeOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.25),
      reverseCurve: const Interval(0.75, 1.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomSingleChildLayout(
      delegate: _PopupLayoutDelegate(
          childSize: _childSize, parentRect: widget.parentRect),
      child: Stack(
        fit: StackFit.loose,
        children: [
          AppKitMeasureSingleChildWidget(
            onLayout: (size) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  logger.t('child size: $size');
                  _childSize = size;
                });
              });
            },
            child: FadeTransition(
              opacity: _fadeOpacity,
              child: AppKitOverlayFilterWidget(
                backgroundBlur: 80,
                borderRadius: BorderRadius.circular(6),
                color: AppKitColors.materials.medium.withOpacity(1.0),
                child: Builder(builder: (context) {
                  return const SizedBox();
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PopupLayoutDelegate extends SingleChildLayoutDelegate {
  final Size? childSize;
  final Rect parentRect;

  _PopupLayoutDelegate({required this.childSize, required this.parentRect});

  @override
  Offset getPositionForChild(Size size, Size _) {
    logger.i(
        '_PopupLayoutDelegate:getPositionForChild:size: $size, childSize: $childSize');

    if (childSize != null) {
      if (parentRect.centerRight.dx + childSize!.width < size.width) {
        logger.t('parent center right');
        return parentRect.topRight;
      } else if (parentRect.centerLeft.dx - childSize!.width > 0) {
        logger.t('parent center left');
        return parentRect.centerLeft - Offset(childSize!.width, 0);
      } else {
        logger.t('parent top center');
        return parentRect.topCenter -
            Offset(childSize!.width / 2, childSize!.height);
      }
    }

    return parentRect.topRight;
  }

  @override
  Size getSize(BoxConstraints constraints) {
    logger.i(
        '_PopupLayoutDelegate:getSize: $constraints, childSize: $childSize, parentRect: $parentRect');

    if (null != childSize) {
      return Size(min(max(childSize!.width, 100), constraints.maxWidth),
          min(childSize!.height, constraints.maxHeight));
    }

    return Size.zero;
  }

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return constraints;
  }

  @override
  bool shouldRelayout(covariant SingleChildLayoutDelegate oldDelegate) {
    logger.i('_PopupLayoutDelegate:shouldRelayout');
    return (oldDelegate is _PopupLayoutDelegate &&
            oldDelegate.childSize != childSize) ||
        childSize == null;
  }
}

class RenderMenuItem extends RenderProxyBox {
  RenderMenuItem(this.onLayout, [RenderBox? child]) : super(child);

  ValueChanged<Size> onLayout;

  @override
  void performLayout() {
    super.performLayout();
    onLayout(size);
  }
}

abstract class MenuEntry<T> {
  final bool enabled;

  MenuEntry({required this.enabled});
}

// ignore: must_be_immutable
final class Menu<T> {
  final List<MenuEntry<T>> children;
  Menu({required this.children});
}

class MenuItemDivider<T> extends MenuEntry<T> {
  MenuItemDivider() : super(enabled: false);
}

class MenuItem<T> extends MenuEntry<T> {
  final String title;
  final IconData? image;
  final IconData? onImage;
  final IconData? offImage;
  final T value;
  final MenuItemState state;
  final AlignmentGeometry imageAlignment;
  final TextAlign textAlign;

  MenuItem({
    required this.title,
    required this.value,
    this.image,
    this.onImage,
    this.offImage,
    super.enabled = true,
    this.state = MenuItemState.off,
    this.imageAlignment = Alignment.centerRight,
    this.textAlign = TextAlign.left,
  });
}

class SubMenu<T> extends MenuEntry<T> {
  final String title;
  final ContextMenuBuilder<T> menuBuilder;

  SubMenu({
    required this.title,
    required this.menuBuilder,
    super.enabled = true,
  });
}

enum MenuItemState {
  on,
  off,
  mixed;

  bool get isOn => this == MenuItemState.on;
  bool get isOff => this == MenuItemState.off;
  bool get isMixed => this == MenuItemState.mixed;
}

// ignore: must_be_immutable
class _MenuRenderer<T> extends StatefulWidget {
  final List<MenuEntry<T>> children;
  final int selectedIndex;

  _MenuRenderer.fromMenu(
      {super.key, required Menu<T> menu, this.selectedIndex = -1})
      : children = menu.children;

  const _MenuRenderer({
    super.key,
    required this.children,
    this.selectedIndex = -1,
  });

  @override
  State<_MenuRenderer<T>> createState() => _MenuRendererState<T>();
}

class _MenuRendererState<T> extends State<_MenuRenderer<T>> {
  late int _selectedIndex = widget.selectedIndex;

  _PopupRoute<T>? _route;

  void onOpenSubMenu(ContextMenuBuilder<T> menuBuilder) {
    logger.i('onOpenSubMenu');
    final RenderBox itemBox = context.findRenderObject()! as RenderBox;
    final Offset itemRect = itemBox.localToGlobal(Offset.zero);

    final widgetRect = Rect.fromLTRB(
      itemRect.dx,
      itemRect.dy,
      itemRect.dx + itemBox.size.width,
      itemRect.dy + itemBox.size.height,
    );

    logger.t('widgetRect: $widgetRect');

    _route = _PopupRoute<T>(
        parentRect: widgetRect, menuBuilder: menuBuilder, value: null);
    final NavigatorState navigator = Navigator.of(context);
    navigator.push(_route!).then((value) {
      logger.t('route completed: $value');
      _route?._dismiss();
      _route = null;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  void _handlePointerEvent(PointerEvent event) {
    debugPrint('pointer event: $event');
    // check if the pointer event is over one of the menu items
    // if not, close the menu

    final box = context.findRenderObject();
    debugPrint('box: $box');
  }

  @override
  void dispose() {
    _route?._dismiss();
    _route = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UiElementColorBuilder(builder: (context, colorContainer) {
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: IntrinsicWidth(
          child: Container(
            constraints: const BoxConstraints(minWidth: 150),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.children.mapIndexed((index, entry) {
                final bool selected = _selectedIndex == index && entry.enabled;
                debugPrint(
                    'index: $index, selected: $selected, entry: $entry, enabled: ${entry.enabled}');
                if (entry is MenuItem<T>) {
                  return _MenuItemRenderer(
                    title: entry.title,
                    image: entry.image,
                    enabled: entry.enabled,
                    state: entry.state,
                    selected: selected,
                    imageAlignment: entry.imageAlignment,
                    textAlign: entry.textAlign,
                    onImage: entry.onImage,
                    offImage: entry.offImage,
                    onEnter: (event) {
                      setState(() {
                        debugPrint('onEnter: $index');
                        _selectedIndex = index;
                      });
                    },
                    onExit: (event) {},
                  );
                } else if (entry is MenuItemDivider<T>) {
                  return const Divider(
                    thickness: 0.5,
                    indent: 6,
                    endIndent: 6,
                  );
                } else if (entry is SubMenu<T>) {
                  return _MenuItemRenderer(
                    title: entry.title,
                    hasSubMenu: true,
                    enabled: entry.enabled,
                    state: MenuItemState.off,
                    selected: selected,
                    onEnter: (event) {
                      setState(() {
                        debugPrint('onEnter: $index');
                        _route?._dismiss();
                        _route = null;

                        _selectedIndex = index;
                        onOpenSubMenu(entry.menuBuilder);
                      });
                    },
                    onExit: (event) {
                      debugPrint('onExit: $index');
                      // _route?._dismiss();
                      // _route = null;
                    },
                  );
                } else {
                  return const SizedBox();
                }
              }).toList(),
            ),
          ),
        ),
      );
    });
  }
}

class _MenuItemRenderer extends StatelessWidget {
  final String title;
  final IconData? image;
  final IconData? onImage;
  final IconData? offImage;
  final bool enabled;
  final MenuItemState state;
  final AlignmentGeometry imageAlignment;
  final TextAlign textAlign;
  final bool selected;
  final PointerEnterEventListener? onEnter;
  final PointerExitEventListener? onExit;
  final bool hasSubMenu;

  const _MenuItemRenderer({
    required this.title,
    this.image,
    this.onImage,
    this.offImage,
    this.enabled = true,
    this.state = MenuItemState.off,
    this.imageAlignment = Alignment.centerRight,
    this.textAlign = TextAlign.left,
    this.selected = false,
    this.hasSubMenu = false,
    this.onEnter,
    this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppKitTheme.of(context);

    final IconData icon;
    if (state == MenuItemState.on) {
      icon = onImage ?? CupertinoIcons.check_mark;
    } else if (state == MenuItemState.off) {
      icon = offImage ?? CupertinoIcons.check_mark;
    } else {
      icon = image ?? CupertinoIcons.minus;
    }

    Color textColor = selected && enabled
        ? AppKitColors.labelColor.darkColor
        : AppKitColors.labelColor;
    if (!enabled) {
      textColor = textColor.withOpacity(0.3);
    }

    final Color iconColor = state.isOff ? Colors.transparent : textColor;

    return MouseRegion(
      onEnter: enabled ? onEnter : null,
      onExit: enabled ? onExit : null,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: selected
              ? AppKitColors.systemBlue.color.withOpacity(0.7)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 3.0, top: 3.0, right: 12.0, bottom: 3.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 3.0),
                child: Icon(
                  icon,
                  size: 12,
                  color: iconColor,
                ),
              ),
              const SizedBox(width: 4),
              if (image != null && imageAlignment == Alignment.centerLeft) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 3.0, right: 4.0),
                  child: Icon(
                    image,
                    size: 12,
                    color: iconColor,
                  ),
                ),
              ],
              Text(
                textAlign: textAlign,
                softWrap: true,
                title,
                maxLines: 1,
                style: theme.typography.body.copyWith(
                  fontSize: 13,
                  color: textColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              if (image != null && imageAlignment == Alignment.centerRight) ...[
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(top: 3.0, left: 4.0),
                  child: Icon(
                    image,
                    size: 12,
                    color: iconColor,
                  ),
                ),
              ],
              if (hasSubMenu) ...[
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(top: 3.0, left: 4.0),
                  child: Icon(
                    CupertinoIcons.right_chevron,
                    size: 12,
                    color: textColor,
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
