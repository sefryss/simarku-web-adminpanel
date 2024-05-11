import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel{

  String? name="";
  String? image="";
  String? id="";

  int? refId=1;

  CategoryModel({this.id,this.name,this.image,this.refId,});

  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return CategoryModel(
      id: doc.id,
      name: data['name']??'',
      image: data['image']??'',
      refId: data['refId']??0,
    );
  }

  factory CategoryModel.fromJson(Map<String, dynamic> data) {



    return CategoryModel(

      image: data['image'],
      name: data['name'],
      refId: data['refId'],


    );


  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['image'] = this.image;
    data['refId'] = this.refId;
    return data;
  }


}