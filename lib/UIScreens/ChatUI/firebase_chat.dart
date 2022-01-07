import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:oyaridedriver/ApiServices/api_constant.dart';
class DatabaseMethods {
  Future<void> addUserInfo(
      {required String docId, required Map<String, dynamic> userData}) async {
    try {
      FirebaseFirestore.instance
          .collection("users")
          .doc(docId)
          .set(userData)
          .catchError((e) {
        print(e.toString());
      });
    } catch (ex) {
      print("Error::$ex");
    }
  }

  getUserInfo({required int id}) {
    return FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: id.toInt())
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  addChatRoom(
      {required Map<String, dynamic> chatRoom, required String chatRoomId}) {
    try {
      FirebaseFirestore.instance
          .collection("messages")
          .doc(chatRoomId)
          .set(chatRoom)
          .catchError((e) {
        print(e);
      });
    } catch (ex) {
      print("Error::$ex");
    }
  }

  getChatList() {
    return FirebaseFirestore.instance
        .collection("messages")
        .where('chatUsersID', arrayContains: int.parse(AppConstants.userID))
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  addMessage(
      {required String chatRoomId,
        required Map<String, dynamic> chatMessageData}) {
    try {
      FirebaseFirestore.instance
          .collection("messages")
          .doc(chatRoomId)
          .collection(chatRoomId)
          .add(chatMessageData)
          .catchError((e) {
        print(e.toString());
      });
    } catch (ex) {
      print("Error::$ex");
    }
  }

  updateTimeStamp({required String groupChatId}) {
    try {
      FirebaseFirestore.instance
          .collection("messages")
          .doc(groupChatId)
          .update({'createdAt': DateTime.now().millisecondsSinceEpoch});
    } catch (ex) {
      print("Error::$ex");
    }
  }



  changeUserStatus({required bool isUserOnline}) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(AppConstants.userID)
          .update({'userStatus': isUserOnline ? 1 : 0});
    } catch (ex) {
      print("Error::$ex");
    }
  }

  deleteGroupChat(String groupChatId) {
    try {
      FirebaseFirestore.instance
          .collection("messages")
          .doc(groupChatId)
          .delete();
    }catch (ex) {
      print("Error::$ex");
    }
  }

  getUserFirebaseToken(String id) async {
    String token='';
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .where("id", isEqualTo: id)
          .get()
          .then((value) {
        token = value.docs[0].data()['firebaseToken'];
        print(token);
      });
    } catch (ex) {
      print("Error::$ex");
    }
    return token;
  }

  addUnreadMessaged({required String id, required String chatRoomId}) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(id)
          .get()
          .then((value) async {
        int v = value.data()!['unReadMessages'] + 1;
        print(v);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(id)
            .update({'unReadMessages': v});
      });

      await FirebaseFirestore.instance
          .collection('messages')
          .doc(chatRoomId)
          .get()
          .then((value) async {
        int v = value.data()!['unReadMessageCountOfChat'] + 1;
        print(v);
        await FirebaseFirestore.instance
            .collection('messages')
            .doc(chatRoomId)
            .update({'unReadMessageCountOfChat': v});
      });
    } catch (ex) {
      print("Error::$ex");
    }
  }

  Future<bool> checkChatRoomExist(String chatRoomID) async {
    DocumentSnapshot dc = await FirebaseFirestore.instance
        .collection('messages')
        .doc(chatRoomID)
        .get();
    if (dc.data() == null) {
      return false;
    } else if (dc.data()!=null) {
      return true;
    }
    return false;
  }

  Future<bool> checkUserExist(String id) async {
    try {
      DocumentSnapshot dc =
      await FirebaseFirestore.instance.collection('users').doc(id).get();
      print(dc.data);
      if (dc.data() == null) {
        return false;
      } else if (dc.data()!=null) {
        return true;
      }
    } catch (ex) {
      print("Error::$ex");
    }

    return false;
  }

  makeStatusOnline(groupChatId) async {
    await FirebaseFirestore.instance
        .collection('messages')
        .doc(groupChatId)
        .update({AppConstants.userID:1});
    // .doc(AppConstants.userID)
    // .update({'userStatus': isUserOnline ? 1 : 0});
  }
  makeStatusOffline(groupChatId) async {
    await FirebaseFirestore.instance
        .collection('messages')
        .doc(groupChatId)
        .update({AppConstants.userID:0});
    // .doc(AppConstants.userID)
    // .update({'userStatus': isUserOnline ? 1 : 0});
  }


  makeAllMessageSeen(
      {required String userID, required String groupChatId}) {

    FirebaseFirestore.instance
        .collection('messages')
        .doc(groupChatId).
    collection(groupChatId).orderBy('timestamp', descending: true).get().then((value) async {

      printInfo(info: "idTO==="+value.docs[0]["idTo"]);
      printInfo(info: "isRead=="+value.docs[0]["isRead"].toString());
      if(AppConstants.userID==value.docs[0]["idTo"]){

        printInfo(info: "match");
        FirebaseFirestore.instance
            .collection("messages")
            .doc(groupChatId)
            .get()
            .then((value) async {
          int val = value.data()!['unReadMessageCountOfChat'];
          // print("unReadMessageCountOfChat=====" + val.toString());
          FirebaseFirestore.instance
              .collection('messages')
              .doc(groupChatId)
              .update({'unReadMessageCountOfChat': 0});

        });



        QuerySnapshot result = await FirebaseFirestore.instance
            .collection("messages")
            .doc(groupChatId)
            .collection(groupChatId)
            .get();
        final List<DocumentSnapshot> documents2 = result.docs;

        for (var doc in documents2) {
          FirebaseFirestore.instance
              .collection("messages")
              .doc(groupChatId)
              .collection(groupChatId)
              .doc(doc.id)
              .update({'isRead': true}).catchError((e) {
            print("Error not all messages are seen:::::$e");
          });
        }


      }
    });
  }

}