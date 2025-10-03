import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/skill_model.dart';

class JsonService {
  /// Load skills from JSON file in assets folder
  static Future<List<Skill>> loadSkillsFromAssets() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/skills.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      final List<Skill> skills = jsonData
          .map((json) => Skill.fromJson(json as Map<String, dynamic>))
          .toList();
      
      print('✅ Successfully loaded ${skills.length} skills');
      return skills;
    } catch (e) {
      print('❌ Error loading skills from assets: $e');
      return [];
    }
  }

  /// Group skills by level in correct order: Basic → Intermediate → Advanced
  static Map<String, List<Skill>> groupSkillsByLevel(List<Skill> skills) {
    Map<String, List<Skill>> grouped = {
      'Basic': [],
      'Intermediate': [],
      'Advanced': [],
    };

    for (var skill in skills) {
      String level = skill.level.trim();
      if (grouped.containsKey(level)) {
        grouped[level]!.add(skill);
      }
    }
    
    print('📊 Grouped - Basic: ${grouped['Basic']?.length}, '
          'Intermediate: ${grouped['Intermediate']?.length}, '
          'Advanced: ${grouped['Advanced']?.length}');

    return grouped;
  }
}
