import 'package:cloud_firestore/cloud_firestore.dart';

class KegiatanLiterasiModel {
  String? title;
  String? id;
  String? image;
  String? source;
  String? date;
  String? desc;
  String? url;

  int? index;
  bool? isActive;

  KegiatanLiterasiModel({
    this.title,
    this.id,
    this.image,
    this.source,
    this.date,
    this.desc,
    this.url,
    this.index = 1,
    this.isActive = true,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = this.title;
    data['id'] = this.id;
    data['image'] = this.image;
    data['source'] = this.source;
    data['date'] = this.date;
    data['desc'] = this.desc;
    data['url'] = this.url;
    data['index'] = this.index;
    data['is_active'] = this.isActive;
    return data;
  }

  factory KegiatanLiterasiModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return KegiatanLiterasiModel(
      id: doc.id,
      title: data['title'] ?? '',
      image: data['image'] ?? '',
      source: data['source'] ?? '',
      date: data['date'] ?? '',
      desc: data['desc'] ?? '',
      url: data['url'] ?? '',
      index: data['index'] ?? 0,
      isActive: data['is_active'] ?? false,
    );
  }
}
