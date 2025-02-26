import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String message;
  final DateTime createdAt;

  Message({required this.id, required this.message, required this.createdAt});

  factory Message.fromJson(QueryDocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Message(
      id: data['id'] ?? 'Unknown', // ✅ Default value
      message: data['message'] ?? '', // ✅ Default value
      createdAt:
          (data['createdAt'] as Timestamp?)?.toDate() ??
          DateTime.now(), // ✅ Handle null timestamps
    );
  }
}
