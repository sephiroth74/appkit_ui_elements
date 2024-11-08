import 'package:flutter/cupertino.dart';

class AppKitToggleButtonController extends ChangeNotifier {
  bool _isOn = false;

  bool get isOn => _isOn;

  set isOn(bool value) {
    _isOn = value;
    notifyListeners();
  }

  void toggle() {
    _isOn = !_isOn;
    notifyListeners();
  }
}
