// ignore_for_file: unused_field
import 'package:ebookadminpanel/ui/chat/subwidget/chat_web_widget.dart';
import 'package:ebookadminpanel/util/common_blank_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ebookadminpanel/theme/color_scheme.dart';
import 'package:ebookadminpanel/ui/common/common.dart';
import '../../controller/data/LoginData.dart';

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
