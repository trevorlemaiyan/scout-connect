import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/connection.dart';
import '../models/message.dart';

class ConnectionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Send connection request
  Future<bool> sendConnectionRequest(String receiverId, String receiverType) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      final connectionId = '${currentUser.uid}_$receiverId';
      
      // Check if connection already exists
      final existingConnection = await _firestore
          .collection('connections')
          .doc(connectionId)
          .get();

      if (existingConnection.exists) return false;

      // Create connection request
      final connection = Connection(
        id: connectionId,
        requesterId: currentUser.uid,
        receiverId: receiverId,
        requesterType: _getUserType(currentUser.uid),
        receiverType: receiverType == 'athlete' ? ConnectionType.athlete : ConnectionType.scout,
        status: ConnectionStatus.pending,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('connections').doc(connectionId).set(connection.toMap());

      // Create connection request message
      final messageId = _firestore.collection('messages').doc().id;
      final message = Message.connectionRequest(
        id: messageId,
        senderId: currentUser.uid,
        receiverId: receiverId,
        content: 'Would like to connect with you',
      );

      await _firestore.collection('messages').doc(messageId).set(message.toMap());

      return true;
    } catch (e) {
      return false;
    }
  }

  // Accept connection request
  Future<bool> acceptConnectionRequest(String connectionId) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      // Update connection status
      await _firestore.collection('connections').doc(connectionId).update({
        'status': 'accepted',
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });

      // Get connection details
      final connectionDoc = await _firestore.collection('connections').doc(connectionId).get();
      final connectionData = connectionDoc.data() as Map<String, dynamic>;
      final requesterId = connectionData['requesterId'] as String;

      // Create acceptance message
      final messageId = _firestore.collection('messages').doc().id;
      final message = Message.connectionAccepted(
        id: messageId,
        senderId: currentUser.uid,
        receiverId: requesterId,
      );

      await _firestore.collection('messages').doc(messageId).set(message.toMap());

      // Update connection counts for both users
      await _updateConnectionCount(currentUser.uid);
      await _updateConnectionCount(requesterId);

      return true;
    } catch (e) {
      return false;
    }
  }

  // Decline connection request
  Future<bool> declineConnectionRequest(String connectionId) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      // Get connection details
      final connectionDoc = await _firestore.collection('connections').doc(connectionId).get();
      final connectionData = connectionDoc.data() as Map<String, dynamic>;
      final requesterId = connectionData['requesterId'] as String;

      // Create decline message
      final messageId = _firestore.collection('messages').doc().id;
      final message = Message.connectionDeclined(
        id: messageId,
        senderId: currentUser.uid,
        receiverId: requesterId,
      );

      await _firestore.collection('messages').doc(messageId).set(message.toMap());

      // Delete connection request
      await _firestore.collection('connections').doc(connectionId).delete();

      return true;
    } catch (e) {
      return false;
    }
  }

  // Scout adds athlete to their players list
  Future<bool> addAthleteToScout(String athleteId) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      // Get scout data
      final scoutDoc = await _firestore.collection('users').doc(currentUser.uid).get();
      if (!scoutDoc.exists) return false;

      final scoutData = scoutDoc.data() as Map<String, dynamic>;
      final currentPlayers = List<String>.from(scoutData['discoveredAthletes'] ?? []);

      // Check if athlete is already added
      if (currentPlayers.contains(athleteId)) return false;

      // Add athlete to scout's players
      currentPlayers.add(athleteId);
      await _firestore.collection('users').doc(currentUser.uid).update({
        'discoveredAthletes': currentPlayers,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });

      // Mark athlete as scouted
      await _firestore.collection('users').doc(athleteId).update({
        'isScouted': true,
        'scoutedBy': FieldValue.arrayUnion([currentUser.uid]),
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  // Get user's connections
  Stream<List<Connection>> getUserConnections(String userId) {
    return _firestore
        .collection('connections')
        .where('requesterId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Connection.fromFirestore(data);
      }).toList();
    });
  }

  // Get connection requests for current user
  Stream<List<Connection>> getConnectionRequests() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return Stream.value([]);

    return _firestore
        .collection('connections')
        .where('receiverId', isEqualTo: currentUser.uid)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Connection.fromFirestore(data);
      }).toList();
    });
  }

  // Check if two users are connected
  Future<bool> areUsersConnected(String userId1, String userId2) async {
    final connectionId1 = '${userId1}_$userId2';
    final connectionId2 = '${userId2}_$userId1';

    final doc1 = await _firestore.collection('connections').doc(connectionId1).get();
    final doc2 = await _firestore.collection('connections').doc(connectionId2).get();

    return (doc1.exists || doc2.exists) && 
           (doc1.data()?['status'] == 'accepted' || doc2.data()?['status'] == 'accepted');
  }

  // Get connection count for a user
  Future<int> getConnectionCount(String userId) async {
    final connections = await _firestore
        .collection('connections')
        .where('requesterId', isEqualTo: userId)
        .where('status', isEqualTo: 'accepted')
        .get();

    return connections.docs.length;
  }

  // Update connection count for a user
  Future<void> _updateConnectionCount(String userId) async {
    final count = await getConnectionCount(userId);
    await _firestore.collection('users').doc(userId).update({
      'connectionCount': count,
      'updatedAt': Timestamp.fromDate(DateTime.now()),
    });
  }

  // Get user type (athlete or scout)
  ConnectionType _getUserType(String userId) {
    // This would typically come from user document
    // For now, we'll determine based on context or a separate field
    return ConnectionType.athlete; // Default, should be determined from user data
  }

  // Get scout's players (athletes they've added)
  Stream<List<String>> getScoutPlayers(String scoutId) {
    return _firestore
        .collection('users')
        .doc(scoutId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) return [];
      final data = snapshot.data() as Map<String, dynamic>;
      return List<String>.from(data['discoveredAthletes'] ?? []);
    });
  }

  // Get athletes who scouted a specific athlete
  Stream<List<String>> getAthleteScouts(String athleteId) {
    return _firestore
        .collection('users')
        .doc(athleteId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) return [];
      final data = snapshot.data() as Map<String, dynamic>;
      return List<String>.from(data['scoutedBy'] ?? []);
    });
  }
}
