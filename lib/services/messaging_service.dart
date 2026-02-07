import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/message.dart';
import 'connection_service.dart';

class MessagingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Send text message
  Future<bool> sendTextMessage(String receiverId, String content) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      // Check if users are connected
      final connectionService = ConnectionService();
      final areConnected = await connectionService.areUsersConnected(currentUser.uid, receiverId);
      if (!areConnected) return false;

      final messageId = _firestore.collection('messages').doc().id;
      final message = Message(
        id: messageId,
        senderId: currentUser.uid,
        receiverId: receiverId,
        type: MessageType.text,
        status: MessageStatus.sent,
        content: content,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('messages').doc(messageId).set(message.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  // Send media message (image/video)
  Future<bool> sendMediaMessage(String receiverId, String content, String mediaUrl, MessageType type) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      // Check if users are connected
      final connectionService = ConnectionService();
      final areConnected = await connectionService.areUsersConnected(currentUser.uid, receiverId);
      if (!areConnected) return false;

      final messageId = _firestore.collection('messages').doc().id;
      final message = Message(
        id: messageId,
        senderId: currentUser.uid,
        receiverId: receiverId,
        type: type,
        status: MessageStatus.sent,
        content: content,
        mediaUrl: mediaUrl,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('messages').doc(messageId).set(message.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get conversation between two users
  Stream<List<Message>> getConversation(String userId1, String userId2) {
    return _firestore
        .collection('messages')
        .where('senderId', whereIn: [userId1, userId2])
        .where('receiverId', whereIn: [userId1, userId2])
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Message.fromFirestore(data);
      }).toList();
    });
  }

  // Get all conversations for current user
  Stream<List<Map<String, dynamic>>> getUserConversations() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return Stream.value([]);

    return _firestore
        .collection('messages')
        .where('senderId', isEqualTo: currentUser.uid)
        .snapshots()
        .asyncMap((snapshot) async {
      final conversations = <String, Map<String, dynamic>>{};
      final processedUsers = <String>{};

      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final otherUserId = data['receiverId'] as String;
        
        if (!processedUsers.contains(otherUserId)) {
          processedUsers.add(otherUserId);
          
          // Get other user's info
          final userDoc = await _firestore.collection('users').doc(otherUserId).get();
          final userData = userDoc.data() as Map<String, dynamic>?;
          
          // Get last message
          final lastMessageDoc = await _firestore
              .collection('messages')
              .where('senderId', whereIn: [currentUser.uid, otherUserId])
              .where('receiverId', whereIn: [currentUser.uid, otherUserId])
              .orderBy('createdAt', descending: true)
              .limit(1)
              .get();
          
          final lastMessage = lastMessageDoc.docs.isNotEmpty
              ? Message.fromFirestore(lastMessageDoc.docs.first.data() as Map<String, dynamic>)
              : null;

          conversations[otherUserId] = {
            'userId': otherUserId,
            'userData': userData,
            'lastMessage': lastMessage,
            'unreadCount': await _getUnreadCount(currentUser.uid, otherUserId),
          };
        }
      }
      
      return conversations.values.toList();
    });
  }

  // Mark messages as read
  Future<void> markMessagesAsRead(String otherUserId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    final unreadMessages = await _firestore
        .collection('messages')
        .where('senderId', isEqualTo: otherUserId)
        .where('receiverId', isEqualTo: currentUser.uid)
        .where('status', isEqualTo: 'sent')
        .get();

    final batch = _firestore.batch();
    for (final doc in unreadMessages.docs) {
      batch.update(doc.reference, {
        'status': 'read',
        'readAt': Timestamp.fromDate(DateTime.now()),
      });
    }
    
    await batch.commit();
  }

  // Get unread message count
  Future<int> _getUnreadCount(String userId1, String userId2) async {
    final unreadMessages = await _firestore
        .collection('messages')
        .where('senderId', isEqualTo: userId2)
        .where('receiverId', isEqualTo: userId1)
        .where('status', isEqualTo: 'sent')
        .get();

    return unreadMessages.docs.length;
  }

  // Delete message
  Future<bool> deleteMessage(String messageId) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      final messageDoc = await _firestore.collection('messages').doc(messageId).get();
      if (!messageDoc.exists) return false;

      final messageData = messageDoc.data() as Map<String, dynamic>;
      final senderId = messageData['senderId'] as String;
      final receiverId = messageData['receiverId'] as String;

      // Only allow sender or receiver to delete
      if (senderId == currentUser.uid || receiverId == currentUser.uid) {
        await _firestore.collection('messages').doc(messageId).delete();
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  // Get unread messages count for current user
  Stream<int> getUnreadMessagesCount() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return Stream.value(0);

    return _firestore
        .collection('messages')
        .where('receiverId', isEqualTo: currentUser.uid)
        .where('status', isEqualTo: 'sent')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}
