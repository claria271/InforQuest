import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/user_progress.dart';
import '../models/quiz_result.dart';

class StorageService {
  static const String _keyUser = 'infoquest_user';
  static const String _keyProgress = 'infoquest_progress';
  static const String _keyHistory = 'infoquest_history';
  static const String _keyOnboarding = 'infoquest_onboarding';
  static const String _keyDarkMode = 'infoquest_dark_mode';
  static const String _keySound = 'infoquest_sound';
  static const String _keyVibration = 'infoquest_vibration';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  // --- User Profile ---
  Future<void> saveUser(UserModel user) async {
    final jsonStr = jsonEncode(user.toJson());
    await _prefs.setString(_keyUser, jsonStr);
  }

  UserModel? getUser() {
    final jsonStr = _prefs.getString(_keyUser);
    if (jsonStr == null || jsonStr.isEmpty) return null;
    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return UserModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  // --- User Progress ---
  Future<void> saveProgress(UserProgress progress) async {
    final jsonStr = jsonEncode(progress.toJson());
    await _prefs.setString(_keyProgress, jsonStr);
  }

  UserProgress? getProgress() {
    final jsonStr = _prefs.getString(_keyProgress);
    if (jsonStr == null || jsonStr.isEmpty) return null;
    try {
      final map = jsonDecode(jsonStr) as Map<String, dynamic>;
      return UserProgress.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  // --- Quiz History ---
  Future<void> saveQuizResult(QuizResult result) async {
    final history = getQuizHistory();
    history.insert(0, result); // most recent first
    final listJson = history.map((e) => e.toJson()).toList();
    await _prefs.setString(_keyHistory, jsonEncode(listJson));
  }

  List<QuizResult> getQuizHistory() {
    final jsonStr = _prefs.getString(_keyHistory);
    if (jsonStr == null || jsonStr.isEmpty) return [];
    try {
      final list = jsonDecode(jsonStr) as List;
      return list.map((e) => QuizResult.fromJson(Map<String, dynamic>.from(e as Map))).toList();
    } catch (_) {
      return [];
    }
  }

  // --- App Settings ---
  bool hasCompletedOnboarding() {
    return _prefs.getBool(_keyOnboarding) ?? false;
  }

  Future<void> setCompletedOnboarding(bool val) async {
    await _prefs.setBool(_keyOnboarding, val);
  }

  bool isDarkMode() {
    return _prefs.getBool(_keyDarkMode) ?? false;
  }

  Future<void> setDarkMode(bool val) async {
    await _prefs.setBool(_keyDarkMode, val);
  }

  bool isSoundEnabled() {
    return _prefs.getBool(_keySound) ?? true;
  }

  Future<void> setSoundEnabled(bool val) async {
    await _prefs.setBool(_keySound, val);
  }

  bool isVibrationEnabled() {
    return _prefs.getBool(_keyVibration) ?? true;
  }

  Future<void> setVibrationEnabled(bool val) async {
    await _prefs.setBool(_keyVibration, val);
  }

  // --- Reset All Data ---
  Future<void> resetAllProgress(String userId) async {
    await _prefs.remove(_keyProgress);
    await _prefs.remove(_keyHistory);
  }

  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
