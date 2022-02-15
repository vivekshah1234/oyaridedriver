import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';
import 'package:oyaridedriver/ApiServices/api_constant.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'package:oyaridedriver/Common/image_assets.dart';

import 'ChatUI/chat_screen.dart';
import 'ChatUI/firebase_chat.dart';
import 'drawer_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final double _mediumFont = 15.0;
  final double _smallFont = 12.0;
  final TextEditingController _txtSearch = TextEditingController();
  final OutlineInputBorder _border = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(
        color: Colors.transparent,
      ));

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  DatabaseMethods databaseMethods = DatabaseMethods();
  var id;
  late String name;

  @override
  void initState() {
    id = AppConstants.userID;
    name = AppConstants.fullName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: appBarWidget("Message", _scaffoldKey),
      drawer: const DrawerScreen(),
      body: StreamBuilder<QuerySnapshot>(
          stream: databaseMethods.getChatList(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            return Column(
              children: [
                snapshot.hasData
                    ? Expanded(
                        child: ListView.separated(
                            itemCount: snapshot.data!.docs.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return messageUserList(context, snapshot.data!.docs[index]);
                            },
                            separatorBuilder: (BuildContext con, int index) {
                              return Divider();
                            }))
                    : Container()
              ],
            );
          }),
    );
  }

  Widget messageUserList(BuildContext context, document) {
    return GestureDetector(
      onTap: (){
        Get.to(() => ChatPage(
          peerId: id == document['chatUsersID'][1].toString()
              ? document['chatUsersID'][0].toString()
              : document['chatUsersID'][1].toString(),
        ));
      },
      child: Container(
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade300))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
          child: ListTile(
            title: textWidget(
                txt: name == document['chatUsers'][1].toString()
                    ? document['chatUsers'][0].toString()
                    : document['chatUsers'][1].toString(),
                fontSize: 16,
                color: AllColors.blueColor,
                bold: FontWeight.w600, italic: false),
            subtitle: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("messages")
                    .doc(document['chatRoomId'])
                    .collection(document['chatRoomId'])
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  } else if (snapshot.hasData) {
                    return Text(snapshot.data!.docs.isEmpty ? "" : snapshot.data!.docs[0]["content"].toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:  TextStyle(
                          fontSize: 12,
                          color: AllColors.blueColor,
                          fontWeight: FontWeight.w300
                        ));
                  }
                  return Container();
                }),
            leading: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(document['chatUsersID'][0] == int.parse(AppConstants.userID)
                    ? document['chatUsersID'][1].toString()
                    : document['chatUsersID'][0].toString())
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Icon(Icons.person);
                  } else if (snapshot.hasData) {
                    //return Text(snapshot.data['nickname']);
                    return snapshot.data!['photoUrl'].toString().isEmpty ||
                        snapshot.data!['photoUrl'].toString() == "profilePic"
                        ? CircleAvatar(
                        radius: 23,
                        backgroundColor: AllColors.whiteColor,
                        child: Image.asset(
                          ImageAssets.chatIcon,
                          scale: 15,
                          color: AllColors.redColor,
                        ))
                        : CircleAvatar(
                      backgroundImage: NetworkImage(snapshot.data!['photoUrl']),
                      backgroundColor: AllColors.whiteColor,
                      radius: 23,
                    );
                  }
                  return const Icon(Icons.person);
                }),
            trailing: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("messages")
                  .doc(document['chatRoomId'])
                  .collection(document['chatRoomId'])
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot2) {
                if (snapshot2.hasError) {
                  return const Icon(Icons.person);
                } else if (snapshot2.hasData) {
                  return document['unReadMessageCountOfChat'] > 0 &&
                      snapshot2.data!.docs[0]["idTo"] == AppConstants.userID
                      ? CircleAvatar(
                    child: Text(
                      document['unReadMessageCountOfChat'].toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    radius: 14,
                    backgroundColor: AllColors.greyColor,
                  )
                      : Container(
                    width: 15,
                  );
                }
                return const Icon(Icons.person);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget searchTextField() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      height: 45,
      child: TextField(
        controller: _txtSearch,
        decoration: InputDecoration(
            hintText: "Search",
            filled: true,
            fillColor: Colors.white,
            focusedBorder: _border,
            enabledBorder: _border,
            border: _border,
            suffixIcon: Icon(
              Icons.search,
              color: Colors.grey.shade300,
            ),
            hintStyle: TextStyle(fontSize: _mediumFont, fontWeight: FontWeight.w600, color: AllColors.blackColor)),
      ),
    );
  }
}
