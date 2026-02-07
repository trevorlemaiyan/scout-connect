import 'package:cloud_firestore/cloud_firestore.dart';

class Athlete {
  final String id;
  final String name;
  final String email;
  final String sport;
  final String position;
  final int age;
  final String location;
  final String profilePictureUrl;
  final String bio;
  final List<String> achievements;
  final List<String> skills;
  final List<String> videoUrls; // New field for video uploads
  final List<String> achievementsImages; // New field for achievement images
  final double height; // Physical stats
  final double weight;
  final String experience; // Years of experience
  final String education; // Educational background
  final DateTime createdAt;
  final DateTime updatedAt;

  Athlete({
    required this.id,
    required this.name,
    required this.email,
    required this.sport,
    required this.position,
    required this.age,
    required this.location,
    required this.profilePictureUrl,
    required this.bio,
    required this.achievements,
    required this.skills,
    this.videoUrls = const [],
    this.achievementsImages = const [],
    this.height = 0.0,
    this.weight = 0.0,
    this.experience = '',
    this.education = '',
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert Athlete to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'sport': sport,
      'position': position,
      'age': age,
      'location': location,
      'profilePictureUrl': profilePictureUrl,
      'bio': bio,
      'achievements': achievements,
      'skills': skills,
      'videoUrls': videoUrls,
      'achievementsImages': achievementsImages,
      'height': height,
      'weight': weight,
      'experience': experience,
      'education': education,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // Create Athlete from Firestore Document
  factory Athlete.fromFirestore(Map<String, dynamic> data) {
    return Athlete(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      sport: data['sport'] ?? '',
      position: data['position'] ?? '',
      age: data['age'] ?? 0,
      location: data['location'] ?? '',
      profilePictureUrl: data['profilePictureUrl'] ?? '',
      bio: data['bio'] ?? '',
      achievements: List<String>.from(data['achievements'] ?? []),
      skills: List<String>.from(data['skills'] ?? []),
      videoUrls: List<String>.from(data['videoUrls'] ?? []),
      achievementsImages: List<String>.from(data['achievementsImages'] ?? []),
      height: (data['height'] ?? 0.0).toDouble(),
      weight: (data['weight'] ?? 0.0).toDouble(),
      experience: data['experience'] ?? '',
      education: data['education'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  // Create Athlete from Map
  factory Athlete.fromMap(Map<String, dynamic> map) {
    return Athlete(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      sport: map['sport'] ?? '',
      position: map['position'] ?? '',
      age: map['age'] ?? 0,
      location: map['location'] ?? '',
      profilePictureUrl: map['profilePictureUrl'] ?? '',
      bio: map['bio'] ?? '',
      achievements: List<String>.from(map['achievements'] ?? []),
      skills: List<String>.from(map['skills'] ?? []),
      createdAt: map['createdAt'] ?? DateTime.now(),
      updatedAt: map['updatedAt'] ?? DateTime.now(),
    );
  }

  // Copy with method for updating
  Athlete copyWith({
    String? id,
    String? name,
    String? email,
    String? sport,
    String? position,
    int? age,
    String? location,
    String? profilePictureUrl,
    String? bio,
    List<String>? achievements,
    List<String>? skills,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Athlete(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      sport: sport ?? this.sport,
      position: position ?? this.position,
      age: age ?? this.age,
      location: location ?? this.location,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      bio: bio ?? this.bio,
      achievements: achievements ?? this.achievements,
      skills: skills ?? this.skills,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Athlete(id: $id, name: $name, sport: $sport, position: $position)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Athlete &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.sport == sport &&
        other.position == position &&
        other.age == age &&
        other.location == location &&
        other.profilePictureUrl == profilePictureUrl &&
        other.bio == bio &&
        other.achievements == achievements &&
        other.skills == skills;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        sport.hashCode ^
        position.hashCode ^
        age.hashCode ^
        location.hashCode ^
        profilePictureUrl.hashCode ^
        bio.hashCode ^
        achievements.hashCode ^
        skills.hashCode;
  }
}
