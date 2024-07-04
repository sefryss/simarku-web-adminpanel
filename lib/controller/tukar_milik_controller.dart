import 'package:ebookadminpanel/controller/home_controller.dart';
import 'package:ebookadminpanel/model/tukar_milik_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TukarMilikController extends GetxController {
  TextEditingController receiverBook = TextEditingController();
  TextEditingController receiver = TextEditingController();
  TextEditingController senderBook = TextEditingController();
  TextEditingController sender = TextEditingController();
  TextEditingController status = TextEditingController();
  TextEditingController timestamp = TextEditingController();

  TukarMilikModel? tukarMilikModel;
  HomeController? homeController;
  RxBool isLoading = false.obs;

  TukarMilikController({this.tukarMilikModel, this.homeController});

  @override
  Future<void> onInit() async {
    super.onInit();
    setAllDataFromTukarMilikModel(tukarMilikModel!, homeController!);
  }

  Future<String> getUserName(String userId) async {
    var userDoc =
        await FirebaseFirestore.instance.collection('Users').doc(userId).get();
    return userDoc['FullName'];
  }

  Future<String> getBookName(String bookId) async {
    var bookDoc =
        await FirebaseFirestore.instance.collection('books').doc(bookId).get();
    return bookDoc['name'];
  }

  String formatTimestamp(Timestamp timestamp) {
    var date = timestamp.toDate();
    var formatter = DateFormat('d MMMM yyyy, hh.mm a', 'id_ID');
    return formatter.format(date);
  }

  setAllDataFromTukarMilikModel(
      TukarMilikModel? s, HomeController controller) async {
    print("called-----setData");
    homeController = controller;
    if (s != null) {
      tukarMilikModel = s;

      if (tukarMilikModel != null) {
        receiver.text = await getUserName(tukarMilikModel!.receiverId);
        receiverBook.text = await getBookName(tukarMilikModel!.receiverBookId);
        sender.text = await getUserName(tukarMilikModel!.senderId);
        senderBook.text = await getBookName(tukarMilikModel!.senderBookId);
        status.text = tukarMilikModel!.status;
        timestamp.text = formatTimestamp(tukarMilikModel!.timestamp);
      }
    }
  }

  void clearStoryData() {
    receiver = TextEditingController();
    sender = TextEditingController();
    senderBook = TextEditingController();
    receiverBook = TextEditingController();
    status = TextEditingController();
    timestamp = TextEditingController();
    homeController = null;
    isLoading.value = false;
  }

  void detailTukarPinjam(HomeController homeController, BuildContext context,
      Function function) async {
    tukarMilikModel!.receiverId = receiver.text;
    tukarMilikModel!.receiverBookId = receiverBook.text;
    tukarMilikModel!.senderId = sender.text;
    tukarMilikModel!.senderBookId = senderBook.text;
    tukarMilikModel!.status = status.text;
    //     tukarPinjamModel!.loanEndTime = loanEndTime.text;
    // tukarPinjamModel!.timestamp = timestamp.text.toString();
  }
}
