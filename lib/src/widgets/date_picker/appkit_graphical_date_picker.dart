import 'dart:async';
import 'dart:math';

import 'package:appkit_ui_element_colors/appkit_ui_element_colors.dart';
import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:appkit_ui_elements/src/utils/appkit_logger.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide DateTimeRange;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' hide TextDirection;

const _kGrahpicalDatePickerWidth = 139.0;
const _kGrahpicalDatePickerHeight = 148.0;
const _kGraphicalDatePickerBorderWidth = 1.0;
const _kGraphicalDatePickerHeaderHeight = 18.0;
const _kGraphicalDatePickerDividerHeight = 2.0;

@protected
class GraphicalDatePicker extends StatefulWidget {
  final DateTimeRange initialDateTime;
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final Color? color;
  final OnDateChanged? onChanged;
  final String languageCode;
  final bool isMainWindow;
  final bool drawBackground;
  final bool drawBorder;
  final bool autofocus;
  final bool canRequestFocus;
  final AppKitDatePickerSelectionType selectionType;

  const GraphicalDatePicker({
    super.key,
    required this.initialDateTime,
    this.minimumDate,
    this.maximumDate,
    this.color,
    this.onChanged,
    this.autofocus = false,
    this.canRequestFocus = true,
    required this.selectionType,
    required this.languageCode,
    required this.isMainWindow,
    required this.drawBackground,
    required this.drawBorder,
  });

  @override
  State<GraphicalDatePicker> createState() => _GraphicalDatePickerState();
}

class _GraphicalDatePickerState extends State<GraphicalDatePicker> {
  // ignore: unused_field
  late final _logger = newLogger('GraphicalDatePicker');

  FocusNode? _focusNode;

  FocusNode get _effectiveFocusNode => _focusNode ??= FocusNode(
      debugLabel: 'GraphicalDatePicker[$hashCode]',
      canRequestFocus: widget.canRequestFocus);

  late final FocusNode _childFocusNode = FocusNode();

  bool get enabled => widget.onChanged != null;

  bool get isFocused => _effectiveFocusNode.hasFocus;

  /// The initial date time that was passed to the widget
  /// This is used to display the current date time in the calendar view
  late DateTime _initialDateTime = widget.initialDateTime.start;

  late DateTimeRange _currentDateTime = widget.initialDateTime;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant GraphicalDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialDateTime != widget.initialDateTime) {
      _currentDateTime = widget.initialDateTime;
      _initialDateTime = widget.initialDateTime.start;
    }
  }

  void _handleUpdateCalendarView(DateTime dateTime) {
    setState(() {
      if (_effectiveFocusNode.canRequestFocus) {
        FocusScope.of(context).requestFocus(_effectiveFocusNode);
      }
      _initialDateTime = dateTime.copyWith();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _effectiveFocusNode,
      canRequestFocus: enabled && _effectiveFocusNode.canRequestFocus,
      autofocus: enabled && widget.autofocus,
      child: AppKitFocusContainer(
        borderRadius: BorderRadius.circular(3),
        canRequestFocus: true,
        enabled: enabled,
        focusNode: _effectiveFocusNode,
        child: Builder(builder: (context) {
          final AppKitThemeData theme = AppKitTheme.of(context);
          final AppKitDateTimePickerThemeData dateTimePickerTheme =
              AppKitDateTimePickerTheme.of(context);

          final bool isDark = theme.brightness == Brightness.dark;
          final Color accentColor = widget.color ??
              dateTimePickerTheme.accentColor ??
              theme.activeColor.multiplyLuminance(0.85);

          return Container(
            constraints: const BoxConstraints(
              minWidth: _kGrahpicalDatePickerWidth,
              maxWidth: _kGrahpicalDatePickerWidth,
              minHeight: _kGrahpicalDatePickerHeight,
              maxHeight: _kGrahpicalDatePickerHeight,
            ),
            decoration: BoxDecoration(
              color: widget.drawBackground
                  ? dateTimePickerTheme.graphicalDatePickerBackgroundColor ??
                      theme.controlColor.multiplyOpacity(0.5)
                  : null,
              border: widget.drawBorder
                  ? Border(
                      top: BorderSide(
                          color: AppKitDynamicColor.resolve(
                                  context,
                                  isDark
                                      ? AppKitColors.text.opaque.quaternary
                                      : AppKitColors.text.opaque.tertiary)
                              .multiplyOpacity(0.65),
                          width: _kGraphicalDatePickerBorderWidth),
                      left: BorderSide(
                          color: AppKitDynamicColor.resolve(
                                  context, AppKitColors.text.opaque.tertiary)
                              .multiplyOpacity(0.65),
                          width: _kGraphicalDatePickerBorderWidth),
                      right: BorderSide(
                          color: AppKitDynamicColor.resolve(
                                  context, AppKitColors.text.opaque.tertiary)
                              .multiplyOpacity(0.65),
                          width: _kGraphicalDatePickerBorderWidth),
                      bottom: BorderSide(
                          color: AppKitDynamicColor.resolve(
                                  context, AppKitColors.text.opaque.secondary)
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
                      currentDate: _initialDateTime,
                      isMainWindow: widget.isMainWindow,
                      languageCode: widget.languageCode,
                      onDateChanged: enabled ? _handleUpdateCalendarView : null,
                      theme: theme,
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
                        focusNode: _effectiveFocusNode,
                        childFocusNode: _childFocusNode,
                        initialDateTime: _initialDateTime,
                        currentDateTime: _currentDateTime,
                        minimumDate: widget.minimumDate,
                        maximumDate: widget.maximumDate,
                        accentColor: accentColor,
                        theme: theme,
                        isMainWindow: widget.isMainWindow,
                        languageCode: widget.languageCode,
                        selectionType: widget.selectionType,
                        onUpdateCalendarView:
                            enabled ? _handleUpdateCalendarView : null,
                        onChanged: widget.onChanged,
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
  final bool isMainWindow;
  final String languageCode;
  final AppKitThemeData theme;
  final ValueChanged<DateTime>? onDateChanged;

  const _GraphicalDatePickerHeader({
    required this.currentDate,
    required this.isMainWindow,
    required this.languageCode,
    required this.theme,
    this.onDateChanged,
  });

  bool get isEnabled => onDateChanged != null;

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormatter = DateFormat.yMMM(languageCode);
    final String dateString = dateFormatter.format(currentDate);

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
              onPressed: isEnabled
                  ? () => onDateChanged?.call(currentDate.previousMonth())
                  : null,
            ),
            const SizedBox(width: 5.0),
            _GraphicalDatePickerHeaderButton(
              type: _HeaderButtonType.center,
              isMainWindow: isMainWindow,
              onPressed:
                  isEnabled ? () => onDateChanged?.call(DateTime.now()) : null,
            ),
            const SizedBox(width: 5.0),
            _GraphicalDatePickerHeaderButton(
              type: _HeaderButtonType.right,
              isMainWindow: isMainWindow,
              onPressed: isEnabled
                  ? () => onDateChanged?.call(currentDate.nextMonth())
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _GraphicalDatePickerContent extends StatelessWidget {
  final DateTime initialDateTime;
  final DateTimeRange currentDateTime;
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final bool isMainWindow;
  final String languageCode;
  final Color accentColor;
  final AppKitDatePickerSelectionType selectionType;
  final AppKitThemeData theme;
  final FocusNode? focusNode;
  final FocusNode childFocusNode;
  final OnDateChanged? onChanged;
  final ValueChanged<DateTime>? onUpdateCalendarView;

  const _GraphicalDatePickerContent({
    required this.initialDateTime,
    required this.currentDateTime,
    required this.theme,
    required this.isMainWindow,
    required this.languageCode,
    required this.accentColor,
    required this.selectionType,
    required this.childFocusNode,
    this.onChanged,
    this.minimumDate,
    this.maximumDate,
    this.onUpdateCalendarView,
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

  bool get enabled => onChanged != null;

  @override
  Widget build(BuildContext context) {
    final theme = AppKitTheme.of(context);
    final weekDayTextColor =
        AppKitDynamicColor.resolve(context, AppKitColors.text.opaque.secondary)
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
                  childFocusNode: childFocusNode,
                  initialDateTime: initialDateTime,
                  currentDateTime: currentDateTime,
                  minimumDate: minimumDate,
                  maximumDate: maximumDate,
                  isMainWindow: isMainWindow,
                  languageCode: languageCode,
                  accentColor: accentColor,
                  theme: theme,
                  selectionType: selectionType,
                  onUpdateCalendarView: onUpdateCalendarView,
                  onChanged: onChanged,
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
  final DateTimeRange currentDateTime;
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final AppKitThemeData theme;
  final bool isMainWindow;
  final String languageCode;
  final Color accentColor;
  final AppKitDatePickerSelectionType selectionType;
  final ValueChanged<DateTime>? onUpdateCalendarView;
  final OnDateChanged? onChanged;
  final FocusNode? focusNode;
  final FocusNode childFocusNode;

  const _GraphicalDatePickerMonthView({
    required this.initialDateTime,
    required this.currentDateTime,
    required this.theme,
    required this.isMainWindow,
    required this.languageCode,
    required this.accentColor,
    required this.selectionType,
    required this.childFocusNode,
    this.minimumDate,
    this.maximumDate,
    this.focusNode,
    this.onChanged,
    this.onUpdateCalendarView,
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

  late DateTime _initialDateTime = widget.initialDateTime;
  late DateTime? _pointerDownDate = _currentDateTime.start;
  late DateTimeRange _currentDateTime = widget.currentDateTime;

  DateTime? _hoveredDateTime;

  bool get isRangeSelection =>
      widget.selectionType == AppKitDatePickerSelectionType.range;

  DateTime get firstDayOfMonth => DateTime(
      _initialDateTime.year,
      _initialDateTime.month,
      1,
      _initialDateTime.hour,
      _initialDateTime.minute,
      _initialDateTime.second);

  DateTime get firstDayOfWeek =>
      firstDayOfMonth.subtract(Duration(days: firstDayOfMonth.weekday - 1));

  DateTime get lastDayOfMonth =>
      DateTime(_initialDateTime.year, _initialDateTime.month + 1, 0);

  DateTime get lastDayOfWeek =>
      firstDayOfWeek.add(const Duration(days: totalDays - 1));

  late DateTime today = DateTime.now();

  bool get enabled => widget.onChanged != null;

  @override
  void didUpdateWidget(covariant _GraphicalDatePickerMonthView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.currentDateTime != widget.currentDateTime) {
      _currentDateTime = widget.currentDateTime;

      if (widget.currentDateTime.start != _pointerDownDate &&
          widget.currentDateTime.end != _pointerDownDate) {
        _pointerDownDate = widget.currentDateTime.start;
      }
    }

    if (widget.initialDateTime != oldWidget.initialDateTime) {
      _initialDateTime = widget.initialDateTime;
    }
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    final bool isShiftPressed =
        isRangeSelection && HardwareKeyboard.instance.isShiftPressed;

    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      /// -->
      if (event.logicalKey == LogicalKeyboardKey.arrowRight ||
          event.logicalKey == LogicalKeyboardKey.arrowDown) {
        _pointerDownDate ??= _currentDateTime.start;

        final nextDay = _currentDateTime.end.add(Duration(
            days: event.logicalKey == LogicalKeyboardKey.arrowRight ? 1 : 7));

        final isBeforeMinimumDate =
            widget.minimumDate != null && nextDay.isBefore(widget.minimumDate!);
        final isAfterMaximumDate =
            widget.maximumDate != null && nextDay.isAfter(widget.maximumDate!);
        final isWithinValidRange = !isBeforeMinimumDate && !isAfterMaximumDate;

        if (!nextDay.isSameMonth(firstDayOfMonth)) {
          widget.onUpdateCalendarView?.call(nextDay);
        }

        if (isWithinValidRange) {
          setState(() {
            if (!isShiftPressed) {
              _pointerDownDate = nextDay;
            }

            if (isRangeSelection) {
              if (isShiftPressed) {
                _currentDateTime =
                    DateTimeRange(start: _pointerDownDate!, end: nextDay);
              } else {
                widget.onChanged?.call(right(DateTimeRange.single(nextDay)));
              }
            } else {
              widget.onChanged?.call(left(nextDay));
            }
          });
        }
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
          event.logicalKey == LogicalKeyboardKey.arrowUp) {
        _pointerDownDate ??= _currentDateTime.end;

        final nextDay = _currentDateTime.start.subtract(Duration(
            days: event.logicalKey == LogicalKeyboardKey.arrowLeft ? 1 : 7));

        final isBeforeMinimumDate =
            widget.minimumDate != null && nextDay.isBefore(widget.minimumDate!);
        final isAfterMaximumDate =
            widget.maximumDate != null && nextDay.isAfter(widget.maximumDate!);
        final isWithinValidRange = !isBeforeMinimumDate && !isAfterMaximumDate;

        if (!nextDay.isSameMonth(firstDayOfMonth)) {
          widget.onUpdateCalendarView?.call(nextDay);
        }

        if (isWithinValidRange) {
          setState(() {
            if (!isShiftPressed) {
              _pointerDownDate = nextDay;
            }

            if (isRangeSelection) {
              if (isShiftPressed) {
                _currentDateTime =
                    DateTimeRange(start: _pointerDownDate!, end: nextDay);
              } else {
                widget.onChanged?.call(right(DateTimeRange.single(nextDay)));
              }
            } else {
              widget.onChanged?.call(left(nextDay));
            }
          });
        }
        return KeyEventResult.handled;
      }
    } else if (event is KeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowRight ||
          event.logicalKey == LogicalKeyboardKey.arrowDown ||
          event.logicalKey == LogicalKeyboardKey.arrowLeft ||
          event.logicalKey == LogicalKeyboardKey.arrowUp) {
        if (isRangeSelection) {
          widget.onChanged?.call(right(_currentDateTime));
        }

        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  void _handlePanDown() {
    if (!enabled || _hoveredDateTime == null) {
      return;
    }

    final day = _hoveredDateTime!;
    final isBeforeCurrentMonth = day.isBefore(firstDayOfMonth);
    final isAfterCurrentMonth = day.isAfter(lastDayOfMonth);
    final isBeforeMinimumDate =
        widget.minimumDate != null && day.isBefore(widget.minimumDate!);
    final isAfterMaximumDate =
        widget.maximumDate != null && day.isAfter(widget.maximumDate!);
    final isWithinValidRange = !isBeforeMinimumDate && !isAfterMaximumDate;

    FocusScope.of(context).requestFocus(widget.childFocusNode);

    if (isBeforeCurrentMonth || isAfterCurrentMonth) {
      // do nothing
    } else if (isWithinValidRange) {
      // final bool isShiftPressed = isRangeSelection && HardwareKeyboard.instance.isShiftPressed;

      setState(() {
        _pointerDownDate = day;
        _isMousePressed = true;
        _currentDateTime = DateTimeRange(start: day, end: day);
      });
    }
  }

  void _handlePanUpdate() {
    if (_hoveredDateTime == null ||
        !_isMousePressed ||
        _pointerDownDate == null) {
      return;
    }

    final day = _hoveredDateTime!;

    final isBeforeCurrentMonth = day.isBefore(firstDayOfMonth);
    final isAfterCurrentMonth = day.isAfter(lastDayOfMonth);
    final isBeforeMinimumDate =
        widget.minimumDate != null && day.isBefore(widget.minimumDate!);
    final isAfterMaximumDate =
        widget.maximumDate != null && day.isAfter(widget.maximumDate!);
    final isWithinValidRange = !isBeforeMinimumDate && !isAfterMaximumDate;

    if (isBeforeCurrentMonth) {
      // widget.onPreviousMonthPressed?.call();
      return;
    } else if (isAfterCurrentMonth) {
      // widget.onNextMonthPressed?.call();
      return;
    } else if (!isWithinValidRange) {
      return;
    }

    if (day.isBefore(_pointerDownDate!)) {
      setState(() {
        _currentDateTime = DateTimeRange(start: day, end: _pointerDownDate!);
      });
    } else if (day.isAfter(_pointerDownDate!)) {
      setState(() {
        _currentDateTime = DateTimeRange(start: _pointerDownDate!, end: day);
      });
    }
  }

  void _handlePanEnd() {
    setState(() {
      _pointerDownDate = null;
      _isMousePressed = false;
      widget.onChanged?.call(right(_currentDateTime));
    });
  }

  void _handleTap(DateTime day) {
    final isBeforeCurrentMonth = day.isBefore(firstDayOfMonth);
    final isAfterCurrentMonth = day.isAfter(lastDayOfMonth);
    final isBeforeMinimumDate =
        widget.minimumDate != null && day.isBefore(widget.minimumDate!);
    final isAfterMaximumDate =
        widget.maximumDate != null && day.isAfter(widget.maximumDate!);
    final isWithinValidRange = !isBeforeMinimumDate && !isAfterMaximumDate;

    setState(() {
      if (!isRangeSelection) {
        FocusScope.of(context).requestFocus(widget.childFocusNode);
      }

      _isMousePressed = false;
      _pointerDownDate = null;

      if (isBeforeCurrentMonth) {
        widget.onUpdateCalendarView?.call(day);
      } else if (isAfterCurrentMonth) {
        widget.onUpdateCalendarView?.call(day);
      } else if (isWithinValidRange) {
        if (isRangeSelection) {
          widget.onChanged?.call(right(DateTimeRange(start: day, end: day)));
        } else {
          widget.onChanged?.call(left(day));
        }
      }
    });
  }

  void _handleMouseEnter(DateTime day) {
    final isBeforeCurrentMonth = day.isBefore(firstDayOfMonth);
    final isAfterCurrentMonth = day.isAfter(lastDayOfMonth);

    _hoveredDateTime = day;

    if (_isMousePressed) {
      if (isBeforeCurrentMonth) {
        widget.onUpdateCalendarView?.call(day);
        return;
      } else if (isAfterCurrentMonth) {
        widget.onUpdateCalendarView?.call(day);
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppKitTheme.of(context);

    if (widget.focusNode?.hasFocus == true && !widget.childFocusNode.hasFocus) {
      widget.childFocusNode.requestFocus();
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
          final isCurrentMonth = day.month == _initialDateTime.month;
          final isToday = day.day == today.day &&
              day.month == today.month &&
              day.year == today.year;
          final isBeforeMinimumDate =
              widget.minimumDate != null && day.isBefore(widget.minimumDate!);
          final isAfterMaximumDate =
              widget.maximumDate != null && day.isAfter(widget.maximumDate!);
          final isSelected = _currentDateTime.contains(day);

          final isPreviousDaySelected =
              day.weekday != 0 && _currentDateTime.isBefore(day);
          final isNextDaySelected =
              day.weekday != 7 && _currentDateTime.isAfter(day);

          final backgroundColor = enabled && isSelected
              ? widget.isMainWindow && isFocused
                  ? widget.accentColor
                  : AppKitColors.systemGray.withLuminance(0.85)
              : null;

          double dayTextOpacity = 1.0;

          if (!enabled) {
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
            child: MouseRegion(
              onEnter: enabled && isRangeSelection
                  ? (_) => _handleMouseEnter(day)
                  : null,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: enabled ? () => _handleTap(day) : null,
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

        return Focus(
          focusNode: widget.childFocusNode,
          canRequestFocus: true,
          onKeyEvent: enabled && widget.isMainWindow
              ? (node, event) => _handleKeyEvent(node, event)
              : null,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onPanDown:
                enabled && isRangeSelection ? (_) => _handlePanDown() : null,
            onPanEnd:
                enabled && isRangeSelection ? (_) => _handlePanEnd() : null,
            onPanUpdate:
                enabled && isRangeSelection ? (_) => _handlePanUpdate() : null,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var row in days) ...[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: row),
                ]
              ],
            ),
          ),
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

const _kGrahpicalTimePickerWidth = 120.0;

class GrahpicalTimePicker extends StatefulWidget {
  final DateTime initialDateTime;
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final ValueChanged<DateTime>? onChanged;
  final String languageCode;
  final bool isMainWindow;

  const GrahpicalTimePicker({
    super.key,
    required this.initialDateTime,
    this.minimumDate,
    this.maximumDate,
    this.onChanged,
    required this.languageCode,
    required this.isMainWindow,
  });

  @override
  State<GrahpicalTimePicker> createState() => _GrahpicalTimePickerState();
}

class _GrahpicalTimePickerState extends State<GrahpicalTimePicker> {
  late DateTime time = widget.initialDateTime;

  bool get enabled => widget.onChanged != null;

  @override
  void didUpdateWidget(covariant GrahpicalTimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialDateTime != widget.initialDateTime) {
      time = widget.initialDateTime;
    }
  }

  void _handleTimeChanged(DateTime newTime) {
    if (newTime != time) {
      widget.onChanged?.call(newTime);
      // setState(() {
      // time = newTime;
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return UiElementColorBuilder(builder: (context, colorContainer) {
      return SizedBox(
        width: _kGrahpicalTimePickerWidth,
        height: _kGrahpicalTimePickerWidth,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(
              painter: _GrahicalTimePickerBackgroundPainter(
                colorContainer: colorContainer,
                initialDateTime: time,
                languageCode: widget.languageCode,
              ),
            ),
            _GraphicalTimerPickerHandle(
              initialDateTime: time,
              element: _GrahicalTimePickerHourPainterElement.hour,
              onChanged: enabled ? _handleTimeChanged : null,
            ),
            _GraphicalTimerPickerHandle(
              initialDateTime: time,
              element: _GrahicalTimePickerHourPainterElement.minute,
              onChanged: enabled ? _handleTimeChanged : null,
            ),
            _GraphicalTimerPickerHandle(
              initialDateTime: time,
              element: _GrahicalTimePickerHourPainterElement.second,
              onChanged: enabled ? _handleTimeChanged : null,
            ),
          ],
        ),
      );
    });
  }
}

class _GraphicalTimerPickerHandle extends StatefulWidget {
  const _GraphicalTimerPickerHandle({
    required this.initialDateTime,
    required this.element,
    this.onChanged,
  });

  final DateTime initialDateTime;
  final _GrahicalTimePickerHourPainterElement element;
  final ValueChanged<DateTime>? onChanged;

  @override
  State<_GraphicalTimerPickerHandle> createState() =>
      _GraphicalTimerPickerHandleState();
}

class _GraphicalTimerPickerHandleState
    extends State<_GraphicalTimerPickerHandle> {
  _GrahicalTimePickerHourPainterElement get element => widget.element;

  Size _widgetSize = Size.zero;

  bool _panStarted = false;

  double _thumbAngle = 0.0;

  late DateTime _currentDateTime = widget.initialDateTime;

  @override
  @override
  void didUpdateWidget(_GraphicalTimerPickerHandle oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialDateTime != widget.initialDateTime) {
      _currentDateTime = widget.initialDateTime;
    }
  }

  bool get enabled => widget.onChanged != null;

  Color get color => element == _GrahicalTimePickerHourPainterElement.second
      ? Colors.red
      : Colors.black;

  double get radius => _widgetSize.shortestSide / 2;

  double get strokeWidth =>
      element == _GrahicalTimePickerHourPainterElement.second ? 1.25 : 3.0;

  double get widthRatio =>
      element == _GrahicalTimePickerHourPainterElement.second
          ? 0.85
          : element == _GrahicalTimePickerHourPainterElement.minute
              ? 0.85
              : 0.6;

  set currentDateTime(DateTime value) {
    setState(() {
      // _currentDateTime = value;
      widget.onChanged?.call(value);
    });
  }

  set panStarted(bool value) {
    setState(() => _panStarted = value);
  }

  void _handlePanDown(DragDownDetails details) {
    _thumbAngle = atan2(details.localPosition.dy - radius,
            details.localPosition.dx - radius) +
        pi / 2;
    panStarted = true;
  }

  void _handlePanEnd() {
    panStarted = false;
  }

  void _handleThumbPan(DragUpdateDetails details) {
    final angle = atan2(details.localPosition.dy - radius,
            details.localPosition.dx - radius) +
        pi / 2;
    double deltaAngle = angle - _thumbAngle;

    if (deltaAngle < -pi) {
      deltaAngle = (pi * 2) + deltaAngle;
    } else if (deltaAngle > pi) {
      deltaAngle = deltaAngle - (pi * 2);
    }

    final deltaDegrees = deltaAngle * 180 / pi;

    if (element == _GrahicalTimePickerHourPainterElement.minute ||
        element == _GrahicalTimePickerHourPainterElement.second) {
      // if delta degrees > 1 second, then update the time
      if (deltaDegrees.abs() >= 6) {
        final seconds = deltaDegrees ~/ 6;

        final newDateTime = _currentDateTime.add(
            element == _GrahicalTimePickerHourPainterElement.second
                ? Duration(seconds: seconds)
                : Duration(minutes: seconds));
        currentDateTime = newDateTime;
        _thumbAngle = angle;
      }
    } else {
      // if delta degrees > 1 hour, then update the time
      if (deltaDegrees.abs() >= 30) {
        final hours = deltaDegrees ~/ 30;
        final newDateTime = _currentDateTime.add(Duration(hours: hours));
        currentDateTime = newDateTime;
        _thumbAngle = angle;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppKitMeasureSingleChildWidget(
      onSizeChanged: (value) {
        _widgetSize = value;
      },
      child: GestureDetector(
        behavior: HitTestBehavior.deferToChild,
        dragStartBehavior: DragStartBehavior.start,
        onPanDown: enabled ? _handlePanDown : null,
        onPanEnd: (details) => _handlePanEnd(),
        onPanCancel: () => _handlePanEnd(),
        onPanUpdate: enabled
            ? (details) {
                if (_panStarted) {
                  _handleThumbPan(details);
                }
              }
            : null,
        child: SizedBox(
          child: CustomPaint(
            painter: _GrahicalTimePickerHandlePainter(
              time: _currentDateTime,
              color: color,
              strokeWidth: strokeWidth,
              widthRatio: widthRatio,
              element: element,
            ),
          ),
        ),
      ),
    );
  }
}

class _GrahicalTimePickerBackgroundPainter extends CustomPainter {
  static const clockViewBorderColor = Color(0xFFD1E5ED);
  static const dayPeriodTextColor = Color(0xFFAAAAAA);
  static const clockViewBackgroundColor = Colors.white;
  static const double handPinHoleSize = 3.0;
  static const TextStyle style =
      TextStyle(color: dayPeriodTextColor, fontSize: 13.0);

  final DateTime initialDateTime;

  final String languageCode;

  final UiElementColorContainer colorContainer;

  late String dayPeriod;

  _GrahicalTimePickerBackgroundPainter(
      {required this.colorContainer,
      required this.initialDateTime,
      required this.languageCode}) {
    dayPeriod = DateFormat('a', languageCode).format(initialDateTime);
  }

  @override
  void paint(Canvas canvas, Size size) {
    _paintClockBase(canvas, size);
    _paintAmPm(canvas, size);
    _paintHours(canvas, size, 1.0);
    _paintPinHole(canvas, size);
  }

  void _paintClockBase(Canvas canvas, Size size) {
    // Border
    const borderWidth = 5.0;
    final center = size.center(Offset.zero);
    final radius1 = size.shortestSide / 2.0;
    final radius2 = radius1 - borderWidth;
    final rect1 = Rect.fromCircle(center: center, radius: radius1);
    final rect2 = Rect.fromCircle(center: center, radius: radius2);
    final shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        clockViewBorderColor,
        Color.alphaBlend(
          const Color(0xFF767574),
          clockViewBorderColor,
        ),
      ],
    ).createShader(rect1);

    // Draw the border
    canvas.drawOval(rect1, Paint()..shader = shader);

    canvas.drawOval(rect2, Paint()..color = clockViewBackgroundColor);

    // Inner shadow
    const blurRadius = 3.0;
    final shadowPainter = Paint()
      ..maskFilter = const MaskFilter.blur(
        BlurStyle.normal,
        blurRadius,
      )
      ..color = colorContainer.shadowColor.withOpacity(0.9);
    final path = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(
        const EdgeInsets.all(blurRadius)
            .copyWith(bottom: -rect2.height / 2)
            .inflateRect(rect2),
      )
      ..addArc(
        const EdgeInsets.symmetric(horizontal: blurRadius).inflateRect(rect2),
        pi,
        pi,
      );
    canvas.clipPath(Path()..addOval(rect2));
    canvas.drawPath(path, shadowPainter);
  }

  void _paintAmPm(Canvas canvas, Size size) {
    TextSpan span = TextSpan(style: style, text: dayPeriod);
    TextPainter periodPainter = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    periodPainter.layout();
    periodPainter.paint(
      canvas,
      size.center(
        const Offset(0.0, 20.0) - periodPainter.size.center(Offset.zero),
      ),
    );
  }

  void _paintHours(
    Canvas canvas,
    Size size,
    double scaleFactor,
  ) {
    TextStyle style = const TextStyle(
        color: Colors.black, fontWeight: FontWeight.w300, fontSize: 13.0);
    double distanceFromBorder = 16.0;

    double radius = size.shortestSide / 2;
    double longHandLength = radius - (distanceFromBorder * scaleFactor);

    for (var hour = 1; hour <= 12; hour++) {
      double angle = (hour * pi / 6) - pi / 2;
      Offset offset = Offset(
        longHandLength * cos(angle),
        longHandLength * sin(angle),
      );
      TextSpan span = TextSpan(style: style, text: hour.toString());
      TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      tp.paint(canvas, size.center(offset - tp.size.center(Offset.zero)));
    }
  }

  void _paintPinHole(Canvas canvas, Size size) {
    final pinHolePainter = Paint()
      ..color = Colors.black
      ..isAntiAlias = true
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      size.center(Offset.zero),
      handPinHoleSize,
      pinHolePainter,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is _GrahicalTimePickerBackgroundPainter &&
        (oldDelegate.colorContainer != colorContainer ||
            oldDelegate.initialDateTime != initialDateTime ||
            oldDelegate.languageCode != languageCode);
  }
}

class _GrahicalTimePickerHandlePainter extends CustomPainter {
  Path? _hitTestPath;

  final DateTime time;
  final Color color;
  final double strokeWidth;
  final double widthRatio;
  final _GrahicalTimePickerHourPainterElement element;

  _GrahicalTimePickerHandlePainter({
    required this.time,
    required this.color,
    required this.strokeWidth,
    required this.widthRatio,
    required this.element,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final shortestSide = size.shortestSide;
    double r = shortestSide / 2;
    double hourHandLength = r * widthRatio;

    final handPaint = Paint()
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.bevel
      ..color = color
      ..strokeWidth = strokeWidth;

    double seconds = time.second / 60.0;
    double minutes = (time.minute + seconds) / 60.0;
    double hour = (time.hour + minutes) / 12.0;

    // Draw hour hand
    Offset center = size.center(Offset.zero);

    final rect = Rect.fromLTRB(
        element == _GrahicalTimePickerHourPainterElement.second
            ? -(shortestSide * 0.05833333333)
            : 0,
        -strokeWidth / 2,
        hourHandLength,
        strokeWidth / 2);

    final rrect =
        RRect.fromRectAndRadius(rect, Radius.circular(strokeWidth / 2));

    // rotate the rect
    Path path = Path()
      ..addRRect(rrect)
      ..close();

    final radians = -pi / 2 +
        2 *
            pi *
            (element == _GrahicalTimePickerHourPainterElement.hour
                ? hour
                : element == _GrahicalTimePickerHourPainterElement.minute
                    ? minutes
                    : seconds);

    path = path.transform(Matrix4.rotationZ(radians).storage);
    path = path.shift(center);

    final hitTestRect = rect.inflate(strokeWidth);
    Path hitPath = Path()
      ..addRect(hitTestRect)
      ..close();

    _hitTestPath = Path()
      ..addPath(
          hitPath.transform(Matrix4.rotationZ(radians).storage).shift(center),
          Offset.zero);

    if (element == _GrahicalTimePickerHourPainterElement.second) {
      canvas.drawCircle(center, 2, handPaint);
    }

    canvas.drawPath(path, handPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is _GrahicalTimePickerHandlePainter &&
        (oldDelegate.time != time ||
            oldDelegate.color != color ||
            oldDelegate.strokeWidth != strokeWidth ||
            oldDelegate.widthRatio != widthRatio ||
            _hitTestPath == null);
  }

  @override
  bool? hitTest(Offset position) {
    if (_hitTestPath == null) {
      return false;
    }
    final test = _hitTestPath!.contains(position);
    return test;
  }
}

enum _GrahicalTimePickerHourPainterElement { hour, minute, second }
