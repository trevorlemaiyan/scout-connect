class SportCategory {
  final String id;
  final String name;
  final String description;
  final List<String> positions;
  final List<String> skills;
  final String icon;
  final bool isActive;

  SportCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.positions,
    required this.skills,
    required this.icon,
    this.isActive = true,
  });

  // Football positions and skills
  static final SportCategory football = SportCategory(
    id: 'football',
    name: 'Football',
    description: 'Association football (soccer)',
    positions: [
      'Goalkeeper',
      'Center Back',
      'Full Back',
      'Center Midfielder',
      'Winger',
      'Striker',
      'Defensive Midfielder',
      'Attacking Midfielder'
    ],
    skills: [
      'Dribbling',
      'Passing',
      'Shooting',
      'Defending',
      'Speed',
      'Stamina',
      'Ball Control',
      'Tackling',
      'Heading',
      'Vision'
    ],
    icon: '⚽',
  );

  // Athletics positions and skills (for future expansion)
  static final SportCategory athletics = SportCategory(
    id: 'athletics',
    name: 'Athletics',
    description: 'Track and field sports',
    positions: [
      'Sprinter',
      'Distance Runner',
      'Jumper',
      'Thrower',
      'Hurdler',
      'Relay Runner'
    ],
    skills: [
      'Speed',
      'Endurance',
      'Power',
      'Technique',
      'Agility',
      'Strength',
      'Coordination',
      'Balance'
    ],
    icon: '🏃',
    isActive: false, // Not active yet
  );

  // Get all active sports
  static List<SportCategory> getActiveSports() {
    return [football]; // Only football is active for now
  }

  // Get all sports (including inactive)
  static List<SportCategory> getAllSports() {
    return [football, athletics];
  }

  // Get sport by ID
  static SportCategory? getSportById(String id) {
    try {
      return getAllSports().firstWhere((sport) => sport.id == id);
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'positions': positions,
      'skills': skills,
      'icon': icon,
      'isActive': isActive,
    };
  }

  factory SportCategory.fromMap(Map<String, dynamic> map) {
    return SportCategory(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      positions: List<String>.from(map['positions'] ?? []),
      skills: List<String>.from(map['skills'] ?? []),
      icon: map['icon'] ?? '',
      isActive: map['isActive'] ?? true,
    );
  }
}
