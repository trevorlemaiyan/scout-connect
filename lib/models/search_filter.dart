class AthleteSearchFilter {
  final String? sport;
  final String? position;
  final List<String> skills;
  final String? location;
  final int? minAge;
  final int? maxAge;
  final double? minHeight;
  final double? maxHeight;
  final double? minWeight;
  final double? maxWeight;
  final String? experience;
  final String? education;
  final bool hasVideos;
  final bool hasAchievements;
  final String sortBy; // 'relevance', 'age', 'location', 'recent'
  final bool ascending;

  AthleteSearchFilter({
    this.sport,
    this.position,
    this.skills = const [],
    this.location,
    this.minAge,
    this.maxAge,
    this.minHeight,
    this.maxHeight,
    this.minWeight,
    this.maxWeight,
    this.experience,
    this.education,
    this.hasVideos = false,
    this.hasAchievements = false,
    this.sortBy = 'relevance',
    this.ascending = true,
  });

  AthleteSearchFilter copyWith({
    String? sport,
    String? position,
    List<String>? skills,
    String? location,
    int? minAge,
    int? maxAge,
    double? minHeight,
    double? maxHeight,
    double? minWeight,
    double? maxWeight,
    String? experience,
    String? education,
    bool? hasVideos,
    bool? hasAchievements,
    String? sortBy,
    bool? ascending,
  }) {
    return AthleteSearchFilter(
      sport: sport ?? this.sport,
      position: position ?? this.position,
      skills: skills ?? this.skills,
      location: location ?? this.location,
      minAge: minAge ?? this.minAge,
      maxAge: maxAge ?? this.maxAge,
      minHeight: minHeight ?? this.minHeight,
      maxHeight: maxHeight ?? this.maxHeight,
      minWeight: minWeight ?? this.minWeight,
      maxWeight: maxWeight ?? this.maxWeight,
      experience: experience ?? this.experience,
      education: education ?? this.education,
      hasVideos: hasVideos ?? this.hasVideos,
      hasAchievements: hasAchievements ?? this.hasAchievements,
      sortBy: sortBy ?? this.sortBy,
      ascending: ascending ?? this.ascending,
    );
  }

  // Check if filter has any active criteria
  bool get hasActiveCriteria {
    return sport != null ||
        position != null ||
        skills.isNotEmpty ||
        location != null ||
        minAge != null ||
        maxAge != null ||
        minHeight != null ||
        maxHeight != null ||
        minWeight != null ||
        maxWeight != null ||
        experience != null ||
        education != null ||
        hasVideos ||
        hasAchievements;
  }

  // Clear all filters
  AthleteSearchFilter clear() {
    return AthleteSearchFilter(
      sortBy: 'relevance',
      ascending: true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sport': sport,
      'position': position,
      'skills': skills,
      'location': location,
      'minAge': minAge,
      'maxAge': maxAge,
      'minHeight': minHeight,
      'maxHeight': maxHeight,
      'minWeight': minWeight,
      'maxWeight': maxWeight,
      'experience': experience,
      'education': education,
      'hasVideos': hasVideos,
      'hasAchievements': hasAchievements,
      'sortBy': sortBy,
      'ascending': ascending,
    };
  }

  factory AthleteSearchFilter.fromMap(Map<String, dynamic> map) {
    return AthleteSearchFilter(
      sport: map['sport'],
      position: map['position'],
      skills: List<String>.from(map['skills'] ?? []),
      location: map['location'],
      minAge: map['minAge'],
      maxAge: map['maxAge'],
      minHeight: map['minHeight']?.toDouble(),
      maxHeight: map['maxHeight']?.toDouble(),
      minWeight: map['minWeight']?.toDouble(),
      maxWeight: map['maxWeight']?.toDouble(),
      experience: map['experience'],
      education: map['education'],
      hasVideos: map['hasVideos'] ?? false,
      hasAchievements: map['hasAchievements'] ?? false,
      sortBy: map['sortBy'] ?? 'relevance',
      ascending: map['ascending'] ?? true,
    );
  }

  @override
  String toString() {
    return 'AthleteSearchFilter(sport: $sport, position: $position, skills: $skills, location: $location)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AthleteSearchFilter &&
        other.sport == sport &&
        other.position == position &&
        other.skills == skills &&
        other.location == location &&
        other.minAge == minAge &&
        other.maxAge == maxAge &&
        other.minHeight == minHeight &&
        other.maxHeight == maxHeight &&
        other.minWeight == minWeight &&
        other.maxWeight == maxWeight &&
        other.experience == experience &&
        other.education == education &&
        other.hasVideos == hasVideos &&
        other.hasAchievements == hasAchievements &&
        other.sortBy == sortBy &&
        other.ascending == ascending;
  }

  @override
  int get hashCode {
    return sport.hashCode ^
        position.hashCode ^
        skills.hashCode ^
        location.hashCode ^
        minAge.hashCode ^
        maxAge.hashCode ^
        minHeight.hashCode ^
        maxHeight.hashCode ^
        minWeight.hashCode ^
        maxWeight.hashCode ^
        experience.hashCode ^
        education.hashCode ^
        hasVideos.hashCode ^
        hasAchievements.hashCode ^
        sortBy.hashCode ^
        ascending.hashCode;
  }
}
