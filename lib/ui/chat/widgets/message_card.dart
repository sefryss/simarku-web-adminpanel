import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ebookadminpanel/controller/chat_controller.dart';
import 'package:ebookadminpanel/model/chat_model.dart';
import 'package:ebookadminpanel/theme/color_scheme.dart';
import 'package:ebookadminpanel/ui/chat/widgets/widgets.dart';
import 'package:ebookadminpanel/util/app_colors.dart';
import 'package:ebookadminpanel/util/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';

class MessageCard extends StatefulWidget {
  final ChatModel message;
  const MessageCard({super.key, required this.message});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = ChatController.user.uid == widget.message.fromId;

    return InkWell(
      onLongPress: () {
        _showBottomSheet(isMe);
      },
      child: isMe ? _greenMessage(context) : _blueMessage(context),
    );
  }

  Widget _blueMessage(BuildContext context) {
    if (widget.message.read.isEmpty) {
      ChatController.updateMessageReadStatus(widget.message);
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.3,
            ),
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 51, 64, 62),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                  topLeft: Radius.circular(12),
                ),
              ),
              child: _buildMessageContent(),
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            children: [
              Text(
                MyDateUtil.getFormattedTime(
                    context: context, time: widget.message.sent),
                style: AppTextStyle.body4Regular.copyWith(
                  color: getFontColor(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _greenMessage(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.3,
            ),
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.second,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                  topLeft: Radius.circular(12),
                ),
              ),
              child: _buildMessageContent(),
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                MyDateUtil.getFormattedTime(
                    context: context, time: widget.message.sent),
                style: AppTextStyle.body4Regular.copyWith(
                  color: getFontColor(context),
                ),
              ),
              SizedBox(
                width: 2,
              ),
              Icon(
                Icons.done_all_rounded,
                color:
                    widget.message.read.isNotEmpty ? Colors.blue : Colors.grey,
                size: 20,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageContent() {
    if (widget.message.type == Type.text) {
      return Text(
        widget.message.msg,
        style: AppTextStyle.body3Regular.copyWith(color: AppColors.white),
      );
    } else if (widget.message.type == Type.image) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: CachedNetworkImage(
          imageUrl: widget.message.msg,
          fit: BoxFit.cover,
          placeholder: (context, url) => const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          errorWidget: (context, url, error) =>
              const Icon(Icons.image, size: 70),
        ),
      );
    } else if (widget.message.type == Type.file) {
      return _buildFileMessage();
    } else {
      return Container();
    }
  }

  Widget _buildFileMessage() {
    // Assuming the message.msg is the file URL and we can retrieve the file name
    final uri = Uri.parse(widget.message.msg);
    final fileNameEncoded = uri.pathSegments.last;
    final fileName = Uri.decodeFull(
        fileNameEncoded.split('/').last); // Get only the file name

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/pdf.png',
            height: 44,
            width: 32,
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  fileName,
                  style: AppTextStyle.body2Regular
                      .copyWith(color: AppColors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // bottom sheet for modifying message details
  void _showBottomSheet(bool isMe) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              //black divider
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(vertical: 16, horizontal: 150),
                decoration: BoxDecoration(
                    color: getFontColor(context),
                    borderRadius: BorderRadius.circular(8)),
              ),

              widget.message.type == Type.text
                  ? //copy option
                  _OptionItem(
                      color: getFontColor(context),
                      icon: const Icon(Icons.copy_all_rounded,
                          color: Colors.blue, size: 26),
                      name: 'Salin Pesan',
                      onTap: () async {
                        await Clipboard.setData(
                                ClipboardData(text: widget.message.msg))
                            .then((value) {
                          //for hiding bottom sheet
                          Navigator.pop(context);

                          Dialogs.showSnackbar(context, 'Text Copied!');
                        });
                      })
                  : widget.message.type == Type.file
                      ? //read file option
                      Container()
                      : //save image option
                      _OptionItem(
                          color: getFontColor(context),
                          icon: const Icon(Icons.download_rounded,
                              color: Colors.blue, size: 26),
                          name: 'Simpan Gambar',
                          onTap: () async {
                            try {
                              log('Image Url: ${widget.message.msg}');
                              await GallerySaver.saveImage(widget.message.msg,
                                      albumName: 'SiMarKu')
                                  .then((success) {
                                if (success != null && success) {
                                  // SMLoaders.successSnackBar(
                                  //     title: 'Berhasil',
                                  //     message: 'Gambar berhasil disimpan!');
                                }
                              });
                            } catch (e) {
                              log('ErrorWhileSavingImg: $e');
                            }
                          }),

              //separator or divider
              if (isMe)
                Divider(
                  color: getFontColor(context),
                  endIndent: 16,
                  indent: 16,
                ),

              //edit option
              if (widget.message.type == Type.text && isMe)
                _OptionItem(
                    color: getFontColor(context),
                    icon: const Icon(Icons.edit, color: Colors.blue, size: 26),
                    name: 'Edit Pesan',
                    onTap: () {
                      //for hiding bottom sheet
                      Navigator.pop(context);

                      _showMessageUpdateDialog();
                    }),

              //delete option
              if (isMe)
                _OptionItem(
                    color: getFontColor(context),
                    icon: const Icon(Icons.delete_forever,
                        color: Colors.red, size: 26),
                    name: 'Hapus Pesan',
                    onTap: () async {
                      await ChatController.deleteMessage(widget.message)
                          .then((value) {
                        //for hiding bottom sheet
                        Navigator.pop(context);
                      });
                    }),

              //separator or divider
              Divider(
                color: getFontColor(context),
                endIndent: 16,
                indent: 16,
              ),

              //sent time
              _OptionItem(
                  color: getFontColor(context),
                  icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
                  name:
                      'Dikirim: ${MyDateUtil.getMessageTime(context: context, time: widget.message.sent)}',
                  onTap: () {}),

              //read time
              _OptionItem(
                  color: getFontColor(context),
                  icon: const Icon(Icons.remove_red_eye, color: Colors.green),
                  name: widget.message.read.isEmpty
                      ? 'Dibaca: Belum dibaca'
                      : 'Dibaca: ${MyDateUtil.getMessageTime(context: context, time: widget.message.read)}',
                  onTap: () {}),
            ],
          );
        });
  }

  //dialog for updating message content
  void _showMessageUpdateDialog() {
    String updatedMsg = widget.message.msg;

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding:
                  EdgeInsets.only(left: 24, right: 24, top: 20, bottom: 10),

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),

              //title
              title: Row(
                children: [
                  Icon(
                    Icons.message,
                    color: AppColors.primary,
                    size: 28,
                  ),
                  Text(
                    ' Edit Pesan',
                    style: TextStyle(color: AppColors.primary),
                  )
                ],
              ),

              //content
              content: TextFormField(
                initialValue: updatedMsg,
                maxLines: null,
                onChanged: (value) => updatedMsg = value,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),

              //actions
              actions: [
                //cancel button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Batal',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    )),

                //update button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Navigator.pop(context);
                      ChatController.updateMessage(widget.message, updatedMsg);
                    },
                    child: const Text(
                      'Ubah',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ))
              ],
            ));
  }
}

//custom options card (for copy, edit, delete, etc.)
class _OptionItem extends StatelessWidget {
  final Icon icon;
  final Color color;
  final String name;
  final VoidCallback onTap;

  const _OptionItem(
      {required this.icon,
      required this.name,
      required this.onTap,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => onTap(),
        child: Padding(
          padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
          child: Row(children: [
            icon,
            Flexible(
                child: Text('    $name',
                    style: TextStyle(
                        fontSize: 15, color: color, letterSpacing: 0.5)))
          ]),
        ));
  }
}
