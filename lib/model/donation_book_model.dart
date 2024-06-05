import 'package:cloud_firestore/cloud_firestore.dart';

enum DonationBookType { physicalBook, ebook }

class DonationBookModel {
  String? name = "";
  String? author = "";
  List? ownerId;
  String? page = "";
  String? publisher = "";
  String? releaseDate = "";
  String? image = "";
  String? pdf = "";
  String? desc = "";
  String? id = "";
  String? refId = '';
  List? genreId;
  int? index = 1;
  bool? isActive = true;
  DonationBookType? bookType;

  DonationBookModel({
    this.author,
    this.releaseDate,
    this.page,
    this.ownerId,
    this.publisher,
    this.genreId,
    this.pdf,
    this.id,
    this.name,
    this.image,
    this.refId,
    this.desc,
    this.index,
    this.isActive,
    this.bookType,
  });

  factory DonationBookModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;

    return DonationBookModel(
      id: doc.id,
      name: data['name'] ?? '',
      author: data['author'] ?? '',
      ownerId: data['owner_id'] ?? '',
      page: data['page'] ?? '',
      releaseDate: data['release_date'] ?? '',
      publisher: data['publisher'] ?? '',
      image: data['image'] ?? '',
      refId: data['refId'] ?? '',
      desc: data['desc'] ?? '',
      index: data['index'] ?? 0,
      isActive: data['is_active'] ?? false,
      genreId: data['genre_id'] ?? '',
      pdf: data['pdf'] ?? '',
      bookType: data['book_type'] != null
          ? DonationBookType.values.firstWhere(
              (e) => getDonationBookTypeString(e) == data['book_type'])
          : null,
    );
  }

  factory DonationBookModel.fromJson(Map<String, dynamic> data) {
    return DonationBookModel(
      image: data['image'],
      name: data['name'],
      author: data['author'],
      ownerId: data['owner_id'],
      page: data['page'],
      publisher: data['publisher'],
      releaseDate: data['release_date'],
      refId: data['refId'],
      index: data['index'],
      desc: data['desc'],
      isActive: data['is_active'],
      genreId: data['genre_id'],
      pdf: data['pdf'],
      bookType: data['book_type'] != null
          ? DonationBookType.values.firstWhere(
              (e) => getDonationBookTypeString(e) == data['book_type'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['author'] = this.author;
    data['owner_id'] = this.ownerId;
    data['page'] = this.page;
    data['publisher'] = this.publisher;
    data['release_date'] = this.releaseDate;
    data['image'] = this.image;
    data['refId'] = this.refId;
    data['desc'] = this.desc;
    data['index'] = this.index;
    data['is_active'] = this.isActive;
    data['genre_id'] = this.genreId;

    data['pdf'] = this.pdf;
    data['book_type'] = this.bookType != null
        ? getDonationBookTypeString(this.bookType!)
        : null;
    return data;
  }
}

String getDonationBookTypeString(DonationBookType bookType) {
  switch (bookType) {
    case DonationBookType.physicalBook:
      return 'Buku Fisik';
    case DonationBookType.ebook:
      return 'E-Book';
    default:
      return '';
  }
}
