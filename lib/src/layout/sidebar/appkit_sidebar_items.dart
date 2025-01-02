import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const Duration _kExpand = Duration(milliseconds: 200);
const ShapeBorder _defaultShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.all(Radius.circular(4.0)),
);

enum AppKitSidebarItemSize {
  small(24.0, 12.0),
  medium(29.0, 16.0),
  large(36.0, 18.0);

  const AppKitSidebarItemSize(
    this.height,
    this.iconSize,
  );

  final double height;

  final double iconSize;
}

class AppKitSidebarItems extends StatelessWidget {
  const AppKitSidebarItems({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onChanged,
    this.itemSize = AppKitSidebarItemSize.medium,
    this.scrollController,
    this.selectedColor,
    this.unselectedColor,
    this.shape,
    this.textColor,
    this.selectedTextColor,
    this.iconColor,
    this.selectedIconColor,
    this.cursor = SystemMouseCursors.basic,
  }) : assert(currentIndex >= 0);

  final List<AppKitSidebarItem> items;

  final int currentIndex;

  final ValueChanged<int> onChanged;

  final AppKitSidebarItemSize itemSize;

  final ScrollController? scrollController;

  final Color? selectedColor;

  final Color? unselectedColor;
  final Color? textColor;
  final Color? selectedTextColor;
  final Color? iconColor;
  final Color? selectedIconColor;

  final ShapeBorder? shape;

  final MouseCursor? cursor;

  AppKitAccentColor _getAccentColor(BuildContext context) =>
      AppKitTheme.of(context).accentColor;

  List<AppKitSidebarItem> get _allItems {
    List<AppKitSidebarItem> result = [];
    for (var element in items) {
      if (element.disclosureItems != null) {
        result.addAll(element.disclosureItems!);
      } else {
        result.add(element);
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();
    assert(debugCheckHasAppKitTheme(context));
    assert(currentIndex < _allItems.length);
    return MainWindowBuilder(builder: (context, isMainWindow) {
      return AppKitIconTheme.merge(
        data: const AppKitIconThemeData(size: 20),
        child: Builder(
          builder: (context) {
            final theme = AppKitTheme.of(context);
            return _SidebarItemsConfiguration(
              selectedColor: selectedColor ?? theme.activeColor,
              unselectedColor: unselectedColor ?? Colors.transparent,
              shape: shape ?? _defaultShape,
              itemSize: itemSize,
              textColor: textColor,
              iconColor: iconColor,
              selectedIconColor: selectedIconColor,
              selectedTextColor: selectedTextColor,
              child: ListView(
                controller: scrollController,
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.all(10.0 - theme.visualDensity.horizontal),
                children: List.generate(items.length, (index) {
                  final item = items[index];
                  if (item.disclosureItems != null) {
                    return MouseRegion(
                      cursor: cursor!,
                      child: _DisclosureSidebarItem(
                        item: item,
                        selectedItem: _allItems[currentIndex],
                        onChanged: (item) {
                          onChanged(_allItems.indexOf(item));
                        },
                      ),
                    );
                  }
                  return MouseRegion(
                    cursor: cursor!,
                    child: _SidebarItem(
                      item: item,
                      selected: _allItems[currentIndex] == item,
                      onClick: () => onChanged(_allItems.indexOf(item)),
                    ),
                  );
                }),
              ),
            );
          },
        ),
      );
    });
  }
}

class _SidebarItemsConfiguration extends InheritedWidget {
  // ignore: use_super_parameters
  const _SidebarItemsConfiguration({
    Key? key,
    required super.child,
    this.selectedColor = Colors.transparent,
    this.unselectedColor = Colors.transparent,
    this.shape = _defaultShape,
    this.itemSize = AppKitSidebarItemSize.medium,
    this.textColor,
    this.selectedTextColor,
    this.iconColor,
    this.selectedIconColor,
  }) : super(key: key);

  final Color? textColor;
  final Color? selectedTextColor;
  final Color? iconColor;
  final Color? selectedIconColor;
  final Color selectedColor;
  final Color unselectedColor;
  final ShapeBorder shape;
  final AppKitSidebarItemSize itemSize;

  static _SidebarItemsConfiguration of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_SidebarItemsConfiguration>()!;
  }

  @override
  bool updateShouldNotify(_SidebarItemsConfiguration oldWidget) {
    return true;
  }
}

class _SidebarItem extends StatelessWidget {
  /// Builds a [_SidebarItem].
  // ignore: use_super_parameters
  const _SidebarItem({
    Key? key,
    required this.item,
    required this.onClick,
    required this.selected,
  }) : super(key: key);

  final AppKitSidebarItem item;

  final bool selected;

  final VoidCallback? onClick;

  void _handleActionTap() => onClick?.call();

  Map<Type, Action<Intent>> get _actionMap => <Type, Action<Intent>>{
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (ActivateIntent intent) => _handleActionTap(),
        ),
        ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
          onInvoke: (ButtonActivateIntent intent) => _handleActionTap(),
        ),
      };

  bool get hasLeading => item.leading != null;
  bool get hasTrailing => item.trailing != null;

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasAppKitTheme(context));
    final theme = AppKitTheme.of(context);

    final selectedColor = item.selectedColor ??
        _SidebarItemsConfiguration.of(context).selectedColor;
    final unselectedColor = item.unselectedColor ??
        _SidebarItemsConfiguration.of(context).unselectedColor;

    final selectedTextColor = item.selectedTextColor ??
        _SidebarItemsConfiguration.of(context).selectedTextColor;
    final unselectedTextColor =
        item.textColor ?? _SidebarItemsConfiguration.of(context).textColor;

    final selectedIconColor = item.selectedIconColor ??
        _SidebarItemsConfiguration.of(context).selectedIconColor;
    final unselectedIconColor =
        item.iconColor ?? _SidebarItemsConfiguration.of(context).iconColor;

    final double spacing = 10.0 + theme.visualDensity.horizontal;
    final itemSize = _SidebarItemsConfiguration.of(context).itemSize;
    TextStyle? labelStyle;
    switch (itemSize) {
      case AppKitSidebarItemSize.small:
        labelStyle = theme.typography.subheadline;
        break;
      case AppKitSidebarItemSize.medium:
        labelStyle = theme.typography.body;
        break;
      case AppKitSidebarItemSize.large:
        labelStyle = theme.typography.title3;
        break;
    }

    final Color? iconColor;
    if (selected) {
      iconColor = selectedIconColor ??
          (selectedColor.computeLuminance() >= 0.5
              ? CupertinoColors.black
              : CupertinoColors.white);
    } else {
      iconColor = unselectedIconColor ?? theme.primaryColor;
    }

    final Color? textColor = selected
        ? selectedTextColor ?? _textLuminance(selectedColor)
        : unselectedTextColor;

    return Semantics(
      label: item.semanticLabel,
      button: true,
      focusable: true,
      focused: item.focusNode?.hasFocus,
      enabled: onClick != null,
      selected: selected,
      child: GestureDetector(
        onTap: onClick,
        child: FocusableActionDetector(
          focusNode: item.focusNode,
          descendantsAreFocusable: false,
          enabled: onClick != null,
          //mouseCursor: SystemMouseCursors.basic,
          actions: _actionMap,
          child: Container(
            width: 134.0 + theme.visualDensity.horizontal,
            height: itemSize.height + theme.visualDensity.vertical,
            decoration: ShapeDecoration(
              color: selected ? selectedColor : unselectedColor,
              shape: item.shape ?? _SidebarItemsConfiguration.of(context).shape,
            ),
            padding: EdgeInsets.symmetric(
              vertical: 7 + theme.visualDensity.horizontal,
              horizontal: spacing,
            ),
            child: Row(
              children: [
                if (hasLeading)
                  Padding(
                    padding: EdgeInsets.only(right: spacing),
                    child: AppKitIconTheme.merge(
                      data: AppKitIconThemeData(
                        color: iconColor,
                        size: itemSize.iconSize,
                      ),
                      child: item.leading!,
                    ),
                  ),
                Expanded(
                  child: DefaultTextStyle(
                    style: labelStyle.copyWith(
                      color: textColor,
                      overflow: TextOverflow.ellipsis,
                    ),
                    child: item.label,
                  ),
                ),
                if (hasTrailing) ...[
                  const Spacer(),
                  DefaultTextStyle(
                    style: labelStyle.copyWith(
                      color: textColor,
                    ),
                    child: item.trailing!,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DisclosureSidebarItem extends StatefulWidget {
  // ignore: use_super_parameters
  _DisclosureSidebarItem({
    Key? key,
    required this.item,
    this.selectedItem,
    this.onChanged,
  })  : assert(item.disclosureItems != null),
        super(key: key);

  final AppKitSidebarItem item;

  final AppKitSidebarItem? selectedItem;

  final ValueChanged<AppKitSidebarItem>? onChanged;

  @override
  __DisclosureSidebarItemState createState() => __DisclosureSidebarItemState();
}

class __DisclosureSidebarItemState extends State<_DisclosureSidebarItem>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.25);

  late AnimationController _controller;
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;
  late bool _isExpanded;

  bool get hasLeading => widget.item.leading != null;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));

    _isExpanded = widget.item.expandDisclosureItems;
    if (_isExpanded) {
      _controller.forward();
    }
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) return;
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
      PageStorage.of(context).writeState(context, _isExpanded);
    });
    // widget.onExpansionChanged?.call(_isExpanded);
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    final theme = AppKitTheme.of(context);
    final double spacing = 10.0 + theme.visualDensity.horizontal;

    final itemSize = _SidebarItemsConfiguration.of(context).itemSize;
    TextStyle? labelStyle;
    switch (itemSize) {
      case AppKitSidebarItemSize.small:
        labelStyle = theme.typography.subheadline;
        break;
      case AppKitSidebarItemSize.medium:
        labelStyle = theme.typography.body;
        break;
      case AppKitSidebarItemSize.large:
        labelStyle = theme.typography.title3;
        break;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: double.infinity,
          child: _SidebarItem(
            item: AppKitSidebarItem(
              label: widget.item.label,
              leading: Row(
                children: [
                  RotationTransition(
                    turns: _iconTurns,
                    child: Icon(
                      CupertinoIcons.chevron_right,
                      size: 12.0,
                      color: theme.brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                    ),
                  ),
                  if (hasLeading)
                    Padding(
                      padding: EdgeInsets.only(left: spacing),
                      child: AppKitIconTheme.merge(
                        data: AppKitIconThemeData(size: itemSize.iconSize),
                        child: widget.item.leading!,
                      ),
                    ),
                ],
              ),
              unselectedColor: Colors.transparent,
              focusNode: widget.item.focusNode,
              semanticLabel: widget.item.semanticLabel,
              shape: widget.item.shape,
              trailing: widget.item.trailing,
            ),
            onClick: _handleTap,
            selected: false,
          ),
        ),
        ClipRect(
          child: DefaultTextStyle(
            style: labelStyle,
            child: Align(
              alignment: Alignment.centerLeft,
              heightFactor: _heightFactor.value,
              child: child,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasAppKitTheme(context));
    final theme = AppKitTheme.of(context);

    final bool closed = !_isExpanded && _controller.isDismissed;

    final Widget result = Offstage(
      offstage: closed,
      child: TickerMode(
        enabled: !closed,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.item.disclosureItems!.map((item) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24.0 + theme.visualDensity.horizontal,
              ),
              child: SizedBox(
                width: double.infinity,
                child: _SidebarItem(
                  item: item,
                  onClick: () => widget.onChanged?.call(item),
                  selected: widget.selectedItem == item,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );

    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: closed ? null : result,
    );
  }
}

Color _textLuminance(Color backgroundColor) {
  return backgroundColor.computeLuminance() >= 0.5
      ? CupertinoColors.black
      : CupertinoColors.white;
}
