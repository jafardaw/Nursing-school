import 'dart:convert';
import 'dart:math';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptionService {
  static const String _encKeyStorageKey = 'enc_key_v1';
  static const String _encIvStorageKey = 'enc_iv_v1';

  final FlutterSecureStorage _secureStorage;
  late final enc.Encrypter _encrypter;
  late final enc.IV _iv;

  EncryptionService._(this._secureStorage);

  static Future<EncryptionService> create() async {
    const secureStorage = FlutterSecureStorage();
    final service = EncryptionService._(secureStorage);
    await service._initKeyMaterial();
    return service;
  }

  Future<void> _initKeyMaterial() async {
    String? keyB64 = await _secureStorage.read(key: _encKeyStorageKey);
    String? ivB64 = await _secureStorage.read(key: _encIvStorageKey);

    if (keyB64 == null || ivB64 == null) {
      final keyBytes = _randomBytes(32); // AES-256 key
      final ivBytes = _randomBytes(16);  // CBC IV size

      keyB64 = base64Encode(keyBytes);
      ivB64 = base64Encode(ivBytes);

      await _secureStorage.write(key: _encKeyStorageKey, value: keyB64);
      await _secureStorage.write(key: _encIvStorageKey, value: ivB64);
    }

    final key = enc.Key(base64Decode(keyB64));
    _iv = enc.IV(base64Decode(ivB64));
    _encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
  }

  String encryptToken(String plainToken) {
    return _encrypter.encrypt(plainToken, iv: _iv).base64;
  }

  String decryptToken(String encryptedToken) {
    return _encrypter.decrypt64(encryptedToken, iv: _iv);
  }

  static List<int> _randomBytes(int length) {
    final random = Random.secure();
    return List<int>.generate(length, (_) => random.nextInt(256));
  }
}