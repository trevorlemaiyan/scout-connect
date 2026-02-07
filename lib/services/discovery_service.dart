import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/athlete.dart';
import '../models/search_filter.dart';
import '../models/sport_category.dart';

class DiscoveryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Search athletes with filters
  Stream<List<Athlete>> searchAthletes(AthleteSearchFilter filter) {
    Query query = _firestore
        .collection('users')
        .where('accountType', isEqualTo: 'Athlete');

    // Apply filters
    if (filter.sport != null) {
      query = query.where('sport', isEqualTo: filter.sport);
    }

    if (filter.position != null) {
      query = query.where('position', isEqualTo: filter.position);
    }

    if (filter.location != null && filter.location!.isNotEmpty) {
      query = query.where('location', isGreaterThanOrEqualTo: filter.location!)
                   .where('location', isLessThanOrEqualTo: filter.location! + '\uf8ff');
    }

    if (filter.minAge != null) {
      query = query.where('age', isGreaterThanOrEqualTo: filter.minAge);
    }

    if (filter.maxAge != null) {
      query = query.where('age', isLessThanOrEqualTo: filter.maxAge);
    }

    if (filter.minHeight != null) {
      query = query.where('height', isGreaterThanOrEqualTo: filter.minHeight);
    }

    if (filter.maxHeight != null) {
      query = query.where('height', isLessThanOrEqualTo: filter.maxHeight);
    }

    if (filter.minWeight != null) {
      query = query.where('weight', isGreaterThanOrEqualTo: filter.minWeight);
    }

    if (filter.maxWeight != null) {
      query = query.where('weight', isLessThanOrEqualTo: filter.maxWeight);
    }

    if (filter.hasVideos) {
      query = query.where('videoUrls', isGreaterThanOrEqualTo: 1);
    }

    if (filter.hasAchievements) {
      query = query.where('achievements', isGreaterThanOrEqualTo: 1);
    }

    // Apply sorting
    switch (filter.sortBy) {
      case 'age':
        query = query.orderBy('age', descending: !filter.ascending);
        break;
      case 'location':
        query = query.orderBy('location', descending: !filter.ascending);
        break;
      case 'recent':
        query = query.orderBy('createdAt', descending: filter.ascending);
        break;
      case 'relevance':
      default:
        // For relevance, we could implement a custom scoring system
        // For now, sort by creation date
        query = query.orderBy('createdAt', descending: true);
        break;
    }

    return query.snapshots().map((snapshot) {
      final athletes = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Athlete.fromFirestore(data);
      }).toList();

      // Apply client-side filtering for skills and other complex filters
      return _applyClientSideFilters(athletes, filter);
    });
  }

  // Apply client-side filters for complex criteria
  List<Athlete> _applyClientSideFilters(List<Athlete> athletes, AthleteSearchFilter filter) {
    if (!filter.hasActiveCriteria) return athletes;

    return athletes.where((athlete) {
      // Skills filter
      if (filter.skills.isNotEmpty) {
        final hasRequiredSkills = filter.skills.every((skill) =>
            athlete.skills.any((athleteSkill) =>
                athleteSkill.toLowerCase().contains(skill.toLowerCase())));
        if (!hasRequiredSkills) return false;
      }

      // Experience filter
      if (filter.experience != null && filter.experience!.isNotEmpty) {
        if (!athlete.experience.toLowerCase().contains(filter.experience!.toLowerCase())) {
          return false;
        }
      }

      // Education filter
      if (filter.education != null && filter.education!.isNotEmpty) {
        if (!athlete.education.toLowerCase().contains(filter.education!.toLowerCase())) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  // Get recommended athletes for a scout
  Stream<List<Athlete>> getRecommendedAthletes(String scoutId, {int limit = 10}) {
    // Get scout's interested sports and preferences
    return _firestore.collection('users').doc(scoutId).snapshots().asyncMap(
      (scoutDoc) async {
        if (!scoutDoc.exists) return [];

        final scoutData = scoutDoc.data() as Map<String, dynamic>;
        final interestedSports = List<String>.from(scoutData['interestedSports'] ?? []);

        // Find athletes matching scout's interests
        Query query = _firestore
            .collection('users')
            .where('accountType', isEqualTo: 'Athlete')
            .limit(limit);

        if (interestedSports.isNotEmpty) {
          query = query.where('sport', whereIn: interestedSports.take(10)); // Firestore limit
        }

        final snapshot = await query.get();
        return snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return Athlete.fromFirestore(data);
        }).toList();
      },
    );
  }

  // Get trending athletes (based on profile views, recent activity, etc.)
  Stream<List<Athlete>> getTrendingAthletes({int limit = 20}) {
    return _firestore
        .collection('users')
        .where('accountType', isEqualTo: 'Athlete')
        .orderBy('profileViews', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Athlete.fromFirestore(data);
      }).toList();
    });
  }

  // Get athletes by sport
  Stream<List<Athlete>> getAthletesBySport(String sport, {int limit = 50}) {
    return _firestore
        .collection('users')
        .where('accountType', isEqualTo: 'Athlete')
        .where('sport', isEqualTo: sport)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Athlete.fromFirestore(data);
      }).toList();
    });
  }

  // Get athletes by location
  Stream<List<Athlete>> getAthletesByLocation(String location, {int limit = 50}) {
    return _firestore
        .collection('users')
        .where('accountType', isEqualTo: 'Athlete')
        .where('location', isGreaterThanOrEqualTo: location)
        .where('location', isLessThanOrEqualTo: location + '\uf8ff')
        .limit(limit)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Athlete.fromFirestore(data);
      }).toList();
    });
  }

  // Search athletes by name or bio
  Future<List<Athlete>> searchAthletesByQuery(String query, {int limit = 20}) async {
    final snapshot = await _firestore
        .collection('users')
        .where('accountType', isEqualTo: 'Athlete')
        .limit(limit)
        .get();

    final athletes = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Athlete.fromFirestore(data);
    }).toList();

    // Client-side text search
    final searchQuery = query.toLowerCase();
    return athletes.where((athlete) =>
        athlete.name.toLowerCase().contains(searchQuery) ||
        athlete.bio.toLowerCase().contains(searchQuery) ||
        athlete.sport.toLowerCase().contains(searchQuery) ||
        athlete.position.toLowerCase().contains(searchQuery)
    ).toList();
  }

  // Get available sports categories
  List<SportCategory> getAvailableSports() {
    return SportCategory.getActiveSports();
  }

  // Get positions for a specific sport
  List<String> getPositionsForSport(String sportId) {
    final sport = SportCategory.getSportById(sportId);
    return sport?.positions ?? [];
  }

  // Get skills for a specific sport
  List<String> getSkillsForSport(String sportId) {
    final sport = SportCategory.getSportById(sportId);
    return sport?.skills ?? [];
  }

  // Save scout search preference
  Future<void> saveScoutSearchPreference(String scoutId, AthleteSearchFilter filter) async {
    await _firestore.collection('scout_preferences').doc(scoutId).set({
      'lastSearchFilter': filter.toMap(),
      'updatedAt': Timestamp.now(),
    }, SetOptions(merge: true));
  }

  // Get scout's last search preference
  Future<AthleteSearchFilter?> getScoutSearchPreference(String scoutId) async {
    final doc = await _firestore.collection('scout_preferences').doc(scoutId).get();
    if (!doc.exists) return null;

    final data = doc.data() as Map<String, dynamic>;
    final filterData = data['lastSearchFilter'] as Map<String, dynamic>?;
    
    return filterData != null ? AthleteSearchFilter.fromMap(filterData) : null;
  }
}
