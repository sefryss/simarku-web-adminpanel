import 'package:cloud_firestore/cloud_firestore.dart';

class Genre {
  String? genre;
  String? id;
  int? refId=1;

  int? index = 1;
  bool? isActive = true;

  Genre({
    this.genre,
    this.id,
    this.refId,
    this.index,
    this.isActive,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['genre'] = this.genre;
    data['refId'] = this.refId;
    data['index'] = this.index;
    data['is_active'] = this.isActive;

    return data;
  }

  factory Genre.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Genre(
      id: doc.id,
      genre: data['genre'] ?? '',
      refId: data['refId'] ?? 0,
      index: data['index'] ?? 0,
      isActive: data['is_active'] ?? false,
    );
  }
}
