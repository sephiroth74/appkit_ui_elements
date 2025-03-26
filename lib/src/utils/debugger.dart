import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

const _kLoggerLevel = Level.FINEST;

void initLogging() {
  hierarchicalLoggingEnabled = true;
}

getLogger(dynamic classNameOrInstance) {
  String className;
  if (classNameOrInstance is String) {
    className = classNameOrInstance;
  } else {
    className =
        '<${classNameOrInstance.runtimeType} ${shortHash(classNameOrInstance)}>';
  }
  final logger = Logger(className)..level = _kLoggerLevel;
  logger.onRecord.listen((record) {
    debugPrint(
        '${record.time} ${record.loggerName} [${record.level.name}] ${record.message}');
  });
  return logger;
}

void logDebug(dynamic className, String message) {
  getLogger(className).fine(message);
}

void logInfo(dynamic className, String message) {
  getLogger(className).info(message);
}

void logWarning(dynamic className, String message) {
  getLogger(className).warning(message);
}

void logError(dynamic className, String message) {
  getLogger(className).severe(message);
}

void logVerbose(dynamic className, String message) {
  getLogger(className).finest(message);
}
