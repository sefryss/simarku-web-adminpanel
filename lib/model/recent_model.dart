import 'package:cloud_firestore/cloud_firestore.dart';

import '../controller/data/key_table.dart';

class RecentModel{


  
  String? id="";
  String? storyId="";
  int? index=1;

  
  
  RecentModel({this.id,this.storyId,this.index,});

  factory RecentModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return RecentModel(
      id: doc.id,
      storyId: data[KeyTable.storyId],
      index: data['index'],
    );
  }

  factory RecentModel.fromJson(Map<String, dynamic> data) {
    return RecentModel(
      storyId: data[KeyTable.storyId],
      index: data['index'],
    );
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[KeyTable.storyId] = this.storyId;
    data['index'] = this.index;
    return data;
  }


}