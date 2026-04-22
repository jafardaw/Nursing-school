import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../errors/exceptions.dart';

abstract class StorageService {
  Future<void> saveString(String key, String value);
  Future<String?> getString(String key);
  Future<void> saveInt(String key, int value);
  Future<int?> getInt(String key);
  Future<void> saveBool(String key, bool value);
  Future<bool?> getBool(String key);
  Future<void> saveDouble(String key, double value);
  Future<double?> getDouble(String key);
  Future<void> saveStringList(String key, List<String> value);
  Future<List<String>> getStringList(String key);
  Future<void> saveObject(String key, Map<String, dynamic> value);
  Future<Map<String, dynamic>?> getObject(String key);
  Future<void> remove(String key);
  Future<void> clear();
  Future<bool> containsKey(String key);
}

class StorageServiceImpl implements StorageService {
  final SharedPreferences _prefs;

  StorageServiceImpl(this._prefs);

  static Future<StorageServiceImpl> create() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageServiceImpl(prefs);
  }

  @override
  Future<void> saveString(String key, String value) async {
    try {
      await _prefs.setString(key, value);
    } catch (e) {
      throw CacheException('Failed to save string: ${e.toString()}');
    }
  }

  @override
  Future<String?> getString(String key) async {
    try {
      return _prefs.getString(key);
    } catch (e) {
      throw CacheException('Failed to get string: ${e.toString()}');
    }
  
  }

  @override
  Future<void> saveInt(String key, int value) async {
    try {
      await _prefs.setInt(key, value);
    } catch (e) {
      throw CacheException('Failed to save int: ${e.toString()}');
    }
  }

  @override
  Future<int?> getInt(String key) async {
    try {
      return _prefs.getInt(key);
    } catch (e) {
      throw CacheException('Failed to get int: ${e.toString()}');
    }
  }

  @override
  Future<void> saveBool(String key, bool value) async {
    try {
      await _prefs.setBool(key, value);
    } catch (e) {
      throw CacheException('Failed to save bool: ${e.toString()}');
    }
  }

  @override
  Future<bool?> getBool(String key) async {
    try {
      return _prefs.getBool(key);
    } catch (e) {
      throw CacheException('Failed to get bool: ${e.toString()}');
    }
  }

  @override
  Future<void> saveDouble(String key, double value) async {
    try {
      await _prefs.setDouble(key, value);
    } catch (e) {
      throw CacheException('Failed to save double: ${e.toString()}');
    }
  }

  @override
  Future<double?> getDouble(String key) async {
    try {
      return _prefs.getDouble(key);
    } catch (e) {
      throw CacheException('Failed to get double: ${e.toString()}');
    }
  }

  @override
  Future<void> saveStringList(String key, List<String> value) async {
    try {
      await _prefs.setStringList(key, value);
    } catch (e) {
      throw CacheException('Failed to save string list: ${e.toString()}');
    }
  }

  @override
  Future<List<String>> getStringList(String key) async {
    try {
      return _prefs.getStringList(key) ?? [];
    } catch (e) {
      throw CacheException('Failed to get string list: ${e.toString()}');
    }
  }

  @override
  Future<void> saveObject(String key, Map<String, dynamic> value) async {
    try {
      final jsonString = jsonEncode(value);
      await _prefs.setString(key, jsonString);
    } catch (e) {
      throw CacheException('Failed to save object: ${e.toString()}');
    }
  }

  @override
  Future<Map<String, dynamic>?> getObject(String key) async {
    try {
      final jsonString = _prefs.getString(key);
      if (jsonString == null) return null;

      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      throw CacheException('Failed to get object: ${e.toString()}');
    }
  }

  @override
  Future<void> remove(String key) async {
    try {
      await _prefs.remove(key);
    } catch (e) {
      throw CacheException('Failed to remove value: ${e.toString()}');
    }
  }

  @override
  Future<void> clear() async {
    try {
      await _prefs.clear();
    } catch (e) {
      throw CacheException('Failed to clear storage: ${e.toString()}');
    }
  }

  @override
  Future<bool> containsKey(String key) async {
    try {
      return _prefs.containsKey(key);
    } catch (e) {
      throw CacheException('Failed to check key: ${e.toString()}');
    }
  }
}
