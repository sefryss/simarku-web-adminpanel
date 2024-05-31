import 'package:cloud_firestore/cloud_firestore.dart';

class SekilasInfoModel {
  String? title;
  String? id;
  String? image;
  String? author;
  String? date;
  String? desc;
  String? source;

  int? index;
  bool? isFav;
  bool? isActive;

  SekilasInfoModel({
    this.title,
    this.id,
    this.image,
    this.author,
    this.date,
    this.desc,
    this.source,
    this.index = 1,
    this.isFav = false,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = this.title;
    data['id'] = this.id;
    data['image'] = this.image;
    data['author'] = this.author;
    data['date'] = this.date;
    data['desc'] = this.desc;
    data['source'] = this.source;
    data['index'] = this.index;
    data['is_fav'] = this.isFav;
    data['is_active'] = this.isActive;
    return data;
  }

  factory SekilasInfoModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return SekilasInfoModel(
      id: doc.id,
      title: data['title'] ?? '',
      image: data['image'] ?? '',
      author: data['author'] ?? '',
      date: data['date'] ?? '',
      desc: data['desc'] ?? '',
      source: data['source'] ?? '',
      index: data['index'] ?? 0,
      isFav: data['is_fav'] ?? false,
      isActive: data['is_active'] ?? false,
    );
  }
}
