import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebookadminpanel/model/genre_model.dart';
import 'package:ebookadminpanel/model/user_model.dart';
import 'package:ebookadminpanel/util/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';
import 'package:ebookadminpanel/controller/home_controller.dart';
import 'package:ebookadminpanel/model/category_model.dart';
import 'package:ebookadminpanel/model/story_model.dart';
import 'package:ebookadminpanel/theme/app_theme.dart';

import '../../main.dart';
import '../../model/authors_model.dart';
import '../../model/dashboard_screen_data_model.dart';
import '../../model/slider_model.dart';
import '../../ui/common/common.dart';
import '../../util/pref_data.dart';
import 'key_table.dart';

class FirebaseData {
  static createUser(
      {required bool isAdmin,
      required bool isAccess,
      required String password,
      required String username,
      required Function function}) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection(KeyTable.adminData).doc(uid).set({
      'FullName': 'Mimin SiMarKu',
      'ProfilePicture': '',
      'NIKNumber': '',
      'PhoneNumber': '',
      'Address': '',
      KeyTable.keyUserName: username,
      'IsOnline': false,
      'LastActive': '',
      'PushToken': '',
      KeyTable.keyIsAccess: isAccess,
      KeyTable.keyIsAdmin: isAdmin,
      KeyTable.keyDeviceId: deviceID.value,
      KeyTable.keyUid: uid,
    }).then((value) {
      print("called-----function");
      function();
    });
  }

  static changePassword(
      {required String password,
      required Function function,
      required BuildContext context}) async {
    if (FirebaseAuth.instance.currentUser != null) {
      User? user = FirebaseAuth.instance.currentUser!;

      user.updatePassword(password).then((_) async {
        String id = await PrefData.getLoginId();

        FirebaseFirestore.instance
            .collection(KeyTable.adminData)
            .doc(id)
            .update({'password': password}).then((value) {
          showCustomToast(
              context: context, message: "Password change successfully");
          function();
        });
      }).catchError((error) {
        print("Password can't be changed" + error.toString());
        //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
      });
    }
  }

  static insertData(
      {required var map,
      required String tableName,
      required Function function,
      required BuildContext context}) async {
    FirebaseFirestore.instance.collection(tableName).add(map).then((value) {
      showCustomToast(
          message: "Add Successfully...", title: '', context: context);
      function();
    });
  }

  static setData(
      {required var map,
      required String tableName,
      required String doc,
      required Function function,
      bool? isToast,
      required BuildContext context}) {
    FirebaseFirestore.instance
        .collection(tableName)
        .doc(doc)
        .set(map)
        .then((value) {
      if (isToast == null) {
        showCustomToast(
          message: "Update Successfully...",
          title: 'Success',
          context: context,
        );
      }
      function();
    });
  }

  static updateData(
      {required var map,
      required String tableName,
      required String doc,
      required Function function,
      bool? isToast,
      required BuildContext context}) {
    print("tableName------${tableName}");

    FirebaseFirestore.instance
        .collection(tableName)
        .doc(doc)
        .update(map)
        .then((value) {
      if (isToast == null) {
        showCustomToast(
          message: "Update Successfully...",
          title: 'Success',
          context: context,
        );
      }
      function();
    });
  }

  static deleteRecentStory(
      {required BuildContext context,
      required Function function,
      required String storyId}) async {
    deleteSliderStory(
        context: context,
        function: (doc) {
          FirebaseData.deleteData(
              tableName: KeyTable.sliderList, doc: doc, function: () {});
        },
        storyId: storyId);

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(KeyTable.recentList)
        .where(KeyTable.storyId, isEqualTo: storyId)
        .get();

    if (querySnapshot.size > 0 && querySnapshot.docs.isNotEmpty) {
      function(querySnapshot.docs[0].id);
    }
  }

  static deleteSliderStory(
      {required BuildContext context,
      required Function function,
      required String storyId}) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(KeyTable.sliderList)
        .where(KeyTable.storyId, isEqualTo: storyId)
        .get();

    if (querySnapshot.size > 0 && querySnapshot.docs.isNotEmpty) {
      function(querySnapshot.docs[0].id);
    }
  }

  static deleteData(
      {required String tableName,
      required String doc,
      required Function function}) {
    FirebaseFirestore.instance
        .collection(tableName)
        .doc(doc)
        .delete()
        .then((value) {
      function();
    });
  }

  static deleteBatch(
      Function function, String id, String tableName, String key) async {
    print("auth_id-----${key}");
    print("id-----${id}");
    WriteBatch batch = FirebaseFirestore.instance.batch();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(tableName)
        .where(key, isEqualTo: id)
        .get();

    if (querySnapshot.size > 0) {
      if (querySnapshot.docs.length > 0) {
        List<DocumentSnapshot> list1 = querySnapshot.docs;
        for (int i = 0; i < list1.length; i++) {
          batch.delete(list1[i].reference);
        }
        batch.commit().then((value) {
          function();
        });
      } else {
        function();
      }
    } else {
      function();
    }
  }

  static Future<bool> checkExist(String docID, String collection) async {
    bool exist = false;
    try {
      print("isExist====${exist}===$docID===$collection");
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection(collection)
          .doc(docID)
          .get();

      exist = documentSnapshot.exists;

      print("isExist====${exist}");

      return exist;
    } catch (e) {
      // If any error
      return false;
    }
  }

  static Future<DocumentSnapshot?> checkStoryExist(
      String docID, String collection) async {
    bool exist = false;
    try {
      print("isExist====${exist}===$docID===$collection");
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection(collection)
          .doc(docID)
          .get();

      exist = documentSnapshot.exists;

      print("isExist====${exist}");

      return documentSnapshot;
    } catch (e) {
      // If any error
      return null;
    }
  }

  static Future<bool> checkIfDocExists(String docId, String collection) async {
    bool isExist = await checkExist(docId, collection);

    if (isExist) {
      await FirebaseFirestore.instance
          .doc("$collection/$docId")
          .get()
          .then((doc) async {
        isExist = await checkExist(
            StoryModel.fromFirestore(doc).refId!, KeyTable.keyCategoryTable);
      });

      return isExist;
    } else {
      return false;
    }
  }

  static Future<bool> checkIfDetailExists(
      String docId, String collection) async {
    bool isExist = await checkExist(docId, collection);

    if (isExist) {
      await FirebaseFirestore.instance
          .doc("$collection/$docId")
          .get()
          .then((doc) async {
        isExist = await checkExist(
            StoryModel.fromFirestore(doc).refId!, KeyTable.appDetail);
      });
      return isExist;
    } else {
      return false;
    }
  }

  static Future<bool> checkCategoryExists(String docId,
      {String? collection}) async {
    print("doc===$docId");
    try {
      var collectionRef = FirebaseFirestore.instance.collection(
          collection == null ? KeyTable.keyCategoryTable : collection);

      var doc = await collectionRef.doc(docId).get();

      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

  static Future<int> getCategoryRefId() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(KeyTable.keyCategoryTable)
        .orderBy(KeyTable.refId, descending: true)
        .get();

    if (querySnapshot.size > 0) {
      if (querySnapshot.docs.length > 0) {
        List<DocumentSnapshot> list1 = querySnapshot.docs;
        if (list1.length > 0) {
          CategoryModel categoryModel = CategoryModel.fromFirestore(list1[0]);
          return (categoryModel.refId! + 1);
        }
      }
      return 1;
    } else {
      return 1;
    }
  }

  static Future<bool> checkGenreExists(String docId,
      {String? collection}) async {
    print("doc===$docId");
    try {
      var collectionRef = FirebaseFirestore.instance
          .collection(collection == null ? KeyTable.genreList : collection);

      var doc = await collectionRef.doc(docId).get();

      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

  static Future<int> getGenreRefId() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(KeyTable.genreList)
        .orderBy(KeyTable.refId, descending: true)
        .get();

    if (querySnapshot.size > 0) {
      if (querySnapshot.docs.length > 0) {
        List<DocumentSnapshot> list1 = querySnapshot.docs;
        if (list1.length > 0) {
          Genre genreModel = Genre.fromFirestore(list1[0]);
          return (genreModel.refId! + 1);
        }
      }
      return 1;
    } else {
      return 1;
    }
  }

  static Future<int> getLastIndexFromTable(String table) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(table)
        .orderBy(KeyTable.index, descending: true)
        .get();

    if (querySnapshot.size > 0) {
      if (querySnapshot.docs.length > 0) {
        List<DocumentSnapshot> list1 = querySnapshot.docs;
        if (list1.length > 0) {
          StoryModel categoryModel = StoryModel.fromFirestore(list1[0]);
          return (categoryModel.index! + 1);
        }
      }
      return 1;
    } else {
      return 1;
    }
  }

  static Future<int> getLastIndexFromAuthTable() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(KeyTable.authorList)
        .orderBy(KeyTable.index, descending: true)
        .get();

    if (querySnapshot.size > 0) {
      if (querySnapshot.docs.length > 0) {
        List<DocumentSnapshot> list1 = querySnapshot.docs;
        if (list1.length > 0) {
          TopAuthors categoryModel = TopAuthors.fromFirestore(list1[0]);
          return (categoryModel.index! + 1);
        }
      }
      return 1;
    } else {
      return 1;
    }
  }

  static Future<int> getLastIndexFromGenreTable() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(KeyTable.genreList)
        .orderBy(KeyTable.index, descending: true)
        .get();

    if (querySnapshot.size > 0) {
      if (querySnapshot.docs.length > 0) {
        List<DocumentSnapshot> list1 = querySnapshot.docs;
        if (list1.length > 0) {
          Genre genreModel = Genre.fromFirestore(list1[0]);
          return (genreModel.index! + 1);
        }
      }
      return 1;
    } else {
      return 1;
    }
  }

  // static Future<int> getLastIndexFromUserTable() async {
  //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //       .collection(KeyTable.user)
  //       .orderBy(KeyTable.index, descending: true)
  //       .get();

  //   if (querySnapshot.size > 0) {
  //     if (querySnapshot.docs.length > 0) {
  //       List<DocumentSnapshot> list1 = querySnapshot.docs;
  //       if (list1.length > 0) {
  //         UserModel userModel = UserModel.fromFirestore(list1[0]);
  //         return (userModel.index! + 1);
  //       }
  //     }
  //     return 1;
  //   } else {
  //     return 1;
  //   }
  // }

  static Future<String> getAuthName({required String refId}) async {
    print("called-----true");
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection(KeyTable.authorList)
        .doc(refId)
        .get();
    print("called-----${snapshot.toString()}");

    TopAuthors topAuthors = TopAuthors.fromFirestore(snapshot);

    print("topAuthors-----${topAuthors}");

    String author = topAuthors.authorName ?? "";

    return author;
  }

  Future<void> getUserName({required String refId}) async {
    try {
      print("called-----true");

      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection(KeyTable.user)
          .doc(refId)
          .get();

      print("called-----${snapshot.exists}");

      if (snapshot.exists) {
        UserModel user = UserModel.fromFirestore(snapshot);
        print("users-----${user}");

        String userName = user.fullName;
        print("User FullName: $userName");
      } else {
        throw Exception("User not found");
      }
    } catch (e) {
      print('Error getting user name: $e');
    }
  }

  static Future<String> getGenre({required String refId}) async {
    print("called-----true");
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection(KeyTable.genreList)
        .doc(refId)
        .get();
    print("called-----${snapshot.toString()}");

    Genre genre = Genre.fromFirestore(snapshot);

    print("genre-----${genre}");

    String genreName = genre.genre ?? "";

    return genreName;
  }

  static deleteAuthorBatch(Function function, String id, String tableName,
      String key, BuildContext context) async {
    print("genre_id-----genre-----${key}");
    print("id-----genre-----${id}");
    WriteBatch batch = FirebaseFirestore.instance.batch();

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(tableName)
        .where(key, arrayContains: id)
        // .where(key, isEqualTo: id)
        .get();

    print("doc---------genre-----${querySnapshot.docs.length}");

    // QuerySnapshot querySnapshot = await FirebaseFirestore.instance
    //     .collection(tableName)
    //     .where(key, isEqualTo: id)
    //     .get();

    if (querySnapshot.size > 0) {
      if (querySnapshot.docs.length > 0) {
        List<DocumentSnapshot> list1 = querySnapshot.docs;
        for (int i = 0; i < list1.length; i++) {
          StoryModel storyModel = StoryModel.fromFirestore(list1[i]);

          print(
              "story<=Model============+${storyModel.id}----------${storyModel.name}--------${storyModel.genreId.toString()}");

          if (storyModel.genreId!.isNotEmpty) {
            List genre = storyModel.genreId!;

            if (genre.isNotEmpty) {
              if (genre.contains(id)) {
                genre.remove(id);

                print("genre.isNotEmpty==========${genre.isNotEmpty}");

                if (genre.isNotEmpty) {
                  FirebaseData.updateData(
                      map: {KeyTable.genreId: genre},
                      tableName: tableName,
                      doc: storyModel.id ?? "",
                      function: () {},
                      context: context,
                      isToast: false);
                } else {
                  FirebaseData.deleteData(
                      tableName: tableName,
                      doc: storyModel.id ?? "",
                      function: () {});
                }
              }
            }
          }

          // batch.delete(list1[i].reference);

          print("sliderId-------${list1[i].id}");

          await deleteBackendData(list1[i].id, KeyTable.sliderList);
        }
        batch.commit().then((value) {
          function();
        });
      } else {
        function();
      }
    } else {
      function();
    }
  }

  static deleteGenreBatch(Function function, String id, String tableName,
      String key, BuildContext context) async {
    print("genre_id-----genre-----${key}");
    print("id-----genre-----${id}");
    WriteBatch batch = FirebaseFirestore.instance.batch();

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(tableName)
        .where(key, arrayContains: id)
        // .where(key, isEqualTo: id)
        .get();

    print("doc---------auth-----${querySnapshot.docs.length}");

    // QuerySnapshot querySnapshot = await FirebaseFirestore.instance
    //     .collection(tableName)
    //     .where(key, isEqualTo: id)
    //     .get();

    if (querySnapshot.size > 0) {
      if (querySnapshot.docs.length > 0) {
        List<DocumentSnapshot> list1 = querySnapshot.docs;
        for (int i = 0; i < list1.length; i++) {
          StoryModel storyModel = StoryModel.fromFirestore(list1[i]);

          print(
              "story<=Model============+${storyModel.id}----------${storyModel.name}--------${storyModel.genreId.toString()}");

          if (storyModel.genreId!.isNotEmpty) {
            List genre = storyModel.genreId!;

            if (genre.isNotEmpty) {
              if (genre.contains(id)) {
                genre.remove(id);

                print("genre.isNotEmpty==========${genre.isNotEmpty}");

                if (genre.isNotEmpty) {
                  FirebaseData.updateData(
                      map: {KeyTable.genreId: genre},
                      tableName: tableName,
                      doc: storyModel.id ?? "",
                      function: () {},
                      context: context,
                      isToast: false);
                } else {
                  FirebaseData.deleteData(
                      tableName: tableName,
                      doc: storyModel.id ?? "",
                      function: () {});
                }
              }
            }
          }

          // batch.delete(list1[i].reference);

          print("sliderId-------${list1[i].id}");

          await deleteBackendData(list1[i].id, KeyTable.sliderList);
        }
        batch.commit().then((value) {
          function();
        });
      } else {
        function();
      }
    } else {
      function();
    }
  }

  static deleteBackendData(String id, String tableName) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(tableName)
        .where(KeyTable.storyId, isEqualTo: id)
        .get();

    if (querySnapshot.docs.isNotEmpty && querySnapshot.docs[0].exists) {
      await FirebaseFirestore.instance
          .collection(tableName)
          .doc(querySnapshot.docs[0].id)
          .delete();
    }
  }

  static getData({required String tableName}) async {
    return FirebaseFirestore.instance.collection(tableName).snapshots();
  }

  static refreshStoryData() {
    HomeController homeController = Get.find();
    homeController.fetchStoryData();
  }

  // static refreshCategoryData() {
  //   HomeController homeController = Get.find();
  //   homeController.fetchCategoryData();
  // }

  static refreshAuthorData() {
    HomeController homeController = Get.find();
    homeController.fetchAuthorData();
  }

  static refreshGenreData() {
    HomeController homeController = Get.find();
    homeController.fetchGenreData();
  }

  static refreshSekilasInfoData() {
    HomeController homeController = Get.find();
    homeController.fetchSekilasInfoData();
  }

  static refreshKegiatanLiterasiData() {
    HomeController homeController = Get.find();
    homeController.fetchKegiatanLiterasiData();
  }

  static refreshFeedbackData() {
    HomeController homeController = Get.find();
    homeController.fetchFeedback();
  }

  static refreshRatingData() {
    HomeController homeController = Get.find();
    homeController.fetchRating();
  }

  static refreshUserData() {
    HomeController homeController = Get.find();
    homeController.fetchUserData();
  }

  static refreshSliderData() {
    HomeController homeController = Get.find();
    homeController.fetchSliderData();
  }

  static getStory(String storyId) async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection(KeyTable.storyList)
        .doc(storyId)
        .get();
    StoryModel storyModel = StoryModel.fromFirestore(snapshot);

    print("story-----${storyModel.name}");

    return storyModel;
  }

  static Future<int> getLastIndexFromSliderTable(String table) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(table)
        .orderBy(KeyTable.index, descending: true)
        .get();

    if (querySnapshot.size > 0) {
      if (querySnapshot.docs.length > 0) {
        List<DocumentSnapshot> list1 = querySnapshot.docs;

        print("sliderlistlen------${list1.length}");
        if (list1.length > 0) {
          SliderModel categoryModel = SliderModel.fromFirestore(list1[0]);
          return (categoryModel.index! + 1);
        }
      }
      return 1;
    } else {
      return 1;
    }
  }
}

List<DashBoardData> getDashboardData() {
  return [
    DashBoardData(
        icon: 'dashboard_category_icon.svg',
        title: 'Buku',
        backgroundColor: Color(0XFFFFEDE9),
        buttonColor: primaryColor,
        tableName: KeyTable.storyList,
        navigateId: 2,
        navigateIndex: 4,
        navigateAddClassId: 3,
        action: actionStories,
        addAction: actionAddStory),
    DashBoardData(
        icon: 'dashboard_homeslider_slider.svg',
        title: 'Genre',
        backgroundColor: Color(0XFFD8F1E4),
        buttonColor: Color(0XFF36CB79),
        tableName: KeyTable.genreList,
        navigateId: 5,
        navigateIndex: 4,
        navigateAddClassId: 5,
        action: actionGenre,
        addAction: actionAddGenre),
    DashBoardData(
        icon: 'dashboard_featured_books_icon.svg',
        title: 'Buku Rekomendasi',
        backgroundColor: Color(0XFFFFF6D4),
        buttonColor: Color(0XFFFFAE35),
        tableName: KeyTable.storyList,
        navigateId: 4,
        navigateIndex: 3,
        navigateAddClassId: 6,
        action: actionStories,
        isFeatured: true,
        addAction: actionAddStory),
    DashBoardData(
        icon: 'dashboard_populer_books_icon.svg',
        title: 'Buku Populer',
        backgroundColor: Color(0XFFF3E7FF),
        buttonColor: Color(0XFFA67CFF),
// backgroundColor: Color(0XFFE1F1FF),
// buttonColor: Color(0XFF4CB8F4),
        tableName: KeyTable.storyList,
        navigateId: 4,
        isPopular: true,
        navigateIndex: 3,
        navigateAddClassId: 5,
        action: actionStories,
        addAction: actionAddStory),
    DashBoardData(
        icon: 'dashboard_tukar_pinjam_icon.svg',
        title: 'Tukar Pinjam',
        backgroundColor: Color(0XFFFFEDE9),
        buttonColor: primaryColor,
        tableName: KeyTable.tukarPinjam,
        navigateId: 2,
        navigateIndex: 4,
        navigateAddClassId: 3,
        action: actionTukarPinjam,
        addAction: null),
    DashBoardData(
        icon: 'dashboard_tukar_milik_icon.svg',
        title: 'Tukar Milik',
        backgroundColor: Color(0XFFD8F1E4),
        buttonColor: Color(0XFF36CB79),
        tableName: KeyTable.tukarMilik,
        navigateId: 2,
        navigateIndex: 4,
        navigateAddClassId: 3,
        action: actionTukarMilik,
        addAction: null),
    DashBoardData(
        icon: 'dashboard_donation_icon.svg',
        title: 'Donasi Buku',
        backgroundColor: Color(0XFFFFF6D4),
        buttonColor: Color(0XFFFFAE35),
        tableName: KeyTable.donationBook,
        navigateId: 2,
        navigateIndex: 4,
        navigateAddClassId: 3,
        action: actionDonationBook,
        addAction: null),
    DashBoardData(
        icon: 'dashboard_kegiatan_literasi_icon.svg',
        title: 'Kegiatan Literasi',
        backgroundColor: Color(0XFFF3E7FF),
        buttonColor: Color(0XFFA67CFF),
        tableName: KeyTable.kegiatanLiterasi,
        navigateId: 5,
        navigateIndex: 4,
        navigateAddClassId: 5,
        action: actionKegiatanLiterasi,
        addAction: actionAddKegiatanLiterasi),
    DashBoardData(
        icon: 'dashboard_sekilas_info_icon.svg',
        title: 'Sekilas Info',
        backgroundColor: Color(0XFFFFEDE9),
        buttonColor: primaryColor,
        tableName: KeyTable.sekilasInfo,
        navigateId: 4,
        navigateIndex: 3,
        navigateAddClassId: 6,
        action: actionSekilasInfo,
        addAction: actionAddSekilasInfo),
    DashBoardData(
        icon: 'dashboard_user_icon.svg',
        title: 'Pengguna',
        backgroundColor: Color(0XFFD8F1E4),
        buttonColor: Color(0XFF36CB79),
        tableName: KeyTable.user,
        navigateId: 5,
        navigateIndex: 4,
        navigateAddClassId: 5,
        action: actionUser,
        addAction: null),
    DashBoardData(
        icon: 'dashboard_feedback_icon.svg',
        title: 'Umpan Balik',
        backgroundColor: Color(0XFFFFF6D4),
        buttonColor: Color(0XFFFFAE35),
        tableName: KeyTable.feedback,
        navigateId: 4,
        navigateIndex: 3,
        navigateAddClassId: 6,
        action: actionFeedback,
        addAction: null),
    DashBoardData(
        icon: 'dashboard_rating_icon.svg',
        title: 'Rating',
        backgroundColor: Color(0XFFF3E7FF),
        buttonColor: Color(0XFFA67CFF),
        tableName: KeyTable.rating,
        navigateId: 4,
        navigateIndex: 3,
        navigateAddClassId: 5,
        action: actionRating,
        addAction: null),
  ];
}
