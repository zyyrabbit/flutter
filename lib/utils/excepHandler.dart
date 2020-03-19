
import 'dart:async';
import 'package:flutter/material.dart';

bool get isInDebugMode {
  // Assume you're in production mode.
  bool inDebugMode = false;

  // Assert expressions are only evaluated during development. They are ignored
  // in production. Therefore, this code only sets `inDebugMode` to true
  // in a development environment.
  assert(inDebugMode = true);

  return inDebugMode;
}

class ExcepHandler {
  /// 捕获Flutter异常
  static resetOnError() {
    FlutterError.onError = (FlutterErrorDetails details) async {
      if (isInDebugMode) {
        FlutterError.dumpErrorToConsole(details);
      } else {
        Zone.current.handleUncaughtError(details.exception, details.stack);
      }
    };
  }
  /// 用于日志上报，捕获Flutter异常
  static Future<Null> reportError(dynamic error, dynamic stackTrace) async {
    /// 日志上报或者其他处理
    /// writeLog(stackTrace);
  }
 
}