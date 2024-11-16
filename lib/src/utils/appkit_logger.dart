import 'package:logger/logger.dart';

final logger = Logger(
  filter: DevelopmentFilter(),
  level: Level.all,
  printer: SimplePrinter(
    colors: true,
    printTime: true,
  ),
  output: ConsoleOutput(),
);
