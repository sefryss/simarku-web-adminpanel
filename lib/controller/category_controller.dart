
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ebookadminpanel/controller/home_controller.dart';
import 'package:ebookadminpanel/model/category_model.dart';
import '../ui/common/common.dart';
import 'data/FirebaseData.dart';
import 'data/key_table.dart';

class CategoryController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  Uint8List webImage = Uint8List(10);

  RxBool isImageOffline = false.obs;

  CategoryModel? categoryModel;
  RxBool isLoading = false.obs;

  String oldCategory = '';

  CategoryController({this.categoryModel});

  @override
  void onInit() {
    super.onInit();

    setAllCategoryDate(categoryModel);

    // if (categoryModel != null) {
    //
    //   // File file = new File((categoryModel!.image ?? "") as List<Object>);
    //   // String basename = basename(file.path);
    //
    //
    //   String fileName = categoryModel!.image!.split('%2F').last;
    //
    //   String file = fileName.split('?').first;
    //
    //   oldCategory = '';
    //   nameController.text = categoryModel!.name!;
    //   imageController.text = file;
    //   // imageController.text = categoryModel!.image!;
    //   oldCategory = nameController.text;
    // }
  }


  setAllCategoryDate(CategoryModel? category){


    if(category != null){

      categoryModel = category;

      if (categoryModel != null) {

        // File file = new File((categoryModel!.image ?? "") as List<Object>);
        // String basename = basename(file.path);


        String fileName = categoryModel!.image!.split('%2F').last;

        String file = fileName.split('?').first;

        oldCategory = '';
        nameController.text = categoryModel!.name!;
        imageController.text = file;
        // imageController.text = categoryModel!.image!;
        oldCategory = nameController.text;
      }


      // if (categoryModel != null) {
      //
      //   // File file = new File((categoryModel!.image ?? "") as List<Object>);
      //   // String basename = basename(file.path);
      //
      //   String fileName = categoryModel!.image!.split('%2F').last;
      //
      //   String file = fileName.split('?').first;
      //
      //   oldCategory = '';
      //   nameController.text = categoryModel!.name!;
      //   // colorController.text = categoryModel!.color!;
      //   imageController.text = file;
      //
      //   // imageController.text = categoryModel!.image!;
      //   oldCategory = nameController.text;
      //
      // }
    }
  }


  clearData(){
    nameController = TextEditingController();
    imageController = TextEditingController();
    webImage = Uint8List(10);

    isImageOffline.value = false;

    categoryModel = null;
    isLoading = false.obs;

    oldCategory = '';
  }



  bool isCheckAlreadyExistsOrNot(BuildContext context){
    HomeController homeController = Get.find();
    if(homeController.allCategoryList.length > 0  && homeController.allCategoryList.contains(nameController.text)){
      isLoading(false);

      showCustomToast(context: context, message: 'Already Exists..');
      return false;
    }else{
      return true;
    }
  }
  addCategory(BuildContext context, Function function) async {
    if (checkValidation(context)) {
      String url = await uploadFile(pickImage!);

      if (isCheckAlreadyExistsOrNot(context)) {
        CategoryModel firebaseHistory = new CategoryModel();
        firebaseHistory.name = nameController.text;
        firebaseHistory.image = url;
        firebaseHistory.refId = await FirebaseData.getCategoryRefId();

        FirebaseData.insertData(
            context: context,
            map: firebaseHistory.toJson(),
            tableName: KeyTable.keyCategoryTable,
            function: () {
              isLoading(false);
              function();
              FirebaseData.refreshCategoryData();
            });
      }



    }
  }

  bool checkValidation(BuildContext context) {
    if (isNotEmpty(nameController.text)) {
      if (isNotEmpty(imageController.text)) {


        if (!imageController.text.split(".").last.startsWith("svg")) {
          isLoading(true);
          return true;
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
    } else {
      showCustomToast(
          message: 'Enter name...', title: 'Error', context: context);
      return false;
    }
  }

  editCategory(BuildContext context, Function function) async {
    if (checkValidation(context)) {
      String url = imageController.text;

      if (imageController.text != categoryModel!.image!) {
        if(pickImage != null){
          url = await uploadFile(pickImage!);
        }
      }

      if (isCheckAlreadyExistsOrNot(context)) {
        categoryModel!.name = nameController.text;

        if(pickImage != null){
          print("called----if");
          categoryModel!.image = url;
        }else{

          print("called----else");
          categoryModel!.image = categoryModel!.image;
        }


        FirebaseData.updateData(
            context: context,
            map: categoryModel!.toJson(),
            tableName: KeyTable.keyCategoryTable,
            doc: categoryModel!.id!,
            function: () {
              isLoading(false);
              function();
              FirebaseData.refreshCategoryData();
            });
      }
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
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {
        print("complete=====true");
      // ignore: body_might_complete_normally_catch_error
      }).catchError((error) {
        print("error=====$error");
      });
      String url = await taskSnapshot.ref.getDownloadURL();
      print("complete=====$url");

      return url;
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

  XFile? pickImage;
  final picker = ImagePicker();
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
}
