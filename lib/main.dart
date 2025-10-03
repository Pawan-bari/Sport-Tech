import 'package:flutter/material.dart';
import 'screen/skill_screen.dart';

void main() {
  runApp(const SportsSkillsApp());
}

class SportsSkillsApp extends StatelessWidget {
  const SportsSkillsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sports Skills App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        scaffoldBackgroundColor: Color(0xFFF5F7FA),
      ),
      home: const SkillsScreen(),
    );
  }
}
