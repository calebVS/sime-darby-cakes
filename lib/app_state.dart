import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  bool _isDarkMode = false;
  String _language = 'English';
  String _displayName = 'Maya J';

  bool get isDarkMode => _isDarkMode;
  String get language => _language;
  String get displayName => _displayName;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  AppState() {
    loadPreferences();
  }

  // Load saved preferences on startup
  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _language = prefs.getString('language') ?? 'English';
    _displayName = prefs.getString('displayName') ?? 'Maya J';
    notifyListeners(); // Refresh UI once loaded
  }

  // Toggle Dark/Light Mode globally
  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
    notifyListeners(); // Tells MaterialApp to rebuild immediately
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', value);
  }

  // Change Language globally
  Future<void> setLanguage(String lang) async {
    _language = lang;
    notifyListeners(); // Rebuilds text strings
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', lang);
  }

  Future<void> setDisplayName(String name) async {
    _displayName = name;
    notifyListeners(); // Instantly updates ProfileScreen!
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('displayName', name);
  }
}