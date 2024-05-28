import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../common/data/data.dart';
import '../../common/storage/storage.dart';
import 'message_index.dart';

class MessageController extends GetxController {
  MessageController();
  //Grab current login user token
  final token = UserStore.to.token;
  final db = FirebaseFirestore.instance;
  final MessageState state = MessageState();
  var listener;

  final RefreshController refreshController = RefreshController (
    initialRefresh: true
  );

  //The dependency requires this 2 functions to work
  void onRefresh() {
    asyncLoadAllData().then((_){
      refreshController.refreshCompleted(resetFooterState: true);
    }).catchError((_){
      refreshController.refreshFailed();
    });
  }
 
  void onLoading() {
    asyncLoadAllData().then((_){
      refreshController.loadComplete();
    }).catchError((_){
      refreshController.loadFailed();
    });
  }
  //

  asyncLoadAllData() async {
    var fromMessages = await db.collection("message").withConverter(
      fromFirestore: Msg.fromFirestore, 
      toFirestore: (Msg msg, options) => msg.toFirestore()
    ).where("from_uid", isEqualTo: token).get();

    var toMessages = await db.collection("message").withConverter(
      fromFirestore: Msg.fromFirestore, 
      toFirestore: (Msg msg, options) => msg.toFirestore()
    ).where("to_uid", isEqualTo: token)
    .where("msg_num", isGreaterThan: 0).get();

    state.msgList.clear();

    if(fromMessages.docs.isNotEmpty) {
      state.msgList.assignAll(fromMessages.docs);
    } 

    if(toMessages.docs.isNotEmpty) {
      state.msgList.assignAll(toMessages.docs);
    }

    if(fromMessages.docs.isNotEmpty && toMessages.docs.isNotEmpty) {
      state.msgList.assignAll(fromMessages.docs + toMessages.docs);
    }
  }
}