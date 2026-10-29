import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/level.dart';
import '../models/material_section.dart';
import '../models/question.dart';

class ContentService {
  List<LevelModel>? _cachedLevels;
  final Map<int, List<MaterialSection>> _cachedMaterials = {};
  final Map<int, List<QuestionModel>> _cachedQuestions = {};
  final Map<int, Map<String, dynamic>> _cachedChallenges = {};

  Future<List<LevelModel>> getLevels() async {
    if (_cachedLevels != null) return _cachedLevels!;
    final jsonStr = await rootBundle.loadString('assets/data/levels.json');
    final map = jsonDecode(jsonStr) as Map<String, dynamic>;
    final list = map['levels'] as List;
    _cachedLevels = list.map((e) => LevelModel.fromJson(Map<String, dynamic>.from(e as Map))).toList();
    return _cachedLevels!;
  }

  Future<LevelModel?> getLevelById(int levelId) async {
    final levels = await getLevels();
    try {
      return levels.firstWhere((lvl) => lvl.id == levelId);
    } catch (_) {
      return null;
    }
  }

  Future<List<MaterialSection>> getMaterials(int levelId) async {
    if (_cachedMaterials.containsKey(levelId)) {
      return _cachedMaterials[levelId]!;
    }
    final paddedId = levelId.toString().padLeft(2, '0');
    final jsonStr = await rootBundle.loadString('assets/data/materials/level_$paddedId.json');
    final map = jsonDecode(jsonStr) as Map<String, dynamic>;
    final list = map['sections'] as List;
    final sections = list.map((e) => MaterialSection.fromJson(Map<String, dynamic>.from(e as Map))).toList();
    sections.sort((a, b) => a.order.compareTo(b.order));
    _cachedMaterials[levelId] = sections;
    return sections;
  }

  Future<List<QuestionModel>> getQuestions(int levelId) async {
    if (_cachedQuestions.containsKey(levelId)) {
      return _cachedQuestions[levelId]!;
    }
    final paddedId = levelId.toString().padLeft(2, '0');
    final jsonStr = await rootBundle.loadString('assets/data/questions/level_$paddedId.json');
    final map = jsonDecode(jsonStr) as Map<String, dynamic>;
    final list = map['questions'] as List;
    final questions = list.map((e) => QuestionModel.fromJson(Map<String, dynamic>.from(e as Map))).toList();
    _cachedQuestions[levelId] = questions;
    return questions;
  }

  Future<Map<String, dynamic>?> getChallenge(int levelId) async {
    if (_cachedChallenges.containsKey(levelId)) {
      return _cachedChallenges[levelId];
    }
    final paddedId = levelId.toString().padLeft(2, '0');
    final jsonStr = await rootBundle.loadString('assets/data/questions/level_$paddedId.json');
    final map = jsonDecode(jsonStr) as Map<String, dynamic>;
    if (map.containsKey('challenge') && map['challenge'] != null) {
      _cachedChallenges[levelId] = Map<String, dynamic>.from(map['challenge'] as Map);
      return _cachedChallenges[levelId];
    }
    return null;
  }
}
