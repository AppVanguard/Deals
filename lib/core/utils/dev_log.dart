import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// Logs [message] only in non-release builds.
void log(
  String message, {
  int level = 0,
  String name = '',
  Object? error,
  StackTrace? stackTrace,
}) {
  if (!kReleaseMode) {
    developer.log(
      message,
      level: level,
      name: name,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
