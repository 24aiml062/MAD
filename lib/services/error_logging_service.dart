import 'package:flutter/foundation.dart';

class AppErrorRecord {
  final String id;
  final String message;
  final String stackTrace;
  final DateTime timestamp;
  final String category;

  AppErrorRecord({
    required this.id,
    required this.message,
    required this.stackTrace,
    required this.timestamp,
    this.category = 'UI_ERROR',
  });
}

class ErrorLoggingService {
  static final ErrorLoggingService _instance = ErrorLoggingService._internal();
  factory ErrorLoggingService() => _instance;
  ErrorLoggingService._internal();

  final List<AppErrorRecord> _errorLog = [];
  List<AppErrorRecord> get errorLog => List.unmodifiable(_errorLog);

  void init() {
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      logError(
        message: details.exceptionAsString(),
        stackTrace: details.stack?.toString() ?? 'No stack trace available',
        category: 'FLUTTER_ERROR',
      );
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      logError(
        message: error.toString(),
        stackTrace: stack.toString(),
        category: 'ASYNC_PLATFORM_ERROR',
      );
      return true; // handled
    };
  }

  void logError({
    required String message,
    required String stackTrace,
    String category = 'RUNTIME_EXCEPTION',
  }) {
    final record = AppErrorRecord(
      id: 'err_${DateTime.now().millisecondsSinceEpoch}',
      message: message,
      stackTrace: stackTrace,
      timestamp: DateTime.now(),
      category: category,
    );

    _errorLog.insert(0, record);
    if (_errorLog.length > 50) {
      _errorLog.removeLast();
    }

    if (kDebugMode) {
      print(' [AppErrorCaptured] [${record.category}] ${record.message}');
    }
  }

  void clearLogs() {
    _errorLog.clear();
  }
}
