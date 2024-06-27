import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebookadminpanel/model/user_model.dart';
import 'package:ebookadminpanel/theme/color_scheme.dart';
import 'package:ebookadminpanel/ui/chat/widgets/widgets.dart';
import 'package:ebookadminpanel/ui/common/common.dart';
import 'package:ebookadminpanel/util/app_colors.dart';
import 'package:ebookadminpanel/util/app_text_style.dart';
import 'package:ebookadminpanel/util/common_blank_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ebookadminpanel/controller/chat_controller.dart';

// ignore: must_be_immutable
class ChatWebWidget extends StatefulWidget {
  ChatWebWidget();

  @override
  State<ChatWebWidget> createState() => _ChatWebWidgetState();
}

class _ChatWebWidgetState extends State<ChatWebWidget> {
  final TextEditingController textEditingController = TextEditingController();
  RxString queryText = ''.obs;
  String _searchQuery = '';
  // for storing all users
  List<UserModel> _list = [];
  // for storing searched items
  List<UserModel> _searchList = [];
  // for storing search status
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // Add a listener to handle the search query changes
    textEditingController.addListener(_handleSearch);
    _fetchAllUsers();
  }

  @override
  void dispose() {
    textEditingController.removeListener(_handleSearch);
    textEditingController.dispose();
    super.dispose();
  }

  void _fetchAllUsers() async {
    final snapshot = await FirebaseFirestore.instance.collection('Users').get();
    setState(() {
      _list =
          snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList();
    });
  }

  void _handleSearch() {
    setState(() {
      _searchQuery = textEditingController.text.trim().toLowerCase();
      _isSearching = _searchQuery.isNotEmpty;

      if (_isSearching) {
        _searchList = _list.where((user) {
          return user.fullName.toLowerCase().contains(_searchQuery);
        }).toList();
      } else {
        _searchList.clear();
      }
    });
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
                child: Column(
                  children: [
                    getVerticalSpace(context, getCommonPadding(context)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        isWeb(context) ? Container() : Container(),
                        getHorizontalSpace(context, isWeb(context) ? 300 : 0),
                        Visibility(
                          child: Expanded(child: Container()),
                          visible: isWeb(context),
                        ),
                        Expanded(
                          child: getSearchTextFiledWidget(
                            context,
                            'Cari...',
                            textEditingController,
                          ),
                        ),
                        getHorizontalSpace(context, 15),
                        InkWell(
                          onTap: () {
                            _addChatUserDialog(context);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context)
                                  .primaryColor, // Change the color as needed
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors
                                  .white, // Change the icon color as needed
                            ),
                          ),
                        ),
                      ],
                    ),
                    getVerticalSpace(context, 35),
                    _isSearching && _searchList.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                              itemCount: _searchList.length,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return ChatCard(user: _searchList[index]);
                              },
                            ),
                          )
                        : _isSearching && _searchList.isEmpty
                            ? Center(
                                child: Text(
                                  'Tidak ada hasil untuk "$_searchQuery"',
                                  style:
                                      TextStyle(color: getFontColor(context)),
                                ),
                              )
                            : StreamBuilder(
                                stream: ChatController.getMyUsersId(),
                                builder: (context, snapshot) {
                                  switch (snapshot.connectionState) {
                                    //if data is loading
                                    case ConnectionState.waiting:
                                    case ConnectionState.none:
                                      return const Center(
                                          child: CircularProgressIndicator());

                                    //if some or all data is loaded then show it
                                    case ConnectionState.active:
                                    case ConnectionState.done:
                                      return StreamBuilder(
                                        stream: ChatController.getAllUsers(
                                            snapshot.data?.docs
                                                    .map((e) => e.id)
                                                    .toList() ??
                                                []),

                                        //get only those user, who's ids are provided
                                        builder: (context, snapshot) {
                                          switch (snapshot.connectionState) {
                                            //if data is loading
                                            case ConnectionState.waiting:
                                            case ConnectionState.none:
                                            // return const Center(
                                            //     child: CircularProgressIndicator());

                                            //if some or all data is loaded then show it
                                            case ConnectionState.active:
                                            case ConnectionState.done:
                                              final data = snapshot.data?.docs;
                                              _list = data
                                                      ?.map((e) =>
                                                          UserModel.fromJson(
                                                              e.data()))
                                                      .toList() ??
                                                  [];
                                              if (_list.isNotEmpty) {
                                                return Expanded(
                                                  child: ListView.builder(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 8),
                                                      itemCount: _isSearching
                                                          ? _searchList.length
                                                          : _list.length,
                                                      physics:
                                                          const BouncingScrollPhysics(),
                                                      itemBuilder:
                                                          (context, index) {
                                                        return ChatCard(
                                                            user: _isSearching
                                                                ? _searchList[
                                                                    index]
                                                                : _list[index]);
                                                      }),
                                                );
                                              } else {
                                                return const Center(
                                                  child: Text(
                                                      'Belum ada pesan!',
                                                      style: AppTextStyle
                                                          .body2Regular),
                                                );
                                              }
                                          }
                                        },
                                      );
                                  }
                                })
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // for adding new chat user
  void _addChatUserDialog(BuildContext context) {
    String fullName = '';

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),

              //title
              title: Row(
                children: [
                  Text(
                    'Tambah Pengguna',
                    style: AppTextStyle.body1Regular
                        .copyWith(color: getFontColor(context)),
                  )
                ],
              ),

              //content
              content: TextFormField(
                maxLines: null,
                onChanged: (value) => fullName = value,
                decoration: InputDecoration(
                    hintText: 'Nama Lengkap Pengguna',
                    hintStyle: AppTextStyle.body3Regular,
                    prefixIcon:
                        const Icon(Icons.people, color: AppColors.primary),
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
                    child: Text('Batal',
                        style: TextStyle(
                            color: getFontColor(context), fontSize: 16))),

                //add button
                MaterialButton(
                    onPressed: () async {
                      //hide alert dialog
                      Navigator.pop(context);
                      if (fullName.isNotEmpty) {
                        await ChatController.addChatUser(fullName)
                            .then((value) {
                          if (!value) {
                            Dialogs.showSnackbar(
                                context, 'Pengguna tidak ditemukan!');
                          }
                        });
                      }
                    },
                    child: Text(
                      'Tambah',
                      style:
                          TextStyle(color: getFontColor(context), fontSize: 16),
                    ))
              ],
            ));
  }
}
