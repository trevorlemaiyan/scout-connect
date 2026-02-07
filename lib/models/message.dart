import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType {
  text,
  image,
  video,
  connectionRequest,
  connectionAccepted,
  connectionDeclined,
}

enum MessageStatus {
  sent,
  delivered,
  read,
}

class Message {
  final String id;
  final String senderId;
  final String receiverId;
  final MessageType type;
  final MessageStatus status;
  final String content;
  final String? mediaUrl;
  final DateTime createdAt;
  final DateTime? readAt;
  final Map<String, dynamic>? metadata; // For connection requests, etc.

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.type,
    required this.status,
    required this.content,
    this.mediaUrl,
    required this.createdAt,
    this.readAt,
    this.metadata,
  });

  // Create Message from Firestore
  factory Message.fromFirestore(Map<String, dynamic> data) {
    return Message(
      id: data['id'] ?? '',
      senderId: data['senderId'] ?? '',
      receiverId: data['receiverId'] ?? '',
      type: MessageType.values.firstWhere(
        (e) => e.toString() == 'MessageType.${data['type']}',
        orElse: () => MessageType.text,
      ),
      status: MessageStatus.values.firstWhere(
        (e) => e.toString() == 'MessageStatus.${data['status']}',
        orElse: () => MessageStatus.sent,
      ),
      content: data['content'] ?? '',
      mediaUrl: data['mediaUrl'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      readAt: (data['readAt'] as Timestamp?)?.toDate(),
      metadata: data['metadata'],
    );
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'type': type.toString().split('.').last,
      'status': status.toString().split('.').last,
      'content': content,
      'mediaUrl': mediaUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'readAt': readAt != null ? Timestamp.fromDate(readAt!) : null,
      'metadata': metadata,
    };
  }

  // Create connection request message
  factory Message.connectionRequest({
    required String id,
    required String senderId,
    required String receiverId,
    required String content,
  }) {
    return Message(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      type: MessageType.connectionRequest,
      status: MessageStatus.sent,
      content: content,
      createdAt: DateTime.now(),
      metadata: {
        'isConnectionRequest': true,
        'requiresAction': true,
      },
    );
  }

  // Create connection accepted message
  factory Message.connectionAccepted({
    required String id,
    required String senderId,
    required String receiverId,
  }) {
    return Message(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      type: MessageType.connectionAccepted,
      status: MessageStatus.sent,
      content: 'Connection request accepted',
      createdAt: DateTime.now(),
      metadata: {
        'isConnectionUpdate': true,
        'action': 'accepted',
      },
    );
  }

  // Create connection declined message
  factory Message.connectionDeclined({
    required String id,
    required String senderId,
    required String receiverId,
  }) {
    return Message(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      type: MessageType.connectionDeclined,
      status: MessageStatus.sent,
      content: 'Connection request declined',
      createdAt: DateTime.now(),
      metadata: {
        'isConnectionUpdate': true,
        'action': 'declined',
      },
    );
  }
}
