import 'package:ebookadminpanel/controller/home_controller.dart';
import 'package:ebookadminpanel/model/tukar_pinjam_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TukarPinjamController extends GetxController {
  TextEditingController loanDuration = TextEditingController();
  TextEditingController receiverBook = TextEditingController();
  TextEditingController receiver = TextEditingController();
  TextEditingController senderBook = TextEditingController();
  TextEditingController sender = TextEditingController();
  TextEditingController loanEndTime = TextEditingController();
  TextEditingController status = TextEditingController();
  TextEditingController timestamp = TextEditingController();

  TukarPinjamModel? tukarPinjamModel;
  HomeController? homeController;
  RxBool isLoading = false.obs;

  TukarPinjamController({this.tukarPinjamModel, this.homeController});

  @override
  Future<void> onInit() async {
    super.onInit();
    setAllDataFromTukarPinjamModel(tukarPinjamModel!, homeController!);
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

  setAllDataFromTukarPinjamModel(
      TukarPinjamModel? s, HomeController controller) async {
    print("called-----setData");
    homeController = controller;
    if (s != null) {
      tukarPinjamModel = s;

      if (tukarPinjamModel != null) {
        receiver.text = await getUserName(tukarPinjamModel!.receiverId);
        receiverBook.text = await getBookName(tukarPinjamModel!.receiverBookId);
        sender.text = await getUserName(tukarPinjamModel!.senderId);
        senderBook.text = await getBookName(tukarPinjamModel!.senderBookId);
        loanDuration.text = tukarPinjamModel!.loanDuration;
        status.text = tukarPinjamModel!.status;
        loanEndTime.text = formatTimestamp(tukarPinjamModel!.loanEndTime);
        timestamp.text = formatTimestamp(tukarPinjamModel!.timestamp);
      }
    }
  }

  void clearStoryData() {
    receiver = TextEditingController();
    sender = TextEditingController();
    senderBook = TextEditingController();
    receiverBook = TextEditingController();
    loanDuration = TextEditingController();
    loanEndTime = TextEditingController();
    status = TextEditingController();
    timestamp = TextEditingController();
    homeController = null;
    isLoading.value = false;
  }

  void detailTukarPinjam(HomeController homeController, BuildContext context,
      Function function) async {
    tukarPinjamModel!.receiverId = receiver.text;
    tukarPinjamModel!.receiverBookId = receiverBook.text;
    tukarPinjamModel!.senderId = sender.text;
    tukarPinjamModel!.senderBookId = senderBook.text;
    tukarPinjamModel!.loanDuration = loanDuration.text;
    tukarPinjamModel!.status = status.text;
    //     tukarPinjamModel!.loanEndTime = loanEndTime.text;
    // tukarPinjamModel!.timestamp = timestamp.text.toString();
  }
}
