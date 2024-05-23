import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebookadminpanel/model/authors_model.dart';
import 'package:ebookadminpanel/model/genre_model.dart';
import 'package:ebookadminpanel/model/user_model.dart';
import 'package:get/get.dart';
import 'package:ebookadminpanel/controller/data/FirebaseData.dart';
import 'package:ebookadminpanel/model/category_model.dart';
import 'package:ebookadminpanel/model/slider_model.dart';
import 'package:ebookadminpanel/util/constants.dart';

import '../model/story_model.dart';
import '../ui/home/home_page.dart';
import 'data/key_table.dart';

class HomeController extends GetxController {
  CategoryModel? categoryModel = null;
  StoryModel? storyModel = null;
  TopAuthors? authorModel = null;
  Genre? genreModel = null;
  UserModel? userModel = null;
  RxString category = ''.obs;
  RxString slider = ''.obs;
  RxString author = ''.obs;
  RxString genre = ''.obs;
  RxString user = ''.obs;
  RxString story = ''.obs;
  RxString storyNotification = ''.obs;
  RxString pdf = Constants.physichBook.obs;

  RxList<CategoryModel> categoryList = <CategoryModel>[].obs;
  RxList<TopAuthors> authorList = <TopAuthors>[].obs;
  RxList<String> allAuthorList = <String>[].obs;
  RxList<Genre> genreList = <Genre>[].obs;
  RxList<String> allGenreList = <String>[].obs;
  RxList<UserModel> userList = <UserModel>[].obs;
  RxList<String> allUserList = <String>[].obs;
  RxList<String> allCategoryList = <String>[].obs;
  RxList<StoryModel> storyList = <StoryModel>[].obs;
  RxList<StoryModel> storyListNotification = <StoryModel>[].obs;
  RxList<String> sliderList = <String>[].obs;
  RxList<String> allStoryList = <String>[].obs;
  RxList<String> allStoryListNotification = <String>[].obs;
  RxList<String> sliderIdList = <String>[].obs;
  RxBool isLoading = false.obs;

  List<String> pdfOptionList = [Constants.physichBook, Constants.file];

  setCategoryModel(CategoryModel categoryModel) {
    this.categoryModel = categoryModel;
    changeAction(actionEditCategory);
  }

  setStoryModel(StoryModel storyModel) {
    this.storyModel = storyModel;
    changeAction(actionEditStory);
  }

  setAuthorModel(TopAuthors authorModel) {
    this.authorModel = authorModel;
    changeAction(actionEditAuthor);
  }

  setGenreModel(Genre genreModel) {
    this.genreModel = genreModel;
    changeAction(actionEditGenre);
  }

  setUserModel(UserModel userModel) {
    this.userModel = userModel;
    changeAction(actionEditUser);
  }

  @override
  void onInit() {
    super.onInit();
    fetchCategoryData();
    fetchAuthorData();
    fetchStoryData();
    fetchSliderData();
    fetchGenreData();
    fetchUserData();

    fetchStoryDataForNotification();
  }

  fetchCategoryData() async {
    isLoading(true);
    categoryList = <CategoryModel>[].obs;
    allCategoryList = <String>[].obs;
    category("");
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(KeyTable.keyCategoryTable)
        .get();

    if (querySnapshot.size > 0 && querySnapshot.docs.length > 0) {
      List<DocumentSnapshot> list1 = querySnapshot.docs;
      categoryList = <CategoryModel>[].obs;
      for (int i = 0; i < list1.length; i++) {
        categoryList.add(CategoryModel.fromFirestore(list1[i]));
        allCategoryList.add(CategoryModel.fromFirestore(list1[i]).name!);
      }
      isLoading(false);
      category((list1[0]).id);
      categoryList.refresh();
      allCategoryList.refresh();
    } else {
      isLoading(false);
    }
  }

  fetchAuthorData() async {
    isLoading(true);
    authorList = <TopAuthors>[].obs;
    allAuthorList = <String>[].obs;
    author("");
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection(KeyTable.authorList).get();

    if (querySnapshot.size > 0 && querySnapshot.docs.length > 0) {
      List<DocumentSnapshot> list1 = querySnapshot.docs;
      authorList = <TopAuthors>[].obs;
      for (int i = 0; i < list1.length; i++) {
        authorList.add(TopAuthors.fromFirestore(list1[i]));
        allAuthorList.add(TopAuthors.fromFirestore(list1[i]).authorName!);
      }
      isLoading(false);
      author((list1[0]).id);
      authorList.refresh();
      allAuthorList.refresh();
    } else {
      isLoading(false);
    }
  }

  fetchStoryData() async {
    isLoading(true);
    storyList = <StoryModel>[].obs;
    allStoryList = <String>[].obs;
    story("");
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection(KeyTable.storyList).get();

    if (querySnapshot.size > 0 && querySnapshot.docs.length > 0) {
      List<DocumentSnapshot> list1 = querySnapshot.docs;
      storyList = <StoryModel>[].obs;
      for (int i = 0; i < list1.length; i++) {
        storyList.add(StoryModel.fromFirestore(list1[i]));
        allStoryList.add(StoryModel.fromFirestore(list1[i]).name!);
      }
      isLoading(false);
      story((list1[0]).id);
      storyList.refresh();
      allStoryList.refresh();
    } else {
      isLoading(false);
    }
  }

  fetchStoryDataForNotification() async {
    isLoading(true);
    storyListNotification = <StoryModel>[].obs;
    allStoryListNotification = <String>[].obs;
    storyNotification("");
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection(KeyTable.storyList).get();

    if (querySnapshot.size > 0 && querySnapshot.docs.length > 0) {
      List<DocumentSnapshot> list1 = querySnapshot.docs;
      storyListNotification = <StoryModel>[].obs;
      for (int i = 0; i < list1.length; i++) {
        storyListNotification.add(StoryModel.fromFirestore(list1[i]));
        allStoryListNotification.add(StoryModel.fromFirestore(list1[i]).name!);
      }
      isLoading(false);
      // storyNotification((list1[0]).id);
      storyListNotification.refresh();
      allStoryListNotification.refresh();
    } else {
      isLoading(false);
    }
  }

  // fetchStoryData() async {
  //   isLoading(true);
  //   storyList = <StoryModel>[].obs;
  //   story("");
  //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection(KeyTable.storyList).get();
  //   if (querySnapshot.size > 0 && querySnapshot.docs.length > 0) {
  //     List<DocumentSnapshot> list1 = querySnapshot.docs;
  //     storyList = <StoryModel>[].obs;
  //     for (int i = 0; i < list1.length; i++) {
  //       storyList.add(StoryModel.fromFirestore(list1[i]));
  //     }
  //     isLoading(false);
  //     story((list1[0]).id);
  //     storyList.refresh();
  //   } else {
  //     isLoading(false);
  //   }
  // }

  fetchSliderData() async {
    sliderList = <String>[].obs;
    sliderIdList = <String>[].obs;
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection(KeyTable.sliderList).get();
    if (querySnapshot.size > 0 && querySnapshot.docs.length > 0) {
      List<DocumentSnapshot> list1 = querySnapshot.docs;
      List<DocumentSnapshot> sliderList1 = [];
      for (int i = 0; i < list1.length; i++) {
        sliderList1.add((list1[i]));
      }

      sliderList = <String>[].obs;
      sliderIdList = <String>[].obs;

      sliderList1.forEach((element) async {
        SliderModel sliderModel = SliderModel.fromFirestore(element);

        DocumentSnapshot? isExist = await FirebaseData.checkStoryExist(
            sliderModel.storyId!, KeyTable.storyList);

        if (isExist != null && isExist.exists) {
          bool isCatExist = await FirebaseData.checkCategoryExists(
              StoryModel.fromFirestore(isExist).refId!);

          if (isCatExist) {
            sliderList.add(sliderModel.storyId!);
            sliderList.refresh();
          }
          print("isCatExist----${isCatExist}");
        }
      });

      print("slider0-------${sliderList.length}");
      sliderList.refresh();
    }
  }

  fetchGenreData() async {
    isLoading(true);
    genreList = <Genre>[].obs;
    allGenreList = <String>[].obs;
    genre("");
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection(KeyTable.genreList).get();

    if (querySnapshot.size > 0 && querySnapshot.docs.length > 0) {
      List<DocumentSnapshot> list1 = querySnapshot.docs;
      genreList = <Genre>[].obs;
      for (int i = 0; i < list1.length; i++) {
        genreList.add(Genre.fromFirestore(list1[i]));
        allGenreList.add(Genre.fromFirestore(list1[i]).genre!);
      }
      isLoading(false);
      genre((list1[0]).id);
      genreList.refresh();
      allGenreList.refresh();
    } else {
      isLoading(false);
    }
  }

  // fetchUserData() async {
  //   isLoading(true);
  //   userList = <UserModel>[].obs;
  //   allUserList = <String>[].obs;
  //   user("");
  //   QuerySnapshot querySnapshot =
  //       await FirebaseFirestore.instance.collection(KeyTable.user).get();

  //   if (querySnapshot.size > 0 && querySnapshot.docs.length > 0) {
  //     List<DocumentSnapshot> list1 = querySnapshot.docs;
  //     userList = <UserModel>[].obs;
  //     for (int i = 0; i < list1.length; i++) {
  //       userList.add(UserModel.fromFirestore(list1[i]));
  //       allUserList.add(UserModel.fromFirestore(list1[i]).fullName);
  //     }
  //     isLoading(false);
  //     user((list1[0]).id);
  //     userList.refresh();
  //     allUserList.refresh();
  //   } else {
  //     isLoading(false);
  //   }
  // }
  Future<List<UserModel>> fetchUserData() async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Users') // Assuming the collection is named 'Users'
        .get();

    List<UserModel> users = querySnapshot.docs.map((doc) {
      return UserModel.fromFirestore(doc);
    }).toList();

    return users;
  } catch (e) {
    print('Error fetching user data: $e');
    return [];
  }
}
}
