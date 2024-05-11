


import 'package:cloud_firestore/cloud_firestore.dart';

class AdminModel {
  String? username;
  String? deviceId;
  bool? isAccess;
  String? password;
  String? id;
  String? uid;
  bool isAdmin= false;


  AdminModel({this.username,this.uid,this.id,required this.isAdmin,this.deviceId,this.isAccess,this.password});

  factory AdminModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;

    print("dat===$data");

    return AdminModel(
      id:doc.id,
      uid: data['_uid'],
      deviceId: data['device_id'],
      isAccess: data['isAccess'],
      isAdmin: data['is_admin'],
      username: data['username'],
      password: data['password'],
    );
  }


  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //
  //
  //
  //   data['device_id'] = this.deviceId;
  //   data['isAccess'] = this.isAccess;
  //   return data;
  // }

}
