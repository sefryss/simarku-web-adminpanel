import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ebookadminpanel/model/app_detail_model.dart';

import '../ui/common/common.dart';
import 'data/FirebaseData.dart';
import 'data/key_table.dart';
import 'home_controller.dart';

class SettingController extends GetxController{
  TextEditingController appNameController = TextEditingController();
  TextEditingController appAdIdController = TextEditingController();
  TextEditingController iosAppAdIdController = TextEditingController();
  TextEditingController andBannerAdIdController = TextEditingController();
  TextEditingController iosBannerAdIdController = TextEditingController();
  TextEditingController andInterstitialAdIdController = TextEditingController();
  TextEditingController iosInterstitialAdIdController = TextEditingController();
  TextEditingController imageController = TextEditingController();



  TextEditingController termLinkController = TextEditingController();
  TextEditingController privacyLinkController = TextEditingController();
  QuillController aboutController = QuillController.basic();






  RxBool isImageOffline = false.obs;

  RxBool isLoading = false.obs;
  Uint8List webImage = Uint8List(10);

  XFile? pickImage;
  final picker = ImagePicker();
  FilePickerResult? result;


  AppDetailModel? appDetailModel;


  SettingController({this.appDetailModel});

  @override
  void onInit() {
    super.onInit();

    print("appModel-----${appDetailModel}");


    if (appDetailModel != null) {

      String fileName = appDetailModel!.image!.split('%2F').last;

      String file = fileName.split('?').first;


      print("appDetailModel-----${appDetailModel}");

      appNameController.text = appDetailModel!.name!;
      // imageController.text = appDetailModel!.image!;
      imageController.text = file;
      appAdIdController.text = appDetailModel!.adId!;


      termLinkController.text = appDetailModel!.terms!;
      privacyLinkController.text = appDetailModel!.privacyPolicy!;

      if(appDetailModel!.aboutUs != null&& appDetailModel!.aboutUs!.isNotEmpty){

        final doc = Document()..insert(0, decode(appDetailModel!.aboutUs ?? ""));

        // Delta delta = new Delta()..insert(decode(authorModel!.desc!));
        // final doc = Document.fromDelta(delta);
        aboutController = QuillController(document: doc, selection: TextSelection.collapsed(offset: 0));
      }

      // if(appDetailModel!.aboutUs!=null&& appDetailModel!.aboutUs!.isNotEmpty){
      //   Delta delta = new Delta()..insert(decode(appDetailModel!.aboutUs!));
      //   final doc = Document.fromDelta(delta);
      //   aboutController = QuillController(document: doc, selection: TextSelection.collapsed(offset: 0));
      // }
      iosAppAdIdController.text = appDetailModel!.iosAdId!;
      andBannerAdIdController.text = appDetailModel!.bannerAdId!;
      iosBannerAdIdController.text = appDetailModel!.iosBannerAdId!;
      andInterstitialAdIdController.text = appDetailModel!.interstitialAdId!;
      iosInterstitialAdIdController.text = appDetailModel!.iosInterstitialAdId!;




        // Delta delta = new Delta()..insert(storyModel!.desc);
        // final doc = Document.fromDelta(delta);
        // descController = QuillController(document: doc, selection: TextSelection.collapsed(offset: 0));

    }
  }

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

  // setSetting(BuildContext context, HomeController controller,
  //     Function function) async {
  //   if (checkValidation(context)) {
  //     String url ='';
  //     if(pickImage!=null){
  //       url = await uploadFile(pickImage!);
  //     }
  //   }
  // }


  bool checkValidation(BuildContext context) {
    if (isNotEmpty(termLinkController.text)) {
    if (isNotEmpty(appAdIdController.text)) {

    if (isNotEmpty(iosAppAdIdController.text)) {


      if (isNotEmpty(andBannerAdIdController.text)) {
      if (isNotEmpty(iosBannerAdIdController.text)) {
        if (isNotEmpty(andInterstitialAdIdController.text)) {
        if (isNotEmpty(iosInterstitialAdIdController.text)) {
          if (isNotEmpty(privacyLinkController.text)) {
            if (isNotEmpty(aboutController.plainTextEditingValue.text)) {
              // isLoading(true);
              return true;
            } else {
              showCustomToast(
                  message: 'Enter About us', title: 'Error', context: context);
              return false;
            }
          }else {
            showCustomToast(
                message: 'Enter Privacy policy',
                title: 'Error',
                context: context);
            return false;
          }
        }else{
          showCustomToast(
              message: 'Enter Interstitial ad id...',
              title: 'Error',
              context: context);
          return false;
        }
        } else {
          showCustomToast(
              message: 'Enter Interstitial ad id...',
              title: 'Error',
              context: context);
          return false;
        }
      }else{
        showCustomToast(
            message: 'Enter banner ad id...', title: 'Error', context: context);

        return false;
      }



      } else {
        showCustomToast(
            message: 'Enter banner ad id...', title: 'Error', context: context);

        return false;
      }




    }else{
      showCustomToast(
          message: 'Enter ios app ad id...', title: 'Error', context: context);

      return false;
    }
    }else{
      showCustomToast(
          message: 'Enter app ad id...', title: 'Error', context: context);

      return false;
    }
    } else {
      showCustomToast(
          message: 'Enter terms And Conditions...', title: 'Error', context: context);
      return false;
    }
  }

  Future<String> uploadFile(XFile _image) async {
    try {
      final fileBytes = await _image.readAsBytes();
      var reference =
      FirebaseStorage.instance.ref().child("appIcon/${_image.name}");

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

  // String quillDeltaToHtml(Delta delta) {
  //   final convertedValue = jsonEncode(delta.toJson());
  //   final markdown = deltaToMarkdown(convertedValue);
  //   final html = mark.markdownToHtml(markdown);
  //   return html;
  // }


  addDetail(BuildContext context, HomeController controller,
      Function function) async {
    if (checkValidation(context)) {
      String url = await uploadFile(pickImage!);

      AppDetailModel firebaseHistory = new AppDetailModel();
      firebaseHistory.name = appNameController.text;
      firebaseHistory.adId = appAdIdController.text;


      firebaseHistory.terms = termLinkController.text;
      firebaseHistory.privacyPolicy = privacyLinkController.text;

      firebaseHistory.aboutUs = deltaToHtml(aboutController.document.toDelta().toJson());
      // firebaseHistory.aboutUs = quillDeltaToHtml(aboutController.document.toDelta());



      firebaseHistory.iosAdId = iosAppAdIdController.text;
      firebaseHistory.image = url;
      firebaseHistory.bannerAdId = andBannerAdIdController.text;
      firebaseHistory.iosBannerAdId = iosBannerAdIdController.text;
      firebaseHistory.interstitialAdId = andInterstitialAdIdController.text;
      firebaseHistory.iosInterstitialAdId = iosInterstitialAdIdController.text;

      FirebaseData.insertData(
          context: context,
          map: firebaseHistory.toJson(),
          tableName: KeyTable.appDetail,
          function: () {
            isLoading(false);
            function();
          });
    }
  }


  editDetail(HomeController homeController,BuildContext context,Function function) async {

    if (checkValidation(context)) {

      String  url = imageController.text;


      if(imageController.text != appDetailModel!.image!){

        if(pickImage != null){
          url = await uploadFile(pickImage!);
        }

      }

      appDetailModel!.name = appNameController.text;

      if(pickImage != null){
        print("called----if");
        appDetailModel!.image = url;
      }else{

        print("called----else");
        appDetailModel!.image = appDetailModel!.image;
      }




      // appDetailModel!.image = url;



      appDetailModel!.adId =appAdIdController.text;


      appDetailModel!.terms = termLinkController.text;
      appDetailModel!.privacyPolicy = privacyLinkController.text;
      appDetailModel!.aboutUs = deltaToHtml(aboutController.document.toDelta().toJson());
      // appDetailModel!.aboutUs = quillDeltaToHtml(aboutController.document.toDelta());




      appDetailModel!.iosAdId =iosAppAdIdController.text;


      appDetailModel!.bannerAdId = andBannerAdIdController.text;
      appDetailModel!.iosBannerAdId = iosBannerAdIdController.text;
      appDetailModel!.interstitialAdId = andInterstitialAdIdController.text;
      appDetailModel!.iosInterstitialAdId = iosInterstitialAdIdController.text;

      FirebaseData.updateData(context: context,
          map: appDetailModel!.toJson(),
          tableName: KeyTable.appDetail,
          doc: appDetailModel!.id!,
          function: () {
            isLoading(false);
            function();
          });

    }
  }


}