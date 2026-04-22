import 'dart:developer' as developer;

class Logger {
  static const String _defaultTag = 'CargoDriver';
  
  static void debug(String message, {String? tag}) {
    _log('DEBUG', message, tag ?? _defaultTag);
  }
  
  static void info(String message, {String? tag}) {
    _log('INFO', message, tag ?? _defaultTag);
  }
  
  static void warning(String message, {String? tag}) {
    _log('WARNING', message, tag ?? _defaultTag);
  }
  
  static void error(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _log('ERROR', message, tag ?? _defaultTag);
    if (error != null) {
      developer.log('Error details: $error', name: tag ?? _defaultTag, error: error, stackTrace: stackTrace);
    }
  }
  
  static void _log(String level, String message, String tag) {
    final timestamp = DateTime.now().toIso8601String();
    developer.log('[$timestamp] $level: $message', name: tag);
  }
}
