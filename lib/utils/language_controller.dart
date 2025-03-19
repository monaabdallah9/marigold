import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends ChangeNotifier {
  static const String _languageKey = 'language_code';
  Locale _locale = const Locale('en');
  
  Locale get locale => _locale;
  
  bool get isArabic => _locale.languageCode == 'ar';
  
  LanguageController() {
    _loadSavedLanguage();
  }
  
  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguageCode = prefs.getString(_languageKey);
      
      if (savedLanguageCode != null) {
        _locale = Locale(savedLanguageCode);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading saved language: $e');
    }
  }
  
  Future<void> changeLanguage(Locale locale) async {
    if (_locale == locale) return;
    
    _locale = locale;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, locale.languageCode);
    } catch (e) {
      debugPrint('Error saving language: $e');
    }
    
    notifyListeners();
  }
  
  Future<void> toggleLanguage() async {
    final newLocale = isArabic ? const Locale('en') : const Locale('ar');
    await changeLanguage(newLocale);
  }
} 