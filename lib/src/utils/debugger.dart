import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

var _kLoggerLevel = Level.FINE;

const _kBaseTag = 'appkit_ui_elements';

void initLogging({bool isDebug = true}) {
  if (!isDebug) {
    _kLoggerLevel = Level.OFF;
  }
}

String _getTag(dynamic classNameOrInstance) {
  if (classNameOrInstance is String) {
    return classNameOrInstance;
  } else {
    return '<${classNameOrInstance.runtimeType} ${shortHash(classNameOrInstance)}>';
  }
}

String _getTime() {
  final now = DateTime.now();
  return '${now.hour}:${now.minute}:${now.second}.${now.millisecond}';
}

void logDebug(dynamic className, String message) {
  if (_kLoggerLevel <= Level.CONFIG) {
    debugPrint(
        '${_getTime()} $_kBaseTag ${_getTag(className)} [DEBUG]: $message');
  }
}

void logInfo(dynamic className, String message) {
  if (_kLoggerLevel <= Level.INFO) {
    debugPrint(
        '${_getTime()} $_kBaseTag ${_getTag(className)} [INFO]: $message');
  }
}

void logWarning(dynamic className, String message) {
  if (_kLoggerLevel <= Level.WARNING) {
    debugPrint(
        '${_getTime()} $_kBaseTag ${_getTag(className)} [WARNING]: $message');
  }
}

void logError(dynamic className, String message) {
  if (_kLoggerLevel <= Level.SEVERE) {
    debugPrint(
        '${_getTime()} $_kBaseTag ${_getTag(className)} [ERROR]: $message');
  }
}

void logVerbose(dynamic className, String message) {
  if (_kLoggerLevel <= Level.FINE) {
    debugPrint(
        '${_getTime()} $_kBaseTag ${_getTag(className)} [VERBOSE]: $message');
  }
}
