import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebookadminpanel/controller/notification_access_token.dart';
import 'package:ebookadminpanel/model/chat_model.dart';
import 'package:ebookadminpanel/model/user_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

class ChatController {
  FilePickerResult? result;

  // for authentication
  static FirebaseAuth get auth => FirebaseAuth.instance;

  // for accessing cloud firestore database
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // for accessing firebase storage
  static FirebaseStorage storage = FirebaseStorage.instance;

  // to return current user
  static User get user => auth.currentUser!;

  // User Model
  static UserModel? me;

// Initialize the user model with Firestore data
  static Future<void> initializeUserModel() async {
    try {
      me = await UserModel.fetchCurrentUser();
      print('UserModel initialized: ${me!.fullName}');
    } catch (e) {
      print('Error initializing user model: $e');
    }
  }

// for sending push notification (Updated Codes)
  static Future<void> sendPushNotification(
      UserModel chatUser, String msg) async {
    try {
      if (me == null) {
        await initializeUserModel();
      }

      // Ensure 'me' is initialized
      if (me == null) {
        print('User model initialization failed.');
        return;
      }

      final body = {
        "message": {
          "token": chatUser.pushToken,
          "notification": {
            "title": me!.fullName,
            "body": msg,
          },
        }
      };

      print('Sending notification with title: ${me!.fullName}');

      // Firebase Project > Project Settings > General Tab > Project ID
      const projectID = 'simarku-a8d45';

      // get firebase admin token
      final bearerToken = await NotificationAccessToken.getToken;

      log('bearerToken: $bearerToken');

      // handle null token
      if (bearerToken == null) return;

      var res = await post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/$projectID/messages:send'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: 'Bearer $bearerToken'
        },
        body: jsonEncode(body),
      );

      // // Initialize flutter_local_notifications
      // const AndroidInitializationSettings initializationSettingsAndroid =
      //     AndroidInitializationSettings('@mipmap/launcher_icon');

      // const InitializationSettings initializationSettings =
      //     InitializationSettings(
      //   android: initializationSettingsAndroid,
      // );

      // await flutterLocalNotificationsPlugin.initialize(initializationSettings);

      // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //   RemoteNotification? notification = message.notification;
      //   AndroidNotification? android = message.notification?.android;

      //   if (notification != null && android != null) {
      //     flutterLocalNotificationsPlugin.show(
      //       notification.hashCode,
      //       notification.title,
      //       notification.body,
      //       NotificationDetails(
      //         android: AndroidNotificationDetails(
      //           'chats', // channel id
      //           'Chats', // channel name
      //           importance: Importance.max,
      //           priority: Priority.high,
      //           showWhen: false,
      //         ),
      //       ),
      //     );
      //   }
      // });

      log('Response status: ${res.statusCode}');
      log('Response body: ${res.body}');
    } catch (e) {
      log('\nsendPushNotificationE: $e');
    }
  }

  // for checking if user exists or not?
  static Future<bool> userExists() async {
    return (await firestore.collection('Users').doc(user.uid).get()).exists;
  }

  // for adding an chat user for our conversation
  static Future<bool> addChatUser(String fullName) async {
    final data = await firestore
        .collection('Users')
        .where('FullName', isEqualTo: fullName)
        .get();

    log('data: ${data.docs}');

    if (data.docs.isNotEmpty && data.docs.first.id != user.uid) {
      //user exists

      log('user exists: ${data.docs.first.data()}');

      firestore
          .collection('Users')
          .doc(user.uid)
          .collection('my_users')
          .doc(data.docs.first.id)
          .set({});

      return true;
    } else {
      //user doesn't exists

      return false;
    }
  }

  // for getting current user info
  static Future<void> getSelfInfo() async {
    await firestore.collection('Users').doc(user.uid).get().then((user) async {
      if (user.exists) {
        me = UserModel.fromJson(user.data()!);
        await fetchFirebaseMessagingToken();

        //for setting user status to active
        ChatController.updateActiveStatus(true);
        log('My Data: ${user.data()}');
      } else {
        await createUser().then((value) => getSelfInfo());
      }
    });
  }

  static Future<String> fetchFirebaseMessagingToken() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      await messaging.requestPermission();
      String? token = await messaging.getToken();
      if (token == null) {
        print("Failed to get push token");
        throw Exception('Failed to get push token');
      }
      print("Push token retrieved: $token");
      return token;
    } catch (e) {
      print("Error getting push token: $e");
      throw 'Terjadi kesalahan mendapatkan push token';
    }
  }

  // for creating a new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = UserModel(
        id: user.uid,
        address: '',
        deviceId: '',
        isAccess: false,
        isAdmin: false,
        nikNumber: '',
        phoneNumber: user.phoneNumber.toString(),
        fullName: user.displayName.toString(),
        email: user.email.toString(),
        profilePicture: user.photoURL.toString(),
        isOnline: false,
        lastActive: time,
        pushToken: '');

    return await firestore
        .collection('Users')
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  // for getting id's of known users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersId() {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(
            user.uid) // make sure to replace 'user.uid' with the actual user ID
        .collection('my_users')
        .snapshots();
  }

  // for getting all users from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(
      List<String> userIds) {
    log('\nUserIds: $userIds');

    return firestore
        .collection('Users')
        .where('id',
            whereIn: userIds.isEmpty
                ? ['']
                : userIds) //because empty list throws an error
        // .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  // for getting specific user info
  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(
      UserModel chatUser) {
    return firestore
        .collection('Users')
        .where('id', isEqualTo: chatUser.id)
        .snapshots();
  }

  // for adding an user to my user when first message is send
  static Future<void> sendFirstMessage(
      UserModel chatUser, String msg, Type type) async {
    await firestore
        .collection('Users')
        .doc(chatUser.id)
        .collection('my_users')
        .doc(user.uid)
        .set({}).then((value) => sendMessage(chatUser, msg, type));
  }

  // update online or last active status of user
  static Future<void> updateActiveStatus(bool isOnline) async {
    firestore.collection('Users').doc(user.uid).update({
      'IsOnline': isOnline,
      'LastActive': DateTime.now().millisecondsSinceEpoch.toString(),
      //   'push_token': chatUser.pushToken,
    });
  }

  ///************** Chat Screen Related APIs **************

  // chats (collection) --> conversation_id (doc) --> messages (collection) --> message (doc)

  // useful for getting conversation id
  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  // for getting all messages of a specific conversation from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      UserModel user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .snapshots();
  }

  // for sending message
  static Future<void> sendMessage(
      UserModel chatUser, String msg, Type type) async {
    //message sending time (also used as id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    //message to send
    final ChatModel message = ChatModel(
        toId: chatUser.id,
        msg: msg,
        read: '',
        type: type,
        fromId: user.uid,
        sent: time);

    final ref = firestore
        .collection('chats/${getConversationID(chatUser.id)}/messages/');
    await ref.doc(time).set(message.toJson()).then((value) {
      if (type == Type.text) {
        sendPushNotification(chatUser, msg);
      } else if (type == Type.file) {
        sendPushNotification(chatUser, 'File');
      } else if (type == Type.image) {
        sendPushNotification(chatUser, 'Gambar');
      } else {
        // Tipe pesan lainnya (opsional)
        sendPushNotification(chatUser, 'Pesan Lainnya');
      }
    });
  }

  //update read status of message
  static Future<void> updateMessageReadStatus(ChatModel message) async {
    firestore
        .collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  //get only last message of a specific chat
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      UserModel user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  //delete message
  static Future<void> deleteMessage(ChatModel message) async {
    await firestore
        .collection('chats/${getConversationID(message.toId)}/messages/')
        .doc(message.sent)
        .delete();

    if (message.type == Type.image) {
      await storage.refFromURL(message.msg).delete();
    }
  }

  //update message
  static Future<void> updateMessage(
      ChatModel message, String updatedMsg) async {
    await firestore
        .collection('chats/${getConversationID(message.toId)}/messages/')
        .doc(message.sent)
        .update({'msg': updatedMsg});
  }

  //Download File
//   static Future<void> saveFile(String url) async {
//     try {
//       // Meminta izin penyimpanan
//       PermissionStatus status = await Permission.storage.status;
//       if (!status.isGranted) {
//         status = await Permission.storage.request();
//       }

//       log('Permission status: $status');

//       if (status.isGranted) {
//         // Mendapatkan direktori penyimpanan eksternal
//         List<Directory>? directories = await getExternalStorageDirectories();
//         Directory? directory;
//         if (directories != null && directories.isNotEmpty) {
//           directory = directories.first;
//         }

//         log('External storage directory: ${directory?.path}');
//         String newPath = directory!.path.split("Android")[0] + "/SiMarKu";
//         directory = Directory(newPath);
//         log('New directory path: ${directory.path}');
//         if (!await directory.exists()) {
//           await directory.create(recursive: true);
//           log('Directory created');
//         }

//         // Menentukan nama file dari URL
//         String fileName = url.split('/').last.split('?').first;
//         File saveFile = File(directory.path + "/$fileName");
//         log('File path: ${saveFile.path}');

//         // Mengunduh file menggunakan Dio
//         await Dio().download(url, saveFile.path);
//         log('File downloaded');

//         // Menampilkan pesan berhasil
//         SMLoaders.successSnackBar(
//             title: 'Berhasil',
//             message: 'File berhasil disimpan di ${saveFile.path}');
//       } else if (status.isPermanentlyDenied) {
//         // Menampilkan pesan jika izin ditolak permanen dan membuka pengaturan
//         await openAppSettings();
//         SMLoaders.errorSnackBar(
//             title: 'Gagal',
//             message:
//                 'Izin ditolak permanen, buka pengaturan untuk mengizinkan.');
//       } else {
//         // Menampilkan pesan jika izin ditolak
//         SMLoaders.errorSnackBar(title: 'Gagal', message: 'Izin ditolak');
//       }
//     } catch (e) {
//       // Menampilkan pesan kesalahan
//       log('ErrorWhileSavingFile: $e');
//       SMLoaders.errorSnackBar(
//           title: 'Error', message: 'Terjadi kesalahan saat menyimpan file.');
//     }
//   }

  // Open File Picker for documents
  Future<void> openFile(UserModel chatUser) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        Uint8List? fileBytes = result.files.first.bytes;
        String fileName = result.files.first.name;

        // Read file bytes manually if result.files.first.bytes is null
        if (fileBytes == null && result.files.first.path != null) {
          File file = File(result.files.first.path!);
          fileBytes = await file.readAsBytes();
        }

        if (fileBytes != null) {
          // Upload file to Firebase Storage
          String fileUrl = await uploadPdfFile(fileBytes, fileName);

          // Send message with file URL
          if (fileUrl.isNotEmpty) {
            await sendMessage(chatUser, fileUrl, Type.file);
          }
        }
      }
    } catch (e) {
      print("Error picking file: $e");
    }
  }

// Pick images from gallery
  Future<void> pickImages(UserModel chatUser) async {
    try {
      final ImagePicker picker = ImagePicker();

      // Picking multiple images
      final List<XFile>? images = await picker.pickMultiImage(imageQuality: 70);

      if (images != null) {
        for (var i in images) {
          log('Image Path: ${i.path}');
          await sendChatImage(chatUser, await i.readAsBytes(), i.name);
        }
      }
    } catch (e) {
      print("Error picking images: $e");
    }
  }

// Send chat image
  static Future<void> sendChatImage(
      UserModel chatUser, Uint8List fileBytes, String fileName) async {
    String ext = fileName.split('.').last;

    // Storage file ref with path
    final ref = FirebaseStorage.instance.ref().child(
        'images/${getConversationID(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

    // Uploading image
    UploadTask uploadTask =
        ref.putData(fileBytes, SettableMetadata(contentType: 'image/$ext'));

    // Updating image in Firestore database
    final imageUrl = await (await uploadTask).ref.getDownloadURL();
    await sendMessage(chatUser, imageUrl, Type.image);
  }

  // Send PDF file
  Future<String> uploadPdfFile(Uint8List fileBytes, String fileName) async {
    try {
      var reference = FirebaseStorage.instance.ref().child('pdf/$fileName');
      UploadTask uploadTask = reference.putData(
        fileBytes,
        SettableMetadata(contentType: "application/pdf"),
      );

      return await getUrlFromTask(uploadTask);
    } catch (e) {
      print('Error in uploading PDF: ${e.toString()}');
      return '';
    }
  }

  // Get URL from Task
  Future<String> getUrlFromTask(UploadTask uploadTask) async {
    try {
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {
        print("Upload complete");
      });

      String url = await taskSnapshot.ref.getDownloadURL();
      print("File URL: $url");

      return url;
    } catch (e) {
      print("Error getting download URL: $e");
      return '';
    }
  }

//   // Get File Size String
//   static String getFileSizeString({required int bytes, int decimals = 0}) {
//     if (bytes <= 0) return "0 Bytes";
//     const suffixes = [" Bytes", "KB", "MB", "GB", "TB"];
//     var i = (log(bytes) / log(1024)).floor();
//     return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
//   }
}
