import 'package:cloud_firestore/cloud_firestore.dart';

class TopAuthors{
   String? image;
   String? authorName;
   String? id;
   String? desc;
   String? refId;
   String? designation;
   String? faceUrl;
   String? instUrl;
   String? twitUrl;
   String? youUrl;
   String? webUrl;

   int? index;
   bool? isActive=true;

  TopAuthors({this.webUrl,this.youUrl,this.twitUrl,this.instUrl,this.faceUrl,this.image,  this.authorName,this.id,this.desc,this.refId,this.designation,this.index,this.isActive});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['image'] = this.image;
    data['authorName'] = this.authorName;
    data['desc'] = this.desc;
    data['refId'] = this.refId;
    data['designation'] = this.designation;
    data['index'] = this.index;
    data['facebook_url'] = this.faceUrl;
    data['instagram_url'] = this.instUrl;
    data['twitter_url'] = this.twitUrl;
    data['youtube_url'] = this.youUrl;
    data['website_url'] = this.webUrl;
    data['is_active'] = this.isActive;

  return data;
  }


   factory TopAuthors.fromFirestore(DocumentSnapshot doc) {
     Map data = doc.data() as Map;
     return TopAuthors(
       id: doc.id,
       image: data['image'],
       authorName: data['authorName'],
       desc: data['desc'],
       refId: data['refId'],
       designation: data['designation'],
       index: data['index'],
       faceUrl: data['facebook_url'],
       instUrl: data['instagram_url'],
       twitUrl: data['twitter_url'],
       youUrl: data['youtube_url'],
       webUrl: data['website_url'],
       isActive: data['is_active']??false,
     );
   }

}

