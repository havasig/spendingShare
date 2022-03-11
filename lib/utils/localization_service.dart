import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class LocalizationService extends Translations {
  // Default locale
  static const locale = Locale('en', 'US');

  // fallbackLocale saves the day when the locale gets in trouble
  static const fallbackLocale = Locale('en', 'US');

  // Supported languages
  // Needs to be same order with locales
  static final langs = [
    'English',
    'Magyar',
  ];

  // Supported locales
  // Needs to be same order with langs
  static final locales = [
    const Locale('en', 'US'),
    const Locale('hu', 'HU'),
  ];

  static final _keys = <String, Map<String, String>>{};

  static Future<bool> loadAllTranslations() async {
    for (final locale in locales) {
      try {
        final languageKey = '${locale.languageCode}_${locale.countryCode}';
        final jsonString = await rootBundle.loadString(
          'assets/lang/$languageKey.json',
        );
        final jsonMap = json.decode(jsonString);
        _keys[languageKey] = Map<String, String>.from(jsonMap.map((key, value) {
          return MapEntry(key, value.toString());
        }));
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
      }
    }
    return true;
  }

  // Keys and their translations
  // Translations are separated maps in `lang` file
  @override
  Map<String, Map<String, String>> get keys => _keys;

  // Gets locale from language, and updates the locale
  void changeLocale(String lang) {
    final locale = _getLocaleFromLanguage(lang);
    Get.updateLocale(locale);
  }

  // Finds language in `langs` list and returns it as Locale
  Locale _getLocaleFromLanguage(String lang) {
    for (int i = 0; i < langs.length; i++) {
      if (lang == langs[i]) return locales[i];
    }
    return Get.locale!;
  }
}
