import 'package:cloud_firestore/cloud_firestore.dart';

class TukarMilikModel {
  String id;
  String senderId;
  String receiverId;
  String senderBookId;
  String receiverBookId;
  String status; // Pending, Accepted, Rejected
  Timestamp timestamp;

  TukarMilikModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.senderBookId,
    required this.receiverBookId,
    required this.status,
    required this.timestamp,
  });

  factory TukarMilikModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return TukarMilikModel(
      id: doc.id,
      senderId: data['senderId'] ?? '',
      receiverId: data['receiverId'] ?? '',
      senderBookId: data['senderBookId'] ?? '',
      receiverBookId: data['receiverBookId'] ?? '',
      status: data['status'] ?? '',
      timestamp: data['timestamp'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'senderBookId': senderBookId,
      'receiverBookId': receiverBookId,
      'status': status,
      'timestamp': timestamp,
    };
  }
}
