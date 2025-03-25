import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:appkit_ui_elements/src/widgets/date_picker/appkit_graphical_date_picker.dart';
import 'package:appkit_ui_elements/src/widgets/date_picker/appkit_textual_date_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

typedef OnDateChanged = void Function(Either<DateTime, DateTimeRange> date);

/// A widget that provides a date picker control.
///
/// The `AppKitDatePicker` widget allows users to select a date or time from a calendar interface.
/// It is a stateful widget that maintains the selected date and updates the UI accordingly.
///
/// Example usage:
///
/// ```dart
///   AppKitDatePicker(
///     canRequestFocus: true,
///     autofocus: false,
///     date: left(_selectedDateRange.start),
///     minimumDate: _minimumDate,
///     maximumDate: _maximumDate,
///     dateElements: AppKitDateElements.monthDayYear,
///     timeElements:
///         AppKitTimeElements.hourMinuteSecond,
///     semanticLabel: 'Date Picker',
///     type: AppKitDatePickerType.textual,
///     onChanged:
///         (Either<DateTime, DateTimeRange> d) {
///       debugPrint('Date Changed ($d)');
///     },
///   );
/// ```
///
class AppKitDatePicker extends StatefulWidget {
  /// Whether the date picker should automatically gain focus when the widget is displayed.
  ///
  /// If true, the date picker will request focus as soon as it is displayed.
  /// If false, the date picker will not request focus automatically.
  ///
  /// Defaults to false.
  final bool autofocus;

  /// Indicates whether the date picker can request focus.
  ///
  /// If set to `true`, the date picker can request focus when interacted with.
  /// If set to `false`, the date picker will not request focus.
  final bool canRequestFocus;

  /// The type of the date picker, which determines its appearance and behavior.
  final AppKitDatePickerType type;

  /// The elements of the date picker related to date selection.
  final AppKitDateElements dateElements;

  /// The elements of the date picker related to time selection.
  final AppKitTimeElements timeElements;

  /// The initial date or date range to be selected in the date picker.
  /// This can be either a single `DateTime` or a `DateTimeRange`.
  final Either<DateTime, DateTimeRange> initialDateTime;

  /// The minimum selectable date for the date picker.
  final DateTime? minimumDate;

  /// The maximum selectable date for the date picker.
  final DateTime? maximumDate;

  /// The semantic label for the date picker, used for accessibility.
  final String? semanticLabel;

  /// The text style to use for the date picker text.
  final TextStyle? textStyle;

  /// The color to use for the date picker.
  final Color? color;

  /// Whether to draw the background of the date picker.
  final bool drawBackground;

  /// Whether to draw the border of the date picker.
  final bool drawBorder;

  /// Callback that is called when the selected date changes.
  final OnDateChanged? onChanged;

  /// The type of selection for the date picker (e.g., single date, date range).
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
  void _handleChanged(Either<DateTime, DateTimeRange> date) {
    if (widget.onChanged != null) {
      widget.onChanged?.call(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasAppKitTheme(context));

    final languageCode = Localizations.localeOf(context).languageCode;
    final bool enabled = widget.onChanged != null;

    return Semantics(
      label: widget.semanticLabel,
      container: true,
      child: Consumer<MainWindowModel>(builder: (context, model, _) {
        final isMainWindow = model.isMainWindow;
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
              onChanged: widget.onChanged != null ? _handleChanged : null,
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
