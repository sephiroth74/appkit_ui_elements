import 'dart:async';

import 'package:appkit_ui_element_colors/appkit_ui_element_colors.dart';
import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:appkit_ui_elements/src/library.dart';
import 'package:appkit_ui_elements/src/utils/main_window_listener.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
          return _TextualDatePicker(
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

class _GraphicalDatePicker extends StatefulWidget {
  static const width = 139.0;
  static const height = 148.0;

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
  bool get enabled => widget.onChanged != null;

  late DateTime _currentDateTime = widget.initialDateTime;

  set currentDateTime(DateTime value) {
    if (value != _currentDateTime) {
      setState(() {
        debugPrint('Setting currentDateTime: $value');
        _currentDateTime = value;
      });
    }
  }

  DateTime get currentDateTime => _currentDateTime;

  void _handlePreviousDatePressed() {
    currentDateTime = DateTime(
        currentDateTime.year, currentDateTime.month - 1, currentDateTime.day);
  }

  void _handleNextDatePressed() {
    currentDateTime = DateTime(
        currentDateTime.year, currentDateTime.month + 1, currentDateTime.day);
  }

  void _handleCurrentDatePressed() {
    currentDateTime = widget.initialDateTime;
  }

  @override
  Widget build(BuildContext context) {
    const borderWidth = 1.0;
    return UiElementColorBuilder(builder: (context, colorContainer) {
      final theme = AppKitTheme.of(context);
      final accentColor = widget.color ??
          theme.accentColor ??
          colorContainer.controlAccentColor;

      return Container(
        constraints: const BoxConstraints(
          minWidth: _GraphicalDatePicker.width,
          maxWidth: _GraphicalDatePicker.width,
          minHeight: _GraphicalDatePicker.height,
          maxHeight: _GraphicalDatePicker.height,
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
                      width: borderWidth),
                  left: BorderSide(
                      color: AppKitColors.text.opaque.tertiary
                          .multiplyOpacity(0.65),
                      width: borderWidth),
                  right: BorderSide(
                      color: AppKitColors.text.opaque.tertiary
                          .multiplyOpacity(0.65),
                      width: borderWidth),
                  bottom: BorderSide(
                      color: AppKitColors.text.opaque.secondary
                          .multiplyOpacity(0.65),
                      width: borderWidth),
                )
              : Border.all(color: Colors.transparent, width: borderWidth),
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 18,
                child: _GraphicalDatePickerHeader(
                  currentDate: currentDateTime,
                  colorContainer: colorContainer,
                  isMainWindow: widget.isMainWindow,
                  enabled: enabled,
                  languageCode: widget.languageCode,
                  onPreviousDatePressed:
                      enabled ? _handlePreviousDatePressed : null,
                  onNextDatePressed: enabled ? _handleNextDatePressed : null,
                  onCurrentDatePressed:
                      enabled ? _handleCurrentDatePressed : null,
                ),
              ),
              const SizedBox(height: 2.0),
              SizedBox(
                height: constraints.maxHeight - 18 - 2,
                width: constraints.maxWidth,
                child: _GraphicalDatePickerContent(
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
                  onNextMonthPressed: enabled ? _handleNextDatePressed : null,
                ),
              )
            ],
          );
        }),
      );
    });
  }
}

class _GraphicalDatePickerHeader extends StatefulWidget {
  final DateTime currentDate;
  final UiElementColorContainer colorContainer;
  final bool isMainWindow;
  final bool enabled;
  final String languageCode;
  final VoidCallback? onPreviousDatePressed;
  final VoidCallback? onNextDatePressed;
  final VoidCallback? onCurrentDatePressed;

  const _GraphicalDatePickerHeader({
    required this.currentDate,
    required this.colorContainer,
    required this.isMainWindow,
    required this.enabled,
    required this.languageCode,
    this.onPreviousDatePressed,
    this.onNextDatePressed,
    this.onCurrentDatePressed,
  });

  @override
  State<_GraphicalDatePickerHeader> createState() =>
      _GraphicalDatePickerHeaderState();
}

class _GraphicalDatePickerHeaderState
    extends State<_GraphicalDatePickerHeader> {
  bool get enabled => widget.enabled && widget.onPreviousDatePressed != null;

  void _handleArrowLeftPressed() {
    widget.onPreviousDatePressed?.call();
  }

  void _handleArrowRightPressed() {
    widget.onNextDatePressed?.call();
  }

  void _handleArrowCenterPressed() {
    widget.onCurrentDatePressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormatter = DateFormat.yMMM(widget.languageCode);
    final String dateString = dateFormatter.format(widget.currentDate);
    final theme = AppKitTheme.of(context);

    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 2.0, right: 3.5, top: 2.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Opacity(
              opacity: widget.enabled ? 1.0 : 0.5,
              child: DefaultTextStyle(
                  style: theme.typography.callout.copyWith(
                      fontWeight: AppKitFontWeight.w600, fontSize: 12.0),
                  child: Text(dateString)),
            ),
            const Spacer(),
            _GraphicalDatePickerHeaderButton(
              type: _HeaderButtonType.left,
              enabled: widget.enabled,
              isMainWindow: widget.isMainWindow,
              onPressed: enabled ? _handleArrowLeftPressed : null,
            ),
            const SizedBox(width: 5.0),
            _GraphicalDatePickerHeaderButton(
              type: _HeaderButtonType.center,
              enabled: widget.enabled,
              isMainWindow: widget.isMainWindow,
              onPressed: enabled ? _handleArrowCenterPressed : null,
            ),
            const SizedBox(width: 5.0),
            _GraphicalDatePickerHeaderButton(
              type: _HeaderButtonType.right,
              enabled: widget.enabled,
              isMainWindow: widget.isMainWindow,
              onPressed: enabled ? _handleArrowRightPressed : null,
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

  const _GraphicalDatePickerContent({
    required this.initialDateTime,
    required this.colorContainer,
    required this.isMainWindow,
    required this.enabled,
    required this.languageCode,
    required this.accentColor,
    required this.selectionType,
    this.minimumDate,
    this.maximumDate,
    this.onPreviousMonthPressed,
    this.onNextMonthPressed,
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
                padding: const EdgeInsets.only(left: 1.0, right: 2.0),
                child: _GraphicalDatePickerMonthView(
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

  const _GraphicalDatePickerMonthView({
    required this.initialDateTime,
    required this.colorContainer,
    required this.isMainWindow,
    required this.enabled,
    required this.languageCode,
    required this.accentColor,
    required this.selectionType,
    this.minimumDate,
    this.maximumDate,
    this.onPreviousMonthPressed,
    this.onNextMonthPressed,
  });

  @override
  State<_GraphicalDatePickerMonthView> createState() =>
      _GraphicalDatePickerMonthViewState();
}

class _GraphicalDatePickerMonthViewState
    extends State<_GraphicalDatePickerMonthView> {
  bool isMousePressed = false;

  DateTime? _pointerDownDate;

  DateTime? _selectedStartDate;

  DateTime? _selectedEndDate;

  DateTime get selectedStartDate =>
      _selectedStartDate ?? widget.initialDateTime;

  DateTime? get selectedEndDate => _selectedEndDate;

  bool get isRangeSelection =>
      widget.selectionType == AppKitDatePickerSelectionType.range;

  void _setSelectionRange(DateTime startDate, DateTime endDate) {
    setState(() {
      _selectedStartDate = startDate.isBefore(endDate) ? startDate : endDate;
      _selectedEndDate = startDate.isBefore(endDate) ? endDate : startDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppKitTheme.of(context);

    // find the date of the first day of the week from the 1st day of the current month
    final firstDayOfMonth =
        DateTime(widget.initialDateTime.year, widget.initialDateTime.month, 1);
    final firstDayOfWeek =
        firstDayOfMonth.subtract(Duration(days: firstDayOfMonth.weekday - 1));
    final lastDayOfMonth = DateTime(
        widget.initialDateTime.year, widget.initialDateTime.month + 1, 0);
    final lastDayOfWeek = lastDayOfMonth.add(Duration(
        days: 7 - (lastDayOfMonth.weekday == 7 ? 0 : lastDayOfMonth.weekday)));
    final dayTextStyle = theme.typography.callout.copyWith(fontSize: 10.0);
    final today = DateTime.now();

    return Padding(
      // padding: const EdgeInsets.only(left: 1.0, right: 3.0, bottom: 4.0, top: 2.0),
      padding: EdgeInsets.zero,
      child: LayoutBuilder(builder: (context, constraints) {
        // now create a grid displaying all the days, starting from the firstDayOfWeek to the lastDayOfWeek
        final totalWidth = constraints.maxWidth;
        final totalHeight = constraints.maxHeight;
        final days = <List<Widget>>[];
        List<Widget> currentRow = <Widget>[];
        final totalDays = lastDayOfWeek.difference(firstDayOfWeek).inDays + 1;

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

          final backgroundColor = widget.enabled && isSelected
              ? widget.isMainWindow
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
              : isToday && widget.isMainWindow
                  ? widget.accentColor
                  : AppKitColors.text.opaque.primary;

          dayTextColor = dayTextColor.multiplyOpacity(dayTextOpacity);

          final textStyle = dayTextStyle.copyWith(
              color: dayTextColor,
              fontWeight: isToday ? FontWeight.bold : null);

          final dayWidget = Padding(
            padding: const EdgeInsets.only(left: 1.0, right: 1.0, bottom: 2.0),
            child: MouseRegion(
              onEnter: widget.enabled &&
                      isRangeSelection &&
                      isMousePressed &&
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
                        debugPrint('onPointerUp');
                        setState(() {
                          isMousePressed = false;
                          _pointerDownDate = null;
                        });
                      }
                    : null,
                onPointerCancel: (_) {
                  debugPrint('onPointerCancel');
                },
                onPointerDown: widget.enabled
                    ? (_) {
                        debugPrint('onPointerDown');
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
                              isMousePressed = false;
                              _setSelectionRange(day, selectedStartDate);
                            } else {
                              isMousePressed = true;
                              _pointerDownDate = day;
                              _selectedStartDate = day;
                              _selectedEndDate = null;
                            }
                          });
                        }
                      }
                    : null,
                child: Container(
                  width: (totalWidth / 7) - 2,
                  height: (totalHeight / 6) - 2,
                  decoration: isSelected
                      ? BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(3.0))
                      : null,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 2.0),
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: row,
              ),
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
  final bool enabled;
  final bool isMainWindow;
  final VoidCallback? onPressed;

  const _GraphicalDatePickerHeaderButton({
    required this.type,
    required this.enabled,
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
      onTapDown: widget.enabled ? (_) => _handleTapDown() : null,
      onTapUp: (_) => widget.enabled ? _handleTapUpOrCancel() : null,
      onTapCancel: () => widget.enabled ? _handleTapUpOrCancel() : null,
      child: SizedBox(
        width: 10,
        height: 10,
        child: Center(
          child: CustomPaint(
            size: const Size(6.5, 6.5),
            painter: _GraphicalDatePickerHeaderButtonPainter(
              type: widget.type,
              enabled: widget.enabled,
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

// region TextualDatePicker

class _TextualDatePicker extends StatefulWidget {
  final String languageCode;
  final AppKitDatePickerType type;
  final AppKitDateElements dateElements;
  final AppKitTimeElements timeElements;
  final DateTime initialDateTime;
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final TextStyle? textStyle;
  final Color? color;
  final bool drawBackground;
  final bool drawBorder;
  final VoidCallback? onChanged;
  final bool isMainWindow;

  const _TextualDatePicker({
    required this.type,
    required this.dateElements,
    required this.timeElements,
    required this.initialDateTime,
    required this.languageCode,
    required this.isMainWindow,
    this.minimumDate,
    this.maximumDate,
    this.textStyle,
    this.color,
    this.onChanged,
    this.drawBackground = true,
    this.drawBorder = true,
  });

  @override
  State<_TextualDatePicker> createState() => _TextualDatePickerState();
}

class _TextualDatePickerState extends State<_TextualDatePicker> {
  int? _focusedIndex;

  bool get enabled => widget.onChanged != null;

  bool get isMainWindow => widget.isMainWindow;

  String get languageCode => widget.languageCode;

  late DateFormat dateFormatter;

  late DateFormat timeFormatter;

  late List<String> dateFormatterSegments;

  late List<String> timeFormatterSegments;

  late List<FocusNode> focusNodes;

  late DateTime dateTime;

  bool get hasDate => widget.dateElements != AppKitDateElements.none;

  bool get hasTime => widget.timeElements != AppKitTimeElements.none;

  String get dateString => dateFormatter.format(dateTime);

  String get timeString => timeFormatter.format(dateTime);

  List<int> get dateSegments => dateString.split('/').map(int.parse).toList();

  List<int> get timeSegments => timeString.split(':').map(int.parse).toList();

  (TextStyle, double)? _charWidth;

  @override
  void initState() {
    super.initState();
    initializeWidget();
  }

  void initializeWidget() {
    debugPrint('**** initializeWidget ****');
    dateTime = widget.initialDateTime.copyWith();

    dateFormatter = widget.dateElements.getDateFormat(languageCode);
    timeFormatter = widget.timeElements.getDateFormat(languageCode);

    dateFormatterSegments =
        hasDate ? dateFormatter.pattern!.split('/').toList() : [];
    timeFormatterSegments =
        hasTime ? timeFormatter.pattern!.split(':').toList() : [];

    final totalSegments =
        (dateFormatterSegments.length) + (timeFormatterSegments.length);

    focusNodes = List.generate(totalSegments, (index) => FocusNode());

    if (_focusedIndex == null || _focusedIndex! >= totalSegments) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        FocusScope.of(context).requestFocus(focusNodes[0]);
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _TextualDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    debugPrint('**** didUpdateWidget ****');
    debugPrint('${oldWidget.dateElements} => ${widget.dateElements}');
    debugPrint('${oldWidget.timeElements} => ${widget.timeElements}');
    debugPrint('${oldWidget.initialDateTime} => ${widget.initialDateTime}');

    if (oldWidget.dateElements != widget.dateElements ||
        oldWidget.timeElements != widget.timeElements ||
        oldWidget.initialDateTime != widget.initialDateTime) {
      initializeWidget();
    }
  }

  void _handleFocusChange(int index, bool value) {
    debugPrint('_handleFocusChange: $index => $value');
    setState(() {
      _focusedIndex = value ? index : null;
    });
  }

  void _handleSegmentStep(int? index, bool increase) {
    debugPrint('_handleSegmentStep: $index => $increase');
    if (index == null) return;
    final segments = List.from(
        index < dateFormatterSegments.length ? dateSegments : timeSegments);
    final segmentIndex = index < dateFormatterSegments.length
        ? index
        : index - dateFormatterSegments.length;
    int newValue = segments[segmentIndex] + (increase ? 1 : -1);
    _handleSegmentChanged(index, newValue);
  }

  void _handleSegmentChanged(int index, int value) {
    final isTimeSegment = index >= dateFormatterSegments.length;
    final segments = List.from(
        index < dateFormatterSegments.length ? dateSegments : timeSegments);
    final segmentIndex = index < dateFormatterSegments.length
        ? index
        : index - dateFormatterSegments.length;
    final segmentName = isTimeSegment
        ? timeFormatterSegments[segmentIndex]
        : dateFormatterSegments[segmentIndex];

    int newValue = value;

    if (value < 0 && isTimeSegment) {
      if (segmentName == 'H') {
        newValue = 23;
      } else {
        newValue = 59;
      }
    }

    if (newValue < 0) newValue = 0;
    segments[segmentIndex] = newValue;

    final DateTime newDate;
    final DateTime newTime;

    if (isTimeSegment) {
      final timeString = segments.join(':');
      newTime = timeFormatter.parse(timeString);
      newDate = dateFormatter.parse(dateString);
    } else {
      final dateString = segments.join('/');
      newDate = dateFormatter.parse(dateString);
      newTime = timeFormatter.parse(timeString);
    }

    setState(() {
      dateTime = DateTime(newDate.year, newDate.month, newDate.day,
          newTime.hour, newTime.minute, newTime.second);
      debugPrint('New DateTime: $dateTime');
    });
  }

  double _getCharWidth(TextStyle textStyle) {
    if (_charWidth != null && _charWidth!.$1 == textStyle) {
      return _charWidth!.$2;
    }
    double maxWidth = 0;
    for (int i in [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]) {
      final Size size = textStyle.getTextSize(i.toString());
      if (size.width > maxWidth) {
        maxWidth = size.width;
      }
    }
    _charWidth = (textStyle, maxWidth);
    return maxWidth;
  }

  @override
  Widget build(BuildContext context) {
    return UiElementColorBuilder(builder: (context, colorContainer) {
      return LayoutBuilder(builder: (context, constraints) {
        assert(constraints.hasBoundedWidth);
        final theme = AppKitTheme.of(context);

        final textStyle = theme.typography.body;
        final charWidth = _getCharWidth(textStyle);

        final List<Widget> children = [];

        for (var i = 0; i < dateFormatterSegments.length; i++) {
          String segment = dateSegments[i].toString();
          final formatterSegment = dateFormatterSegments[i];

          if (formatterSegment == 'y') {
            segment = segment.padLeft(4, '0');
          } else {
            segment = segment.padLeft(2, '0');
          }

          // create a string filled with zeros based on the segment length
          final child = _TextualPickerElement(
            enabled: enabled,
            text: segment,
            charWidth: charWidth,
            textStyle: textStyle,
            index: i,
            color: widget.color ??
                theme.accentColor ??
                colorContainer.controlAccentColor,
            isMainWindow: isMainWindow,
            focusNode: focusNodes[i],
            onSegmentChanged: enabled ? _handleSegmentChanged : null,
            onFocusChanged: enabled ? _handleFocusChange : null,
            isFocused: enabled && _focusedIndex == i,
          );

          children.add(child);

          if (i < dateSegments.length - 1) {
            children.add(DefaultTextStyle(
                style: theme.typography.body, child: const Text('.')));
          }
        }

        if (children.isNotEmpty && timeFormatterSegments.isNotEmpty) {
          children.add(DefaultTextStyle(
              style: theme.typography.body, child: const Text(', ')));
        }

        // now add the time segments

        for (var i = 0; i < timeFormatterSegments.length; i++) {
          String segment = timeSegments[i].toString();
          segment = segment.padLeft(2, '0');

          // create a string filled with zeros based on the segment length
          final child = _TextualPickerElement(
            enabled: enabled,
            text: segment,
            charWidth: charWidth,
            textStyle: textStyle,
            index: i + dateFormatterSegments.length,
            color: widget.color ??
                theme.accentColor ??
                colorContainer.controlAccentColor,
            isMainWindow: isMainWindow,
            focusNode: focusNodes[i + dateFormatterSegments.length],
            onSegmentChanged: enabled ? _handleSegmentChanged : null,
            onFocusChanged: enabled ? _handleFocusChange : null,
            isFocused:
                enabled && _focusedIndex == i + dateFormatterSegments.length,
          );

          children.add(child);

          if (i < timeSegments.length - 1) {
            children.add(DefaultTextStyle(
                style: theme.typography.body, child: const Text(':')));
          }
        }

        final backgroundColor = colorContainer.controlBackgroundColor
            .multiplyOpacity(enabled ? 1.0 : 0.5);

        return ConstrainedBox(
            constraints: constraints,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    padding: const EdgeInsets.only(
                        left: 1.0, right: 1.0, top: 2.0, bottom: 2.0),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      border: Border(
                        top: BorderSide(
                            color: AppKitColors.text.opaque.tertiary
                                .multiplyOpacity(0.65),
                            width: 1),
                        left: BorderSide(
                            color: AppKitColors.text.opaque.tertiary
                                .multiplyOpacity(0.65),
                            width: 1),
                        right: BorderSide(
                            color: AppKitColors.text.opaque.tertiary
                                .multiplyOpacity(0.65),
                            width: 1),
                        bottom: BorderSide(
                            color: AppKitColors.text.opaque.secondary
                                .multiplyOpacity(0.65),
                            width: 1),
                      ),
                    ),
                    child: FocusScope(
                      autofocus: true,
                      canRequestFocus: true,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: children,
                      ),
                    ),
                  ),
                ),
                if (widget.type == AppKitDatePickerType.textualWithStepper) ...[
                  const SizedBox(width: 4),
                  AppKitStepper(
                    value: 1.0,
                    onChanged: enabled
                        ? (value) =>
                            _handleSegmentStep(_focusedIndex, value > 1.0)
                        : null,
                  )
                ]
              ],
            ));
      });
    });
  }
}

typedef FocusChangeCallback = void Function(int index, bool value);
typedef SegmentChangedCallback = void Function(int index, int value);

const _kKeyDelayTimeout = Duration(milliseconds: 1000);

class _TextualPickerElement extends StatefulWidget {
  final String text;
  final TextStyle textStyle;
  final int index;
  final bool isFocused;
  final Color color;
  final bool isMainWindow;
  final FocusNode focusNode;
  final FocusChangeCallback? onFocusChanged;
  final SegmentChangedCallback? onSegmentChanged;
  final double charWidth;
  final bool enabled;

  const _TextualPickerElement({
    required this.text,
    required this.textStyle,
    required this.index,
    required this.color,
    required this.isMainWindow,
    required this.focusNode,
    required this.charWidth,
    required this.enabled,
    this.onFocusChanged,
    this.onSegmentChanged,
    this.isFocused = false,
  });

  @override
  State<_TextualPickerElement> createState() => _TextualPickerElementState();
}

class _TextualPickerElementState extends State<_TextualPickerElement> {
  late final FocusScopeNode focusScopeNode = FocusScopeNode(
    traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop,
  );

  @override
  void didUpdateWidget(_TextualPickerElement oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _editedText = null;
      _dispatchTimer?.cancel();
    }
  }

  @override
  void dispose() {
    _dispatchTimer?.cancel();
    super.dispose();
  }

  String? _editedText;

  Timer? _dispatchTimer;

  String? get editedText => _editedText;

  String get currentText => _editedText ?? widget.text;

  int get maxSegmentLength => widget.text.length;

  set editedText(String? value) {
    if (value != _editedText) {
      setState(() {
        _editedText = value;
      });
    }
  }

  bool _canHandleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      final key = event.logicalKey;
      return (key.keyId >= 30 && key.keyId <= 39) ||
          [
            LogicalKeyboardKey.arrowDown,
            LogicalKeyboardKey.arrowUp,
            LogicalKeyboardKey.digit0,
            LogicalKeyboardKey.digit1,
            LogicalKeyboardKey.digit2,
            LogicalKeyboardKey.digit3,
            LogicalKeyboardKey.digit4,
            LogicalKeyboardKey.digit5,
            LogicalKeyboardKey.digit6,
            LogicalKeyboardKey.digit7,
            LogicalKeyboardKey.digit8,
            LogicalKeyboardKey.digit9,
            LogicalKeyboardKey.numpad0,
            LogicalKeyboardKey.numpad1,
            LogicalKeyboardKey.numpad2,
            LogicalKeyboardKey.numpad3,
            LogicalKeyboardKey.numpad4,
            LogicalKeyboardKey.numpad5,
            LogicalKeyboardKey.numpad6,
            LogicalKeyboardKey.numpad7,
            LogicalKeyboardKey.numpad8,
            LogicalKeyboardKey.numpad9,
          ].contains(key);
    }
    return false;
  }

  void _dispatchResult(int segmentValue) {
    _dispatchTimer?.cancel();
    widget.onSegmentChanged?.call(widget.index, segmentValue);
    editedText = null;
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (!_canHandleKeyEvent(event)) {
      _dispatchTimer?.cancel();
      return KeyEventResult.ignored;
    }

    final key = event.logicalKey;

    if (key == LogicalKeyboardKey.arrowDown ||
        key == LogicalKeyboardKey.arrowUp) {
      final value = int.tryParse(currentText) ?? 0;
      final newValue = value + (key == LogicalKeyboardKey.arrowUp ? 1 : -1);
      _dispatchResult(newValue);
      return KeyEventResult.handled;
    }

    // key event is a numeric key event

    String? newText = editedText;
    KeyEventResult result = KeyEventResult.ignored;

    if (newText == null) {
      newText = key.keyLabel;
      result = KeyEventResult.handled;
    } else if (newText.length < maxSegmentLength) {
      newText = newText + key.keyLabel;
      result = KeyEventResult.handled;
    }

    if (newText.length < maxSegmentLength) {
      editedText = newText;
      _dispatchTimer?.cancel();
      _dispatchTimer = Timer(_kKeyDelayTimeout, () {
        _dispatchResult(int.parse(newText!));
      });
    } else {
      _dispatchResult(int.parse(newText));
    }

    return result;
  }

  void _handleFocusChange(bool value) {
    if (!value) {
      _dispatchTimer?.cancel();
      if (editedText != null) {
        widget.onSegmentChanged?.call(widget.index, int.parse(editedText!));
        editedText = null;
      }
    }
    widget.onFocusChanged?.call(widget.index, value);
  }

  @override
  Widget build(BuildContext context) {
    final segmentWidth = widget.charWidth * widget.text.length;

    final backgroundColor =
        widget.isFocused && widget.isMainWindow ? widget.color : null;
    final Color textColor;

    if (backgroundColor != null) {
      backgroundColor.computeLuminance() > 0.5
          ? textColor = AppKitColors.text.opaque.primary.color
          : textColor = AppKitColors.text.opaque.primary.darkColor;
    } else {
      textColor = AppKitColors.text.opaque.primary.color;
    }

    return Focus(
      debugLabel: 'TextualPickerElement[${widget.index}]',
      focusNode: widget.focusNode,
      descendantsAreTraversable: false,
      descendantsAreFocusable: false,
      skipTraversal: false,
      onFocusChange: widget.enabled ? _handleFocusChange : null,
      onKeyEvent:
          widget.enabled ? (node, event) => _handleKeyEvent(node, event) : null,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(widget.focusNode),
        child: Container(
          width: segmentWidth + 4.0,
          padding: const EdgeInsets.only(top: 0.0, bottom: 1.0, right: 2.0),
          decoration: widget.isFocused
              ? BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(4.0),
                )
              : const BoxDecoration(),
          child: DefaultTextStyle(
            style: widget.textStyle.merge(TextStyle(color: textColor)),
            maxLines: 1,
            textAlign: TextAlign.end,
            child: Text(currentText),
          ),
        ),
      ),
    );
  }
}

// endregion TextualDatePicker

extension _TextStyleX on TextStyle {
  Size getTextSize(String text) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: this),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }
}

extension _DateTimeX on DateTime {
  bool isSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool isBetween(DateTime start, DateTime end, bool inclusive) {
    if (inclusive) {
      // start <= this <= end
      return (isAfter(start) || isSameDay(start)) &&
          (isBefore(end) || isSameDay(end));
    } else {
      // start < this < end
      return isAfter(start) && isBefore(end);
    }
  }
}

enum AppKitDatePickerSelectionType {
  single,
  range,
}
