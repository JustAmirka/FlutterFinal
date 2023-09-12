import 'package:flutter/material.dart';

class LanguageController extends ChangeNotifier {
  Locale _currentLocale = Locale('en', 'US');

  Locale get currentLocale => _currentLocale;

  void setLanguage(String languageCode) {
    _currentLocale = Locale(languageCode);
    notifyListeners();
  }
}
