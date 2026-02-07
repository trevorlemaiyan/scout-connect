class Scout {
  final String id;
  final String name;
  final String email;
  final String organization;
  final String profilePictureUrl;
  final List<String> discoveredAthletes;
  final List<String> interestedSports;
  final String bio;
  final DateTime createdAt;
  final DateTime updatedAt;

  Scout({
    required this.id,
    required this.name,
    required this.email,
    required this.organization,
    required this.profilePictureUrl,
    required this.discoveredAthletes,
    required this.interestedSports,
    required this.bio,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert Scout to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'organization': organization,
      'profilePictureUrl': profilePictureUrl,
      'discoveredAthletes': discoveredAthletes,
      'interestedSports': interestedSports,
      'bio': bio,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // Create Scout from Firestore Document
  factory Scout.fromFirestore(Map<String, dynamic> data) {
    return Scout(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      organization: data['organization'] ?? '',
      profilePictureUrl: data['profilePictureUrl'] ?? '',
      discoveredAthletes: List<String>.from(data['discoveredAthletes'] ?? []),
      interestedSports: List<String>.from(data['interestedSports'] ?? []),
      bio: data['bio'] ?? '',
      createdAt: (data['createdAt'] as Timestamp)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp)?.toDate() ?? DateTime.now(),
    );
  }

  // Create Scout from Map
  factory Scout.fromMap(Map<String, dynamic> map) {
    return Scout(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      organization: map['organization'] ?? '',
      profilePictureUrl: map['profilePictureUrl'] ?? '',
      discoveredAthletes: List<String>.from(map['discoveredAthletes'] ?? []),
      interestedSports: List<String>.from(map['interestedSports'] ?? []),
      bio: map['bio'] ?? '',
      createdAt: map['createdAt'] ?? DateTime.now(),
      updatedAt: map['updatedAt'] ?? DateTime.now(),
    );
  }

  // Copy with method for updating
  Scout copyWith({
    String? id,
    String? name,
    String? email,
    String? organization,
    String? profilePictureUrl,
    List<String>? discoveredAthletes,
    List<String>? interestedSports,
    String? bio,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Scout(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      organization: organization ?? this.organization,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      discoveredAthletes: discoveredAthletes ?? this.discoveredAthletes,
      interestedSports: interestedSports ?? this.interestedSports,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Scout(id: $id, name: $name, organization: $organization)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Scout &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.organization == organization &&
        other.profilePictureUrl == profilePictureUrl &&
        other.discoveredAthletes == discoveredAthletes &&
        other.interestedSports == interestedSports &&
        other.bio == bio;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        organization.hashCode ^
        profilePictureUrl.hashCode ^
        discoveredAthletes.hashCode ^
        interestedSports.hashCode ^
        bio.hashCode;
  }
}
