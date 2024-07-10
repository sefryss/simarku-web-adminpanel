
import 'package:ebookadminpanel/controller/chat_controller.dart';
import 'package:ebookadminpanel/model/chat_model.dart';
import 'package:ebookadminpanel/model/user_model.dart';
import 'package:ebookadminpanel/theme/color_scheme.dart';
import 'package:ebookadminpanel/ui/chat/widgets/widgets.dart';
import 'package:ebookadminpanel/ui/common/common.dart';
import 'package:ebookadminpanel/util/app_colors.dart';
import 'package:ebookadminpanel/util/app_text_style.dart';
import 'package:ebookadminpanel/util/common_blank_page.dart';
import 'package:flutter/material.dart';


class DetailChatScreen extends StatefulWidget {
  final UserModel user;
  const DetailChatScreen({
    super.key,
    required this.user,
  });

  @override
  State<DetailChatScreen> createState() => _DetailChatScreenState();
}

class _DetailChatScreenState extends State<DetailChatScreen> {
  List<ChatModel> _list = [];
  final _textController = TextEditingController();
  final ChatController _chatController = ChatController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CommonPage(
        widget: Material(
          child: Container(
            margin: EdgeInsets.symmetric(
                horizontal: getDefaultHorSpace(context),
                vertical: getDefaultHorSpace(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // getVerticalSpace(context, 35),
                Expanded(
                  child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: AppColors.primary,
                      automaticallyImplyLeading: false,
                      flexibleSpace: _appBar(widget.user),
                      toolbarHeight: 70,
                    ),
                    body: SafeArea(
                      child: Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: StreamBuilder(
                              stream:
                                  ChatController.getAllMessages(widget.user),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final data = snapshot.data?.docs;
                                  _list = data
                                          ?.map((e) =>
                                              ChatModel.fromJson(e.data()))
                                          .toList() ??
                                      [];
                                  if (_list.isNotEmpty) {
                                    return ListView.builder(
                                      reverse: true,
                                      physics: BouncingScrollPhysics(),
                                      itemCount: _list.length,
                                      itemBuilder: (context, index) {
                                        return MessageCard(
                                          message: _list[index],
                                        );
                                      },
                                    );
                                  } else {
                                    return Center(
                                      child: Text('Belum ada pesan.'),
                                    );
                                  }
                                } else if (snapshot.hasError) {
                                  return Center(
                                    child: Text('Error: ${snapshot.error}'),
                                  );
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            ),
                          ),
                          _chatInput(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar(UserModel user) {
    return SafeArea(
        child: StreamBuilder(
            stream: ChatController.getUserInfo(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => UserModel.fromJson(e.data())).toList() ?? [];

              return Row(
                children: [
                  // Sizebox
                  SizedBox(
                    width: 15,
                  ),
                  // User profile
                  ClipRRect(
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
                  SizedBox(
                    width: 10,
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        // 'Udin',
                        list.isNotEmpty
                            ? list[0].fullName
                            : widget.user.fullName,
                        style: AppTextStyle.body1Regular
                            .copyWith(color: AppColors.n1White),
                      ),
                      Text(
                        list.isNotEmpty
                            ? list[0].isOnline
                                ? 'Online'
                                : MyDateUtil.getLastActiveTime(
                                    context: context,
                                    lastActive: list[0].lastActive)
                            : MyDateUtil.getLastActiveTime(
                                context: context,
                                lastActive: widget.user.lastActive),
                        style: AppTextStyle.body4Regular
                            .copyWith(color: AppColors.n3white),
                      )
                    ],
                  ),
                ],
              );
            }));
  }

  // Bottom chat input field
  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: Row(
        children: [
          // Input field & buttons
          Expanded(
            child: Card(
              color: getCardColor(context),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        _showModalBottomSheet(context);
                      },
                      icon: const Icon(Icons.attach_file_rounded,
                          color: AppColors.second, size: 25)),

                  Expanded(
                      child: TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onTap: () {},
                    decoration: const InputDecoration(
                        hintText: 'Ketik Pesan',
                        hintStyle: TextStyle(color: AppColors.grey),
                        border: InputBorder.none),
                  )),

                  // Adding some space
                  SizedBox(width: 8),
                ],
              ),
            ),
          ),

          // Send message button
          MaterialButton(
            onPressed: () async {
              if (_textController.text.isNotEmpty) {
                if (_list.isEmpty) {
                  //on first message (add user to my_user collection of chat user)
                  ChatController.sendFirstMessage(
                      widget.user, _textController.text, Type.text);
                } else {
                  //simply send message
                  ChatController.sendMessage(
                      widget.user, _textController.text, Type.text);
                }
                _textController.text = '';
              }
            },
            minWidth: 0,
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: const CircleBorder(),
            color: AppColors.primary,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Icon(Icons.send, color: Colors.white, size: 24),
            ),
          )
        ],
      ),
    );
  }

  void _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.neutral09,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildBottomSheetIcon(context, Icons.insert_drive_file,
                      "Dokumen", Colors.indigo, () async {
                    await _chatController.openFile(widget.user);
                  }),
                  _buildBottomSheetIcon(
                    context,
                    Icons.photo,
                    "Galeri",
                    Colors.purpleAccent,
                    () async {
                      await _chatController.pickImages(widget.user);
                    },
                  ),
                ],
              ),
              SizedBox(height: 50),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomSheetIcon(BuildContext context, IconData icon,
      String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: color,
            radius: 28,
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          SizedBox(height: 5),
          Text(label, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
