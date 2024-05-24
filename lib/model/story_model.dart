import 'package:cloud_firestore/cloud_firestore.dart';

enum BookType { BukuFisik, EBook } // 1. Added enum for book type

enum Category { TukarPinjam, TukarMilik, BebasBaca }

class StoryModel {
  String? name = "";
  String? author = "";
  List ? ownerId;
  String? page = "";
  String? publisher = "";
  String? releaseDate = "";
  String? image = "";
  String? pdf = "";
  String? desc = "";
  String? date = "";
  String? id = "";
  String? refId = '';
  List? genreId;
  int? index = 1;
  int? views = 1;
  bool? isBookmark = false;
  bool? isFav = false;
  bool? isActive = true;
  bool? isPopular = true;
  bool? isFeatured = true;
  bool? isAvailable = true;
  BookType? bookType;
  Category? category;

  StoryModel({
    this.author,
    this.releaseDate,
    this.page,
    this.ownerId,
    this.publisher,
    this.isAvailable,
    this.isPopular,
    this.isFeatured,
    this.genreId,
    this.pdf,
    this.id,
    this.name,
    this.image,
    this.refId,
    this.desc,
    this.index,
    this.isActive,
    this.views,
    this.date,
    this.isBookmark,
    this.isFav,
    this.bookType,
    this.category,
  });

  factory StoryModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;

    return StoryModel(
      id: doc.id,
      name: data['name'] ?? '',
      author: data['author'] ?? '',
      ownerId: data['owner_id'] ?? '',
      page: data['page'] ?? '',
      releaseDate: data['release_date'] ?? '',
      publisher: data['publisher'] ?? '',
      isAvailable: data['is_available'] ?? false,
      image: data['image'] ?? '',
      refId: data['refId'] ?? '',
      desc: data['desc'] ?? '',
      index: data['index'] ?? 0,
      isActive: data['is_active'] ?? false,
      date: data['date'] ?? '',
      genreId: data['genre_id'] ?? '',
      views: data['views'] ?? 0,
      pdf: data['pdf'] ?? '',
      isBookmark: data['is_bookmark'] ?? false,
      isFav: data['is_favourite'] ?? false,
      isPopular: data['is_popular'] ?? false,
      isFeatured: data['is_featured'] ?? false,
      bookType: data['book_type'] != null
          ? BookType.values.byName(data['book_type'])
          : null,
      category: data['category'] != null
          ? Category.values.byName(data['category'])
          : null,
    );
  }

  factory StoryModel.fromJson(Map<String, dynamic> data) {
    return StoryModel(
      image: data['image'],
      name: data['name'],
      author: data['author'],
      ownerId: data['owner_id'],
      page: data['page'],
      publisher: data['publisher'],
      releaseDate: data['release_date'],
      refId: data['refId'],
      index: data['index'],
      views: data['views'],
      desc: data['desc'],
      isActive: data['is_active'],
      date: data['date'],
      genreId: data['genre_id'],
      isBookmark: data['is_bookmark'],
      pdf: data['pdf'],
      isFav: data['is_favourite'],
      isPopular: data['is_popular'],
      isFeatured: data['is_featured'],
      isAvailable: data['is_active'],
      bookType: data['book_type'] != null
          ? BookType.values.byName(data['book_type'])
          : null,
      category: data['category'] != null
          ? Category.values.byName(data['category'])
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
    data['date'] = this.date;
    data['genre_id'] = this.genreId;
    data['views'] = this.views;
    data['is_bookmark'] = this.isBookmark;
    data['is_favourite'] = this.isFav;
    data['is_popular'] = this.isPopular;
    data['is_featured'] = this.isFeatured;
    data['is_available'] = this.isAvailable;
    data['pdf'] = this.pdf;
    data['book_type'] =
        this.bookType != null ? this.bookType.toString().split('.').last : null;
    data['category'] =
        this.category != null ? this.category.toString().split('.').last : null;

    return data;
  }
}
