import 'package:appkit_ui_element_colors/appkit_ui_element_colors.dart';
import 'package:appkit_ui_elements/appkit_ui_elements.dart';
import 'package:appkit_ui_elements/src/library.dart';
import 'package:appkit_ui_elements/src/utils/main_window_listener.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:intl/intl.dart';

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

  AppKitDatePicker({
    super.key,
    required this.type,
    required this.initialDateTime,
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
  })  : assert(minimumDate == null ||
            maximumDate == null ||
            minimumDate.isBefore(maximumDate)),
        assert(initialDateTime.isAfter(minimumDate ?? DateTime(1)) &&
            initialDateTime.isBefore(maximumDate ?? DateTime(9999)));

  @override
  State<AppKitDatePicker> createState() => _AppKitDatePickerState();
}

class _AppKitDatePickerState extends State<AppKitDatePicker> {
  bool get enabled => widget.onChanged != null;

  // FocusNode? _focusNode;

  // List<FocusNode> _focusNodes = [
  //   FocusNode(),
  //   FocusNode(),
  // ];

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
        if (widget.type == AppKitDatePickerType.textual) {
          return _TextualDatePicker(
            type: widget.type,
            dateElements: widget.dateElements,
            timeElements: widget.timeElements,
            initialDateTime: widget.initialDateTime,
            minimumDate: widget.minimumDate,
            maximumDate: widget.maximumDate,
            semanticLabel: widget.semanticLabel,
            textStyle: widget.textStyle,
            color: widget.color,
            drawBackground: widget.drawBackground,
            drawBorder: widget.drawBorder,
            onChanged: widget.onChanged,
            languageCode: languageCode,
            isMainWindow: isMainWindow,
          );

          // return FocusScope(
          //   autofocus: true,
          //   onFocusChange: (value) {
          //     debugPrint('DatePicker focus changed: $value');
          //   },
          //   child: Row(children: [
          //     FocusableWidget(focusNode: _focusNodes[0], index: 0),
          //     const SizedBox(width: 4),
          //     FocusableWidget(focusNode: _focusNodes[1], index: 1),
          //   ]),
          //   // child: _TextualDatePicker(
          //   //   focusNode: _effectiveFocusNode,
          //   //   type: widget.type,
          //   //   dateElements: widget.dateElements,
          //   //   timeElements: widget.timeElements,
          //   //   initialDateTime: widget.initialDateTime,
          //   //   minimumDate: widget.minimumDate,
          //   //   maximumDate: widget.maximumDate,
          //   //   semanticLabel: widget.semanticLabel,
          //   //   textStyle: widget.textStyle,
          //   //   color: widget.color,
          //   //   drawBackground: widget.drawBackground,
          //   //   drawBorder: widget.drawBorder,
          //   //   onChanged: widget.onChanged,
          //   // ),
          // );
        } else {
          return Container();
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

class FocusableWidget extends StatefulWidget {
  final FocusNode focusNode;
  final int index;

  const FocusableWidget({
    required this.focusNode,
    required this.index,
  });

  @override
  State<FocusableWidget> createState() => _FocusableWidgetState();
}

class _FocusableWidgetState extends State<FocusableWidget> {
  @override
  void initState() {
    super.initState();
    if (widget.index == 0) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        FocusScope.of(context).requestFocus(widget.focusNode);
      });
    }
    widget.focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_handleFocusChange);
    super.dispose();
  }

  void _handleFocusChange() {
    debugPrint(
        'FocusableWidget[${widget.index}] focus changed: ${widget.focusNode.hasFocus}');
    setState(() {
      _isFocused = widget.focusNode.hasFocus;
    });
  }

  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: widget.index == 0,
      canRequestFocus: true,
      descendantsAreFocusable: false,
      descendantsAreTraversable: false,
      skipTraversal: false,
      focusNode: widget.focusNode,
      onFocusChange: (value) {
        debugPrint('[${widget.index}] FocusableWidget onFocusChange: $value');
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(widget.focusNode);
        },
        child: SizedBox.square(
          dimension: 50,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: _isFocused ? Colors.red : Colors.black,
                  width: _isFocused ? 2 : 1),
            ),
          ),
        ),
      ),
    );
  }
}

class _TextualDatePicker extends StatefulWidget {
  final String languageCode;
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
    this.semanticLabel,
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

  late final DateFormat formatter;

  late final List<String> formatterSegments;

  late final List<FocusNode> focusNodes;

  @override
  void initState() {
    super.initState();

    formatter = DateFormat.yMd(languageCode);
    formatterSegments =
        formatter.pattern!.split('/').map((e) => e.toLowerCase()).toList();
    focusNodes =
        List.generate(formatterSegments.length, (index) => FocusNode());

    SchedulerBinding.instance.addPostFrameCallback((_) {
      debugPrint('Requesting focus for index 0');
      FocusScope.of(context).requestFocus(focusNodes[0]);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _handleFocusChange(int index, bool value) {
    debugPrint('focus changed: $index => $value');
    setState(() {
      _focusedIndex = value ? index : null;
    });
  }

  void _handleKeyEvent(int index, KeyEvent event) {
    debugPrint('key event: $index => $event');
  }

  @override
  Widget build(BuildContext context) {
    final date = formatter.format(widget.initialDateTime);
    final dateSegments = date.split('/');
    // debugPrint('date: $date');

    return UiElementColorBuilder(builder: (context, colorContainer) {
      return LayoutBuilder(builder: (context, constraints) {
        assert(constraints.hasBoundedWidth);
        final theme = AppKitTheme.of(context);

        final List<Widget> children = [];

        for (var i = 0; i < dateSegments.length; i++) {
          String segment = dateSegments[i];
          final formatterSegment = formatterSegments[i];

          if (formatterSegment == 'y') {
            segment = segment.padLeft(4, '0');
          } else {
            segment = segment.padLeft(2, '0');
          }

          final child = _TextualPickerElement(
            text: segment,
            textStyle: theme.typography.body,
            index: i,
            color: widget.color ??
                theme.accentColor ??
                colorContainer.controlAccentColor,
            isMainWindow: isMainWindow,
            focusNode: focusNodes[i],
            onFocusChanged: enabled ? _handleFocusChange : null,
            onKeyEvent: enabled ? _handleKeyEvent : null,
            isFocused: enabled && _focusedIndex == i,
          );

          children.add(child);

          if (i < dateSegments.length - 1) {
            children.add(DefaultTextStyle(
                style: theme.typography.body, child: const Text('.')));
          }
        }

        final backgroundColor = colorContainer.controlBackgroundColor
            .multiplyOpacity(enabled ? 1.0 : 0.5);

        return ConstrainedBox(
            constraints: constraints,
            child: Container(
              padding: const EdgeInsets.only(
                  left: 2.0, right: 2.0, top: 0.0, bottom: 1.0),
              decoration: BoxDecoration(
                color: backgroundColor,
                border: GradientBoxBorder(
                    gradient: LinearGradient(
                      colors: [
                        AppKitColors.text.opaque.tertiary.multiplyOpacity(0.6),
                        AppKitColors.text.opaque.secondary.multiplyOpacity(0.75)
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.9, 1.0],
                    ),
                    width: 0.5),
              ),
              child: FocusScope(
                autofocus: true,
                canRequestFocus: true,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: children,
                ),
              ),
            ));
      });
    });
  }
}

typedef FocusChangeCallback = void Function(int index, bool value);
typedef KeyEventCallback = void Function(int index, KeyEvent event);

class _TextualPickerElement extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final int index;
  final bool isFocused;
  final Color color;
  final bool isMainWindow;
  final FocusNode focusNode;
  final FocusChangeCallback? onFocusChanged;
  final KeyEventCallback? onKeyEvent;

  late final FocusScopeNode focusScopeNode = FocusScopeNode(
    traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop,
  );

  _TextualPickerElement({
    required this.text,
    required this.textStyle,
    required this.index,
    required this.color,
    required this.isMainWindow,
    required this.focusNode,
    this.onFocusChanged,
    this.onKeyEvent,
    this.isFocused = false,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isFocused && isMainWindow ? color : null;
    final Color textColor;

    if (backgroundColor != null) {
      backgroundColor.computeLuminance() > 0.5
          ? textColor = AppKitColors.text.opaque.primary.color
          : textColor = AppKitColors.text.opaque.primary.darkColor;
    } else {
      textColor = AppKitColors.text.opaque.primary.color;
    }

    return Focus(
      debugLabel: 'TextualPickerElement[$index]',
      focusNode: focusNode,
      descendantsAreTraversable: false,
      descendantsAreFocusable: false,
      skipTraversal: false,
      onFocusChange: (value) {
        onFocusChanged?.call(index, value);
      },
      onKeyEvent: (node, event) {
        if ([
              LogicalKeyboardKey.arrowDown,
              LogicalKeyboardKey.arrowUp,
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
            ].contains(event.logicalKey) ||
            (event.logicalKey.keyId >= 30 && event.logicalKey.keyId <= 39)) {
          onKeyEvent?.call(index, event);
          return KeyEventResult.handled;
        }

        return KeyEventResult.ignored;
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(focusNode),
        child: Container(
          padding: const EdgeInsets.only(
              top: 1.0, bottom: 3.0, left: 1.0, right: 1.0),
          decoration: isFocused
              ? BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(4.0),
                )
              : const BoxDecoration(),
          child: DefaultTextStyle(
            style: textStyle.merge(TextStyle(color: textColor)),
            child: Text(text),
          ),
        ),
      ),
    );
  }
}

enum AppKitDatePickerType {
  graphical,
  textualWithStepper,
  textual,
}

enum AppKitDateElements {
  monthDayYear,
  monthYear,
  none,
}

enum AppKitTimeElements {
  hourMinuteSecond,
  hourMinute,
  none,
}
