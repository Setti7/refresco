import 'package:logger/logger.dart';

Logger getLogger(String className) {
  return Logger(printer: SimpleLogPrinter(className));
}

class SimpleLogPrinter extends LogPrinter {
  final String className;
  SimpleLogPrinter(this.className);

  @override
  List<String> log(LogEvent event) {
    final level = event.level.toString().split('.').last.toLowerCase();
    return [('[$className - $level] ${event.message.toString()}')];
  }
}