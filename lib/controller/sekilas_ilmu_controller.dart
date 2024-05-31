import 'dart:typed_data';
import 'package:ebookadminpanel/model/sekilas_info_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ebookadminpanel/controller/home_controller.dart';
import '../ui/common/common.dart';
import 'data/FirebaseData.dart';
import 'data/key_table.dart';

class SekilasInfoController extends GetxController {
  TextEditingController titleController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController sourceController = TextEditingController();
  Uint8List webImage = Uint8List(10);
  QuillController descController = QuillController.basic();

  RxBool isImageOffline = false.obs;

  SekilasInfoModel? sekilasInfoModel;
  HomeController? controller;
  RxBool isLoading = false.obs;
  RxBool isFav = false.obs;
  RxBool activeStatus = true.obs;

  SekilasInfoController({this.sekilasInfoModel, this.controller});

  @override
  void onInit() {
    super.onInit();

    setAllSekilasInfo(sekilasInfoModel);
  }

  setAllSekilasInfo(
    SekilasInfoModel? sekilasInfo,
  ) {
    if (sekilasInfo != null) {
      sekilasInfoModel = sekilasInfo;

      if (sekilasInfoModel != null) {
        // File file = new File((sekilasInfoModel!.image ?? "") as List<Object>);
        // String basename = basename(file.path);

        String fileName = sekilasInfoModel!.image!.split('%2F').last;

        String file = fileName.split('?').first;

        titleController.text = sekilasInfoModel!.title!;
        imageController.text = file;
        authorController.text = sekilasInfoModel!.author!;
        dateController.text = sekilasInfoModel!.date!;
        sourceController.text = sekilasInfoModel!.source!;
        activeStatus.value = sekilasInfoModel!.isActive ?? true;

        if (sekilasInfoModel!.desc != null &&
            sekilasInfoModel!.desc!.isNotEmpty) {
          // Delta delta = new Delta()..insert(decode(sekilasInfoModel!.desc!));
          // final doc = Document.fromDelta(delta);
          final doc = Document()
            ..insert(0, decode(sekilasInfoModel!.desc ?? ""));

          descController = QuillController(
              document: doc, selection: TextSelection.collapsed(offset: 0));
        }
      }
    }
  }

  clearSekilasInfoData() {
    titleController = TextEditingController();
    imageController = TextEditingController();
    webImage = Uint8List(10);
    authorController = TextEditingController();
    dateController = TextEditingController();
    sourceController = TextEditingController();
    descController = QuillController.basic();

    isImageOffline.value = false;

    sekilasInfoModel = null;
    isLoading = false.obs;
    activeStatus.value = true;

    // oldCategory = '';
  }

  // bool isCheckAlreadyExistsOrNot(BuildContext context) {
  //   HomeController homeController = Get.find();
  //   if (homeController.allSekilasInfoList.length > 0 &&
  //       homeController.allSekilasInfoList.contains(titleController.text)) {
  //     isLoading(false);

  //     showCustomToast(context: context, message: 'Already Exists..');
  //     return false;
  //   } else {
  //     return true;
  //   }
  // }

  addSekilasInfo(BuildContext context, HomeController controller,
      Function function) async {
    if (checkValidation(context)) {
      String url = await uploadFile(pickImage!);

      SekilasInfoModel firebaseHistory = new SekilasInfoModel();
      firebaseHistory.title = titleController.text;
      firebaseHistory.image = url;
      firebaseHistory.author = authorController.text;
      firebaseHistory.date = dateController.text;
      firebaseHistory.desc =
          deltaToHtml(descController.document.toDelta().toJson());
      firebaseHistory.source = sourceController.text;
      firebaseHistory.isFav = false;
      firebaseHistory.isActive = activeStatus.value;

      FirebaseData.insertData(
          context: context,
          map: firebaseHistory.toJson(),
          tableName: KeyTable.sekilasInfo,
          function: () {
            isLoading(false);
            function();
            clearSekilasInfoData();
          });
    }
  }

  bool checkValidation(BuildContext context) {
    if (isNotEmpty(titleController.text)) {
      if (isNotEmpty(imageController.text)) {
        if (!imageController.text.split(".").last.startsWith("svg")) {
          isLoading(true);
          return true;
        } else {
          showCustomToast(
              message: 'svg image not supported',
              title: 'Error',
              context: context);
          return false;
        }
      } else {
        showCustomToast(
            message: 'Pilih Gambar', title: 'Error', context: context);
        return false;
      }
    } else {
      showCustomToast(
          message: 'Masukkan Judul...', title: 'Error', context: context);
      return false;
    }
  }

  editSekilasInfo(HomeController controller, BuildContext context,
      Function function) async {
    if (checkValidation(context)) {
      String url = imageController.text;

      if (imageController.text != sekilasInfoModel!.image!) {
        if (pickImage != null) {
          url = await uploadFile(pickImage!);
        }
      }

      sekilasInfoModel!.title = titleController.text;
      sekilasInfoModel!.author = authorController.text;
      sekilasInfoModel!.date = dateController.text;
      sekilasInfoModel!.desc =
          deltaToHtml(descController.document.toDelta().toJson());
      sekilasInfoModel!.source = sourceController.text;
      sekilasInfoModel!.isActive = activeStatus.value;

      if (pickImage != null) {
        print("called----if");
        sekilasInfoModel!.image = url;
      } else {
        print("called----else");
        sekilasInfoModel!.image = sekilasInfoModel!.image;
      }

      FirebaseData.updateData(
          context: context,
          map: sekilasInfoModel!.toJson(),
          tableName: KeyTable.sekilasInfo,
          doc: sekilasInfoModel!.id!,
          function: () {
            isLoading(false);
            function();
            clearSekilasInfoData();
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

      if (file == "svg") {
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
