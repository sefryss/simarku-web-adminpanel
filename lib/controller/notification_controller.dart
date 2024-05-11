import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ebookadminpanel/model/story_model.dart';
import '../ui/common/common.dart';
import '../util/constants.dart';



class NotificationController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController messageController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController linkController = TextEditingController();

  RxBool isImageOffline = false.obs;

  StoryModel? storyModel;
  RxBool isLoading = false.obs;
  RxBool isDataLoading = false.obs;

  String oldCategory = '';
  Uint8List webImage = Uint8List(10);

  RxString story = "".obs;


  NotificationController({this.storyModel});



  @override
  void onInit() {
    super.onInit();

  }

  clearAllData(){
    nameController.text = "";
    messageController.text = "";
    imageController.text = "";
    linkController.text = "";

    pickImage = null;


    isImageOffline = false.obs;

    storyModel = null;
    isLoading = false.obs;
    isDataLoading = false.obs;

    oldCategory = '';
    webImage = Uint8List(10);
  }


  // void sendPushMessage(String body,String title,String token) async {
  //   try {
  //
  //   final response = await http.post(
  //       Uri.parse('https://fcm.googleapis.com/v1/projects/com.example.ebook_appadminpanel/messages:send HTTP/1.1'),
  //       // Uri.parse('https://fcm.googleapis.com/v1/{parent=com.example.ebook_appadminpanel}/messages:send'),
  //       // Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //       // Uri.parse('https://api.rnfirebase.io/messaging/send'),
  //
  //       // headers: {
  //       //   // HttpHeaders.contentTypeHeader: 'application/json',
  //       //   HttpHeaders.acceptHeader: 'application/json',
  //       //   HttpHeaders.authorizationHeader: 'Bearer AAAAehi1tLY:APA91bGRyPlbh487gV_wca0CSydme8Kqula6OoPEtUOfvbRzXiFUqUNki3a0DUOq9d4h5vp7-0-nrSY7PGVdJb6KZtgV0FpfQaHUbANUfalHTrlBiD0jXwWgHqBXbtELybakRL2NEnt1',
  //       // },
  //
  //       body:
  //       <String,dynamic>{
  //         "collapse_key": "string",
  //         "priority": 'high',
  //         "restricted_package_name": "com.example.ebook_appadminpanel",
  //         "data": {
  //
  //         },
  //         "notification": {
  //
  //         },
  //         "fcm_options": {
  //
  //         },
  //         "direct_boot_ok": true
  //       }
  //
  //
  //     // body: [
  //     //   {
  //     //   "name": title,
  //     //   "data": {
  //     //
  //     //   },
  //     //   "notification": {
  //     //     "title":"FCM Message",
  //     //     "body":"This is an FCM notification message!"
  //     //   },
  //     //   // Union field target can be only one of the following:
  //     //   "token": token,
  //     //   "topic": body,
  //     //   "condition": "string"
  //     //   // End of list of possible types for union field target.
  //     // }]
  //
  //     // body: jsonEncode({
  //     //   "message":{
  //     //     "token":token,
  //     //     "notification":{
  //     //       "title":"FCM Message",
  //     //       "body":"This is an FCM notification message!"
  //     //     }
  //     //   }
  //     // })
  //
  //     // body: jsonEncode({
  //     //   'priority' : 'high',
  //     //   'data': {
  //     //     'body' : body,
  //     //     'title' : title,
  //     //     'click_action' : 'FLUTTER_NOTIFICATION_CLICK',
  //     //     'status' : 'done',
  //     //   },
  //     //   // {
  //     //   'notification': {
  //     //     'title': title,
  //     //     'body': body,
  //     //   },
  //     //   'to' : token
  //     // }),
  //     //
  //   );
  //
  //   print("response-------${response.statusCode}");
  //
  //   if(response.statusCode == 200){
  //     print("body----------${response.body}");
  //   }else{
  //     print("body--------${response.statusCode}");
  //   }
  //
  //
  //
  //   // print('FCM request for device sent!');
  //    } catch (e) {
  //   print("error--------$e");
  // }
  // }


  Future<bool> sendFcmMessage(BuildContext context,String title, String message,String token,String imageUrl) async {
    // print("image----${image}");




    print("url--------${imageUrl}");

    try {

      var url = 'https://fcm.googleapis.com/fcm/send';
      var header = {
        "Content-Type": "application/json",
        "Authorization": Constants.serverKey
      };
      var request =
      {
        "notification": {
          "title": title,
          "body" : message,
          "text": "${message}",
          "image": imageUrl,
          "click_action": "",
          // "click_action": (linkController.text.isNotEmpty)?"FLUTTER_NOTIFICATION_CLICK":"",
          // "link": linkController.text
          // "image": image,
          // "imageUrl": "https://media.istockphoto.com/id/1350993173/photo/winding-coast-road-in-corsica.jpg?s=612x612&w=is&k=20&c=D7sRuENZ3q5oztuqI80bR8-Am0zla1Ax6hdleiG7PgE="

          // "sound": "default",
          // "color": "#990000",
        },
        "pushNotifications":{
          "foreground": true,
        },

        // "android":{
        //   "notification": {
        //     "imageUrl": "https://media.istockphoto.com/id/1350993173/photo/winding-coast-road-in-corsica.jpg?s=612x612&w=is&k=20&c=D7sRuENZ3q5oztuqI80bR8-Am0zla1Ax6hdleiG7PgE="
        //     // "sound": "default",
        //     // "color": "#990000",
        //   },
        // },
        "data":{
          "link" : linkController.text,
        },
        "priority": "high",
        "to": token,
        "mutable-content": true,
        // "to": "d2NW0tA1R1u1EO53tbEMsv:APA91bFTJII4gYbAjskd8DkwBBiKG_CeP0sVVTemoILuW_ksj6L3A4IzpA1uXjmaarvkMpE4NhrNqj6LSjyS_rcUKDOTgVByxSLaSghbVJNcTN0caCH5tTMoi-miaZJb5ZdhSqXnCIOl",

      };

      var client = new Client();
      var response =
      await client.post(Uri.parse(url), headers: header, body: json.encode(request));

      print("res--${response.body}");
      return true;
    } catch (e) {
      print(e);
      return false;
    }

  }

  Future<bool> sendFcmMessageWihStory(BuildContext context,String token,StoryModel storyModel) async {
    String desc1 = removeAllHtmlTags(decode(storyModel.desc!));


    String desc = desc1;

    if(desc.length > 200){
      desc = desc1.substring(0,200);
    }

    try {

      var url = 'https://fcm.googleapis.com/fcm/send';
      var header = {
        "Content-Type": "application/json",
        "Authorization": Constants.serverKey,
      };
      var request =
      {
        "notification": {
          "title": storyModel.name,
          "body" : desc,
          "text": desc,
          "image": storyModel.image,
          "click_action":"",
          // "link": linkController.text,

          // "image": image,
          // "imageUrl": "https://media.istockphoto.com/id/1350993173/photo/winding-coast-road-in-corsica.jpg?s=612x612&w=is&k=20&c=D7sRuENZ3q5oztuqI80bR8-Am0zla1Ax6hdleiG7PgE="

          // "sound": "default",
          // "color": "#990000",
        },
        "pushNotifications":{
          "foreground": true,
        },
        // "android":{
        //   "notification": {
        //     "imageUrl": "https://media.istockphoto.com/id/1350993173/photo/winding-coast-road-in-corsica.jpg?s=612x612&w=is&k=20&c=D7sRuENZ3q5oztuqI80bR8-Am0zla1Ax6hdleiG7PgE="
        //     // "sound": "default",
        //     // "color": "#990000",
        //   },
        // },
        "data":{
          "story_id" : storyModel.id,
          "link" : linkController.text,
        },
        "priority": "high",
        "to": token,
        "mutable-content": true,
        // "to": "d2NW0tA1R1u1EO53tbEMsv:APA91bFTJII4gYbAjskd8DkwBBiKG_CeP0sVVTemoILuW_ksj6L3A4IzpA1uXjmaarvkMpE4NhrNqj6LSjyS_rcUKDOTgVByxSLaSghbVJNcTN0caCH5tTMoi-miaZJb5ZdhSqXnCIOl",


      };

      var client = new Client();
      var response =
      await client.post(Uri.parse(url), headers: header, body: json.encode(request));

      print("res--${response.body}");
      return true;
    } catch (e) {

      showCustomToast(context: context, message: e.toString());
      print(e);
      return false;
    }

  }




  // void sendPushMessage(String body,String title,String? token) async {
  //   // if (token == null) {
  //   //   print('Unable to send FCM message, no token exists.');
  //   //   return;
  //   // }
  //
  //   try {
  //
  //     final response = await http.post(
  //       Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //       // Uri.parse('https://api.rnfirebase.io/messaging/send'),
  //
  //       headers: <String, String>{
  //         HttpHeaders.contentTypeHeader: 'application/json',
  //         HttpHeaders.authorizationHeader: 'key=APA91bGRyPlbh487gV_wca0CSydme8Kqula6OoPEtUOfvbRzXiFUqUNki3a0DUOq9d4h5vp7-0-nrSY7PGVdJb6KZtgV0FpfQaHUbANUfalHTrlBiD0jXwWgHqBXbtELybakRL2NEnt1',
  //       },
  //
  //       body: jsonEncode(
  //         <String, dynamic>{
  //           'notification': <String, dynamic>{
  //             'body': body,
  //             'title': title,
  //           },
  //           'priority': 'high',
  //           'data': <String, dynamic>{
  //             'click_action': 'FLUTTER_NOTIFICATION_CLICK',
  //             'id': '1',
  //             'status': 'done'
  //           },
  //           "to": "/topics/all",
  //         },
  //
  //       // body:
  //       // jsonEncode(<String,dynamic>{
  //       //   'priority' : 'high',
  //       //   'data': {
  //       //     'body' : body,
  //       //     'title' : title,
  //       //     'click_action' : 'FLUTTER_NOTIFICATION_CLICK',
  //       //     'status' : 'done',
  //       //     // 'via': 'FlutterFire Cloud Messaging!!!',
  //       //     // 'count': i++,
  //       //   },
  //       // // {
  //       //   'notification': {
  //       //     'title': title,
  //       //     'body': body,
  //       //   },
  //       //   'to' : token
  //       // }
  //
  //       ),
  //     //
  //     );
  //
  //     print("response-------${response.statusCode}");
  //
  //     if(response.statusCode == 200){
  //       print("body----------${response.body}");
  //     }else{
  //       print("body--------${response.statusCode}");
  //     }
  //
  //     // print('FCM request for device sent!');
  //   } catch (e) {
  //     print("error--------$e");
  //   }
  // }
  //
  //
  // Future<bool> callOnFcmApiSendPushNotifications(String userToken) async {
  //
  //
  //   final postUrl = 'https://fcm.googleapis.com/fcm/send';
  //   final data = {
  //     "to": userToken,
  //     "priority": "high",
  //     "notification": {
  //       "body": "body",
  //       "title": "title"
  //     }
  //   };
  //
  //   final headers = {
  //     'content-type': 'application/json',
  //     // 'authorization': "key=AIzaSyC3wFXfqYeRap_rbZcsoVCVdIrws-UgZ_c" // 'key=YOUR_SERVER_KEY'
  //     'authorization': Constants.serverKey,
  //   };
  //
  //   final response = await http.post(Uri.parse(postUrl),
  //       body: json.encode(data),
  //       encoding: Encoding.getByName('utf-8'),
  //       headers: headers);
  //
  //   print("response-------${response.body}");
  //
  //   if (response.statusCode == 200) {
  //     // on success do sth
  //     print('test ok push CFM');
  //     return true;
  //   } else {
  //
  //
  //     print(' CFM error------${response.statusCode}');
  //     // on failure do sth
  //     return false;
  //   }
  //
  // }


  // void sendPushMessage(String body, String title, String token) async {
  //   try {
  //     await http.post(
  //       Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //         'Authorization':
  //         'key=REPLACETHISWITHYOURAPIKEY',
  //       },
  //       body: jsonEncode(
  //         <String, dynamic>{
  //           'notification': <String, dynamic>{
  //             'body': body,
  //             'title': title,
  //           },
  //           'priority': 'high',
  //           'data': <String, dynamic>{
  //             'click_action': 'FLUTTER_NOTIFICATION_CLICK',
  //             'id': '1',
  //             'status': 'done'
  //           },
  //           "to": token,
  //         },
  //       ),
  //     );
  //     print('done');
  //   } catch (e) {
  //     print("error push notification");
  //   }
  // }

  // String constructFCMPayload(String body,String title) {
  //   // _messageCount++;
  //   return jsonEncode({
  //     'priority' : 'high',
  //     'data': {
  //       'body' : body,
  //       'title' : title,
  //       'click_action' : 'FLUTTER_NOTIFICATION_CLICK',
  //       'status' : 'done',
  //       // 'via': 'FlutterFire Cloud Messaging!!!',
  //       // 'count': 1.toString(),
  //     },
  //     'notification': {
  //       'title': title,
  //       'body': body,
  //     },
  //   });
  // }
  //
  //
  // sendDetail(BuildContext context,
  //     Function function) async {
  //   if (checkValidation(context)) {
  //     String url ='';
  //     if(pickImage!=null){
  //        url = await uploadFile(pickImage!);
  //     }
  //   }
  // }


  bool checkValidation(BuildContext context) {
    if (isNotEmpty(nameController.text)) {
      if(isNotEmpty(messageController.text.toString().trim())) {

        return true;

      }else{
        showCustomToast(
            message: 'Enter message...', title: 'Error', context: context);

        return false;
      }
    } else {
      showCustomToast(
          message: 'Enter title...', title: 'Error', context: context);
      return false;
    }
  }








  Future<String> uploadFile(XFile _image) async {
    try {
      final fileBytes = await _image.readAsBytes();
      var reference =
          FirebaseStorage.instance.ref().child("files/${_image.name}");

      UploadTask uploadTask = reference.putData(
          fileBytes,
          SettableMetadata(
              contentType:
                  "image/${getFileExtension(_image.name).replaceAll('.', '')}"));

      return await getUrlFromTask(uploadTask);
    } catch (e) {
      print('error in uploading image for : ${e.toString()}');
      return '';
    }
  }

  // Future<String> uploadAudio() async {
  //
  //   try{
  //
  //     Uint8List fileBytes = result!.files.first.bytes!;
  //     String fileName = result!.files.first.name;
  //
  //     var reference =
  //     FirebaseStorage.instance.ref().child('uploads/$fileName',);
  //
  //     UploadTask  uploadTask= reference.putData(fileBytes, SettableMetadata(
  //         contentType:
  //         "audio/mpeg"));
  //
  //     return await getUrlFromTask(uploadTask);
  //   }catch(e){
  //     return '';
  //   }
  // }


  getUrlFromTask(  UploadTask  uploadTask)async{
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {
      print("complete=====true");
    // ignore: body_might_complete_normally_catch_error
    }).catchError((error) {
      print("error=====$error");
    });
    String url = await taskSnapshot.ref.getDownloadURL();

    return url;
  }
  String getFileExtension(String fileName) {
    try {
      return "." + fileName.split('.').last;
    } catch (e) {
      return '';
    }
  }

  XFile? pickImage;
  final picker = ImagePicker();
  FilePickerResult? result;


  imgFromGallery() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

    pickImage = image;

    if (image != null) {
      imageController.text = pickImage!.name;
      var f = await pickImage!.readAsBytes();
      isImageOffline(false);
      webImage = f;
      isImageOffline(true);
    }
  }


  Future<String> getImage() async {
    String imageUrl = "";
    if(pickImage != null){
      imageUrl = await uploadFile(pickImage!);
    }

    return imageUrl;
  }
}
