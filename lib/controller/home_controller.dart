import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebookadminpanel/model/admin_model.dart';
import 'package:ebookadminpanel/model/authors_model.dart';
import 'package:ebookadminpanel/model/donation_book_model.dart';
import 'package:ebookadminpanel/model/feedback_model.dart';
import 'package:ebookadminpanel/model/genre_model.dart';
import 'package:ebookadminpanel/model/kegiatan_literasi_model.dart';
import 'package:ebookadminpanel/model/rate_us_model.dart';
import 'package:ebookadminpanel/model/sekilas_info_model.dart';
import 'package:ebookadminpanel/model/story_model.dart';
import 'package:ebookadminpanel/model/tukar_milik_model.dart';
import 'package:ebookadminpanel/model/user_model.dart';
import 'package:get/get.dart';
import 'package:ebookadminpanel/controller/data/FirebaseData.dart';
import 'package:ebookadminpanel/model/slider_model.dart';
import 'package:ebookadminpanel/util/constants.dart';
import '../ui/home/home_page.dart';
import 'data/key_table.dart';

class HomeController extends GetxController {
  FeedbackModel? feedbackModel = null;
  TukarMilikModel? tukarMilikModel = null;
  RateUsModel? rateUsModel = null;
  StoryModel? storyModel = null;
  DonationBookModel? donationBookModel = null;
  TopAuthors? authorModel = null;
  Genre? genreModel = null;
  SekilasInfoModel? sekilasInfoModel = null;
  KegiatanLiterasiModel? kegiatanLiterasiModel = null;
  UserModel? userModel = null;
  RxString slider = ''.obs;
  RxString author = ''.obs;
  RxString genre = ''.obs;
  RxString sekilasInfo = ''.obs;
  RxString kegiatanLiterasi = ''.obs;
  RxString user = ''.obs;
  RxString story = ''.obs;
  RxString feedback = ''.obs;
  RxString tukarMilik = ''.obs;
  RxString donationBook = ''.obs;
  RxString rateUs = ''.obs;
  RxString storyNotification = ''.obs;
  RxString pdf = Constants.file.obs;

  Rx<BookType> bookType = BookType.ebook.obs;
  Rx<DonationBookType> donationBookType = DonationBookType.ebook.obs;
  Rx<Category> category = Category.bebasBaca.obs;
// Rx<AdminModel> adminModel = AdminModel().obs;
  RxList<TopAuthors> authorList = <TopAuthors>[].obs;
  RxList<String> allAuthorList = <String>[].obs;
  RxList<Genre> genreList = <Genre>[].obs;
  RxList<String> allGenreList = <String>[].obs;
  RxList<SekilasInfoModel> sekilasInfoList = <SekilasInfoModel>[].obs;
  RxList<KegiatanLiterasiModel> kegiatanLiterasiList =
      <KegiatanLiterasiModel>[].obs;
  RxList<String> allSekilasInfoList = <String>[].obs;
  RxList<String> allKegiatanLiterasiList = <String>[].obs;
  RxList<UserModel> userList = <UserModel>[].obs;
  RxList<String> allUserList = <String>[].obs;
  RxList<StoryModel> storyList = <StoryModel>[].obs;
  RxList<DonationBookModel> donationBookList = <DonationBookModel>[].obs;
  RxList<FeedbackModel> feedbackList = <FeedbackModel>[].obs;
  RxList<RateUsModel> ratingList = <RateUsModel>[].obs;
  RxList<TukarMilikModel> tukarMilikList = <TukarMilikModel>[].obs;
  RxList<StoryModel> storyListNotification = <StoryModel>[].obs;
  RxList<String> sliderList = <String>[].obs;
  RxList<String> allStoryList = <String>[].obs;
  RxList<String> allDonationBookList = <String>[].obs;
  RxList<String> allFeedbackList = <String>[].obs;
  RxList<String> allRateUsList = <String>[].obs;
  RxList<String> allTukarMilikList = <String>[].obs;
  RxList<String> allStoryListNotification = <String>[].obs;
  RxList<String> sliderIdList = <String>[].obs;
  RxBool isLoading = false.obs;
  List<Category> categoryList = Category.values;
  List<BookType> bookTypeList = BookType.values;
  List<DonationBookType> donationBookTypeList = DonationBookType.values;

  setStoryModel(StoryModel storyModel) {
    this.storyModel = storyModel;
    changeAction(actionEditStory);
  }

  setDonationBookModel(DonationBookModel donationBookModel) {
    this.donationBookModel = donationBookModel;
    changeAction(actionEditDonationBook);
  }

  setAuthorModel(TopAuthors authorModel) {
    this.authorModel = authorModel;
    changeAction(actionEditAuthor);
  }

  setGenreModel(Genre genreModel) {
    this.genreModel = genreModel;
    changeAction(actionEditGenre);
  }

  setSekilasInfoModel(SekilasInfoModel sekilasInfoModel) {
    this.sekilasInfoModel = sekilasInfoModel;
    changeAction(actionEditSekilasInfo);
  }

  setKegiatanLiterasiModel(KegiatanLiterasiModel kegiatanLiterasiModel) {
    this.kegiatanLiterasiModel = kegiatanLiterasiModel;
    changeAction(actionEditKegiatanLiterasi);
  }

  setFeedbackModel(FeedbackModel feedbackModel) {
    this.feedbackModel = feedbackModel;
    changeAction(actionEditFeedback);
  }

  setRateUsModel(RateUsModel rateUsModel) {
    this.rateUsModel = rateUsModel;
    changeAction(actionEditRating);
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
    fetchSekilasInfoData();
    fetchKegiatanLiterasiData();
    fetchUserData();
    fetchStoryDataForNotification();
    fetchDonationBook();
    fetchFeedback();
    fetchRating();
    fetchTukarMilik();
    // fetchAdminData();
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

        var isExist = await FirebaseData.checkStoryExist(
            slider.storyId!, KeyTable.storyList);

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

  fetchSekilasInfoData() async {
    isLoading(true);
    sekilasInfoList.clear();
    allSekilasInfoList.clear();
    sekilasInfo("");
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection(KeyTable.sekilasInfo).get();

    if (querySnapshot.size > 0 && querySnapshot.docs.isNotEmpty) {
      List<DocumentSnapshot> list1 = querySnapshot.docs;
      for (var doc in list1) {
        var sekilasInfo = SekilasInfoModel.fromFirestore(doc);
        sekilasInfoList.add(sekilasInfo);
        allSekilasInfoList.add(sekilasInfo.title!);
      }
      isLoading(false);
      sekilasInfo((list1[0]).id);
    } else {
      isLoading(false);
    }
  }

  fetchKegiatanLiterasiData() async {
    isLoading(true);
    kegiatanLiterasiList.clear();
    allKegiatanLiterasiList.clear();
    kegiatanLiterasi("");
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(KeyTable.kegiatanLiterasi)
        .get();

    if (querySnapshot.size > 0 && querySnapshot.docs.isNotEmpty) {
      List<DocumentSnapshot> list1 = querySnapshot.docs;
      for (var doc in list1) {
        var kegiatanLiterasi = KegiatanLiterasiModel.fromFirestore(doc);
        kegiatanLiterasiList.add(kegiatanLiterasi);
        allKegiatanLiterasiList.add(kegiatanLiterasi.title!);
      }
      isLoading(false);
      kegiatanLiterasi((list1[0]).id);
    } else {
      isLoading(false);
    }
  }

  // void fetchAdminData() async {
  //   try {
  //     // Mengambil data admin dari koleksi "adminData" dengan dokumen tertentu
  //     var snapshot = await FirebaseFirestore.instance.collection('Users').doc('cTO8ePjRXqTyUB7TVxFK').get();
      
  //     if (snapshot.exists) {
  //       // Jika dokumen ada, update nilai adminModel
  //       adminModel.value = AdminModel.fromFirestore(snapshot);
  //     } else {
  //       // Jika dokumen tidak ditemukan, bisa lakukan penanganan error atau default value
  //       print('Dokumen tidak ditemukan');
  //     }
  //   } catch (e) {
  //     // Tangani error jika terjadi masalah saat mengambil data
  //     print('Error fetching admin data: $e');
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

  fetchDonationBook() async {
    isLoading(true);
    donationBookList.clear();
    allDonationBookList.clear();
    donationBook("");
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection(KeyTable.donationBook)
        .get();

    if (querySnapshot.size > 0 && querySnapshot.docs.isNotEmpty) {
      List<DocumentSnapshot> list1 = querySnapshot.docs;
      for (var doc in list1) {
        var donationBook = DonationBookModel.fromFirestore(doc);
        donationBookList.add(donationBook);
        allDonationBookList.add(donationBook.name!);
      }
      isLoading(false);
      donationBook((list1[0]).id);
    } else {
      isLoading(false);
    }
  }

  fetchFeedback() async {
    isLoading(true);
    feedbackList.clear();
    allFeedbackList.clear();
    feedback("");
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection(KeyTable.feedback).get();

    if (querySnapshot.size > 0 && querySnapshot.docs.isNotEmpty) {
      List<DocumentSnapshot> list1 = querySnapshot.docs;
      for (var doc in list1) {
        var feedback = FeedbackModel.fromFirestore(doc);
        feedbackList.add(feedback);
        allFeedbackList.add(feedback.userName!);
      }
      isLoading(false);
      feedback((list1[0]).id);
    } else {
      isLoading(false);
    }
  }

  fetchRating() async {
    isLoading(true);
    ratingList.clear();
    allRateUsList.clear();
    rateUs("");
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection(KeyTable.rating).get();

    if (querySnapshot.size > 0 && querySnapshot.docs.isNotEmpty) {
      List<DocumentSnapshot> list1 = querySnapshot.docs;
      for (var doc in list1) {
        var rating = RateUsModel.fromFirestore(doc);
        ratingList.add(rating);
        allRateUsList.add(rating.userName!);
      }
      isLoading(false);
      rateUs((list1[0]).id);
    } else {
      isLoading(false);
    }
  }

  fetchTukarMilik() async {
    isLoading(true);
    tukarMilikList.clear();
    allTukarMilikList.clear();
    tukarMilik("");
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection(KeyTable.tukarMilik).get();

    if (querySnapshot.size > 0 && querySnapshot.docs.isNotEmpty) {
      List<DocumentSnapshot> list1 = querySnapshot.docs;
      for (var doc in list1) {
        var tukarMilik = TukarMilikModel.fromFirestore(doc);
        tukarMilikList.add(tukarMilik);
        allTukarMilikList.add(tukarMilik.senderBookId!);
      }
      isLoading(false);
      tukarMilik((list1[0]).id);
    } else {
      isLoading(false);
    }
  }
}
