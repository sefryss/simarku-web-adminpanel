import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ebookadminpanel/controller/home_controller.dart';
import 'package:ebookadminpanel/model/slider_model.dart';
import '../ui/common/common.dart';
import 'data/FirebaseData.dart';
import 'data/key_table.dart';

class HomeSliderController extends GetxController {

  TextEditingController imageController = TextEditingController();
  TextEditingController customImageController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  TextEditingController colorController = TextEditingController();

  Uint8List webImage = Uint8List(10);
  Uint8List webCustomImage = Uint8List(10);

  RxBool isImageOffline = false.obs;
  RxBool isImageOfflineCustom = false.obs;

  RxBool isLoading = false.obs;

  XFile? pickImage;
  XFile? customPickImage;
  final picker = ImagePicker();
  final customPicker = ImagePicker();

  bool isSvg = false;



  imgFromGallery() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

    pickImage = image;

    if (image != null) {

      String file = image.name.split(".").last;

      if(file == "svg"){
        isSvg = true;
      }

      imageController.text = pickImage!.name;
      var f = await pickImage!.readAsBytes();
      isImageOffline(false);
      webImage = f;
      isImageOffline(true);
    }
  }


  customImgFromGallery() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    customPickImage = image;
    if (image != null) {
      customImageController.text = customPickImage!.name;
      var f = await customPickImage!.readAsBytes();
      isImageOfflineCustom(false);
      webCustomImage = f;
      isImageOfflineCustom(true);
    }
  }


  bool checkValidation(BuildContext context) {
    if (isNotEmpty(imageController.text)) {


      if (!imageController.text.split(".").last.startsWith("svg")) {

        isLoading(true);
        return true;
        // if(isNotEmpty(colorController.text)){
        //   isLoading(true);
        //   return true;
        // }else{
        //   showCustomToast(
        //       message: 'Enter color...', title: 'Error', context: context);
        //   return false;
        // }
      }else{
        showCustomToast(
            message: 'svg image not supported', title: 'Error', context: context);
        return false;
      }


    } else {
      showCustomToast(
          message: 'Choose Image', title: 'Error', context: context);
      return false;
    }
  }



  bool checkCustomValidation(BuildContext context) {
    if(isNotEmpty(linkController.text) ){
    if(hasValidUrl(linkController.text) ){
      if (isNotEmpty(customImageController.text)) {
        isLoading(true);
        return true;
      } else {
        showCustomToast(
            message: 'Choose Image', title: 'Error', context: context);
        return false;
      }
    }else{
      showCustomToast(
          message: 'URl not valid...', title: 'Error', context: context);
      return false;
    }
    }else{
      showCustomToast(
          message: 'Enter link data...', title: 'Error', context: context);
      return false;
    }
  }

  addSlider(BuildContext context, HomeController controller,Function function) async {

    // isLoading(true);

    if(checkValidation(context)){
      if(!controller.sliderList.contains(controller.story.value)) {

        String url = imageController.text;

        String customUrl = "";

        if(customImageController.text.isNotEmpty){
          customUrl = await uploadFile(customPickImage!);
        }

        if(pickImage != null){
          url = await uploadFile(pickImage!);
        }

        SliderModel sliderModel = new SliderModel();

        sliderModel.index =
        await FirebaseData.getLastIndexFromSliderTable(KeyTable.sliderList);

        if(pickImage != null){
          sliderModel.image = url;
        }else{
          sliderModel.image = sliderModel.image;
          // sliderModel.image = imageController.text;
        }

        sliderModel.customImg = customUrl;
        sliderModel.link = linkController.text;
        sliderModel.color = colorController.text;
        sliderModel.storyId = controller.story.value;

        FirebaseData.insertData(
            context: context,
            map: sliderModel.toJson(),
            tableName: KeyTable.sliderList,
            function: () {
              isLoading(false);
              function();
              controller.fetchSliderData();
            });

      }else{

        isLoading(false);
        showCustomToast(context: context, message: 'Already Exists..');

      }
    }
  }

  addCustomSlider(BuildContext context, HomeController controller,Function function) async {

    // isLoading(true);

    if(checkCustomValidation(context)){



      String customUrl = "";

      if(customImageController.text.isNotEmpty){
        customUrl = await uploadFile(customPickImage!);
      }

      SliderModel sliderModel = new SliderModel();
      sliderModel.index =
      await FirebaseData.getLastIndexFromSliderTable(KeyTable.sliderList);



      sliderModel.image = "";


      sliderModel.customImg = customUrl;
      sliderModel.link = linkController.text;

      sliderModel.storyId = "";

      FirebaseData.insertData(
          context: context,
          map: sliderModel.toJson(),
          tableName: KeyTable.sliderList,
          function: () {
            isLoading(false);
            function();
            controller.fetchSliderData();
          });
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


  String getFileExtension(String fileName) {
    try {
      return "." + fileName.split('.').last;
    } catch (e) {
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

    // String url = await taskSnapshot.ref.fullPath;
    String url = await taskSnapshot.ref.getDownloadURL();

    print("url---------${url}");

    return url;
  }



}
