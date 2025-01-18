// Dil Sağlayıcısı (Language Provider)
// Bu dosya, uygulamanın çoklu dil desteğini yöneten provider sınıfını içerir
// Desteklenen diller: Türkçe (tr), İngilizce (en), Japonca (ja)
// Çeviriler JSON dosyalarından yüklenir ve uygulama genelinde kullanılır

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

// Dil değişikliklerini yöneten provider sınıfı
// ChangeNotifier kullanılarak dil değişikliklerinde UI otomatik güncellenir
class LanguageProvider with ChangeNotifier {
  // Logger instance'ı oluştur
  final _logger = Logger('LanguageProvider');

  // Aktif dil için çeviriler
  Map<String, dynamic> _translations = {};

  // Varsayılan dil: İngilizce
  String _currentLanguage = 'en';

  // Getter metodları
  String get currentLanguage => _currentLanguage;
  Map<String, dynamic> get translations => _translations;

  // Belirtilen dil için çevirileri yükler
  Future<void> loadTranslations(String languageCode) async {
    try {
      // Yükleme işlemini logla
      _logger.info('Loading translations for language: $languageCode');

      // JSON dosyasını assets klasöründen oku
      String jsonString = await rootBundle.loadString(
        'assets/translations/$languageCode.json',
      );
      _logger.fine('JSON file loaded successfully');

      // JSON verisini Map formatına dönüştür
      final Map<String, dynamic> decodedData = json.decode(jsonString);
      _logger.fine('JSON decoded successfully');

      // Çevirileri güncelle ve UI'ı yenile
      _translations = decodedData;
      _currentLanguage = languageCode;
      notifyListeners();
      _logger.info('Translations loaded successfully');
      _logger.fine('Header translations: ${translations['header']}');
    } catch (e, stackTrace) {
      // Hata durumunu logla
      _logger.severe('Error loading translations', e, stackTrace);

      // Hata durumunda İngilizce diline geri dön
      if (languageCode != 'en') {
        _logger.info('Falling back to English translations');
        await loadTranslations('en');
      }
    }
  }

  // Dil değiştirme işlemi
  Future<void> changeLanguage(String languageCode) async {
    _logger.info('Changing language to: $languageCode');
    await loadTranslations(languageCode);
  }

  // Belirli bir çeviri anahtarının değerini döndürür
  String? getTranslation(String key) {
    try {
      // Anahtar zincirini nokta ile ayır ve değeri bul
      final keys = key.split('.');
      dynamic value = _translations;
      for (var k in keys) {
        if (value is Map && value.containsKey(k)) {
          value = value[k];
        } else {
          _logger.warning('Translation key not found: $key');
          return null;
        }
      }
      return value?.toString();
    } catch (e) {
      // Hata durumunu logla
      _logger.warning('Error getting translation for key: $key', e);
      return null;
    }
  }

  // String değer getir, bulunamazsa varsayılan değeri döndür
  String getString(String key, {String defaultValue = ''}) {
    return getTranslation(key) ?? defaultValue;
  }

  // String listesi döndürür
  List<String>? getStringList(String key) {
    try {
      final value = getValue(key);
      if (value is List) {
        return value.map((e) => e.toString()).toList();
      }
      return null;
    } catch (e) {
      // Hata durumunu logla
      _logger.warning('Error getting string list for key: $key', e);
      return null;
    }
  }

  // Herhangi bir tip için değer döndürür
  dynamic getValue(String key, {dynamic defaultValue}) {
    try {
      // Anahtar zincirini nokta ile ayır ve değeri bul
      final keys = key.split('.');
      dynamic value = _translations;
      for (var k in keys) {
        if (value is Map && value.containsKey(k)) {
          value = value[k];
        } else {
          return defaultValue;
        }
      }
      return value ?? defaultValue;
    } catch (e) {
      // Hata durumunu logla
      _logger.warning('Error getting value for key: $key', e);
      return defaultValue;
    }
  }

  // Logger'ı başlat ve yapılandır
  static void initLogger() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
      if (record.error != null) {
        print('Error: ${record.error}');
      }
      if (record.stackTrace != null) {
        print('Stack trace:\n${record.stackTrace}');
      }
    });
  }
}
