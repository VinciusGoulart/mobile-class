import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class SettingsProvider with ChangeNotifier {
  static const String _darkModeKey = 'darkMode';
  static const String _notificationsKey = 'notifications';
  static const String _languageKey = 'language';
  static const String _twoFactorKey = 'twoFactor';

  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  String _language = 'pt';
  bool _twoFactorEnabled = false;

  bool get isDarkMode => _isDarkMode;
  bool get notificationsEnabled => _notificationsEnabled;
  String get language => _language;
  bool get twoFactorEnabled => _twoFactorEnabled;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_darkModeKey) ?? false;
    _notificationsEnabled = prefs.getBool(_notificationsKey) ?? true;
    _language = prefs.getString(_languageKey) ?? 'pt';
    _twoFactorEnabled = prefs.getBool(_twoFactorKey) ?? false;
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, _isDarkMode);
    notifyListeners();
  }

  Future<void> toggleNotifications() async {
    _notificationsEnabled = !_notificationsEnabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsKey, _notificationsEnabled);
    notifyListeners();
  }

  Future<void> setLanguage(String language) async {
    _language = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, language);
    notifyListeners();
  }

  Future<void> toggleTwoFactor() async {
    _twoFactorEnabled = !_twoFactorEnabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_twoFactorKey, _twoFactorEnabled);
    notifyListeners();
  }

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await _loadSettings();
  }

  Future<void> exportData() async {
    // TODO: Implementar exportação de dados
    notifyListeners();
  }

  Future<void> updateProfile(UserModel user) async {
    // TODO: Implementar atualização no backend
    // Por enquanto, apenas simula a atualização
    await Future.delayed(const Duration(seconds: 1));
  }
} 