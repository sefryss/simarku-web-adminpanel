import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackModel {
 String id;
 String userId;
 String userName;
 String feedback;

  FeedbackModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.feedback,
  });

  FeedbackModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? feedback,
  }) {
    return FeedbackModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      feedback: feedback ?? this.feedback,
    );
  }

  static FeedbackModel empty() => FeedbackModel(
        id: '',
        userId: '',
        userName: '',
        feedback: '',
      );

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'feedback': feedback,
    };
  }

  factory FeedbackModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return FeedbackModel(
        id: document.id,
        userId: data['userId'] ?? '',
        userName: data['userName'] ?? '',
        feedback: data['feedback'] ?? '',
      );
    } else {
      throw Exception("Document data is null!");
    }
  }

  factory FeedbackModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return FeedbackModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      feedback: data['feedback'] ?? '',
    );
  }
}
