import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebookadminpanel/model/rate_us_model.dart';
import 'package:ebookadminpanel/ui/chat/subwidget/chat_web_widget.dart';
import 'package:ebookadminpanel/ui/chat/widgets/chat_card.dart';
import 'package:ebookadminpanel/ui/chat/widgets/detail_chat_screen.dart';
import 'package:ebookadminpanel/ui/rating/subwidget/rating_mobile_widget.dart';
import 'package:ebookadminpanel/util/common_blank_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ebookadminpanel/controller/data/FirebaseData.dart';
import 'package:ebookadminpanel/main.dart';
import 'package:ebookadminpanel/theme/color_scheme.dart';
import 'package:ebookadminpanel/ui/category/entries_drop_down.dart';
import 'package:ebookadminpanel/ui/common/common.dart';
import '../../../controller/data/key_table.dart';
import '../../../controller/home_controller.dart';
import '../../controller/data/LoginData.dart';
import '../../util/pref_data.dart';

class ChatScreen extends StatefulWidget {
  final Function function;

  ChatScreen({required this.function});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  RxInt position = 0.obs;

  RxInt totalItem = 10.obs;

  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();

    LoginData.getDeviceId();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController textEditingController = TextEditingController();
    RxString queryText = ''.obs;

    return SafeArea(
      child: CommonPage(
          widget: Container(
        margin: EdgeInsets.symmetric(
            horizontal: getDefaultHorSpace(context),
            vertical: getDefaultHorSpace(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getTextWidget(context, 'Pesan', 75, getFontColor(context),
                fontWeight: FontWeight.w700),
            getVerticalSpace(context, 35),
            Expanded(
                child: getCommonContainer(
                    context: context,
                    verSpace: 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        isWeb(context)
                            ? Container()
                            : Container(
                                // child: getEntryWidget(context),
                                // margin: EdgeInsets.only(top: 15.h),
                                ),
                        getVerticalSpace(context, 25),
                        Expanded(child: ChatWebWidget())
                      ],
                    )))
          ],
        ),
      )),
    );
  }
}
