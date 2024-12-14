import 'dart:async';
import 'dart:math';

import 'package:appkit_ui_element_colors/appkit_ui_element_colors.dart';
import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:appkit_ui_elements/src/library.dart';
import 'package:appkit_ui_elements/src/utils/main_window_listener.dart';
import 'package:appkit_ui_elements/src/widgets/date_picker/textual_date_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' hide TextDirection;

class AppKitDatePicker extends StatefulWidget {
  final bool autofocus;
  final bool canRequestFocus;
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
  final Function(DateTime, DateTime?)? onChanged;
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
    this.canRequestFocus = true,
    this.autofocus = false,
    this.drawBackground = true,
    this.drawBorder = true,
    this.selectionType = AppKitDatePickerSelectionType.single,
    DateTime? date,
  }) : initialDateTime = date ?? DateTime.now() {
    assert(
        dateElements != AppKitDateElements.none ||
            timeElements != AppKitTimeElements.none,
        'At least one of dateElements or timeElements must be non-none');
    assert(
        minimumDate != null
            ? initialDateTime.isSameOrAfter(minimumDate!)
            : true,
        'initialDateTime [$initialDateTime] must be after minimumDate [$minimumDate] (if set)');
    assert(
        maximumDate != null
            ? initialDateTime.isSameOrBefore(maximumDate!)
            : true,
        'initialDateTime [$initialDateTime] must be before maximumDate [$maximumDate] (if set)');
    assert(minimumDate == null ||
        maximumDate == null ||
        minimumDate!.isSameOrBefore(maximumDate!));
  }

  @override
  State<AppKitDatePicker> createState() => _AppKitDatePickerState();
}

class _AppKitDatePickerState extends State<AppKitDatePicker> {
  bool get enabled => widget.onChanged != null;

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
            onChanged: enabled ? (d) => widget.onChanged?.call(d, null) : null,
            languageCode: languageCode,
            isMainWindow: isMainWindow,
            autofocus: widget.autofocus,
            canRequestFocus: widget.canRequestFocus,
          );
        } else {
          if (widget.dateElements != AppKitDateElements.none) {
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
          } else {
            return _GrahpicalTimePicker(
              initialDateTime: widget.initialDateTime,
              minimumDate: widget.minimumDate,
              maximumDate: widget.maximumDate,
              languageCode: languageCode,
              isMainWindow: isMainWindow,
              onChanged:
                  enabled ? (d) => widget.onChanged?.call(d, null) : null,
            );
          }
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
  final Function(DateTime, DateTime?)? onChanged;
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

  late final DateTime _currentDateTime = widget.initialDateTime;

  late final FocusNode _childFocusNode = FocusNode();

  bool get enabled => widget.onChanged != null;

  bool get isFocused => _focusNode.hasFocus;

  set currentDateTime(DateTime value) {
    if (value != _currentDateTime) {
      widget.onChanged?.call(value, null);
      // setState(() {
      // debugPrint('$runtimeType Setting currentDateTime: $value');
      // _currentDateTime = value;
      // });
    }
  }

  DateTime get currentDateTime => _currentDateTime;

  void _handlePreviousDatePressed() {
    currentDateTime = DateTime(
        currentDateTime.year, currentDateTime.month - 1, currentDateTime.day);
    FocusScope.of(context).requestFocus(_focusNode);
  }

  void _handleNextDatePressed() {
    currentDateTime = DateTime(
        currentDateTime.year, currentDateTime.month + 1, currentDateTime.day);
    FocusScope.of(context).requestFocus(_focusNode);
  }

  void _handleCurrentDatePressed() {
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
                        childFocusNode: _childFocusNode,
                        initialDateTime: currentDateTime,
                        minimumDate: widget.minimumDate,
                        maximumDate: widget.maximumDate,
                        colorContainer: colorContainer,
                        accentColor: accentColor,
                        isMainWindow: widget.isMainWindow,
                        languageCode: widget.languageCode,
                        selectionType: widget.selectionType,
                        onPreviousMonthPressed:
                            enabled ? _handlePreviousDatePressed : null,
                        onNextMonthPressed:
                            enabled ? _handleNextDatePressed : null,
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
  final String languageCode;
  final Color accentColor;
  final VoidCallback? onPreviousMonthPressed;
  final VoidCallback? onNextMonthPressed;
  final AppKitDatePickerSelectionType selectionType;
  final FocusNode? focusNode;
  final FocusNode childFocusNode;
  final Function(DateTime, DateTime?)? onChanged;

  const _GraphicalDatePickerContent({
    required this.initialDateTime,
    required this.colorContainer,
    required this.isMainWindow,
    required this.languageCode,
    required this.accentColor,
    required this.selectionType,
    required this.childFocusNode,
    this.onChanged,
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

  bool get enabled => onChanged != null;

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
                  childFocusNode: childFocusNode,
                  initialDateTime: initialDateTime,
                  minimumDate: minimumDate,
                  maximumDate: maximumDate,
                  colorContainer: colorContainer,
                  isMainWindow: isMainWindow,
                  languageCode: languageCode,
                  accentColor: accentColor,
                  selectionType: selectionType,
                  onPreviousMonthPressed: onPreviousMonthPressed,
                  onNextMonthPressed: onNextMonthPressed,
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
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final UiElementColorContainer colorContainer;
  final bool isMainWindow;
  final String languageCode;
  final Color accentColor;
  final AppKitDatePickerSelectionType selectionType;
  final VoidCallback? onPreviousMonthPressed;
  final VoidCallback? onNextMonthPressed;
  final Function(DateTime, DateTime?)? onChanged;
  final FocusNode? focusNode;
  final FocusNode childFocusNode;

  const _GraphicalDatePickerMonthView({
    required this.initialDateTime,
    required this.colorContainer,
    required this.isMainWindow,
    required this.languageCode,
    required this.accentColor,
    required this.selectionType,
    required this.childFocusNode,
    this.minimumDate,
    this.maximumDate,
    this.onPreviousMonthPressed,
    this.onNextMonthPressed,
    this.focusNode,
    this.onChanged,
  });

  @override
  State<_GraphicalDatePickerMonthView> createState() =>
      _GraphicalDatePickerMonthViewState();
}

final _logger = newLogger('GraphicalDatePickerMonthView');

class _GraphicalDatePickerMonthViewState
    extends State<_GraphicalDatePickerMonthView> {
  static const rowsCount = 7;
  static const columnsCount = 6;
  static const totalDays = rowsCount * columnsCount;

  bool _isMousePressed = false;

  /// The date that was pressed down
  late DateTime? _pointerDownDate = widget.initialDateTime;

  DateTime? _currentSelectedDate;

  bool get enabled => widget.onChanged != null;

  set pointerDownDate(DateTime? value) {
    if (value != _pointerDownDate) {
      _logger.d('set pointerDownDate => $value');
      _pointerDownDate = value;
    }
  }

  set currentSelectedDate(DateTime? value) {
    if (value != _currentSelectedDate) {
      _logger.d('set currentSelectedDate => $value');
      _currentSelectedDate = value;
    }
  }

  DateTime get currentSelectedDate =>
      _currentSelectedDate ?? widget.initialDateTime;

  DateTime? get pointerDownDate => _pointerDownDate;

  DateTime? _selectedStartDate;

  DateTime? _selectedEndDate;

  DateTime get selectedStartDate =>
      _selectedStartDate ?? widget.initialDateTime;

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

  @override
  void didUpdateWidget(covariant _GraphicalDatePickerMonthView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialDateTime != widget.initialDateTime) {
      _logger.d('==>> Initial date changed: ${widget.initialDateTime}');
      // _pointerDownDate = widget.initialDateTime;
      // _currentSelectedDate = widget.initialDateTime;
    }
  }

  void _setSelectionRange(DateTime startDate, DateTime? endDate) {
    debugPrint('==>> Setting selection range: $startDate - $endDate');
    setState(() {
      if (endDate == null) {
        _selectedStartDate = startDate;
        _selectedEndDate = null;
      } else {
        _selectedStartDate = startDate.isBefore(endDate) ? startDate : endDate;
        _selectedEndDate = startDate.isBefore(endDate) ? endDate : startDate;
      }
    });
    widget.onChanged?.call(_selectedStartDate!, _selectedEndDate);
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    final bool isShiftPressed =
        isRangeSelection && HardwareKeyboard.instance.isShiftPressed;

    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      final originalDate = _pointerDownDate ?? currentSelectedDate;

      if (event.logicalKey == LogicalKeyboardKey.arrowRight ||
          event.logicalKey == LogicalKeyboardKey.arrowDown) {
        final nextDay = currentSelectedDate.add(Duration(
            days: event.logicalKey == LogicalKeyboardKey.arrowRight ? 1 : 7));

        if (nextDay.isAfter(lastDayOfMonth) &&
            nextDay.isBefore(widget.maximumDate ?? DateTime(9999))) {
          widget.onNextMonthPressed?.call();
        }

        setState(() {
          if (!isShiftPressed) {
            pointerDownDate = nextDay;
          }
          currentSelectedDate = nextDay;
          _setSelectionRange(nextDay, isShiftPressed ? originalDate : null);
        });
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
          event.logicalKey == LogicalKeyboardKey.arrowUp) {
        final duration = Duration(
            days: event.logicalKey == LogicalKeyboardKey.arrowLeft ? 1 : 7);

        final previousDay = currentSelectedDate.subtract(duration);

        if (previousDay.isBefore(firstDayOfMonth) &&
            previousDay.isAfter(widget.minimumDate ?? DateTime(1))) {
          widget.onPreviousMonthPressed?.call();
        }
        setState(() {
          if (!isShiftPressed) {
            pointerDownDate = previousDay;
          }
          currentSelectedDate = previousDay;
          _setSelectionRange(previousDay, isShiftPressed ? originalDate : null);
        });
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppKitTheme.of(context);

    _logger.t('focusNode is focused: ${widget.focusNode?.hasFocus}');

    if (widget.focusNode?.hasFocus == true && !widget.childFocusNode.hasFocus) {
      _logger.t('Requesting focus on childFocusNode');
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
              onEnter: enabled &&
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
                onPointerUp: enabled
                    ? (_) {
                        setState(() {
                          _isMousePressed = false;
                        });
                      }
                    : null,
                onPointerDown: enabled
                    ? (_) {
                        FocusScope.of(context)
                            .requestFocus(widget.childFocusNode);

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
                              currentSelectedDate = day;
                              _setSelectionRange(day, selectedStartDate);
                            } else {
                              _isMousePressed = true;
                              currentSelectedDate = day;
                              pointerDownDate = day;
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
          onFocusChange: (value) {
            debugPrint('==>> Focus changed $value');
          },
          onKeyEvent: enabled && widget.isMainWindow
              ? (node, event) => _handleKeyEvent(node, event)
              : null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var row in days) ...[
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: row),
                // if (days.indexOf(row) < days.length - 1) const SizedBox(height: 2.0),
              ]
            ],
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

class _GrahpicalTimePicker extends StatefulWidget {
  final DateTime initialDateTime;
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final ValueChanged<DateTime>? onChanged;
  final String languageCode;
  final bool isMainWindow;

  const _GrahpicalTimePicker({
    required this.initialDateTime,
    this.minimumDate,
    this.maximumDate,
    this.onChanged,
    required this.languageCode,
    required this.isMainWindow,
  });

  @override
  State<_GrahpicalTimePicker> createState() => _GrahpicalTimePickerState();
}

class _GrahpicalTimePickerState extends State<_GrahpicalTimePicker> {
  late DateTime time = widget.initialDateTime;

  bool get enabled => widget.onChanged != null;

  @override
  void didUpdateWidget(covariant _GrahpicalTimePicker oldWidget) {
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
    debugPrint('[$element] _handlePanDown(details: $details)');
    _thumbAngle = atan2(details.localPosition.dy - radius,
            details.localPosition.dx - radius) +
        pi / 2;
    panStarted = true;
  }

  void _handlePanEnd() {
    debugPrint('[$element] _handlePanEnd()');
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
    // debugPrint('==> [$element] [${_hitTestPath!.getBounds()}] Hit test: $test');
    return test;
  }
}

enum _GrahicalTimePickerHourPainterElement { hour, minute, second }
