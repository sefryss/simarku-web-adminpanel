import 'package:cloud_firestore/cloud_firestore.dart';

class RateUsModel {
  String id;
  String userId;
  String userName;
  double rating;

  RateUsModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.rating,
  });

  RateUsModel copyWith({
    String? id,
    String? userId,
    String? userName,
    double? rating,
  }) {
    return RateUsModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      rating: rating ?? this.rating,
    );
  }

  static RateUsModel empty() => RateUsModel(
        id: '',
        userId: '',
        userName: '',
        rating: 0,
      );

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'rating': rating,
    };
  }

  factory RateUsModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return RateUsModel(
        id: document.id,
        userId: data['userId'] ?? '',
        userName: data['userName'] ?? '',
        rating: data['rating']?.toDouble() ?? 0.0,
      );
    } else {
      throw Exception("Document data is null!");
    }
  }

  factory RateUsModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return RateUsModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      rating: data['rating']?.toDouble() ?? 0.0,
    );
  }
}
