import 'dart:async';

import 'package:appkit_ui_element_colors/appkit_ui_element_colors.dart';
import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

typedef FocusChangeCallback = void Function(int index, bool value);
typedef SegmentChangedCallback = void Function(int index, int value);

const _kKeyDelayTimeout = Duration(milliseconds: 1000);

@protected
class TextualDatePicker extends StatefulWidget {
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
  final bool isMainWindow;
  final bool autofocus;
  final bool canRequestFocus;
  final ValueChanged<DateTime>? onChanged;

  const TextualDatePicker({
    super.key,
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
    this.canRequestFocus = true,
    this.autofocus = false,
    this.drawBackground = true,
    this.drawBorder = true,
  });

  @override
  State<TextualDatePicker> createState() => _TextualDatePickerState();
}

class _TextualDatePickerState extends State<TextualDatePicker> {
  int? _focusedIndex;

  bool get enabled => widget.onChanged != null;

  bool get isMainWindow => widget.isMainWindow;

  String get languageCode => widget.languageCode;

  late DateFormat dateFormatter;

  late DateFormat timeFormatter;

  late List<String> dateFormatterSegments;

  late List<String> timeFormatterSegments;

  int get totalsegments =>
      dateFormatterSegments.length + timeFormatterSegments.length;

  late DateTime dateTime;

  bool get hasDate => widget.dateElements != AppKitDateElements.none;

  bool get hasTime => widget.timeElements != AppKitTimeElements.none;

  String get dateString => dateFormatter.format(dateTime);

  String get timeString => timeFormatter.format(dateTime);

  List<int> get dateSegments => dateString.split('/').map(int.parse).toList();

  List<int> get timeSegments => timeString.split(':').map(int.parse).toList();

  (TextStyle, double)? _charWidth;

  FocusNode? _focusNode;

  FocusNode get _effectiveFocusNode =>
      _focusNode ??= FocusNode(debugLabel: 'TextualDatePicker[$hashCode]');

  String? _editedText;

  Timer? _dispatchTimer;

  int getMaxSegmentLength(int index) => _getSegmentText(index).length;

  set editedText(String? value) {
    if (value != _editedText) {
      setState(() {
        _editedText = value;
      });
    }
  }

  set focusedIndex(int? value) {
    if (value != _focusedIndex) {
      setState(() {
        if (_focusedIndex != null && _editedText != null) {
          _handleSegmentChanged(_focusedIndex!, int.parse(_editedText!));
        }
        _editedText = null;
        _dispatchTimer?.cancel();
        _focusedIndex = value;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initializeWidget();
  }

  @override
  void dispose() {
    _focusNode?.dispose();
    _dispatchTimer?.cancel();
    super.dispose();
  }

  void initializeWidget() {
    dateTime = widget.initialDateTime.copyWith();

    dateFormatter = widget.dateElements.getDateFormat(languageCode);
    timeFormatter = widget.timeElements.getDateFormat(languageCode);

    dateFormatterSegments =
        hasDate ? dateFormatter.pattern!.split('/').toList() : [];
    timeFormatterSegments =
        hasTime ? timeFormatter.pattern!.split(':').toList() : [];

    if (_effectiveFocusNode.hasFocus &&
        widget.autofocus &&
        widget.canRequestFocus &&
        (_focusedIndex == null || _focusedIndex! >= totalsegments)) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        focusedIndex = 0;
      });
    }
  }

  @override
  void didUpdateWidget(covariant TextualDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.dateElements != widget.dateElements ||
        oldWidget.timeElements != widget.timeElements ||
        oldWidget.initialDateTime != widget.initialDateTime) {
      initializeWidget();
    }
  }

  bool _canHandleKeyEvent(KeyEvent event) {
    if (event is KeyUpEvent || event is KeyRepeatEvent) {
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

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      final bool isShiftPressed = HardwareKeyboard.instance.isShiftPressed;

      if (event.logicalKey == LogicalKeyboardKey.arrowRight ||
          (event.logicalKey == LogicalKeyboardKey.tab && !isShiftPressed)) {
        int nextIndex = (_focusedIndex ?? 0) + 1;
        if (nextIndex >= totalsegments) {
          nextIndex = 0;
        }
        focusedIndex = nextIndex;
      } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
          (event.logicalKey == LogicalKeyboardKey.tab && isShiftPressed)) {
        int nextIndex = (_focusedIndex ?? 0) - 1;
        if (nextIndex < 0) {
          nextIndex = totalsegments - 1;
        }
        focusedIndex = nextIndex;
      }
      return KeyEventResult.handled;
    }

    if (!_canHandleKeyEvent(event) || !enabled || _focusedIndex == null) {
      return KeyEventResult.ignored;
    }

    final key = event.logicalKey;
    final index = _focusedIndex!;

    if (key == LogicalKeyboardKey.arrowDown ||
        key == LogicalKeyboardKey.arrowUp) {
      final value = int.tryParse(_getSegmentText(index)) ?? 0;
      final newValue = value + (key == LogicalKeyboardKey.arrowUp ? 1 : -1);

      _editedText = null;
      _dispatchTimer?.cancel();

      _handleSegmentChanged(index, newValue);
      return KeyEventResult.handled;
    }

    // key event is a numeric key event
    final maxSegmentLength = getMaxSegmentLength(index);

    String? newText = _editedText;

    if (newText == null) {
      newText = key.keyLabel;
    } else if (newText.length < maxSegmentLength) {
      newText = newText + key.keyLabel;
    }

    if (newText.length < maxSegmentLength) {
      editedText = newText;
      _dispatchTimer?.cancel();
      _dispatchTimer = Timer(_kKeyDelayTimeout, () {
        _handleSegmentChanged(index, int.parse(newText!));
        _editedText = null;
      });
    } else {
      editedText = null;
      _dispatchTimer?.cancel();
      _handleSegmentChanged(index, int.parse(newText));
    }

    return KeyEventResult.handled;
  }

  void _handleFocusChange(bool value) {
    if (!value) {
      if (_focusedIndex != null && _editedText != null) {
        _handleSegmentChanged(_focusedIndex!, int.parse(_editedText!));
      }
      focusedIndex = null;
    } else {
      if (enabled &&
          (_focusedIndex == null || _focusedIndex! >= totalsegments)) {
        focusedIndex = 0;
      } else {
        setState(() {});
      }
    }
  }

  void _handleSegmentTap(int index) {
    setState(() {
      _effectiveFocusNode.requestFocus();
      _focusedIndex = index;
    });
  }

  void _handleSegmentStep(int? index, bool increase) {
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

    final newDateTime = DateTime(newDate.year, newDate.month, newDate.day,
        newTime.hour, newTime.minute, newTime.second);

    widget.onChanged
        ?.call(newDateTime.clamp(widget.minimumDate, widget.maximumDate));
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

  String _getSegmentText(int index) {
    if (index < dateFormatterSegments.length) {
      final segment = _focusedIndex == index && _editedText != null
          ? _editedText!
          : dateSegments[index].toString();
      return dateFormatterSegments[index] == 'y'
          ? segment.padLeft(4, '0')
          : segment.padLeft(2, '0');
    } else {
      return (_focusedIndex == index && _editedText != null
              ? _editedText!
              : timeSegments[index - dateFormatterSegments.length].toString())
          .padLeft(2, '0');
    }
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
          String segment = _getSegmentText(i);

          // create a string filled with zeros based on the segment length
          final child = _TextualPickerElement(
            enabled: enabled,
            text: segment,
            charWidth: charWidth,
            textStyle: textStyle,
            index: i,
            color: widget.color ??
                theme.primaryColor ??
                colorContainer.controlAccentColor,
            isMainWindow: isMainWindow,
            isFocused: enabled &&
                _focusedIndex == i &&
                _effectiveFocusNode.hasPrimaryFocus,
            onTap: enabled ? _handleSegmentTap : null,
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
          String segment = _getSegmentText(i + dateFormatterSegments.length);

          // create a string filled with zeros based on the segment length
          final child = _TextualPickerElement(
            enabled: enabled,
            text: segment,
            charWidth: charWidth,
            textStyle: textStyle,
            index: i + dateFormatterSegments.length,
            color: widget.color ??
                theme.primaryColor ??
                colorContainer.controlAccentColor,
            isMainWindow: isMainWindow,
            isFocused: _effectiveFocusNode.hasPrimaryFocus &&
                enabled &&
                _focusedIndex == i + dateFormatterSegments.length,
            onTap: enabled ? _handleSegmentTap : null,
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
                    child: Focus(
                      focusNode: _effectiveFocusNode,
                      autofocus: widget.autofocus,
                      canRequestFocus: widget.canRequestFocus,
                      onFocusChange: enabled ? _handleFocusChange : null,
                      onKeyEvent: enabled ? _handleKeyEvent : null,
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

class _TextualPickerElement extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final int index;
  final bool isFocused;
  final Color color;
  final bool isMainWindow;
  final double charWidth;
  final bool enabled;
  final ValueChanged<int>? onTap;

  const _TextualPickerElement({
    required this.text,
    required this.textStyle,
    required this.index,
    required this.color,
    required this.isMainWindow,
    required this.charWidth,
    required this.enabled,
    this.isFocused = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final segmentWidth = charWidth * text.length;

    final backgroundColor = isFocused && isMainWindow ? color : null;
    final Color textColor;

    if (backgroundColor != null) {
      backgroundColor.computeLuminance() > 0.5
          ? textColor = AppKitColors.text.opaque.primary.color
          : textColor = AppKitColors.text.opaque.primary.darkColor;
    } else {
      textColor = AppKitColors.text.opaque.primary.color;
    }

    return GestureDetector(
      onTap: enabled ? () => onTap?.call(index) : null,
      child: Container(
        width: segmentWidth + 4.0,
        padding: const EdgeInsets.only(top: 0.0, bottom: 1.0, right: 2.0),
        decoration: isFocused
            ? BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(4.0),
              )
            : const BoxDecoration(),
        child: DefaultTextStyle(
          style: textStyle.merge(TextStyle(color: textColor)),
          maxLines: 1,
          textAlign: TextAlign.end,
          child: Text(text),
        ),
      ),
    );
  }
}

// endregion TextualDatePicker
