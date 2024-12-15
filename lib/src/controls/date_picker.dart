import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:appkit_ui_elements/src/widgets/date_picker/graphical_date_picker.dart';
import 'package:appkit_ui_elements/src/widgets/date_picker/textual_date_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

typedef OnDateChanged = void Function(Either<DateTime, DateTimeRange> date);

class AppKitDatePicker extends StatefulWidget {
  final bool autofocus;
  final bool canRequestFocus;
  final AppKitDatePickerType type;
  final AppKitDateElements dateElements;
  final AppKitTimeElements timeElements;
  final Either<DateTime, DateTimeRange> initialDateTime;
  final DateTime? minimumDate;
  final DateTime? maximumDate;
  final String? semanticLabel;
  final TextStyle? textStyle;
  final Color? color;
  final bool drawBackground;
  final bool drawBorder;
  final OnDateChanged? onChanged;
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
    Either<DateTime, DateTimeRange>? date,
  }) : initialDateTime = date ??
            (selectionType == AppKitDatePickerSelectionType.single
                ? Left(DateTime.now())
                : Right(DateTimeRange(
                    start: DateTime.now(), end: DateTime.now()))) {
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

    if (selectionType == AppKitDatePickerSelectionType.single) {
      assert(initialDateTime.isLeft(), 'initialDateTime must be a single date');
    } else {
      assert(initialDateTime.isRight(), 'initialDateTime must be a date range');
    }
  }

  @override
  State<AppKitDatePicker> createState() => _AppKitDatePickerState();
}

class _AppKitDatePickerState extends State<AppKitDatePicker> {
  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasAppKitTheme(context));

    final languageCode = Localizations.localeOf(context).languageCode;
    final bool enabled = widget.onChanged != null;

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
            initialDateTime:
                widget.initialDateTime.fold((d) => d, (r) => r.start),
            minimumDate: widget.minimumDate,
            maximumDate: widget.maximumDate,
            textStyle: widget.textStyle,
            color: widget.color,
            drawBackground: widget.drawBackground,
            drawBorder: widget.drawBorder,
            onChanged: enabled ? (d) => widget.onChanged?.call(left(d)) : null,
            languageCode: languageCode,
            isMainWindow: isMainWindow,
            autofocus: widget.autofocus,
            canRequestFocus: widget.canRequestFocus,
          );
        } else {
          if (widget.dateElements != AppKitDateElements.none) {
            return GraphicalDatePicker(
              initialDateTime: widget.initialDateTime
                  .fold((d) => DateTimeRange(start: d, end: d), (r) => r),
              minimumDate: widget.minimumDate,
              maximumDate: widget.maximumDate,
              drawBackground: widget.drawBackground,
              drawBorder: widget.drawBorder,
              color: widget.color,
              languageCode: languageCode,
              isMainWindow: isMainWindow,
              onChanged: widget.onChanged,
              selectionType: widget.selectionType,
              autofocus: widget.autofocus,
              canRequestFocus: widget.canRequestFocus,
            );
          } else {
            return GrahpicalTimePicker(
              initialDateTime:
                  widget.initialDateTime.fold((d) => d, (r) => r.start),
              minimumDate: widget.minimumDate,
              maximumDate: widget.maximumDate,
              languageCode: languageCode,
              isMainWindow: isMainWindow,
              onChanged:
                  enabled ? (d) => widget.onChanged?.call(left(d)) : null,
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
    properties.add(DiagnosticsProperty<Either<DateTime, DateTimeRange>>(
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

extension _EitherX on Either<DateTime, DateTimeRange> {
  bool isSameOrBefore(DateTime date) {
    return fold((DateTime value) => value.isSameOrBefore(date),
        (DateTimeRange value) => value.isSameOrBefore(date));
  }

  bool isSameOrAfter(DateTime date) {
    return fold((DateTime value) => value.isSameOrAfter(date),
        (DateTimeRange value) => value.isSameOrAfter(date));
  }
}
