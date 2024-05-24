import 'package:ebookadminpanel/model/genre_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ebookadminpanel/controller/home_controller.dart';
import '../ui/common/common.dart';
import 'data/FirebaseData.dart';
import 'data/key_table.dart';

class GenreController extends GetxController {
  Genre? genreModel;
  HomeController? controller;

  GenreController({this.genreModel, this.controller});

  TextEditingController genreNameController = TextEditingController();

  final document = "text";

  RxBool isLoading = false.obs;
  RxBool activeStatus = true.obs;

  @override
  void onInit() {
    super.onInit();

    setAllDataFromGenreModel(genreModel, true);
  }

  bool isStatus = true;

  setAllDataFromGenreModel(Genre? a, bool status) {
    isStatus = status;

    if (a != null) {
      genreModel = a;

      if (genreModel != null) {
        print("status----${activeStatus.value}");

        genreNameController.text = genreModel!.genre ?? "";
        activeStatus.value = genreModel!.isActive ?? true;
        print("status----${activeStatus.value}");
      }
    }
  }

  clearGenreData() {
    genreModel = null;
    controller = null;

    genreNameController = TextEditingController();

    isLoading.value = false;
    activeStatus.value = true;
  }

  addGenre(BuildContext context, HomeController controller,
      Function function) async {
    if (checkValidation(context)) {
      // String url = await uploadFile(pickImage!);
      // String audioUrl = await uploadAudio();

      Genre firebaseHistory = new Genre();
      firebaseHistory.genre = genreNameController.text;
      firebaseHistory.refId = await FirebaseData.getGenreRefId();
      firebaseHistory.index = await FirebaseData.getLastIndexFromGenreTable();
      firebaseHistory.isActive = activeStatus.value;
      // firebaseHistory.views = 0;
      // firebaseHistory.isBookmark = false;
      // firebaseHistory.isFav = false;

      FirebaseData.insertData(
          context: context,
          map: firebaseHistory.toJson(),
          tableName: KeyTable.genreList,
          function: () {
            // removeAllField(context);
            isLoading(false);
            function();
            clearGenreData();
          });
    }
  }

  bool checkValidation(BuildContext context) {
    if (isNotEmpty(genreNameController.text)) {
      isLoading(true);
      return true;
    } else {
      showCustomToast(
          message: 'Masukkan Genre...', title: 'Error', context: context);
      return false;
    }
  }

  // String quillDeltaToHtml(Delta delta) {
  //   final convertedValue = jsonEncode(delta.toJson());
  //   final markdown = deltaToMarkdown(convertedValue);
  //   final html = mark.markdownToHtml(markdown);
  //   return html;
  // }

  removeAllField(BuildContext context) {
    genreNameController.text = "";
  }

  editGenre(HomeController homeController, BuildContext context,
      Function function) async {
    if (checkValidation(context)) {
      genreModel!.genre = genreNameController.text;
      genreModel!.isActive = activeStatus.value;

      FirebaseData.updateData(
          context: context,
          map: genreModel!.toJson(),
          tableName: KeyTable.genreList,
          doc: genreModel!.id!,
          function: () {
            isLoading(false);
            function();
            clearGenreData();
          });
    }
  }
}
