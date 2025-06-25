import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// Logs a message only in non-production modes.
void appLog(
  String message, {
  Object? error,
  StackTrace? stackTrace,
}) {
  if (!kReleaseMode) {
    developer.log(message, error: error, stackTrace: stackTrace);
  }
}
