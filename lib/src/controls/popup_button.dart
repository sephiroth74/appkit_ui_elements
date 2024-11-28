import 'package:appkit_ui_element_colors/appkit_ui_element_colors.dart';
import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:appkit_ui_elements/src/utils/main_window_listener.dart';
import 'package:appkit_ui_elements/src/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef ContextMenuBuilder<T> = AppKitContextMenu<T> Function(
    BuildContext context);
typedef SelectedItemBuilder<T> = Widget Function(BuildContext context, T value);

const _kBorderRadius = 5.0;
const _kHeight = 20.0;
const _kCareWidth = 5.5;
const _kCaretHeight = 10.0;
const _kCaretButtonSize = 16.0;
const _kCaretDefaultPadding = 20.0;

const _kMenuPaddingRight =
    EdgeInsets.only(left: 7.0, top: 1.0, right: 2.0, bottom: 2.0);
const _kMenuPaddingLeft =
    EdgeInsets.only(left: 2.0, top: 1.0, right: 7.0, bottom: 2.0);

final _kPressedDecoration = BoxDecoration(
  color: Colors.black.withOpacity(0.05),
  borderRadius: BorderRadius.circular(_kBorderRadius),
);

List<BoxShadow> _getElevatedShadow(
        BuildContext context, UiElementColorContainer colorContainer) =>
    [
      BoxShadow(
        blurStyle: BlurStyle.outer,
        color: colorContainer.shadowColor.withOpacity(0.3),
        blurRadius: 1.25,
        spreadRadius: 0.0,
        offset: const Offset(0, 0.5),
      ),
      BoxShadow(
        blurStyle: BlurStyle.outer,
        offset: const Offset(0.0, 0.0),
        blurRadius: 0.0,
        spreadRadius: 0.5,
        color: colorContainer.shadowColor.withOpacity(0.05),
      )
    ];

Widget _defaultItemBuilder<T>(
    BuildContext context, AppKitContextMenuItem<T>? value, bool enabled) {
  if (value == null) {
    return const SizedBox();
  }

  Color textColor =
      AppKitTheme.of(context).typography.body.color ?? AppKitColors.labelColor;
  if (!enabled) {
    textColor = textColor.withOpacity(0.5);
  }

  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      if (value.image != null)
        Padding(
          padding: const EdgeInsets.only(right: 4.0, top: 3.0),
          child: Icon(
            value.image,
            size: 12.0,
            color: textColor,
          ),
        ),
      Flexible(
        child: Text(
          value.title,
          style: AppKitTheme.of(context)
              .typography
              .body
              .copyWith(fontSize: 13.0, color: textColor),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}

class AppKitPopupButton<T> extends StatefulWidget {
  final ContextMenuBuilder<T>? menuBuilder;
  final T? value;
  final ValueChanged<AppKitContextMenuItem<T>?>? onItemSelected;
  final SelectedItemBuilder<T?>? itemBuilder;
  final double width;
  final AppKitMenuEdge menuEdge;
  final AppKitPopupButtonStyle style;

  const AppKitPopupButton({
    super.key,
    required this.width,
    this.onItemSelected,
    this.menuBuilder,
    this.value,
    this.itemBuilder,
    this.menuEdge = AppKitMenuEdge.bottom,
    this.style = AppKitPopupButtonStyle.push,
  });

  @override
  State<AppKitPopupButton<T>> createState() => _AppKitPopupButtonState<T>();
}

class _AppKitPopupButtonState<T> extends State<AppKitPopupButton<T>> {
  bool get enabled =>
      widget.onItemSelected != null && widget.menuBuilder != null;

  TextStyle get textStyle => AppKitTheme.of(context).typography.body;

  AppKitPopupButtonStyle get style => widget.style;

  bool _isMenuOpened = false;

  bool _isHovered = false;

  late AppKitContextMenu<T> _contextMenu;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('value', widget.value));
    properties.add(DiagnosticsProperty('enabled', enabled));
    properties.add(DiagnosticsProperty('style', style));
    properties.add(DiagnosticsProperty('menuEdge', widget.menuEdge));
    properties.add(DiagnosticsProperty('width', widget.width));
    properties.add(DiagnosticsProperty('menuBuilder', widget.menuBuilder));
    properties
        .add(DiagnosticsProperty('onItemSelected', widget.onItemSelected));
    properties.add(DiagnosticsProperty('itemBuilder', widget.itemBuilder));
  }

  AppKitContextMenuItem<T>? get _selectedItem {
    return _contextMenu.findItemByValue(widget.value);
  }

  @override
  void initState() {
    super.initState();
    _contextMenu = widget.menuBuilder!(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AppKitPopupButton<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _contextMenu = widget.menuBuilder!(context);
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

  void handleTap() async {
    final itemRect = context.getWidgetBounds();
    if (null != itemRect && widget.menuBuilder != null) {
      final menu = _contextMenu.copyWith(
          position: _contextMenu.position ??
              widget.menuEdge.getRectPosition(itemRect));
      setState(() {
        _isMenuOpened = true;
      });

      final value = await showContextMenu<T>(
        context,
        contextMenu: menu,
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: true,
        opaque: false,
        selectedItem: _selectedItem,
        menuEdge: widget.menuEdge,
      );

      setState(() {
        _isMenuOpened = false;
      });

      widget.onItemSelected?.call(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    debugCheckHasAppKitTheme(context);

    return MouseRegion(
      onEnter: enabled ? _handleMouseEnter : null,
      onExit: enabled ? _handleMouseExit : null,
      child: GestureDetector(
        onTap: enabled ? handleTap : null,
        child: UiElementColorBuilder(builder: (context, colorContainer) {
          final isMainWindow =
              MainWindowStateListener.instance.isMainWindow.value;

          const height = _kHeight;
          final width = widget.width;
          final menuEdge = widget.menuEdge;
          final itemBuilder = widget.itemBuilder;
          final value = widget.value;

          if (style == AppKitPopupButtonStyle.push ||
              style == AppKitPopupButtonStyle.bevel) {
            return _PushButtonStyleWidget<T>(
              width: width,
              height: height,
              menuEdge: menuEdge,
              value: value,
              onItemSelected: widget.onItemSelected,
              enabled: enabled,
              colorContainer: colorContainer,
              contextMenuOpened: _isMenuOpened,
              isMainWindow: isMainWindow,
              isBevel: style == AppKitPopupButtonStyle.bevel,
              child: itemBuilder?.call(context, value) ??
                  _defaultItemBuilder(context, _selectedItem, enabled),
            );
          } else if (style == AppKitPopupButtonStyle.plain) {
            return _PlainButtonStyleWidget<T>(
              width: width,
              height: height,
              menuEdge: menuEdge,
              value: value,
              onItemSelected: widget.onItemSelected,
              enabled: enabled,
              colorContainer: colorContainer,
              contextMenuOpened: _isMenuOpened,
              isMainWindow: isMainWindow,
              isHovered: _isHovered,
              child: itemBuilder?.call(context, value) ??
                  _defaultItemBuilder(context, _selectedItem, enabled),
            );
          }

          return const SizedBox();
        }),
      ),
    );
  }
}

class _UpDownCaretsPainter2 extends CustomPainter {
  const _UpDownCaretsPainter2({
    required this.color,
    // ignore: unused_element
    this.strokeWidth = 1.75,
  });

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    /// Draw carets
    final path1 = Path()
      ..moveTo(0, size.height / 2 - 2.0)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height / 2 - 2.0)
      ..moveTo(0, size.height / 2 + 2.0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, size.height / 2 + 2.0);

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

class _PushButtonStyleWidget<T> extends StatelessWidget {
  final double width;
  final double height;
  final AppKitMenuEdge menuEdge;
  final T? value;
  final ValueChanged<AppKitContextMenuItem<T>?>? onItemSelected;
  final bool enabled;
  final UiElementColorContainer colorContainer;
  final bool contextMenuOpened;
  final bool isMainWindow;
  final Widget child;
  final bool isBevel;

  const _PushButtonStyleWidget({
    super.key,
    required this.width,
    required this.height,
    required this.menuEdge,
    required this.value,
    required this.enabled,
    required this.colorContainer,
    required this.contextMenuOpened,
    required this.isMainWindow,
    required this.child,
    this.onItemSelected,
    this.isBevel = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppKitTheme.of(context);
    final enabledFactor = enabled ? 1.0 : 0.5;
    final popupButtonTheme = AppKitPopupButtonTheme.of(context);

    Color caretBackgroundColor;
    Color caretArrowColor;

    if (isBevel) {
      caretBackgroundColor = Colors.transparent;
      caretArrowColor = AppKitColors.labelColor
          .withOpacity(AppKitColors.labelColor.opacity * enabledFactor);
    } else {
      caretBackgroundColor = popupButtonTheme.elevatedButtonColor ??
          theme.accentColor ??
          colorContainer.controlAccentColor;

      final carteBackgroundColorLiminance =
          caretBackgroundColor.computeLuminance();

      caretArrowColor = isMainWindow && enabled
          ? carteBackgroundColorLiminance > 0.5
              ? Colors.black.withOpacity(enabledFactor)
              : Colors.white.withOpacity(enabledFactor)
          : Colors.black.withOpacity(enabledFactor);

      if (contextMenuOpened) {
        final hslColor = HSLColor.fromColor(caretBackgroundColor);
        caretBackgroundColor =
            (hslColor.withLightness(hslColor.lightness / 1.1)).toColor();
      }

      if (!enabled) {
        caretBackgroundColor = caretBackgroundColor
            .withOpacity(caretBackgroundColor.opacity * 0.5);
      }
    }

    return Container(
      height: height,
      width: width,
      foregroundDecoration:
          contextMenuOpened ? _kPressedDecoration : const BoxDecoration(),
      decoration: BoxDecoration(
          color: enabled
              ? theme.controlBackgroundColor
              : theme.controlBackgroundColorDisabled,
          borderRadius: BorderRadius.circular(_kBorderRadius),
          boxShadow: _getElevatedShadow(context, colorContainer)),
      child: Padding(
        padding: menuEdge.isLeft ? _kMenuPaddingLeft : _kMenuPaddingRight,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              left: menuEdge.isLeft ? _kCaretDefaultPadding : 0.0,
              right: menuEdge.isLeft ? 0 : _kCaretDefaultPadding,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: LayoutBuilder(builder: (context, constraints) {
                  return SizedBox(width: constraints.maxWidth, child: child);
                }),
              ),
            ),
            Positioned(
              left: menuEdge.isLeft ? 0.0 : null,
              right: menuEdge.isLeft ? null : 0.0,
              top: 1.0,
              child: SizedBox(
                width: _kCaretButtonSize,
                height: _kCaretButtonSize,
                child: DecoratedBox(
                  decoration: isMainWindow && enabled
                      ? BoxDecoration(
                          color: caretBackgroundColor,
                          borderRadius:
                              BorderRadius.circular(_kBorderRadius - 1),
                          boxShadow: isBevel
                              ? null
                              : [
                                  BoxShadow(
                                    color: colorContainer.controlAccentColor
                                        .withOpacity(0.06),
                                    blurRadius: 1.5,
                                    spreadRadius: 0.0,
                                    offset: const Offset(0, 0.5),
                                  ),
                                  BoxShadow(
                                    offset: const Offset(0.0, 1.0),
                                    blurRadius: 1.0,
                                    spreadRadius: 0.0,
                                    color: colorContainer.controlAccentColor
                                        .withOpacity(0.06),
                                  ),
                                  BoxShadow(
                                    offset: const Offset(0.0, 0.5),
                                    blurRadius: 0.5,
                                    spreadRadius: 0.0,
                                    color: colorContainer.controlAccentColor
                                        .withOpacity(0.12),
                                  )
                                ])
                      : const BoxDecoration(),
                  child: DecoratedBox(
                    decoration: isMainWindow && !isBevel
                        ? BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(_kBorderRadius - 1),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white.withOpacity(0.17),
                                Colors.white.withOpacity(0.0),
                              ],
                            ),
                          )
                        : const BoxDecoration(),
                    child: Center(
                      child: SizedBox(
                        width: _kCareWidth,
                        height: _kCaretHeight,
                        child: CustomPaint(
                          painter: _UpDownCaretsPainter2(
                            color: caretArrowColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _PlainButtonStyleWidget<T> extends StatelessWidget {
  final double width;
  final double height;
  final AppKitMenuEdge menuEdge;
  final T? value;
  final ValueChanged<AppKitContextMenuItem<T>?>? onItemSelected;
  final bool enabled;
  final UiElementColorContainer colorContainer;
  final bool contextMenuOpened;
  final bool isMainWindow;
  final Widget child;
  final bool isHovered;

  const _PlainButtonStyleWidget({
    super.key,
    required this.width,
    required this.height,
    required this.menuEdge,
    required this.value,
    required this.enabled,
    required this.colorContainer,
    required this.contextMenuOpened,
    required this.isMainWindow,
    required this.child,
    this.onItemSelected,
    this.isHovered = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = AppKitTheme.of(context);
    final popupButtonTheme = AppKitPopupButtonTheme.of(context);
    final enabledFactor = enabled ? 1.0 : 0.5;

    Color controlBackgroundColor;
    Color caretBackgroundColor;
    Color caretArrowColor;

    caretArrowColor = AppKitColors.labelColor
        .withOpacity(AppKitColors.labelColor.opacity * enabledFactor);

    if (isHovered) {
      caretBackgroundColor = Colors.transparent;
      controlBackgroundColor = theme.controlBackgroundColor;
    } else {
      caretBackgroundColor = contextMenuOpened
          ? Colors.transparent
          : popupButtonTheme.plainButtonColor ??
              AppKitColors.systemGray.withOpacity(enabled ? 0.2 : 0.1);
      controlBackgroundColor = Colors.transparent;
    }

    return Container(
      height: height,
      width: width,
      foregroundDecoration:
          contextMenuOpened ? _kPressedDecoration : const BoxDecoration(),
      decoration: BoxDecoration(
          color: controlBackgroundColor,
          borderRadius: BorderRadius.circular(_kBorderRadius),
          boxShadow:
              isHovered ? _getElevatedShadow(context, colorContainer) : null),
      child: Padding(
        padding: menuEdge.isLeft ? _kMenuPaddingLeft : _kMenuPaddingRight,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              left: menuEdge.isLeft ? _kCaretDefaultPadding : 0.0,
              right: menuEdge.isLeft ? 0 : _kCaretDefaultPadding,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: LayoutBuilder(builder: (context, constraints) {
                  return SizedBox(width: constraints.maxWidth, child: child);
                }),
              ),
            ),
            Positioned(
              left: menuEdge.isLeft ? 0.0 : null,
              right: menuEdge.isLeft ? null : 0.0,
              top: 1.0,
              child: SizedBox(
                width: _kCaretButtonSize,
                height: _kCaretButtonSize,
                child: DecoratedBox(
                  decoration: isMainWindow
                      ? BoxDecoration(
                          color: caretBackgroundColor,
                          borderRadius:
                              BorderRadius.circular(_kBorderRadius - 1),
                        )
                      : const BoxDecoration(),
                  child: Center(
                    child: SizedBox(
                      width: _kCareWidth,
                      height: _kCaretHeight,
                      child: CustomPaint(
                        painter: _UpDownCaretsPainter2(
                          color: caretArrowColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
