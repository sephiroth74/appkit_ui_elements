import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';

@protected
const kContextMenuTrasitionDuration = Duration(milliseconds: 200);

typedef ContextMenuBuilder<T> = AppKitContextMenu<T> Function(
    BuildContext context);

typedef SelectedItemBuilder<T> = Widget Function(
    BuildContext context, T? value);

@protected
List<BoxShadow> getElevatedShadow(BuildContext context) => [
      BoxShadow(
        blurStyle: BlurStyle.outer,
        color: AppKitColors.shadowColor.withValues(alpha: 0.15),
        blurRadius: 0.25,
        spreadRadius: 0.0,
        offset: const Offset(0, 0.25),
      ),
    ];

class AppKitPopupButton<T> extends StatefulWidget {
  final ContextMenuBuilder<T>? menuBuilder;
  final List<AppKitContextMenuEntry<T>>? items;
  final T? selectedItem;
  final ValueChanged<T?>? onItemSelected;
  final SelectedItemBuilder<T>? itemBuilder;
  final AppKitMenuEdge menuEdge;
  final AppKitPopupButtonStyle style;
  final Color? color;
  final String? hint;
  final AppKitControlSize controlSize;
  final String? semanticLabel;
  final FocusNode? focusNode;
  final bool canRequestFocus;
  final bool forceMenuWidth;
  final double? minWidth;
  final double? maxWidth;

  const AppKitPopupButton({
    super.key,
    this.minWidth,
    this.maxWidth,
    this.onItemSelected,
    this.menuBuilder,
    this.items,
    this.selectedItem,
    this.color,
    this.hint,
    this.itemBuilder,
    this.semanticLabel,
    this.focusNode,
    this.menuEdge = AppKitMenuEdge.bottom,
    this.style = AppKitPopupButtonStyle.push,
    this.controlSize = AppKitControlSize.regular,
    this.canRequestFocus = false,
    this.forceMenuWidth = false,
  })  : assert(menuBuilder != null ? items == null : true,
            'Only one of menuBuilder or items can be provided'),
        assert(minWidth == null || maxWidth == null || minWidth <= maxWidth,
            'minWidth must be less than or equal to maxWidth');

  AppKitContextMenu<T>? _defaultMenuBuilder(BuildContext context) {
    return menuBuilder != null
        ? menuBuilder!.call(context)
        : items != null
            ? AppKitContextMenu<T>(entries: items!)
            : null;
  }

  bool get _hasWidth => minWidth != null || maxWidth != null;

  @override
  State<AppKitPopupButton<T>> createState() => _AppKitPopupButtonState<T>();
}

class _AppKitPopupButtonState<T> extends State<AppKitPopupButton<T>>
    with SingleTickerProviderStateMixin {
  bool get enabled =>
      widget.onItemSelected != null &&
      (widget.menuBuilder != null || widget.items != null);

  TextStyle get textStyle => AppKitTheme.of(context).typography.body;

  AppKitPopupButtonStyle get style => widget.style;

  AppKitControlSize get controlSize => widget.controlSize;

  bool _isMenuOpened = false;

  bool _isHovered = false;

  late AppKitContextMenu<T>? _contextMenu;

  FocusNode? _focusNode;

  FocusNode get _effectiveFocusNode =>
      widget.focusNode ?? (_focusNode ??= FocusNode());

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('enabled', enabled));
    properties.add(DiagnosticsProperty('style', style));
    properties.add(DiagnosticsProperty('menuEdge', widget.menuEdge));
    properties.add(DiagnosticsProperty('minWidth', widget.minWidth));
    properties.add(DiagnosticsProperty('maxWidth', widget.maxWidth));
    properties.add(DiagnosticsProperty('menuBuilder', widget.menuBuilder));
    properties.add(DiagnosticsProperty('items', widget.items));
    properties
        .add(DiagnosticsProperty('onItemSelected', widget.onItemSelected));
    properties.add(DiagnosticsProperty('itemBuilder', widget.itemBuilder));
    properties.add(DiagnosticsProperty('color', widget.color));
    properties.add(DiagnosticsProperty('selectedItem', widget.selectedItem));
    properties.add(DiagnosticsProperty('hint', widget.hint));
    properties.add(DiagnosticsProperty('controlSize', widget.controlSize));
    properties.add(DiagnosticsProperty('semanticLabel', widget.semanticLabel));
    properties.add(DiagnosticsProperty('focusNode', widget.focusNode));
    properties
        .add(DiagnosticsProperty('canRequestFocus', widget.canRequestFocus));
  }

  T? get selectedItem => widget.selectedItem;

  @override
  void initState() {
    super.initState();
    _contextMenu = widget._defaultMenuBuilder(context);
    if (widget.selectedItem != null) {
      assert(_contextMenu != null, 'Menu is not initialized');
      assert(_contextMenu!.findItemByValue(selectedItem) != null);
    }

    _effectiveFocusNode.canRequestFocus = widget.canRequestFocus && enabled;
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AppKitPopupButton<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _contextMenu = widget._defaultMenuBuilder(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Widget _defaultItemBuilder(BuildContext context, {required T? selectedItem}) {
    bool isMainWindow = MainWindowStateListener.instance.isMainWindow.value;
    final popupThemeData = AppKitPopupButtonTheme.of(context);
    final currentSelectedItem = _contextMenu?.findItemByValue(selectedItem);

    Widget title = currentSelectedItem?.child ?? Text(widget.hint ?? '');
    EdgeInsets textPadding = EdgeInsets.only(
        left: popupThemeData.sizeData[controlSize]!.textPadding);

    if (selectedItem == null) {
      if (widget.hint == null) {
        return const SizedBox();
      }
    }

    final TextStyle textStyle =
        style.getTextStyle(theme: popupThemeData, controlSize: controlSize);
    Color textColor;

    if (style == AppKitPopupButtonStyle.inline) {
      textColor = (textStyle.color ??
              AppKitDynamicColor.resolve(context, AppKitColors.labelColor))
          .multiplyOpacity(0.7);
      if (!isMainWindow) {
        textColor = textColor.multiplyOpacity(0.5);
      }
    } else {
      textColor = textStyle.color ??
          AppKitDynamicColor.resolve(context, AppKitColors.labelColor);
    }

    if (!enabled) {
      textColor = textColor.multiplyOpacity(0.5);
    }

    return Padding(
      padding: textPadding,
      child: DefaultTextStyle(
        style: textStyle.copyWith(color: textColor),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        child: title,
      ),
    );
  }

  void _handleMouseEnter(_) {
    setState(() {
      _isHovered = true;
    });
  }

  void _handleMouseExit(_) {
    setState(() {
      _isHovered = false;
    });
  }

  void _handleTap() async {
    final itemRect = context.getWidgetBounds();
    if (null != itemRect &&
        (widget.menuBuilder != null || widget.items != null)) {
      AppKitContextMenu<T> menu = widget._defaultMenuBuilder(context)!;
      menu = menu.copyWith(
          minWidth: widget.forceMenuWidth ? itemRect.width : menu.minWidth,
          maxWidth: widget.forceMenuWidth ? itemRect.width : menu.maxWidth,
          position: menu.position ?? widget.menuEdge.getRectPosition(itemRect));

      setState(() {
        if (_effectiveFocusNode.canRequestFocus) {
          FocusScope.of(context).requestFocus(_effectiveFocusNode);
        }
        _isMenuOpened = true;
      });

      final value = await showContextMenu<T>(
        context,
        contextMenu: menu,
        transitionDuration: kContextMenuTrasitionDuration,
        barrierDismissible: true,
        opaque: false,
        selectedItem: selectedItem,
        menuEdge: widget.menuEdge,
        enableWallpaperTinting: false,
      );

      setState(() {
        _isMenuOpened = false;
      });

      if (value != null) {
        widget.onItemSelected?.call(value.value);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    debugCheckHasAppKitTheme(context);

    return MouseRegion(
      onEnter: enabled ? _handleMouseEnter : null,
      onExit: enabled ? _handleMouseExit : null,
      child: GestureDetector(
        onTap: enabled ? _handleTap : null,
        child: Builder(builder: (context) {
          final isMainWindow =
              MainWindowStateListener.instance.isMainWindow.value;
          final popupButtonTheme = AppKitPopupButtonTheme.of(context);
          final height = style.getHeight(
              theme: popupButtonTheme, controlSize: controlSize);
          final menuEdge = widget.menuEdge;
          final itemBuilder = widget.itemBuilder;

          return Focus.withExternalFocusNode(
            focusNode: _effectiveFocusNode,
            child: Builder(builder: (context) {
              final child = itemBuilder?.call(context, widget.selectedItem) ??
                  _defaultItemBuilder(context,
                      selectedItem: widget.selectedItem);

              if (style == AppKitPopupButtonStyle.push ||
                  style == AppKitPopupButtonStyle.bevel) {
                return _PushButtonStyleWidget<T>(
                  minWidth: widget.minWidth,
                  maxWidth: widget.maxWidth,
                  height: height,
                  menuEdge: menuEdge,
                  enabled: enabled,
                  contextMenuOpened: _isMenuOpened,
                  isHovered: _isHovered,
                  isMainWindow: isMainWindow,
                  style: style,
                  controlSize: controlSize,
                  color: widget.color,
                  child: child,
                );
              } else if (style == AppKitPopupButtonStyle.plain) {
                return _PlainButtonStyleWidget<T>(
                  minWidth: widget.minWidth,
                  maxWidth: widget.maxWidth,
                  height: height,
                  menuEdge: menuEdge,
                  enabled: enabled,
                  contextMenuOpened: _isMenuOpened,
                  isMainWindow: isMainWindow,
                  controlSize: controlSize,
                  isHovered: _isHovered,
                  child: child,
                );
              } else if (style == AppKitPopupButtonStyle.inline) {
                return _InlineButtonStyleWidget<T>(
                  minWidth: widget.minWidth,
                  maxWidth: widget.maxWidth,
                  height: height,
                  menuEdge: menuEdge,
                  enabled: enabled,
                  contextMenuOpened: _isMenuOpened,
                  controlSize: controlSize,
                  isMainWindow: isMainWindow,
                  isHovered: _isHovered,
                  child: child,
                );
              }

              return const SizedBox();
            }),
          );
        }),
      ),
    );
  }
}

class _UpDownCaretsPainter2 extends CustomPainter {
  const _UpDownCaretsPainter2({
    required this.color,
    required this.strokeWidth,
  });

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final padding = size.height / 5.0;

    /// Draw carets
    final path1 = Path()
      ..moveTo(0, size.height / 2 - padding)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height / 2 - padding)
      ..moveTo(0, size.height / 2 + padding)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, size.height / 2 + padding);

    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true
      ..strokeWidth = strokeWidth;

    canvas.drawPath(path1, paint);
  }

  @override
  bool shouldRepaint(_UpDownCaretsPainter2 oldDelegate) {
    return color != oldDelegate.color || strokeWidth != oldDelegate.strokeWidth;
  }

  @override
  bool shouldRebuildSemantics(_UpDownCaretsPainter2 oldDelegate) => false;
}

abstract class _BaseButtonStyleWidget<T> extends StatelessWidget {
  final double? minWidth;
  final double? maxWidth;
  final double height;
  final AppKitMenuEdge menuEdge;
  final bool enabled;
  final bool contextMenuOpened;
  final bool isMainWindow;
  final Widget child;
  final AppKitControlSize controlSize;
  final bool isHovered;

  abstract final AppKitPopupButtonStyle style;

  const _BaseButtonStyleWidget({
    super.key,
    this.minWidth,
    this.maxWidth,
    required this.height,
    required this.menuEdge,
    required this.enabled,
    required this.contextMenuOpened,
    required this.isMainWindow,
    required this.controlSize,
    required this.child,
    this.isHovered = false,
  });

  BoxDecoration? getForegroundDecoration(BuildContext context,
      {required AppKitThemeData theme});

  BoxDecoration getBackgroundDecoration(BuildContext contextm,
      {required AppKitThemeData theme});

  Widget buildCaretWidget(BuildContext context,
      {required AppKitThemeData theme});

  @override
  Widget build(BuildContext context) {
    final theme = AppKitTheme.of(context);
    final popupButtonTheme = AppKitPopupButtonTheme.of(context);
    double caretButtonSize = style.getCaretButtonSize(
        theme: popupButtonTheme, controlSize: controlSize);

    final constraints = BoxConstraints(
      minWidth: minWidth ?? 0,
      maxWidth: maxWidth ?? double.infinity,
      minHeight: height,
      maxHeight: height,
    )..normalize();

    final childPadding = style.getChildPadding(
        theme: popupButtonTheme, controlSize: controlSize);
    final containerPadding = style.getContainerPadding(
        theme: popupButtonTheme, menuEdge: menuEdge, controlSize: controlSize);

    final constraints2 = BoxConstraints(
      minWidth: (constraints.minWidth - containerPadding.horizontal)
          .clamp(0, double.infinity),
      maxWidth: constraints.maxWidth.isFinite
          ? constraints.maxWidth - containerPadding.horizontal
          : constraints.maxWidth,
      minHeight: constraints.minHeight - containerPadding.vertical,
      maxHeight: constraints.maxHeight - containerPadding.vertical,
    )..normalize();

    return Container(
      constraints: constraints,
      foregroundDecoration: getForegroundDecoration(context, theme: theme),
      child: DecoratedBox(
        decoration: getBackgroundDecoration(context, theme: theme),
        child: Padding(
          padding: containerPadding,
          child: Builder(builder: (context) {
            final childConstraints = BoxConstraints(
              minHeight: constraints2.minHeight,
              maxHeight: constraints2.maxHeight,
              minWidth: (constraints2.minWidth -
                      childPadding.horizontal -
                      6 -
                      caretButtonSize)
                  .clamp(0, double.infinity),
              maxWidth: constraints2.maxWidth.isFinite
                  ? constraints2.maxWidth -
                      childPadding.horizontal -
                      6 -
                      caretButtonSize
                  : constraints2.maxWidth,
            )..normalize();
            return Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  flex: 0,
                  child: Padding(
                    padding: childPadding,
                    child: Container(
                      constraints: childConstraints,
                      child: Align(
                        widthFactor: 1,
                        heightFactor: 1,
                        alignment: Alignment.centerLeft,
                        child: child,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6.0),
                buildCaretWidget(context, theme: theme),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _PushButtonStyleWidget<T> extends _BaseButtonStyleWidget<T> {
  final Color? color;

  @override
  final AppKitPopupButtonStyle style;

  const _PushButtonStyleWidget({
    super.key,
    super.minWidth,
    super.maxWidth,
    super.isHovered,
    required super.height,
    required super.menuEdge,
    required super.enabled,
    required super.contextMenuOpened,
    required super.isMainWindow,
    required super.controlSize,
    required super.child,
    required this.style,
    this.color,
  });

  @override
  BoxDecoration? getForegroundDecoration(BuildContext context,
      {required AppKitThemeData theme}) {
    final popupButtonTheme = AppKitPopupButtonTheme.of(context);
    final controlBackgroundColor =
        enabled ? theme.controlColor : theme.controlColor.multiplyOpacity(0.5);
    final borderRadius = style.getBorderRadius(
        theme: popupButtonTheme, controlSize: controlSize);
    return contextMenuOpened
        ? BoxDecoration(
            color: style.getPressedBackgroundColor(
                theme: theme, backgroundColor: controlBackgroundColor),
            borderRadius: BorderRadius.circular(borderRadius),
          )
        : const BoxDecoration();
  }

  @override
  BoxDecoration getBackgroundDecoration(BuildContext context,
      {required AppKitThemeData theme}) {
    final popupButtonTheme = AppKitPopupButtonTheme.of(context);
    final borderRadius = style.getBorderRadius(
        theme: popupButtonTheme, controlSize: controlSize);
    final controlBackgroundColor =
        enabled ? theme.controlColor : theme.controlColor.multiplyOpacity(0.5);
    final isDark = theme.brightness == Brightness.dark;
    return BoxDecoration(
      color: controlBackgroundColor,
      borderRadius: BorderRadius.circular(borderRadius),
      border: GradientBoxBorder(
        gradient: LinearGradient(
          colors: isDark
              ? [
                  AppKitDynamicColor.resolve(
                          context, AppKitColors.text.opaque.primary)
                      .multiplyOpacity(0.5),
                  AppKitDynamicColor.resolve(
                          context, AppKitColors.text.opaque.quaternary)
                      .multiplyOpacity(0.0)
                ]
              : [
                  AppKitDynamicColor.resolve(
                          context, AppKitColors.text.opaque.tertiary)
                      .multiplyOpacity(0.5),
                  AppKitDynamicColor.resolve(
                          context, AppKitColors.text.opaque.secondary)
                      .multiplyOpacity(0.5)
                ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: isDark ? const [0.0, 0.5] : const [0.0, 1.0],
        ),
        width: 0.5,
      ),
      boxShadow: getElevatedShadow(context),
    );
  }

  @override
  Widget buildCaretWidget(BuildContext context,
      {required AppKitThemeData theme}) {
    final isBevel = style == AppKitPopupButtonStyle.bevel;
    final isDark = theme.brightness == Brightness.dark;
    final popupButtonTheme = AppKitPopupButtonTheme.of(context);
    double caretButtonSize = style.getCaretButtonSize(
        theme: popupButtonTheme, controlSize: controlSize);
    final borderRadius = style.getBorderRadius(
        theme: popupButtonTheme, controlSize: controlSize);
    final enabledFactor = enabled ? 1.0 : 0.5;

    Color caretBackgroundColor;
    Color arrowsColor;
    final caretSize =
        style.getCaretSize(theme: popupButtonTheme, controlSize: controlSize);

    if (isBevel) {
      caretBackgroundColor = Colors.transparent;
      arrowsColor =
          AppKitDynamicColor.resolve(context, popupButtonTheme.arrowsColor)
              .multiplyOpacity(enabledFactor);
    } else {
      caretBackgroundColor =
          color ?? popupButtonTheme.elevatedButtonColor ?? theme.activeColor;

      final carteBackgroundColorLiminance =
          caretBackgroundColor.computeLuminance();

      arrowsColor = isMainWindow && enabled
          ? carteBackgroundColorLiminance > 0.5
              ? Colors.black.withValues(alpha: enabledFactor)
              : Colors.white.withValues(alpha: enabledFactor)
          : isDark
              ? Colors.white.withValues(alpha: enabledFactor)
              : Colors.black.withValues(alpha: enabledFactor);

      if (contextMenuOpened) {
        final hslColor = HSLColor.fromColor(caretBackgroundColor);
        caretBackgroundColor =
            (hslColor.withLightness(hslColor.lightness / 1.1)).toColor();
      }

      if (!enabled) {
        caretBackgroundColor = caretBackgroundColor.multiplyOpacity(0.5);
      }
    }

    return SizedBox(
      width: caretButtonSize,
      height: caretButtonSize,
      child: DecoratedBox(
        decoration: isMainWindow && enabled
            ? BoxDecoration(
                color: caretBackgroundColor,
                borderRadius: BorderRadius.circular(borderRadius - 2),
                border: !isBevel
                    ? GradientBoxBorder(
                        gradient: LinearGradient(
                          colors: isDark
                              ? [
                                  AppKitDynamicColor.resolve(context,
                                          AppKitColors.text.opaque.primary)
                                      .multiplyOpacity(0.5),
                                  AppKitDynamicColor.resolve(context,
                                          AppKitColors.text.opaque.quaternary)
                                      .multiplyOpacity(0.0)
                                ]
                              : [
                                  AppKitDynamicColor.resolve(context,
                                          AppKitColors.text.opaque.tertiary)
                                      .multiplyOpacity(0.5),
                                  AppKitDynamicColor.resolve(context,
                                          AppKitColors.text.opaque.secondary)
                                      .multiplyOpacity(0.5)
                                ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: isDark ? const [0.0, 0.5] : const [0.0, 1.0],
                        ),
                        width: 0.5,
                      )
                    : null,
                boxShadow: isBevel
                    ? null
                    : [
                        BoxShadow(
                          color: theme.activeColor.withValues(alpha: 0.5),
                          blurRadius: 0.5,
                          spreadRadius: 0,
                          offset: const Offset(0, 0.5),
                        ),
                      ])
            : const BoxDecoration(),
        child: DecoratedBox(
          decoration: isMainWindow && !isBevel
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius - 1),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withValues(alpha: isDark ? 0.05 : 0.17),
                      Colors.white.withValues(alpha: 0.0),
                    ],
                  ),
                )
              : const BoxDecoration(),
          child: Center(
            child: SizedBox(
              width: caretSize.width,
              height: caretSize.height,
              child: CustomPaint(
                painter: _UpDownCaretsPainter2(
                  color: arrowsColor,
                  strokeWidth: style.getCaretStrokeWidth(
                      theme: popupButtonTheme, controlSize: controlSize),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PlainButtonStyleWidget<T> extends _BaseButtonStyleWidget<T> {
  const _PlainButtonStyleWidget({
    super.key,
    super.minWidth,
    super.maxWidth,
    required super.height,
    required super.menuEdge,
    required super.enabled,
    required super.contextMenuOpened,
    required super.isMainWindow,
    required super.controlSize,
    required super.child,
    super.isHovered,
  });

  @override
  AppKitPopupButtonStyle get style => AppKitPopupButtonStyle.plain;

  @override
  BoxDecoration? getForegroundDecoration(BuildContext context,
      {required AppKitThemeData theme}) {
    final popupButtonTheme = AppKitPopupButtonTheme.of(context);
    final borderRadius = style.getBorderRadius(
        theme: popupButtonTheme, controlSize: controlSize);
    return contextMenuOpened
        ? BoxDecoration(
            color: style.getPressedBackgroundColor(
                theme: theme, backgroundColor: theme.controlColor),
            borderRadius: BorderRadius.circular(borderRadius),
          )
        : const BoxDecoration();
  }

  @override
  BoxDecoration getBackgroundDecoration(BuildContext context,
      {required AppKitThemeData theme}) {
    final popupButtonTheme = AppKitPopupButtonTheme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final enabledFactor = enabled ? 1.0 : 0.5;
    final Color controlBackgroundColor;
    final borderRadius = style.getBorderRadius(
        theme: popupButtonTheme, controlSize: controlSize);

    if (isHovered) {
      controlBackgroundColor = theme.controlColor;
    } else {
      contextMenuOpened
          ? Colors.transparent
          : popupButtonTheme.plainButtonColor.multiplyOpacity(enabledFactor);
      controlBackgroundColor = Colors.transparent;
    }

    return BoxDecoration(
      color: controlBackgroundColor,
      borderRadius: BorderRadius.circular(borderRadius),
      border: isHovered
          ? GradientBoxBorder(
              gradient: LinearGradient(
                colors: isDark
                    ? [
                        AppKitDynamicColor.resolve(
                                context, AppKitColors.text.opaque.primary)
                            .multiplyOpacity(0.5),
                        AppKitDynamicColor.resolve(
                                context, AppKitColors.text.opaque.quaternary)
                            .multiplyOpacity(0.0)
                      ]
                    : [
                        AppKitDynamicColor.resolve(
                                context, AppKitColors.text.opaque.tertiary)
                            .multiplyOpacity(0.5),
                        AppKitDynamicColor.resolve(
                                context, AppKitColors.text.opaque.secondary)
                            .multiplyOpacity(0.5)
                      ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: isDark ? const [0.0, 0.5] : const [0.0, 1.0],
              ),
              width: 0.5,
            )
          : null,
      boxShadow: isHovered ? getElevatedShadow(context) : null,
    );
  }

  @override
  Widget buildCaretWidget(BuildContext context,
      {required AppKitThemeData theme}) {
    final popupButtonTheme = AppKitPopupButtonTheme.of(context);
    final enabledFactor = enabled ? 1.0 : 0.5;
    final Color caretBackgroundColor;
    final caretButtonSize = style.getCaretButtonSize(
        theme: popupButtonTheme, controlSize: controlSize);
    final caretSize =
        style.getCaretSize(theme: popupButtonTheme, controlSize: controlSize);
    final borderRadius = style.getBorderRadius(
        theme: popupButtonTheme, controlSize: controlSize);
    final arrowsColor =
        AppKitDynamicColor.resolve(context, popupButtonTheme.arrowsColor)
            .multiplyOpacity(enabledFactor);

    if (isHovered) {
      caretBackgroundColor = Colors.transparent;
    } else {
      caretBackgroundColor = contextMenuOpened
          ? Colors.transparent
          : popupButtonTheme.plainButtonColor.multiplyOpacity(enabledFactor);
    }

    return SizedBox(
      width: caretButtonSize,
      height: caretButtonSize,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: caretBackgroundColor,
          borderRadius: BorderRadius.circular(borderRadius - 1),
        ),
        child: Center(
          child: SizedBox(
            width: caretSize.width,
            height: caretSize.height,
            child: CustomPaint(
              painter: _UpDownCaretsPainter2(
                color: arrowsColor,
                strokeWidth: style.getCaretStrokeWidth(
                    theme: popupButtonTheme, controlSize: controlSize),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InlineButtonStyleWidget<T> extends _BaseButtonStyleWidget<T> {
  const _InlineButtonStyleWidget({
    super.key,
    super.minWidth,
    super.maxWidth,
    super.isHovered,
    required super.height,
    required super.menuEdge,
    required super.enabled,
    required super.contextMenuOpened,
    required super.isMainWindow,
    required super.controlSize,
    required super.child,
  });

  @override
  AppKitPopupButtonStyle get style => AppKitPopupButtonStyle.inline;

  @override
  BoxDecoration? getForegroundDecoration(BuildContext context,
      {required AppKitThemeData theme}) {
    final popupButtonTheme = AppKitPopupButtonTheme.of(context);
    final Color controlBackgroundColor;
    final borderRadius = style.getBorderRadius(
        theme: popupButtonTheme, controlSize: controlSize);

    if (isHovered) {
      controlBackgroundColor = Colors.black.withValues(alpha: 0.2);
    } else {
      controlBackgroundColor = Colors.black.withValues(alpha: 0.05);
    }

    return contextMenuOpened
        ? BoxDecoration(
            color: style.getPressedBackgroundColor(
                theme: theme, backgroundColor: controlBackgroundColor),
            borderRadius: BorderRadius.circular(borderRadius),
          )
        : const BoxDecoration();
  }

  @override
  BoxDecoration getBackgroundDecoration(BuildContext context,
      {required AppKitThemeData theme}) {
    final popupButtonTheme = AppKitPopupButtonTheme.of(context);
    final Color controlBackgroundColor;
    final borderRadius = style.getBorderRadius(
        theme: popupButtonTheme, controlSize: controlSize);

    if (isHovered) {
      controlBackgroundColor = Colors.black.withValues(alpha: 0.2);
    } else {
      controlBackgroundColor = Colors.black.withValues(alpha: 0.05);
    }
    return BoxDecoration(
        color: controlBackgroundColor,
        borderRadius: BorderRadius.circular(borderRadius));
  }

  @override
  Widget buildCaretWidget(BuildContext context,
      {required AppKitThemeData theme}) {
    final popupButtonTheme = AppKitPopupButtonTheme.of(context);
    final enabledFactor = enabled ? 0.5 : 0.35;

    final caretSize =
        style.getCaretSize(theme: popupButtonTheme, controlSize: controlSize);
    final caretButtonSize = style.getCaretButtonSize(
        theme: popupButtonTheme, controlSize: controlSize);
    final arrowsColor =
        AppKitDynamicColor.resolve(context, popupButtonTheme.arrowsColor)
            .multiplyOpacity(isMainWindow ? enabledFactor : 0.35);

    return SizedBox(
      width: caretButtonSize,
      height: caretButtonSize,
      child: Center(
        child: SizedBox(
          width: caretSize.width,
          height: caretSize.height,
          child: CustomPaint(
            painter: _UpDownCaretsPainter2(
              color: arrowsColor,
              strokeWidth: style.getCaretStrokeWidth(
                  theme: popupButtonTheme, controlSize: controlSize),
            ),
          ),
        ),
      ),
    );
  }
}

extension AppKitPopupButtonStyleX on AppKitPopupButtonStyle {
  EdgeInsets getContainerPadding({
    required AppKitPopupButtonThemeData theme,
    required AppKitMenuEdge menuEdge,
    required AppKitControlSize controlSize,
  }) {
    final paddings = (this == AppKitPopupButtonStyle.inline)
        ? theme.sizeData[controlSize]!.inlineContainerPadding
        : theme.sizeData[controlSize]!.containerPadding;
    if (menuEdge.isLeft) {
      return paddings.invertHorizontally();
    } else {
      return paddings;
    }
  }

  EdgeInsetsGeometry getChildPadding({
    required AppKitPopupButtonThemeData theme,
    required AppKitControlSize controlSize,
  }) {
    switch (this) {
      case AppKitPopupButtonStyle.inline:
        return theme.sizeData[controlSize]!.inlineChildPadding;
      default:
        return theme.sizeData[controlSize]!.childPadding;
    }
  }

  double getCaretButtonSize({
    required AppKitPopupButtonThemeData theme,
    required AppKitControlSize controlSize,
  }) {
    return theme.sizeData[controlSize]!.arrowsButtonSize;
  }

  Size getCaretSize({
    required AppKitPopupButtonThemeData theme,
    required AppKitControlSize controlSize,
  }) {
    return theme.sizeData[controlSize]!.arrowsSize;
  }

  double getCaretStrokeWidth({
    required AppKitPopupButtonThemeData theme,
    required AppKitControlSize controlSize,
  }) {
    return theme.sizeData[controlSize]!.arrowsStrokeWidth;
  }

  double getBorderRadius({
    required AppKitPopupButtonThemeData theme,
    required AppKitControlSize controlSize,
  }) {
    switch (this) {
      case AppKitPopupButtonStyle.push:
      case AppKitPopupButtonStyle.bevel:
      case AppKitPopupButtonStyle.plain:
        return theme.sizeData[controlSize]!.borderRadius;
      case AppKitPopupButtonStyle.inline:
        return theme.sizeData[controlSize]!.inlineBorderRadius;
    }
  }

  double getHeight({
    required AppKitPopupButtonThemeData theme,
    required AppKitControlSize controlSize,
  }) {
    switch (this) {
      case AppKitPopupButtonStyle.push:
      case AppKitPopupButtonStyle.bevel:
      case AppKitPopupButtonStyle.plain:
        return theme.sizeData[controlSize]!.height;
      case AppKitPopupButtonStyle.inline:
        return theme.sizeData[controlSize]!.inlineHeight;
    }
  }

  Color getPressedBackgroundColor(
      {required AppKitThemeData theme, required Color backgroundColor}) {
    final blendedBackgroundColor = Color.lerp(
      theme.canvasColor,
      backgroundColor,
      backgroundColor.a,
    )!;

    final luminance = blendedBackgroundColor.computeLuminance();
    final color = luminance > 0.5
        ? AppKitColors.controlBackgroundPressedColor.color
        : AppKitColors.controlBackgroundPressedColor.darkColor;
    return color;
  }

  TextStyle getTextStyle({
    required AppKitPopupButtonThemeData theme,
    required AppKitControlSize controlSize,
  }) {
    switch (this) {
      case AppKitPopupButtonStyle.inline:
        return theme.sizeData[controlSize]!.inlineTextStyle;
      default:
        return theme.sizeData[controlSize]!.textStyle;
    }
  }
}
