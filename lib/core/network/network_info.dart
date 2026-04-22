import 'dart:io';
import 'package:flutter/foundation.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get connectivityStream;
}

class NetworkInfoImpl implements NetworkInfo {
  @override
  Future<bool> get isConnected async {
    try {
      if (kIsWeb) {
        // For web, we can use a simple HTTP request to check connectivity
        final result = await InternetAddress.lookup('google.com');
        return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      } else {
        // For mobile/desktop, we can check connectivity more directly
        final result = await InternetAddress.lookup('google.com');
        return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  @override
  Stream<bool> get connectivityStream {
    // This is a simplified implementation
    // In a real app, you might want to use connectivity_plus package
    return Stream.value(true).asyncMap((_) => isConnected);
  }
}
