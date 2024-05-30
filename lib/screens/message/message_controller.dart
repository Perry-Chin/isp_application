// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:rxdart/rxdart.dart';

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

  
// Stream to handle fetching service data
  Stream<List<QueryDocumentSnapshot<ServiceData>>> getServiceStream(String token) {
    return db
        .collection('service')
        .where('requester_uid', isNotEqualTo: token)
        .where('status', isEqualTo: 'Requested')
        .withConverter<ServiceData>(
          fromFirestore: ServiceData.fromFirestore,
          toFirestore: (ServiceData serviceData, _) => serviceData.toFirestore(),
        )
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  // Stream to handle fetching user data
  Stream<List<DocumentSnapshot<UserData>>> getUserStream(List<String> userIds) {
    return db
        .collection('users')
        .where(FieldPath.documentId, whereIn: userIds)
        .withConverter<UserData>(
          fromFirestore: UserData.fromFirestore,
          toFirestore: (UserData userData, _) => userData.toFirestore(),
        )
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  // Combine the streams to get user data for each service item
  Stream<Map<String, UserData?>> getCombinedStream(String token) {
    return getServiceStream(token).switchMap((serviceDocs) {
      List<String> userIds = serviceDocs.map((doc) => doc.data().reqUserid!).toList();

      if (userIds.isEmpty) {
        return Stream.value({});
      }

      return getUserStream(userIds).map((userDocs) {
        var userDataMap = Map.fromEntries(userDocs.map((doc) => MapEntry(doc.id, doc.data())));
        state.userDataMap.assignAll(userDataMap); // Update userDataMap in state
        return userDataMap;
      });
    });
  }
  
  // Stream to handle data fetching
  Stream<Map<String, UserData?>> get combinedStream async* {
    await asyncLoadAllData();
    yield* getCombinedStream(UserStore.to.token);
  }
  
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