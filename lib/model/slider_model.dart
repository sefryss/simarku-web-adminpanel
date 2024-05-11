import 'package:cloud_firestore/cloud_firestore.dart';

import '../controller/data/key_table.dart';

class SliderModel{

  String? id="";
  String? storyId="";
  String? image="";
  String? customImg="";
  String? link="";
  int? index=1;
  String? color="";

  SliderModel({this.customImg,this.id,this.storyId,this.index,this.image,this.link,this.color});

  factory SliderModel.fromFirestore(DocumentSnapshot doc) {

    Map data = doc.data() as Map;

    return SliderModel(
      id: doc.id,
      storyId: data[KeyTable.storyId] ??'',
      image: data['image'] ?? '',
      customImg: data['custom_img'] ?? '',
      link: data['link'] ?? '',
      index: data['index']??0,
      color: data['color']??'',
    );

  }

  factory SliderModel.fromJson(Map<String, dynamic> data) {

    return SliderModel(
      storyId: data[KeyTable.storyId],
      index: data['index'],
      image: data['image'],
      link: data['link'],
      customImg: data['custom_img'],
      color: data['color'],
    );
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[KeyTable.storyId] = this.storyId;
    data['index'] = this.index;
    data['image'] = this.image;
    data['custom_img'] = this.customImg;
    data['link'] = this.link;
    data['color'] = this.color;
    return data;
  }


}