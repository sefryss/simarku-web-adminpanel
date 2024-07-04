import 'package:cloud_firestore/cloud_firestore.dart';


class TukarPinjamModel {
  String id;
  String senderId;
  String receiverId;
  String senderBookId;
  String receiverBookId;
  String status;
  String loanDuration; // Field for loan duration
  Timestamp timestamp;
   Timestamp loanEndTime;

  TukarPinjamModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.senderBookId,
    required this.receiverBookId,
    required this.status,
    required this.loanDuration,
    required this.timestamp,
      required  this.loanEndTime,
  });

  factory TukarPinjamModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TukarPinjamModel(
      id: doc.id,
      senderId: data['senderId'],
      receiverId: data['receiverId'],
      senderBookId: data['senderBookId'],
      receiverBookId: data['receiverBookId'],
      status: data['status'],
      loanDuration: data['loanDuration'],
      timestamp: data['timestamp'],
            loanEndTime: data['loan_end_time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'senderBookId': senderBookId,
      'receiverBookId': receiverBookId,
      'status': status,
      'loanDuration': loanDuration,
      'timestamp': timestamp,
            'loan_end_time': loanEndTime,
    };
  }
}
