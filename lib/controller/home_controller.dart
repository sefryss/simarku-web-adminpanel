import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebookadminpanel/model/authors_model.dart';
import 'package:ebookadminpanel/model/genre_model.dart';
import 'package:ebookadminpanel/model/story_model.dart';
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
  StoryModel? storyModel = null;
  TopAuthors? authorModel = null;
  Genre? genreModel = null;
  UserModel? userModel = null;
  RxString slider = ''.obs;
  RxString author = ''.obs;
  RxString genre = ''.obs;
  RxString user = ''.obs;
  RxString story = ''.obs;
  RxString storyNotification = ''.obs;
  RxString pdf = Constants.physichBook.obs;

  Rx<BookType> bookType = BookType.ebook.obs;
  Rx<Category> category = Category.bebasBaca.obs;

  RxList<TopAuthors> authorList = <TopAuthors>[].obs;
  RxList<String> allAuthorList = <String>[].obs;
  RxList<Genre> genreList = <Genre>[].obs;
  RxList<String> allGenreList = <String>[].obs;
  RxList<UserModel> userList = <UserModel>[].obs;
  RxList<String> allUserList = <String>[].obs;
  RxList<StoryModel> storyList = <StoryModel>[].obs;
  RxList<StoryModel> storyListNotification = <StoryModel>[].obs;
  RxList<String> sliderList = <String>[].obs;
  RxList<String> allStoryList = <String>[].obs;
  RxList<String> allStoryListNotification = <String>[].obs;
  RxList<String> sliderIdList = <String>[].obs;
  RxBool isLoading = false.obs;

  List<String> pdfOptionList = [Constants.physichBook, Constants.file];
  List<Category> categoryList = Category.values;
  List<BookType> bookTypeList = BookType.values;

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
    fetchAuthorData();
    fetchStoryData();
    fetchSliderData();
    fetchGenreData();
    fetchUserData();
    fetchStoryDataForNotification();
  }

  fetchAuthorData() async {
    isLoading(true);
    authorList.clear();
    allAuthorList.clear();
    author("");
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection(KeyTable.authorList).get();

    if (querySnapshot.size > 0 && querySnapshot.docs.isNotEmpty) {
      List<DocumentSnapshot> list1 = querySnapshot.docs;
      for (var doc in list1) {
        var author = TopAuthors.fromFirestore(doc);
        authorList.add(author);
        allAuthorList.add(author.authorName!);
      }
      isLoading(false);
      author((list1[0]).id);
    } else {
      isLoading(false);
    }
  }

  fetchStoryData() async {
    isLoading(true);
    storyList.clear();
    allStoryList.clear();
    story("");
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection(KeyTable.storyList).get();

    if (querySnapshot.size > 0 && querySnapshot.docs.isNotEmpty) {
      List<DocumentSnapshot> list1 = querySnapshot.docs;
      for (var doc in list1) {
        var story = StoryModel.fromFirestore(doc);
        storyList.add(story);
        allStoryList.add(story.name!);
      }
      isLoading(false);
      story((list1[0]).id);
    } else {
      isLoading(false);
    }
  }

  fetchStoryDataForNotification() async {
    isLoading(true);
    storyListNotification.clear();
    allStoryListNotification.clear();
    storyNotification("");
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection(KeyTable.storyList).get();

    if (querySnapshot.size > 0 && querySnapshot.docs.isNotEmpty) {
      List<DocumentSnapshot> list1 = querySnapshot.docs;
      for (var doc in list1) {
        var story = StoryModel.fromFirestore(doc);
        storyListNotification.add(story);
        allStoryListNotification.add(story.name!);
      }
      isLoading(false);
    } else {
      isLoading(false);
    }
  }

  fetchSliderData() async {
    sliderList.clear();
    sliderIdList.clear();
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection(KeyTable.sliderList).get();
    if (querySnapshot.size > 0 && querySnapshot.docs.isNotEmpty) {
      List<DocumentSnapshot> list1 = querySnapshot.docs;
      for (var doc in list1) {
        var slider = SliderModel.fromFirestore(doc);

        var isExist = await FirebaseData.checkStoryExist(slider.storyId!, KeyTable.storyList);

        if (isExist != null && isExist.exists) {
          bool isCatExist = await FirebaseData.checkCategoryExists(
              StoryModel.fromFirestore(isExist).refId!);

          if (isCatExist) {
            sliderList.add(slider.storyId!);
          }
        }
      }
      sliderList.refresh();
    }
  }

  fetchGenreData() async {
    isLoading(true);
    genreList.clear();
    allGenreList.clear();
    genre("");
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection(KeyTable.genreList).get();

    if (querySnapshot.size > 0 && querySnapshot.docs.isNotEmpty) {
      List<DocumentSnapshot> list1 = querySnapshot.docs;
      for (var doc in list1) {
        var genre = Genre.fromFirestore(doc);
        genreList.add(genre);
        allGenreList.add(genre.genre!);
      }
      isLoading(false);
      genre((list1[0]).id);
    } else {
      isLoading(false);
    }
  }

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
