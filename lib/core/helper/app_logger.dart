import 'package:logger/logger.dart';

/// App-wide logger. Prints only in debug builds (logger's default filter).
final Logger appLogger = Logger(printer: PrettyPrinter(methodCount: 0));
