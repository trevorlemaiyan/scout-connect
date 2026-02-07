import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class VideoService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Upload video from camera or gallery
  Future<String?> uploadVideo({
    required ImageSource source,
    String? customFileName,
  }) async {
    try {
      final picker = ImagePicker();
      final videoFile = await picker.pickVideo(source: source);

      if (videoFile == null) return null;

      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Create unique filename
      final fileName = customFileName ?? 
          '${user.uid}_${DateTime.now().millisecondsSinceEpoch}.mp4';
      
      // Upload to Firebase Storage
      final ref = _storage.ref().child('athlete_videos/${user.uid}/$fileName');
      
      final uploadTask = await ref.putFile(File(videoFile.path));
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      // Update athlete's video URLs in Firestore
      await _updateAthleteVideoUrls(downloadUrl);

      return downloadUrl;
    } catch (e) {
      print('Error uploading video: $e');
      return null;
    }
  }

  // Upload achievement image
  Future<String?> uploadAchievementImage({
    required ImageSource source,
    String? customFileName,
  }) async {
    try {
      final picker = ImagePicker();
      final imageFile = await picker.pickImage(source: source);

      if (imageFile == null) return null;

      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Create unique filename
      final fileName = customFileName ?? 
          '${user.uid}_achievement_${DateTime.now().millisecondsSinceEpoch}.jpg';
      
      // Upload to Firebase Storage
      final ref = _storage.ref().child('achievement_images/${user.uid}/$fileName');
      
      final uploadTask = await ref.putFile(File(imageFile.path));
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      // Update athlete's achievement images in Firestore
      await _updateAthleteAchievementImages(downloadUrl);

      return downloadUrl;
    } catch (e) {
      print('Error uploading achievement image: $e');
      return null;
    }
  }

  // Update athlete's video URLs in Firestore
  Future<void> _updateAthleteVideoUrls(String videoUrl) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final athleteDoc = await _firestore
        .collection('users')
        .doc(user.uid)
        .get();

    if (athleteDoc.exists) {
      final currentData = athleteDoc.data() as Map<String, dynamic>;
      final currentVideoUrls = List<String>.from(currentData['videoUrls'] ?? []);
      
      currentVideoUrls.add(videoUrl);

      await _firestore.collection('users').doc(user.uid).update({
        'videoUrls': currentVideoUrls,
        'updatedAt': Timestamp.now(),
      });
    }
  }

  // Update athlete's achievement images in Firestore
  Future<void> _updateAthleteAchievementImages(String imageUrl) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final athleteDoc = await _firestore
        .collection('users')
        .doc(user.uid)
        .get();

    if (athleteDoc.exists) {
      final currentData = athleteDoc.data() as Map<String, dynamic>;
      final currentImages = List<String>.from(currentData['achievementsImages'] ?? []);
      
      currentImages.add(imageUrl);

      await _firestore.collection('users').doc(user.uid).update({
        'achievementsImages': currentImages,
        'updatedAt': Timestamp.now(),
      });
    }
  }

  // Delete video
  Future<void> deleteVideo(String videoUrl) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Delete from Firebase Storage
      final ref = _storage.refFromURL(videoUrl);
      await ref.delete();

      // Remove from athlete's video URLs
      final athleteDoc = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      if (athleteDoc.exists) {
        final currentData = athleteDoc.data() as Map<String, dynamic>;
        final currentVideoUrls = List<String>.from(currentData['videoUrls'] ?? []);
        
        currentVideoUrls.remove(videoUrl);

        await _firestore.collection('users').doc(user.uid).update({
          'videoUrls': currentVideoUrls,
          'updatedAt': Timestamp.now(),
        });
      }
    } catch (e) {
      print('Error deleting video: $e');
    }
  }

  // Get video duration (placeholder for future implementation)
  Future<Duration?> getVideoDuration(String videoUrl) async {
    try {
      // TODO: Implement video duration extraction
      // This would require video processing library like video_player
      // For now, return a placeholder duration
      return const Duration(minutes: 5);
    } catch (e) {
      print('Error getting video duration: $e');
      return null;
    }
  }

  // Get video thumbnail (placeholder for future implementation)
  Future<String?> getVideoThumbnail(String videoUrl) async {
    // This would require video processing library
    // For now, return a placeholder or null
    return null;
  }

  // Stream of athlete's videos
  Stream<List<String>> getAthleteVideosStream(String athleteId) {
    return _firestore
        .collection('users')
        .doc(athleteId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) return [];
      final data = snapshot.data() as Map<String, dynamic>;
      return List<String>.from(data['videoUrls'] ?? []);
    });
  }

  // Stream of athlete's achievement images
  Stream<List<String>> getAthleteAchievementImagesStream(String athleteId) {
    return _firestore
        .collection('users')
        .doc(athleteId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) return [];
      final data = snapshot.data() as Map<String, dynamic>;
      return List<String>.from(data['achievementsImages'] ?? []);
    });
  }
}
