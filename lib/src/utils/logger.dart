import 'package:logger/logger.dart';

final logger =  Logger();

class MyPrinter extends LogPrinter {
  @override
  List<String> log(LogEvent event) {
    return [event.message];
  }
}