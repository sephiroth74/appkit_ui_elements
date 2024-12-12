import 'dart:async';

import 'package:appkit_ui_element_colors/appkit_ui_element_colors.dart';
import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:appkit_ui_elements/src/library.dart';
import 'package:appkit_ui_elements/src/utils/main_window_listener.dart';
import 'package:appkit_ui_elements/src/widgets/date_picker/textual_date_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' hide TextDirection;

class AppKitDatePicker extends StatefulWidget {
  final AppKitDatePickerType type;
  final AppKitDateElements dateElements;
  final AppKitTimeElements timeElements;
  final DateTime initialDateTime;
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final String? semanticLabel;
  final TextStyle? textStyle;
  final Color? color;
  final bool drawBackground;
  final bool drawBorder;
  final VoidCallback? onChanged;
  final AppKitDatePickerSelectionType selectionType;

  AppKitDatePicker({
    super.key,
    required this.type,
    this.dateElements = AppKitDateElements.monthDayYear,
    this.timeElements = AppKitTimeElements.none,
    this.minimumDate,
    this.maximumDate,
    this.semanticLabel,
    this.textStyle,
    this.color,
    this.onChanged,
    this.drawBackground = true,
    this.drawBorder = true,
    this.selectionType = AppKitDatePickerSelectionType.single,
    DateTime? date,
  }) : initialDateTime = date ?? DateTime.now() {
    assert(
        dateElements != AppKitDateElements.none ||
            timeElements != AppKitTimeElements.none,
        'At least one of dateElements or timeElements must be non-none');
    assert(initialDateTime.isAfter(minimumDate ?? DateTime(1)) &&
        initialDateTime.isBefore(maximumDate ?? DateTime(9999)));
    assert(minimumDate == null ||
        maximumDate == null ||
        minimumDate!.isBefore(maximumDate!));
    assert(initialDateTime.isAfter(minimumDate ?? DateTime(1)) &&
        initialDateTime.isBefore(maximumDate ?? DateTime(9999)));
  }

  @override
  State<AppKitDatePicker> createState() => _AppKitDatePickerState();
}

class _AppKitDatePickerState extends State<AppKitDatePicker> {
  bool get enabled => widget.onChanged != null;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasAppKitTheme(context));

    final languageCode = Localizations.localeOf(context).languageCode;

    return Semantics(
      label: widget.semanticLabel,
      container: true,
      child: MainWindowBuilder(builder: (context, isMainWindow) {
        if (widget.type == AppKitDatePickerType.textual ||
            widget.type == AppKitDatePickerType.textualWithStepper) {
          return TextualDatePicker(
            type: widget.type,
            dateElements: widget.dateElements,
            timeElements: widget.timeElements,
            initialDateTime: widget.initialDateTime,
            minimumDate: widget.minimumDate,
            maximumDate: widget.maximumDate,
            textStyle: widget.textStyle,
            color: widget.color,
            drawBackground: widget.drawBackground,
            drawBorder: widget.drawBorder,
            onChanged: widget.onChanged,
            languageCode: languageCode,
            isMainWindow: isMainWindow,
          );
        } else {
          return _GraphicalDatePicker(
            initialDateTime: widget.initialDateTime,
            minimumDate: widget.minimumDate,
            maximumDate: widget.maximumDate,
            drawBackground: widget.drawBackground,
            drawBorder: widget.drawBorder,
            color: widget.color,
            languageCode: languageCode,
            isMainWindow: isMainWindow,
            onChanged: widget.onChanged,
            selectionType: widget.selectionType,
          );
        }
      }),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(EnumProperty<AppKitDatePickerType>('type', widget.type));
    properties.add(
        EnumProperty<AppKitDateElements>('dateElements', widget.dateElements));
    properties.add(
        EnumProperty<AppKitTimeElements>('timeElements', widget.timeElements));
    properties.add(DiagnosticsProperty<DateTime>(
        'initialDateTime', widget.initialDateTime));
    properties
        .add(DiagnosticsProperty<DateTime>('minimumDate', widget.minimumDate));
    properties
        .add(DiagnosticsProperty<DateTime>('maximumDate', widget.maximumDate));
    properties.add(StringProperty('semanticLabel', widget.semanticLabel));
    properties
        .add(DiagnosticsProperty<TextStyle>('textStyle', widget.textStyle));
    properties.add(ColorProperty('color', widget.color));
    properties.add(FlagProperty('drawBackground',
        value: widget.drawBackground, ifTrue: 'drawBackground'));
    properties.add(FlagProperty('drawBorder',
        value: widget.drawBorder, ifTrue: 'drawBorder'));
  }
}

const _kGrahpicalDatePickerWidth = 139.0;
const _kGrahpicalDatePickerHeight = 148.0;
const _kGraphicalDatePickerBorderWidth = 1.0;
const _kGraphicalDatePickerHeaderHeight = 18.0;
const _kGraphicalDatePickerDividerHeight = 2.0;

class _GraphicalDatePicker extends StatefulWidget {
  final DateTime initialDateTime;
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final Color? color;
  final VoidCallback? onChanged;
  final String languageCode;
  final bool isMainWindow;
  final bool drawBackground;
  final bool drawBorder;
  final AppKitDatePickerSelectionType selectionType;

  const _GraphicalDatePicker({
    required this.initialDateTime,
    this.minimumDate,
    this.maximumDate,
    this.color,
    this.onChanged,
    required this.selectionType,
    required this.languageCode,
    required this.isMainWindow,
    required this.drawBackground,
    required this.drawBorder,
  });

  @override
  State<_GraphicalDatePicker> createState() => _GraphicalDatePickerState();
}

class _GraphicalDatePickerState extends State<_GraphicalDatePicker> {
  late final FocusNode _focusNode = FocusNode();
  late final List<FocusNode> _focusNodes =
      List.generate(42, (index) => FocusNode());
  late DateTime _currentDateTime = widget.initialDateTime;

  bool get enabled => widget.onChanged != null;
  bool get isFocused => _focusNode.hasFocus;

  set currentDateTime(DateTime value) {
    if (value != _currentDateTime) {
      setState(() {
        debugPrint('$runtimeType Setting currentDateTime: $value');
        _currentDateTime = value;
      });
    }
  }

  DateTime get currentDateTime => _currentDateTime;

  void _handlePreviousDatePressed() {
    debugPrint('_handlePreviousDatePressed');
    currentDateTime = DateTime(
        currentDateTime.year, currentDateTime.month - 1, currentDateTime.day);
    FocusScope.of(context).requestFocus(_focusNode);
  }

  void _handleNextDatePressed() {
    debugPrint('_handleNextDatePressed');
    currentDateTime = DateTime(
        currentDateTime.year, currentDateTime.month + 1, currentDateTime.day);
    FocusScope.of(context).requestFocus(_focusNode);
  }

  void _handleCurrentDatePressed() {
    debugPrint('_handleCurrentDatePressed');
    currentDateTime = widget.initialDateTime;
    FocusScope.of(context).requestFocus(_focusNode);
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      canRequestFocus: enabled,
      autofocus: enabled,
      onFocusChange: (value) {
        setState(() {
          debugPrint('$runtimeType Focus changed: $value');
        });
      },
      child: AppKitFocusContainer(
        borderRadius: BorderRadius.circular(3),
        canRequestFocus: true,
        enabled: enabled,
        focusNode: _focusNode,
        child: UiElementColorBuilder(builder: (context, colorContainer) {
          final theme = AppKitTheme.of(context);
          final accentColor = widget.color ??
              theme.accentColor?.multiplyLuminance(0.85) ??
              colorContainer.controlAccentColor;

          return Container(
            constraints: const BoxConstraints(
              minWidth: _kGrahpicalDatePickerWidth,
              maxWidth: _kGrahpicalDatePickerWidth,
              minHeight: _kGrahpicalDatePickerHeight,
              maxHeight: _kGrahpicalDatePickerHeight,
            ),
            decoration: BoxDecoration(
              color: widget.drawBackground
                  ? colorContainer.controlBackgroundColor
                  : null,
              border: widget.drawBorder
                  ? Border(
                      top: BorderSide(
                          color: AppKitColors.text.opaque.tertiary
                              .multiplyOpacity(0.65),
                          width: _kGraphicalDatePickerBorderWidth),
                      left: BorderSide(
                          color: AppKitColors.text.opaque.tertiary
                              .multiplyOpacity(0.65),
                          width: _kGraphicalDatePickerBorderWidth),
                      right: BorderSide(
                          color: AppKitColors.text.opaque.tertiary
                              .multiplyOpacity(0.65),
                          width: _kGraphicalDatePickerBorderWidth),
                      bottom: BorderSide(
                          color: AppKitColors.text.opaque.secondary
                              .multiplyOpacity(0.65),
                          width: _kGraphicalDatePickerBorderWidth),
                    )
                  : Border.all(
                      color: Colors.transparent,
                      width: _kGraphicalDatePickerBorderWidth),
            ),
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: _kGraphicalDatePickerHeaderHeight,
                    child: _GraphicalDatePickerHeader(
                      currentDate: currentDateTime,
                      colorContainer: colorContainer,
                      isMainWindow: widget.isMainWindow,
                      enabled: enabled,
                      languageCode: widget.languageCode,
                      onPreviousoMonthPressed:
                          enabled ? _handlePreviousDatePressed : null,
                      onNextMonthPressed:
                          enabled ? _handleNextDatePressed : null,
                      onCurrentDatePressed:
                          enabled ? _handleCurrentDatePressed : null,
                    ),
                  ),
                  const SizedBox(height: _kGraphicalDatePickerDividerHeight),
                  SizedBox(
                    height: constraints.maxHeight -
                        _kGraphicalDatePickerHeaderHeight -
                        _kGraphicalDatePickerDividerHeight,
                    width: constraints.maxWidth,
                    child: FocusScope(
                      child: _GraphicalDatePickerContent(
                        focusNode: _focusNode,
                        focusNodes: _focusNodes,
                        initialDateTime: currentDateTime,
                        minimumDate: widget.minimumDate,
                        maximumDate: widget.maximumDate,
                        colorContainer: colorContainer,
                        accentColor: accentColor,
                        isMainWindow: widget.isMainWindow,
                        enabled: enabled,
                        languageCode: widget.languageCode,
                        selectionType: widget.selectionType,
                        onPreviousMonthPressed:
                            enabled ? _handlePreviousDatePressed : null,
                        onNextMonthPressed:
                            enabled ? _handleNextDatePressed : null,
                      ),
                    ),
                  )
                ],
              );
            }),
          );
        }),
      ),
    );
  }
}

class _GraphicalDatePickerHeader extends StatelessWidget {
  final DateTime currentDate;
  final UiElementColorContainer colorContainer;
  final bool isMainWindow;
  final bool enabled;
  final String languageCode;
  final VoidCallback? onPreviousoMonthPressed;
  final VoidCallback? onNextMonthPressed;
  final VoidCallback? onCurrentDatePressed;

  const _GraphicalDatePickerHeader({
    required this.currentDate,
    required this.colorContainer,
    required this.isMainWindow,
    required this.enabled,
    required this.languageCode,
    this.onPreviousoMonthPressed,
    this.onNextMonthPressed,
    this.onCurrentDatePressed,
  });

  bool get isEnabled =>
      enabled &&
      onPreviousoMonthPressed != null &&
      onNextMonthPressed != null &&
      onCurrentDatePressed != null;

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormatter = DateFormat.yMMM(languageCode);
    final String dateString = dateFormatter.format(currentDate);
    final theme = AppKitTheme.of(context);

    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 2.0, right: 3.5, top: 2.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Opacity(
              opacity: isEnabled ? 1.0 : 0.5,
              child: DefaultTextStyle(
                  style: theme.typography.callout.copyWith(
                      fontWeight: AppKitFontWeight.w600, fontSize: 12.0),
                  child: Text(dateString)),
            ),
            const Spacer(),
            _GraphicalDatePickerHeaderButton(
              type: _HeaderButtonType.left,
              isMainWindow: isMainWindow,
              onPressed: isEnabled ? onPreviousoMonthPressed : null,
            ),
            const SizedBox(width: 5.0),
            _GraphicalDatePickerHeaderButton(
              type: _HeaderButtonType.center,
              isMainWindow: isMainWindow,
              onPressed: isEnabled ? onCurrentDatePressed : null,
            ),
            const SizedBox(width: 5.0),
            _GraphicalDatePickerHeaderButton(
              type: _HeaderButtonType.right,
              isMainWindow: isMainWindow,
              onPressed: isEnabled ? onNextMonthPressed : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _GraphicalDatePickerContent extends StatelessWidget {
  final DateTime initialDateTime;
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final UiElementColorContainer colorContainer;
  final bool isMainWindow;
  final bool enabled;
  final String languageCode;
  final Color accentColor;
  final VoidCallback? onPreviousMonthPressed;
  final VoidCallback? onNextMonthPressed;
  final AppKitDatePickerSelectionType selectionType;
  final FocusNode? focusNode;
  final List<FocusNode> focusNodes;

  const _GraphicalDatePickerContent({
    required this.initialDateTime,
    required this.colorContainer,
    required this.isMainWindow,
    required this.enabled,
    required this.languageCode,
    required this.accentColor,
    required this.selectionType,
    required this.focusNodes,
    this.minimumDate,
    this.maximumDate,
    this.onPreviousMonthPressed,
    this.onNextMonthPressed,
    this.focusNode,
  });

  static List<String> getDaysOfWeek(String locale) {
    final now = DateTime.now();
    final firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return List.generate(7, (index) => index)
        .map((value) => DateFormat(DateFormat.ABBR_WEEKDAY, locale)
            .format(firstDayOfWeek.add(Duration(days: value)))
            .substring(0, 2))
        .toList();
  }

  static List<String> _daysOfWeek = [];

  List<String> get daysOfWeek {
    if (_daysOfWeek.isEmpty) {
      _daysOfWeek = getDaysOfWeek(languageCode);
    }
    return _daysOfWeek;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppKitTheme.of(context);
    final weekDayTextColor = AppKitColors.text.opaque.secondary
        .resolveFrom(context)
        .multiplyOpacity(enabled ? 0.9 : 0.5);

    return LayoutBuilder(builder: (context, constrains) {
      return Container(
        constraints: constrains,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
              flex: 0,
              child: Padding(
                padding: const EdgeInsets.only(left: 1.0, right: 2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: daysOfWeek.map((day) {
                    return Container(
                      padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
                      alignment: Alignment.center,
                      child: DefaultTextStyle(
                        style: theme.typography.callout.copyWith(
                            fontWeight: AppKitFontWeight.w600,
                            fontSize: 10.0,
                            color: weekDayTextColor),
                        child: Text(day),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Divider(
              height: 1.0,
              thickness: 1.0,
              indent: 2.0,
              endIndent: 2.0,
              color: AppKitColors.systemGray.color.multiplyOpacity(0.35),
            ),
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 1.0, right: 2.0, top: 1.0),
                child: _GraphicalDatePickerMonthView(
                  focusNode: focusNode,
                  focusNodes: focusNodes,
                  initialDateTime: initialDateTime,
                  minimumDate: minimumDate,
                  maximumDate: maximumDate,
                  colorContainer: colorContainer,
                  isMainWindow: isMainWindow,
                  enabled: enabled,
                  languageCode: languageCode,
                  accentColor: accentColor,
                  selectionType: selectionType,
                  onPreviousMonthPressed: onPreviousMonthPressed,
                  onNextMonthPressed: onNextMonthPressed,
                ),
              ),
            )
          ],
        ),
      );
    });
  }
}

class _GraphicalDatePickerMonthView extends StatefulWidget {
  final DateTime initialDateTime;
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final UiElementColorContainer colorContainer;
  final bool isMainWindow;
  final bool enabled;
  final String languageCode;
  final Color accentColor;
  final AppKitDatePickerSelectionType selectionType;
  final VoidCallback? onPreviousMonthPressed;
  final VoidCallback? onNextMonthPressed;
  final FocusNode? focusNode;
  final List<FocusNode> focusNodes;

  const _GraphicalDatePickerMonthView({
    required this.initialDateTime,
    required this.colorContainer,
    required this.isMainWindow,
    required this.enabled,
    required this.languageCode,
    required this.accentColor,
    required this.selectionType,
    required this.focusNodes,
    this.minimumDate,
    this.maximumDate,
    this.onPreviousMonthPressed,
    this.onNextMonthPressed,
    this.focusNode,
  });

  @override
  State<_GraphicalDatePickerMonthView> createState() =>
      _GraphicalDatePickerMonthViewState();
}

class _GraphicalDatePickerMonthViewState
    extends State<_GraphicalDatePickerMonthView> {
  static const rowsCount = 7;
  static const columnsCount = 6;
  static const totalDays = rowsCount * columnsCount;

  bool _isMousePressed = false;

  DateTime? _pointerDownDate;

  DateTime? _currentSelectedDate;

  DateTime? _selectedStartDate;

  DateTime? _selectedEndDate;

  DateTime get selectedStartDate =>
      _selectedStartDate ?? widget.initialDateTime;

  DateTime get currentSelectedDate =>
      _currentSelectedDate ?? widget.initialDateTime;

  DateTime? get selectedEndDate => _selectedEndDate;

  bool get isRangeSelection =>
      widget.selectionType == AppKitDatePickerSelectionType.range;

  DateTime get firstDayOfMonth =>
      DateTime(widget.initialDateTime.year, widget.initialDateTime.month, 1);

  DateTime get firstDayOfWeek =>
      firstDayOfMonth.subtract(Duration(days: firstDayOfMonth.weekday - 1));

  DateTime get lastDayOfMonth => DateTime(
      widget.initialDateTime.year, widget.initialDateTime.month + 1, 0);

  DateTime get lastDayOfWeek =>
      firstDayOfWeek.add(const Duration(days: totalDays - 1));

  late DateTime today = DateTime.now();

  void _setSelectionRange(DateTime startDate, DateTime? endDate) {
    debugPrint('==>> Setting selection range: $startDate - $endDate');
    setState(() {
      if (endDate == null) {
        _pointerDownDate = startDate;
        _selectedStartDate = startDate;
        _selectedEndDate = null;
      } else {
        _selectedStartDate = startDate.isBefore(endDate) ? startDate : endDate;
        _selectedEndDate = startDate.isBefore(endDate) ? endDate : startDate;
      }
    });
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    final bool isShiftPressed = HardwareKeyboard.instance.isShiftPressed;
    debugPrint(
        'event.key: ${event.logicalKey.debugName} pointerDownDate: $_pointerDownDate, currentSelectedDate: $_currentSelectedDate');

    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowRight ||
          event.logicalKey == LogicalKeyboardKey.arrowDown) {
        final current = selectedEndDate ?? selectedStartDate;
        final nextDay = current.add(Duration(
            days: event.logicalKey == LogicalKeyboardKey.arrowRight ? 1 : 7));

        if (nextDay.isAfter(lastDayOfMonth) &&
            nextDay.isBefore(widget.maximumDate ?? DateTime(9999))) {
          widget.onNextMonthPressed?.call();
        }

        _pointerDownDate = selectedStartDate;
        _currentSelectedDate = nextDay;

        setState(() => _setSelectionRange(
            nextDay, isShiftPressed ? _pointerDownDate : null));
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
          event.logicalKey == LogicalKeyboardKey.arrowUp) {
        final current = selectedStartDate;
        final previousDay = current.subtract(Duration(
            days: event.logicalKey == LogicalKeyboardKey.arrowLeft ? 1 : 7));
        if (previousDay.isBefore(firstDayOfMonth) &&
            previousDay.isAfter(widget.minimumDate ?? DateTime(1))) {
          widget.onPreviousMonthPressed?.call();
        }
        setState(() => _setSelectionRange(
            previousDay, isShiftPressed ? selectedEndDate : null));
        return KeyEventResult.handled;
      }
    } else {
      _pointerDownDate = null;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppKitTheme.of(context);

    debugPrint('focusNode is focused: ${widget.focusNode?.hasFocus}');

    if (_selectedStartDate != null && widget.focusNode?.hasFocus == true) {
      // find the selectedStartDate focus node index

      int index = (currentSelectedDate.difference(firstDayOfWeek).inDays);

      if (index >= 0 && index < widget.focusNodes.length) {
        debugPrint('==>> Focusing on index: $index');
        FocusScope.of(context).requestFocus(widget.focusNodes[index]);
      }
    }

    // find the date of the first day of the week from the 1st day of the current month

    final dayTextStyle = theme.typography.callout.copyWith(fontSize: 10.0);
    final isFocused = widget.focusNode?.hasFocus == true;

    return Padding(
      // padding: const EdgeInsets.only(left: 1.0, right: 3.0, bottom: 4.0, top: 2.0),
      padding: EdgeInsets.zero,
      child: LayoutBuilder(builder: (context, constraints) {
        // now create a grid displaying all the days, starting from the firstDayOfWeek to the lastDayOfWeek
        final totalWidth = constraints.maxWidth;
        final totalHeight = constraints.maxHeight;
        final days = <List<Widget>>[];
        List<Widget> currentRow = <Widget>[];

        for (var i = 0; i < totalDays; i++) {
          final day = firstDayOfWeek.add(Duration(days: i));
          final isCurrentMonth = day.month == widget.initialDateTime.month;
          final isToday = day.day == today.day &&
              day.month == today.month &&
              day.year == today.year;
          final isBeforeMinimumDate =
              widget.minimumDate != null && day.isBefore(widget.minimumDate!);
          final isAfterMaximumDate =
              widget.maximumDate != null && day.isAfter(widget.maximumDate!);
          final isBeforeCurrentMonth = day.isBefore(firstDayOfMonth);
          final isAfterCurrentMonth = day.isAfter(lastDayOfMonth);
          final isWithinValidRange =
              !isBeforeMinimumDate && !isAfterMaximumDate;
          final isSelected = selectedEndDate != null
              ? day.isBetween(selectedStartDate, selectedEndDate!, true)
              : day.isSameDay(selectedStartDate);

          final isPreviousDaySelected =
              day.weekday != 0 && selectedStartDate.isBefore(day);
          final isNextDaySelected = day.weekday != 7 &&
              selectedEndDate != null &&
              selectedEndDate!.isAfter(day);

          final backgroundColor = widget.enabled && isSelected
              ? widget.isMainWindow && isFocused
                  ? widget.accentColor
                  : AppKitColors.systemGray.withLuminance(0.85)
              : null;

          double dayTextOpacity = 1.0;

          if (!widget.enabled) {
            dayTextOpacity *= 0.5;
          }

          if (!isCurrentMonth) {
            dayTextOpacity *= 0.5;
          }

          if (isBeforeMinimumDate || isAfterMaximumDate) {
            dayTextOpacity *= 0.4;
          }

          Color dayTextColor = backgroundColor != null
              ? backgroundColor.computeLuminance() >= 0.5
                  ? AppKitColors.text.opaque.primary
                  : AppKitColors.text.opaque.primary.darkColor
              : isToday && widget.isMainWindow && isFocused
                  ? widget.accentColor
                  : AppKitColors.text.opaque.primary;

          dayTextColor = dayTextColor.multiplyOpacity(dayTextOpacity);

          final textStyle = dayTextStyle.copyWith(
              color: dayTextColor,
              fontWeight: isToday ? FontWeight.bold : null);

          final dayWidget = Padding(
            padding: const EdgeInsets.only(bottom: 2.0),
            child: Focus(
              focusNode: widget.focusNodes[i],
              canRequestFocus: true,
              onFocusChange: (value) {
                debugPrint('==>> Focus changed: [$i] $day ==> $value');
              },
              onKeyEvent: widget.enabled && widget.isMainWindow
                  ? (node, event) => _handleKeyEvent(node, event)
                  : null,
              child: MouseRegion(
                onEnter: widget.enabled &&
                        isRangeSelection &&
                        _isMousePressed &&
                        isWithinValidRange
                    ? (_) {
                        if (isBeforeCurrentMonth) {
                          widget.onPreviousMonthPressed?.call();
                          return;
                        } else if (isAfterCurrentMonth) {
                          widget.onNextMonthPressed?.call();
                          return;
                        }

                        final start = _pointerDownDate ?? selectedStartDate;

                        if (day.isAfter(start)) {
                          _setSelectionRange(start, day);
                        } else {
                          _setSelectionRange(day, start);
                        }
                      }
                    : null,
                child: Listener(
                  onPointerUp: widget.enabled
                      ? (_) {
                          setState(() {
                            _isMousePressed = false;
                            _pointerDownDate = null;
                          });
                        }
                      : null,
                  onPointerDown: widget.enabled
                      ? (_) {
                          // FocusScope.of(context).requestFocus(widget.focusNode);
                          FocusScope.of(context)
                              .requestFocus(widget.focusNodes[i]);

                          if (isBeforeCurrentMonth) {
                            widget.onPreviousMonthPressed?.call();
                          } else if (isAfterCurrentMonth) {
                            widget.onNextMonthPressed?.call();
                          } else if (isWithinValidRange) {
                            final bool isShiftPressed =
                                HardwareKeyboard.instance.isShiftPressed;

                            setState(() {
                              if (isShiftPressed &&
                                  isRangeSelection &&
                                  !day.isSameDay(selectedStartDate)) {
                                _isMousePressed = false;
                                _currentSelectedDate = day;
                                _setSelectionRange(day, selectedStartDate);
                              } else {
                                _isMousePressed = true;
                                _currentSelectedDate = day;
                                _setSelectionRange(day, null);
                              }
                            });
                          }
                        }
                      : null,
                  child: SizedBox(
                    width: (totalWidth / rowsCount) - 0, // see padding
                    height: (totalHeight / columnsCount) - 2, // see paddings
                    child: DecoratedBox(
                      decoration: isSelected &&
                              (isPreviousDaySelected && isNextDaySelected)
                          ? BoxDecoration(color: backgroundColor)
                          : isSelected &&
                                  (!isPreviousDaySelected && isNextDaySelected)
                              ? BoxDecoration(
                                  color: backgroundColor,
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(3.0),
                                      bottomLeft: Radius.circular(3.0)))
                              : isSelected &&
                                      (!isNextDaySelected &&
                                          isPreviousDaySelected)
                                  ? BoxDecoration(
                                      color: backgroundColor,
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(3.0),
                                          bottomRight: Radius.circular(3.0)))
                                  : isSelected
                                      ? BoxDecoration(
                                          color: backgroundColor,
                                          borderRadius:
                                              BorderRadius.circular(3.0))
                                      : const BoxDecoration(),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 2.0, bottom: 2),
                          child: Text(
                            day.day.toString(),
                            style: textStyle,
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
          currentRow.add(dayWidget);

          if (currentRow.length == 7) {
            days.add(currentRow);
            currentRow = <Widget>[];
          }
        }

        if (currentRow.isNotEmpty) {
          days.add(currentRow);
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (var row in days) ...[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: row),
              // if (days.indexOf(row) < days.length - 1) const SizedBox(height: 2.0),
            ]
          ],
        );
      }),
    );
  }
}

class _GraphicalDatePickerHeaderButton extends StatefulWidget {
  final _HeaderButtonType type;
  final bool isMainWindow;
  final VoidCallback? onPressed;

  const _GraphicalDatePickerHeaderButton({
    required this.type,
    required this.isMainWindow,
    this.onPressed,
  });

  @override
  State<_GraphicalDatePickerHeaderButton> createState() =>
      _GraphicalDatePickerHeaderButtonState();
}

class _GraphicalDatePickerHeaderButtonState
    extends State<_GraphicalDatePickerHeaderButton> {
  bool _isPressed = false;
  Timer? _timer;

  bool get enabled => widget.onPressed != null;

  void _handleTapDown() {
    _timer?.cancel();
    widget.onPressed?.call();
    isPressed = true;

    // now send the onPressed event multiple times

    _timer = Timer(const Duration(milliseconds: 500), () {
      _timer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
        widget.onPressed?.call();
      });
    });
  }

  void _handleTapUpOrCancel() {
    _timer?.cancel();
    isPressed = false;
  }

  set isPressed(bool value) {
    if (value != _isPressed) {
      setState(() => _isPressed = value);
    }
  }

  bool get isPressed => _isPressed;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: enabled ? (_) => _handleTapDown() : null,
      onTapUp: (_) => enabled ? _handleTapUpOrCancel() : null,
      onTapCancel: () => enabled ? _handleTapUpOrCancel() : null,
      child: SizedBox(
        width: 10,
        height: 10,
        child: Center(
          child: CustomPaint(
            size: const Size(6.5, 6.5),
            painter: _GraphicalDatePickerHeaderButtonPainter(
              type: widget.type,
              enabled: enabled,
              isMainWindow: widget.isMainWindow,
              isPressed: isPressed,
            ),
          ),
        ),
      ),
    );
  }
}

class _GraphicalDatePickerHeaderButtonPainter extends CustomPainter {
  final _HeaderButtonType type;
  final bool enabled;
  final bool isMainWindow;
  final bool isPressed;

  _GraphicalDatePickerHeaderButtonPainter({
    required this.type,
    required this.enabled,
    required this.isMainWindow,
    required this.isPressed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final color =
        AppKitColors.systemGray.color.multiplyOpacity(enabled ? 1.0 : 0.5);
    const pressedColor = Colors.black;

    final Paint paint = Paint()
      ..color = isPressed && enabled ? pressedColor : color
      ..style = PaintingStyle.fill;

    if (type == _HeaderButtonType.center) {
      // draw a circle
      final center = Offset(size.width / 2, size.height / 2);
      final radius = size.width / 2;
      canvas.drawCircle(center, radius, paint);
    } else if (type == _HeaderButtonType.left) {
      // draw a left arrow
      final path = Path();
      path.moveTo(1, size.height / 2);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
      path.close();
      canvas.drawPath(path, paint);
    } else {
      // draw a right arrow
      final path = Path();
      path.moveTo(0, 0);
      path.lineTo(size.width - 1, size.height / 2);
      path.lineTo(0, size.height);
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is _GraphicalDatePickerHeaderButtonPainter &&
        oldDelegate.type == type &&
        oldDelegate.enabled == enabled &&
        oldDelegate.isMainWindow == isMainWindow &&
        oldDelegate.isPressed == isPressed;
  }
}

enum _HeaderButtonType { left, center, right }
