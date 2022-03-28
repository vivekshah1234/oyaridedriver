import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:oyaridedriver/ApiServices/api_constant.dart';
import 'package:oyaridedriver/ApiServices/message_notification_api.dart';
import 'package:oyaridedriver/Common/all_colors.dart';
import 'package:oyaridedriver/Common/common_widgets.dart';
import 'firebase_chat.dart';

class ChatPage extends StatefulWidget {
  final String peerId;

  ChatPage({required this.peerId});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    getUserData();

    super.initState();
  }

  String profilePic = "";

  getUserData() async {
    print(widget.peerId);
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance.collection('users').doc(widget.peerId).get();
    nickname = documentSnapshot['nickname'];
    profilePic = documentSnapshot["photoUrl"];

    print("nickname===" + nickname);
    if (mounted) {
      setState(() {});
    }
  }

  String nickname = '';

  makeUserOnline() async {
    try {
      databaseMethods.changeUserStatus(isUserOnline: true);
    } catch (ex) {
      print("Error======$ex");
    }
  }

  @override
  Widget build(BuildContext context) {
    return nickname == ''
        ? Scaffold(backgroundColor: AllColors.whiteColor, body: Center(child: greenLoadingWidget()))
        : Scaffold(
            backgroundColor: AllColors.whiteColor,
            appBar: AppBar(
              leading: GestureDetector(
                  onTap: () async {
                    String userID = AppConstants.userID;
                    Navigator.pop(context);
                    try {
                      await FirebaseFirestore.instance.collection('users').doc(userID).update({'userStatus': 0});

                    } catch (ex) {
                      print("Error======$ex");
                    }

                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18.0),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: AllColors.blueColor,
                      size: 28,
                    ),
                  )),
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(profilePic),
                  ),
                  const SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textWidget(
                          txt: nickname == '' ? "User" : nickname,
                          bold: FontWeight.w700,
                          color: AllColors.blueColor,
                          fontSize: 20,
                          italic: false),
                     // SizedBox(height: 2,),
                      textWidget(
                          txt:"Active",
                          bold: FontWeight.w400,
                          color: AllColors.greyColor,
                          fontSize: 12,
                          italic: false),
                    ],
                  ),
                ],
              ),
              // centerTitle: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: ChatScreen(
              peerId: widget.peerId,
              nickName: nickname,
              peerProfilePic: profilePic,
            ),
          );
  }

  @override
  void dispose() {
    makeUserOffline();
    super.dispose();
  }

  DatabaseMethods databaseMethods = DatabaseMethods();

  makeUserOffline() {
    databaseMethods.changeUserStatus(isUserOnline: false);
  }
}

class ChatScreen extends StatefulWidget {
  final String peerId;

  final nickName;
  final String peerProfilePic;

  ChatScreen({required this.peerId, this.nickName, required this.peerProfilePic});

  // ChatScreen({Key key, @required this.peerId, this.nickName}) : super(key: key);

  @override
  State createState() => ChatScreenState(peerId: peerId);
}

class ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  ChatScreenState({required this.peerId});

  late String peerId;
  late String id;

  late List listMessage;
  late String groupChatId;

  // SharedPreferences prefs;

  var imageFile;
  late bool isLoading;
  late bool isShowSticker;

//  late String imageUrl;

  final TextEditingController textMessage = TextEditingController();
  final ScrollController listScrollController = ScrollController();

  late String firebaseToken;
  DatabaseMethods databaseMethods = DatabaseMethods();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    getFirebaseToken();

    groupChatId = '';

    isLoading = false;
    isShowSticker = false;
    readLocal();
  }

  getFirebaseToken() async {
    firebaseToken = await databaseMethods.getUserFirebaseToken(widget.peerId);
    setState(() {});
  }

  // void onFocusChange() {
  //   if (focusNode.hasFocus) {
  //     // Hide sticker when keyboard appear
  //     if (mounted) {
  //       setState(() {
  //         isShowSticker = false;
  //       });
  //     }
  //   }
  // }

  readLocal() async {
    id = AppConstants.userID;

    if (id.hashCode <= peerId.hashCode) {
      groupChatId = '$id-$peerId';
    } else {
      groupChatId = '$peerId-$id';
    }

    List<String> users = [AppConstants.fullName, widget.nickName];
    List<int> usersID = [int.parse(AppConstants.userID), int.parse(widget.peerId)];

    Map<String, dynamic> chatRoom = {
      "chatUsers": users,
      "chatRoomId": groupChatId,
      "chatUsersID": usersID,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
      'unReadMessageCountOfChat': 0,
      AppConstants.userID: 1,
      widget.peerId.toString(): 0
    };
    bool isChatExist = await databaseMethods.checkChatRoomExist(groupChatId);
    if (isChatExist == false) {
      databaseMethods.addChatRoom(chatRoom: chatRoom, chatRoomId: groupChatId);
    } else {
      databaseMethods.makeStatusOnline(groupChatId);

      databaseMethods.makeAllMessageSeen(groupChatId: groupChatId, userID: widget.peerId);
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    imageFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }
      // uploadFile();
    }
  }

  Future<void> onSendMessage(String content, int type) async {
    if (content.trim() != '') {
      databaseMethods.updateTimeStamp(groupChatId: groupChatId);

      FirebaseFirestore.instance.collection('messages').doc(groupChatId).get().then((value) {
        if (value.data()![AppConstants.userID] == 1 && value.data()![widget.peerId] == 1) {
          Map<String, dynamic> messageData = {
            'idFrom': id,
            'idTo': peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch,
            'content': content,
            'type': type,
            'isRead': true
          };
          //add message
          databaseMethods.addMessage(chatRoomId: groupChatId, chatMessageData: messageData);
        } else if (value.data()![widget.peerId] == 0) {
          print("user Offline");
          Map<String, dynamic> messageData = {
            'idFrom': id,
            'idTo': peerId,
            'timestamp': DateTime.now().millisecondsSinceEpoch,
            'content': content,
            'type': type,
            'isRead': false
          };
          //add message
          databaseMethods.addMessage(chatRoomId: groupChatId, chatMessageData: messageData);
          databaseMethods.addUnreadMessaged(chatRoomId: groupChatId, id: widget.peerId);
          //send notification
          sendPushMessage();
        }
      });

      isData = true;
      setState(() {});
      textMessage.clear();
      listScrollController.animateTo(0.0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(msg: "Please write a message.");
    }
  }

  Future<void> sendPushMessage() async {
    final response = await Messaging.sendTo(
        title: AppConstants.fullName+" sent you a message.",
        body: textMessage.text,
        id: int.parse(AppConstants.userID),
        fcmToken: firebaseToken);

    if (response.statusCode != 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('[${response.statusCode}] Error message: ${response.body}'),
      ));
    }
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    if (document['idFrom'] == id) {
      // Right (my message)
      return Align(
        // clipper: ChatBubbleClipper3(type: BubbleType.sendBubble),
        alignment: Alignment.centerRight,
        // margin: EdgeInsets.only(top: 20),
        // backGroundColor: Colors.red,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: 5,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  decoration: BoxDecoration(
                    color: AllColors.greenColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Text(
                    document['content'],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: AppConstants.profilePic != "profilePic"
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(AppConstants.profilePic),
                          radius: 10,
                        )
                      : CircleAvatar(
                          backgroundColor: AllColors.whiteColor,
                          child: Image.asset(
                            "imageUrl",
                            color: AllColors.redColor,
                            scale: 30,
                          ),
                          radius: 10,
                        ),
                )
              ],
            ),
            //textWidget(txt: document[""], fontSize: fontSize, color: color, bold: bold)
          ],
        ),
      );
    } else {
      // Left (peer message)
      return Align(
        alignment: Alignment.topLeft,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: widget.peerProfilePic != "profilePic"
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(widget.peerProfilePic),
                      radius: 10,
                    )
                  : CircleAvatar(
                      backgroundColor: AllColors.whiteColor,
                      child: Image.asset(
                        " ImageAssets.imageUrl",
                        color: AllColors.redColor,
                        scale: 30,
                      ),
                      radius: 10,
                    ),
            ),
            const SizedBox(
              width: 5,
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              decoration:  BoxDecoration(
                    color: Colors.grey.shade200,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  // bottomLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Text(
                document['content'],
                style: TextStyle(color: AllColors.blueColor),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            // List of messages
            buildListMessage(),

            // Input content
            buildInput(),
          ],
        ),

        // Loading
        buildLoading()
      ],
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading ? Center(child: greenLoadingWidget()) : Container(),
    );
  }

  Widget buildInput() {
    return SafeArea(
      child: Container(
        child: Row(
          children: <Widget>[
            // Button send image

            Flexible(
              child: Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: TextField(
                  style: TextStyle(color: AllColors.blueColor, fontWeight: FontWeight.bold, fontSize: 15.0),
                  controller: textMessage,
                  decoration: inputDecoration(
                      hintText: "Message",
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.send,
                          color: AllColors.greenColor,
                        ),
                        onPressed: () => onSendMessage(textMessage.text, 0),
                      )),
                  //focusNode: focusNode,
                ),
              ),
            ),
          ],
        ),
        width: double.infinity,
        padding: const EdgeInsets.all(5),
      ),
    );
  }

  bool isData = true;

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId == ''
          ? Center(child: greenLoadingWidget())
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .doc(groupChatId)
                  .collection(groupChatId)
                  .orderBy('timestamp', descending: true)
                  .limit(20)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: greenLoadingWidget());
                } else {
                  listMessage = snapshot.data!.docs;
                  if (listMessage.isEmpty) {
                    isData = false;
                  } else {
                    isData = true;
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(10.0),
                    itemBuilder: (context, index) => buildItem(index, snapshot.data!.docs[index]),
                    itemCount: snapshot.data!.docs.length,
                    reverse: true,
                    controller: listScrollController,
                  );
                }
              },
            ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    textMessage.clear();
    databaseMethods.makeStatusOffline(groupChatId);

    if (isData == false) {
      databaseMethods.deleteGroupChat(groupChatId);
    }
  }
}

InputDecoration inputDecoration({suffixIcon, required String hintText}) => InputDecoration(
    filled: true,
    suffixIcon: suffixIcon,
    border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.transparent)),
    enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15), borderSide: const BorderSide(color: Colors.transparent)),
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: AllColors.greenColor, width: 2)),
    hintText: hintText,
    //fillColor: AllColors.bgColorOFTextField,
    hintStyle: const TextStyle(color: AllColors.greyColor, fontSize: 14));
