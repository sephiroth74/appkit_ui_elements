import 'package:appkit_ui_elements/appkit_ui_elements.dart';

const _kTabViewRadius = BorderRadius.all(
  Radius.circular(6.0),
);

const _kTabInnerPadding = 36.0;

class AppKitTabView extends StatefulWidget {
  final AppKitTabController controller;
  final List<String>? labels;
  final List<IconData>? icons;
  final List<Widget> children;
  final AppKitTabPosition position;
  final EdgeInsets outerPadding;
  final double innerPadding;
  final BoxConstraints? constraints;
  final BoxDecoration? outerDecoration;
  final BoxDecoration? innerDecoration;
  final ValueChanged<int>? onTabChanged;
  final AppKitSegmentedControlSize size;

  AppKitTabView({
    super.key,
    required this.controller,
    required this.children,
    this.icons,
    this.labels,
    this.constraints,
    this.outerDecoration,
    this.innerDecoration,
    this.innerPadding = _kTabInnerPadding,
    this.outerPadding =
        const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0, bottom: 12.0),
    this.onTabChanged,
    this.position = AppKitTabPosition.top,
    this.size = AppKitSegmentedControlSize.regular,
  })  : assert(children.length == controller.count),
        assert(icons == null || icons.length == children.length),
        assert(labels == null || labels.length == children.length);

  @override
  State<AppKitTabView> createState() => _AppKitTabViewState();
}

class _AppKitTabViewState extends State<AppKitTabView> {
  late List<Widget> _childrenWithKey;

  int? _currentIndex;

  @override
  void initState() {
    super.initState();
    _updateChildren();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleTabControllerTick);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateTabController();
    _currentIndex = widget.controller.index;
  }

  @override
  void didUpdateWidget(covariant AppKitTabView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      _updateTabController();
      _currentIndex = widget.controller.index;
    }
    if (widget.children != oldWidget.children) {
      _updateChildren();
    }
  }

  int get _tabRotation {
    switch (widget.position) {
      case AppKitTabPosition.left:
        return 3;
      case AppKitTabPosition.right:
        return 1;
      case AppKitTabPosition.top:
        return 0;
      case AppKitTabPosition.bottom:
        return 0;
    }
  }

  void _updateTabController() {
    widget.controller.removeListener(_handleTabControllerTick);
    widget.controller.addListener(_handleTabControllerTick);
  }

  void _handleTabControllerTick() {
    if (widget.controller.index != _currentIndex) {
      _currentIndex = widget.controller.index;
    }
    setState(() {
      // Rebuild the children after an index change
      // has completed.
    });
  }

  void _updateChildren() {
    _childrenWithKey = KeyedSubtree.ensureUniqueKeysForList(widget.children);
  }

  _handleSelectionChanged(Set<int> p1, int p2) {
    widget.controller.index = p2;
    widget.onTabChanged?.call(p2);
  }

  @override
  Widget build(BuildContext context) {
    assert(() {
      if (widget.controller.count != widget.children.length) {
        throw FlutterError(
          "Controller's length property (${widget.controller.count}) does not match the "
          "number of tabs (${widget.children.length}) present in TabBar's tabs property.",
        );
      }
      return true;
    }());

    final brightness = AppKitTheme.brightnessOf(context);

    final outerBorderColor = brightness.resolve(
      const Color(0xFFE1E2E4),
      const Color(0xFF3E4045),
    );

    final decoration = widget.outerDecoration ??
        BoxDecoration(
          border: Border.all(
            color: outerBorderColor,
            width: 1.0,
          ),
          borderRadius: _kTabViewRadius,
        );

    return Container(
      constraints: widget.constraints,
      decoration: decoration,
      child: Padding(
        padding: widget.outerPadding,
        child: LayoutBuilder(builder: (context, constraints) {
          return Stack(
            alignment: _alignment,
            children: [
              Builder(builder: (context) {
                return Positioned(
                  top: widget.position == AppKitTabPosition.top ? 0 : null,
                  bottom:
                      widget.position == AppKitTabPosition.bottom ? 0 : null,
                  left: widget.position == AppKitTabPosition.left ? 0 : null,
                  right: widget.position == AppKitTabPosition.right ? 0 : null,
                  child: RotatedBox(
                    quarterTurns: _tabRotation,
                    child: ConstrainedBox(
                      constraints: _getSegmentConstraints(constraints),
                      child: AppKitSegmentedControl(
                        icons: widget.icons,
                        labels: widget.labels,
                        size: widget.size,
                        onSelectionChanged: _handleSelectionChanged,
                        controller: widget.controller,
                      ),
                    ),
                  ),
                );
              }),
              Padding(
                padding: _innerPadding,
                child: DecoratedBox(
                  decoration: widget.innerDecoration ??
                      BoxDecoration(
                        color: brightness.resolve(
                          const Color(0x77e8eaee),
                          const Color(0x772B2E33),
                        ),
                        border: Border.all(
                          color: outerBorderColor,
                          width: 1.0,
                        ),
                        borderRadius: _kTabViewRadius,
                      ),
                  child: IndexedStack(
                    sizing: StackFit.loose,
                    index: _currentIndex,
                    children: _childrenWithKey,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  BoxConstraints _getSegmentConstraints(BoxConstraints constraints) {
    switch (widget.position) {
      case AppKitTabPosition.left:
      case AppKitTabPosition.right:
        return BoxConstraints.tightForFinite(width: constraints.maxHeight);
      case AppKitTabPosition.top:
      case AppKitTabPosition.bottom:
        return BoxConstraints.tightForFinite(width: constraints.maxWidth);
    }
  }

  AlignmentGeometry get _alignment {
    switch (widget.position) {
      case AppKitTabPosition.left:
        return Alignment.centerLeft;
      case AppKitTabPosition.right:
        return Alignment.centerRight;
      case AppKitTabPosition.top:
        return Alignment.topCenter;
      case AppKitTabPosition.bottom:
        return Alignment.bottomCenter;
    }
  }

  EdgeInsetsGeometry get _innerPadding {
    switch (widget.position) {
      case AppKitTabPosition.left:
        return EdgeInsets.only(left: widget.innerPadding);
      case AppKitTabPosition.right:
        return EdgeInsets.only(right: widget.innerPadding);
      case AppKitTabPosition.top:
        return EdgeInsets.only(top: widget.innerPadding);
      case AppKitTabPosition.bottom:
        return EdgeInsets.only(bottom: widget.innerPadding);
    }
  }
}

enum AppKitTabPosition {
  left,
  right,
  top,
  bottom,
}
