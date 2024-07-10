import 'package:ebookadminpanel/controller/chat_controller.dart';
import 'package:ebookadminpanel/model/chat_model.dart';
import 'package:ebookadminpanel/model/user_model.dart';
import 'package:ebookadminpanel/theme/color_scheme.dart';
import 'package:ebookadminpanel/ui/chat/widgets/widgets.dart';
import 'package:ebookadminpanel/util/app_colors.dart';
import 'package:ebookadminpanel/util/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatCard extends StatelessWidget {
  final UserModel user;

  const ChatCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    ChatModel? _message;
    return Card(
      color: getCardColor(context),
      margin: EdgeInsets.symmetric(vertical: 4),
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
          onTap: () => Get.to(() => DetailChatScreen(user: user)),
          child: StreamBuilder(
              stream: ChatController.getLastMessage(user),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;
                final list =
                    data?.map((e) => ChatModel.fromJson(e.data())).toList() ??
                        [];
                if (list.isNotEmpty) {
                  _message = list[0];
                }
                return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: user.profilePicture.isNotEmpty
                          ? Image.network(
                              user.profilePicture,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/images/profile-placeholder.png',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                    ),
                    title: Text(
                      // 'udin',
                      user.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.body2Regular
                          .copyWith(color: getFontColor(context)),
                    ),
                    subtitle: Text(
                      _message != null
                          ? _message!.type == Type.image
                              ? 'Gambar'
                              : _message!.type == Type.file
                                  ? 'File'
                                  : _message!.msg
                          : 'Belum ada pesan.',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.body4Regular
                          .copyWith(color: getFontColor(context)),
                    ),
                    trailing: _message == null
                        ? null
                        : _message!.read.isEmpty &&
                                _message!.fromId != ChatController.user.uid
                            ? Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                    color: AppColors.second,
                                    borderRadius: BorderRadius.circular(10)),
                              )
                            : Text(
                                MyDateUtil.getLastMessageTime(
                                  context: context,
                                  time: _message!.sent,
                                ),
                                style: AppTextStyle.body3Regular,
                              ));
              })),
    );
  }
}
