import 'package:logger/logger.dart';

Logger newLogger(String tag) => Logger(
      filter: DevelopmentFilter(),
      level: Level.all,
      printer: PrefixPrinter(
        SimplePrinter(colors: true, printTime: true),
        error: '[$tag] ERROR',
        warning: '[$tag] WARNING',
        info: '[$tag] INFO',
        debug: '[$tag] DEBUG',
        trace: '[$tag] TRACE',
        fatal: '[$tag] FATAL',
      ),
      output: ConsoleOutput(),
    );
