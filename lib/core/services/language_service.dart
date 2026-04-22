import 'package:flutter/material.dart';

import '../constants/app_constants.dart';
import '../network/api_service.dart';
import '../storage/storage_service.dart';

class AppLanguageService {
  final StorageService _storage;
  final ApiService _apiService;
  final String _fallbackLanguageCode;

  final ValueNotifier<Locale> localeNotifier;

  String _languageCode;

  AppLanguageService({
    required StorageService storage,
    required ApiService apiService,
    String initialLanguageCode = 'ar',
  }) : _storage = storage,
       _apiService = apiService,
       _fallbackLanguageCode = _normalizeLanguageCode(initialLanguageCode),
       _languageCode = _normalizeLanguageCode(initialLanguageCode),
       localeNotifier = ValueNotifier<Locale>(
         Locale(_normalizeLanguageCode(initialLanguageCode)),
       );

  String get languageCode => _languageCode;

  Locale get currentLocale => localeNotifier.value;

  Future<void> initialize() async {
    final storedLanguage = await _storage.getString(AppConstants.languageKey);
    final normalizedLanguage = _normalizeLanguageCode(
      storedLanguage ?? _fallbackLanguageCode,
    );

    await _applyLanguage(normalizedLanguage, persist: false);
  }

  Future<void> setLanguage(String languageCode) async {
    await _applyLanguage(languageCode, persist: true);
  }

  Future<void> _applyLanguage(
    String languageCode, {
    required bool persist,
  }) async {
    final normalizedLanguage = _normalizeLanguageCode(languageCode);

    if (persist) {
      await _storage.remove(AppConstants.languageKey);
      await _storage.saveString(AppConstants.languageKey, normalizedLanguage);
    }

    _languageCode = normalizedLanguage;
    localeNotifier.value = Locale(normalizedLanguage);
    _apiService.updateHeaders({
      'Accept-Language': normalizedLanguage,
      'lang': normalizedLanguage.toUpperCase(),
    });
  }

  static String _normalizeLanguageCode(String? languageCode) {
    final normalized = languageCode?.trim().toLowerCase();
    if (normalized == 'en') {
      return 'en';
    }
    return 'ar';
  }

  void dispose() {
    localeNotifier.dispose();
  }
}
