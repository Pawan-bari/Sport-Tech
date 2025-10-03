import 'package:flutter/material.dart';
import '../models/skill_model.dart';
import '../services/json_services.dart';

class SkillsScreen extends StatefulWidget {
  const SkillsScreen({super.key});

  @override
  State<SkillsScreen> createState() => _SkillsScreenState();
}

class _SkillsScreenState extends State<SkillsScreen>
    with SingleTickerProviderStateMixin {
  List<Skill> skills = [];
  Map<String, List<Skill>> groupedSkills = {};
  final List<String> levelOrder = ['Basic', 'Intermediate', 'Advanced'];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSkills();
  }

  Future<void> _loadSkills() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      List<Skill> loadedSkills = await JsonService.loadSkillsFromAssets();
      if (loadedSkills.isEmpty) {
        setState(() {
          errorMessage = 'No skills found in JSON file';
          isLoading = false;
        });
        return;
      }
      setState(() {
        skills = loadedSkills;
        groupedSkills = JsonService.groupSkillsByLevel(skills);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading skills: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FF),
      appBar: _buildAppBar(),
      body: isLoading
          ? _buildLoading()
          : errorMessage != null
              ? _buildError()
              : _buildContent(context),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      toolbarHeight: 70,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2979FF), Color(0xFF1565C0)],
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade200,
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(Icons.sports_soccer, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Sports Skills',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF103178),
                  letterSpacing: -0.6,
                ),
              ),
              if (!isLoading && skills.isNotEmpty)
                Text(
                  '${skills.length} skills available',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade200,
                  blurRadius: 20,
                  spreadRadius: 8,
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: const CircularProgressIndicator(
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation(Color(0xFF2979FF)),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Fetching skills...',
            style: TextStyle(color: Colors.grey.shade700, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
            const SizedBox(height: 20),
            Text(
              errorMessage!,
              style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: _loadSkills,
              icon: const Icon(Icons.refresh),
              label: const Text("Try Again"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2979FF),
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 6,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: levelOrder.map((level) {
          final levelSkills = groupedSkills[level]!;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(level, levelSkills.length),
                const SizedBox(height: 8),
                SizedBox(
                  height: 260,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    itemCount: levelSkills.length,
                    itemBuilder: (_, index) {
                      return PremiumSkillCard(skill: levelSkills[index]);
                    },
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSectionHeader(String level, int count) {
    Color baseColor;
    IconData icon;
    switch (level) {
      case 'Basic':
        baseColor = const Color(0xFF43A047);
        icon = Icons.school;
        break;
      case 'Intermediate':
        baseColor = const Color(0xFF1E88E5);
        icon = Icons.trending_up;
        break;
      case 'Advanced':
        baseColor = const Color(0xFFE53935);
        icon = Icons.military_tech;
        break;
      default:
        baseColor = Colors.grey;
        icon = Icons.star;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: baseColor,
            radius: 18,
            child: Icon(
              icon,
              size: 22,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 14),
          Text(
            "$level Skills",
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 20,
              color: baseColor,
              shadows: [
                Shadow(
                    color: baseColor.withOpacity(0.4),
                    blurRadius: 8,
                    offset: Offset(0, 3))
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Text(
              "$count available",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PremiumSkillCard extends StatefulWidget {
  final Skill skill;
  const PremiumSkillCard({required this.skill, super.key});

  @override
  State<PremiumSkillCard> createState() => _PremiumSkillCardState();
}

class _PremiumSkillCardState extends State<PremiumSkillCard>
    with SingleTickerProviderStateMixin {
  bool isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  Color get baseColor {
    switch (widget.skill.level) {
      case 'Basic':
        return const Color(0xFF43A047);
      case 'Intermediate':
        return const Color(0xFF1E88E5);
      case 'Advanced':
        return const Color(0xFFE53935);
      default:
        return Colors.grey;
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _scaleAnim = Tween<double>(begin: 1.0, end: 1.07).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onHover(bool hovering) {
    setState(() => isHovered = hovering);
    if (hovering) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          margin: const EdgeInsets.only(right: 20, bottom: 14),
          width: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: baseColor.withOpacity(isHovered ? 0.3 : 0.1),
                blurRadius: isHovered ? 16 : 10,
                offset: const Offset(0, 6),
              ),
            ],
            gradient: LinearGradient(
              colors: [baseColor.withOpacity(0.9), baseColor.withOpacity(0.6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        widget.skill.image,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Container(
                            color: baseColor.withOpacity(0.3),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, _, __) {
                          return Container(
                            color: baseColor.withOpacity(0.3),
                            child: const Center(
                              child: Icon(Icons.broken_image,
                                  color: Colors.white, size: 48),
                            ),
                          );
                        },
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.5),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(22),
                    ),
                  ),
                  child: Text(
                    widget.skill.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: baseColor.darken(0.3),
                      letterSpacing: 0.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
