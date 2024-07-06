import 'dart:typed_data';
import 'package:ebookadminpanel/model/kegiatan_literasi_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ebookadminpanel/controller/home_controller.dart';
import '../ui/common/common.dart';
import 'data/FirebaseData.dart';
import 'data/key_table.dart';

class KegiatanLiterasiController extends GetxController {
  TextEditingController titleController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController sourceController = TextEditingController();
  TextEditingController dateStartController = TextEditingController();
  TextEditingController dateEndController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  Uint8List webImage = Uint8List(10);
  QuillController descController = QuillController.basic();

  RxBool isImageOffline = false.obs;

  KegiatanLiterasiModel? kegiatanLiterasiModel;
  HomeController? controller;
  RxBool isLoading = false.obs;
  // RxBool isFav = false.obs;
  RxBool activeStatus = true.obs;

  KegiatanLiterasiController({this.kegiatanLiterasiModel, this.controller});

  @override
  void onInit() {
    super.onInit();

    setAllKegiatanLiterasi(kegiatanLiterasiModel);
  }

  setAllKegiatanLiterasi(
    KegiatanLiterasiModel? kegiatanLiterasi,
  ) {
    if (kegiatanLiterasi != null) {
      kegiatanLiterasiModel = kegiatanLiterasi;

      if (kegiatanLiterasiModel != null) {
        String fileName = kegiatanLiterasiModel!.image!.split('%2F').last;

        String file = fileName.split('?').first;

        titleController.text = kegiatanLiterasiModel!.title!;
        imageController.text = file;
        sourceController.text = kegiatanLiterasiModel!.source!;
   dateStartController.text =
            kegiatanLiterasiModel!.dateStart!.toString(); // Update as per UI requirement
        dateEndController.text =
            kegiatanLiterasiModel!.dateEnd!.toString(); // Update as per UI requirement
        urlController.text = kegiatanLiterasiModel!.url!;
        activeStatus.value = kegiatanLiterasiModel!.isActive ?? true;
        if (kegiatanLiterasiModel!.desc != null &&
            kegiatanLiterasiModel!.desc!.isNotEmpty) {
          final doc = Document()
            ..insert(0, decode(kegiatanLiterasiModel!.desc ?? ""));

          descController = QuillController(
              document: doc, selection: TextSelection.collapsed(offset: 0));
        }
      }
    }
  }

  clearKegiatanLiterasiData() {
    titleController = TextEditingController();
    imageController = TextEditingController();
    webImage = Uint8List(10);
    sourceController = TextEditingController();
    dateStartController = TextEditingController();
    dateEndController = TextEditingController();
    urlController = TextEditingController();
    descController = QuillController.basic();
    isImageOffline.value = false;

    kegiatanLiterasiModel = null;
    isLoading = false.obs;
    activeStatus.value = true;

    // oldCategory = '';
  }

  addKegiatanLiterasi(BuildContext context, HomeController controller,
      Function function) async {
    if (checkValidation(context)) {
      String url = await uploadFile(pickImage!);

      KegiatanLiterasiModel firebaseHistory = new KegiatanLiterasiModel();
      firebaseHistory.title = titleController.text;
      firebaseHistory.image = url;
      firebaseHistory.source = sourceController.text;
      firebaseHistory.dateStart = dateStartController.text;
      firebaseHistory.dateEnd = dateEndController.text;
      firebaseHistory.desc =
          deltaToHtml(descController.document.toDelta().toJson());
      firebaseHistory.url = urlController.text;
      // firebaseHistory.isFav = false;
      firebaseHistory.isActive = activeStatus.value;

      FirebaseData.insertData(
          context: context,
          map: firebaseHistory.toJson(),
          tableName: KeyTable.kegiatanLiterasi,
          function: () {
            isLoading(false);
            function();
            clearKegiatanLiterasiData();
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
            message: 'Choose Image', title: 'Error', context: context);
        return false;
      }
    } else {
      showCustomToast(
          message: 'Enter name...', title: 'Error', context: context);
      return false;
    }
  }

  editKegiatanLiterasi(HomeController controller, BuildContext context,
      Function function) async {
    if (checkValidation(context)) {
      String url = imageController.text;

      if (imageController.text != kegiatanLiterasiModel!.image!) {
        if (pickImage != null) {
          url = await uploadFile(pickImage!);
        }
      }

      kegiatanLiterasiModel!.title = titleController.text;
      kegiatanLiterasiModel!.source = sourceController.text;
      kegiatanLiterasiModel!.dateStart = dateStartController.text;
      kegiatanLiterasiModel!.dateEnd = dateEndController.text;
      kegiatanLiterasiModel!.desc =
          deltaToHtml(descController.document.toDelta().toJson());
      kegiatanLiterasiModel!.url = urlController.text;
      kegiatanLiterasiModel!.isActive = activeStatus.value;

      if (pickImage != null) {
        print("called----if");
        kegiatanLiterasiModel!.image = url;
      } else {
        print("called----else");
        kegiatanLiterasiModel!.image = kegiatanLiterasiModel!.image;
      }

      FirebaseData.updateData(
          context: context,
          map: kegiatanLiterasiModel!.toJson(),
          tableName: KeyTable.kegiatanLiterasi,
          doc: kegiatanLiterasiModel!.id!,
          function: () {
            isLoading(false);
            function();
            clearKegiatanLiterasiData();
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
