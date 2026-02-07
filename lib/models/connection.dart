import 'package:cloud_firestore/cloud_firestore.dart';

enum ConnectionStatus {
  pending,
  accepted,
  declined,
}

enum ConnectionType {
  athlete,
  scout,
}

class Connection {
  final String id;
  final String requesterId;
  final String receiverId;
  final ConnectionType requesterType;
  final ConnectionType receiverType;
  final ConnectionStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Connection({
    required this.id,
    required this.requesterId,
    required this.receiverId,
    required this.requesterType,
    required this.receiverType,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  // Create Connection from Firestore
  factory Connection.fromFirestore(Map<String, dynamic> data) {
    return Connection(
      id: data['id'] ?? '',
      requesterId: data['requesterId'] ?? '',
      receiverId: data['receiverId'] ?? '',
      requesterType: ConnectionType.values.firstWhere(
        (e) => e.toString() == 'ConnectionType.${data['requesterType']}',
        orElse: () => ConnectionType.athlete,
      ),
      receiverType: ConnectionType.values.firstWhere(
        (e) => e.toString() == 'ConnectionType.${data['receiverType']}',
        orElse: () => ConnectionType.athlete,
      ),
      status: ConnectionStatus.values.firstWhere(
        (e) => e.toString() == 'ConnectionStatus.${data['status']}',
        orElse: () => ConnectionStatus.pending,
      ),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'requesterId': requesterId,
      'receiverId': receiverId,
      'requesterType': requesterType.toString().split('.').last,
      'receiverType': receiverType.toString().split('.').last,
      'status': status.toString().split('.').last,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  // Copy with updated status
  Connection copyWith({
    String? id,
    String? requesterId,
    String? receiverId,
    ConnectionType? requesterType,
    ConnectionType? receiverType,
    ConnectionStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Connection(
      id: id ?? this.id,
      requesterId: requesterId ?? this.requesterId,
      receiverId: receiverId ?? this.receiverId,
      requesterType: requesterType ?? this.requesterType,
      receiverType: receiverType ?? this.receiverType,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
