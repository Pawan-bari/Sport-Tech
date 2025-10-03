class Skill {
  final String name;
  final String level;
  final String image;

  Skill({
    required this.name,
    required this.level,
    required this.image,
  });

  // Parse JSON to Skill object
  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      name: json['name'] as String,
      level: json['level'] as String,
      image: json['image'] as String,
    );
  }

  // Convert Skill object to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'level': level,
      'image': image,
    };
  }

  @override
  String toString() {
    return 'Skill(name: $name, level: $level, image: $image)';
  }
}
