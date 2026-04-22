import 'dart:developer';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class DeviceService {
  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  // جلب نوع الجهاز (ANDROID / IOS)
  static Future<String> getDeviceType() async {
    if (Platform.isAndroid) {
      return 'ANDROID';
    } else if (Platform.isIOS) {
      return 'IOS';
    }
    return 'UNKNOWN';
  }

  // جلب IMEI أو معرف فريد للجهاز
  static Future<String> getDeviceImei() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        // Android ID (بديل عن IMEI لأن IMEI يحتاج صلاحيات خاصة)
        return androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return iosInfo.identifierForVendor ?? 'unknown';
      }
    } catch (e) {
      log('Error getting device IMEI: $e');
    }
    return 'unknown_device_id';
  }

  // جلب معلومات الجهاز (الموديل، الشركة)
  static Future<String> getDeviceInfo() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return '${androidInfo.manufacturer} ${androidInfo.model}';
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return iosInfo.model;
      }
    } catch (e) {
      print('Error getting device info: $e');
    }
    return 'Unknown Device';
  }

  // جلب الموقع الحالي
  static Future<Position?> getCurrentLocation() async {
    try {
      // طلب صلاحية الموقع
      PermissionStatus status = await Permission.location.request();

      if (status.isGranted) {
        // جلب الموقع
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        return position;
      } else if (status.isDenied) {
        print('Location permission denied');
      } else if (status.isPermanentlyDenied) {
        print('Location permission permanently denied');
      }
    } catch (e) {
      print('Error getting location: $e');
    }
    return null;
  }

  // جلب كل بيانات الجهاز مرة واحدة
  static Future<Map<String, dynamic>> getAllDeviceData() async {
    final deviceType = await getDeviceType();
    final deviceImei = await getDeviceImei();
    final deviceInfo = await getDeviceInfo();
    final position = await getCurrentLocation();

    return {
      'deviceType': deviceType,
      'deviceImei': deviceImei,
      'deviceInfo': deviceInfo,
      'longitude': position?.longitude ?? 0.0,
      'latitude': position?.latitude ?? 0.0,
    };
  }
}
