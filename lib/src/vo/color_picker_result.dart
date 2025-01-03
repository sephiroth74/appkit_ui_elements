import 'dart:ui';

double jsonToDouble(dynamic value) {
  return value.toDouble();
}

class ColorPickerResult {
  final int id;
  final RGBAColor color;

  ColorPickerResult({required this.id, required this.color});

  ColorPickerResult.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        color = RGBAColor.fromJson(json['color'] as Map<String, dynamic>);

  @override
  String toString() {
    return 'ColorPickerResult{id: $id, color: $color}';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'color': color.toJson(),
      };
}

enum ColorSpaceMode {
  unknown(-1),
  rgb(1),
  cmyk(2),
  gray(0),
  lab(3),
  deviceN(4),
  indexed(5),
  pattern(6);

  final int value;

  const ColorSpaceMode(this.value);

  static ColorSpaceMode fromValue(int value) {
    return ColorSpaceMode.values.firstWhere((element) => element.value == value,
        orElse: () => ColorSpaceMode.unknown);
  }
}

class RGBAColor {
  final double red;
  final double green;
  final double blue;
  final double alpha;
  final ColorSpaceMode mode;

  RGBAColor(this.red, this.green, this.blue, this.alpha, this.mode);

  RGBAColor.fromJson(Map<dynamic, dynamic> json)
      : red = jsonToDouble(json['red']),
        green = jsonToDouble(json['green']),
        blue = jsonToDouble(json['blue']),
        alpha = jsonToDouble(json['alpha']),
        mode = ColorSpaceMode.fromValue((json['mode'] as int?) ?? -1);

  RGBAColor.fromColor(Color color, {this.mode = ColorSpaceMode.unknown})
      : red = color.r,
        green = color.g,
        blue = color.b,
        alpha = color.a;

  @override
  String toString() {
    return 'RGBAColor{red: $red, green: $green, blue: $blue, alpha: $alpha, mode: $mode}';
  }

  Color toColor() {
    return Color.fromRGBO((red * 255).toInt(), (green * 255).toInt(),
        (blue * 255).toInt(), alpha);
  }

  Map<String, dynamic> toJson() => {
        'red': red,
        'green': green,
        'blue': blue,
        'alpha': alpha,
        'mode': mode.value,
      };
}
