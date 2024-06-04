// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

import '../../common/data/data.dart';
import '../../common/storage/storage.dart';
import 'message_index.dart';

class MessageController extends GetxController {
  MessageController();
  final token = UserStore.to.token;
  final db = FirebaseFirestore.instance;
  final MessageState state = MessageState();
  var listener;
  TextEditingController searchController = TextEditingController();
  final RefreshController refreshController = RefreshController(initialRefresh: false);

  // The dependency requires these 2 functions to work
  void onRefresh() {
    asyncLoadAllData().then((_) {
      refreshController.refreshCompleted(resetFooterState: true);
    }).catchError((_) {
      refreshController.refreshFailed();
    });
  }

  void onLoading() {
    asyncLoadAllData().then((_) {
      refreshController.loadComplete();
    }).catchError((_) {
      refreshController.loadFailed();
    });
  }
  
  void filterMessages(String username) {
    if (username.isEmpty) {
      state.filteredMsgList.assignAll(state.msgList);
    } else {
      state.filteredMsgList.assignAll(state.msgList.where((msg) {
        var userData = state.userDataMap[msg.data().fromUserid == token ? msg.data().toUserid : msg.data().fromUserid];
        var usernameMatch = userData?.username?.toLowerCase()?.contains(username.toLowerCase()) ?? false;
        return usernameMatch;
      }).toList());
    }
    // Trigger UI update
    update();
  }

  // Stream to handle fetching message data
  Stream<List<QueryDocumentSnapshot<Msg>>> getMessageStream(String token) {
    var fromStream = db
        .collection('message')
        .where('from_uid', isNotEqualTo: token)
        .withConverter<Msg>(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (Msg msg, _) => msg.toFirestore(),
        )
        .snapshots()
        .map((snapshot) => snapshot.docs);

    var toStream = db
        .collection('message')
        .where('to_uid', isNotEqualTo: token)
        .withConverter<Msg>(
          fromFirestore: Msg.fromFirestore,
          toFirestore: (Msg msg, _) => msg.toFirestore(),
        )
        .snapshots()
        .map((snapshot) => snapshot.docs);

    return rxdart.Rx.combineLatest2(fromStream, toStream,
        (List<QueryDocumentSnapshot<Msg>> fromMessages, List<QueryDocumentSnapshot<Msg>> toMessages) {
      return [...fromMessages, ...toMessages];
    });
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

  // Combine the streams to get user data for each message item
  Stream<Map<String, UserData?>> getCombinedStream(String token) {
    return getMessageStream(token).switchMap((messageDocs) {
      List<String> userIds = messageDocs.expand((doc) {
        return [doc.data().fromUserid, doc.data().toUserid];
      }).whereType<String>().toSet().toList();

      if (userIds.isEmpty) {
        return Stream.value({});
      }

      return getUserStream(userIds).map((userDocs) {
        var userDataMap = Map.fromEntries(userDocs.map((doc) {
          return MapEntry(doc.id, doc.data());
        }));
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

  @override
  void onInit() {
    super.onInit();
    asyncLoadAllData();
    // Listen to token changes and refresh data accordingly
    ever(UserStore.to.obs, (_) {
      asyncLoadAllData();
    });
  }

  Future<void> asyncLoadAllData() async {
    var fromMessages = await db.collection("message").withConverter(
        fromFirestore: Msg.fromFirestore,
        toFirestore: (Msg msg, options) => msg.toFirestore())
        .where("from_uid", isEqualTo: token)
        .get();

    var toMessages = await db.collection("message").withConverter(
        fromFirestore: Msg.fromFirestore,
        toFirestore: (Msg msg, options) => msg.toFirestore())
        .where("to_uid", isEqualTo: token)
        .where("msg_num", isGreaterThan: 0)
        .get();

    state.messageCount.value = fromMessages.docs.length + toMessages.docs.length;

    var allMessages = [...fromMessages.docs, ...toMessages.docs];
    
    state.msgList.assignAll(allMessages);

    // Apply the filter only if the applyFilter flag is true
    state.filteredMsgList.assignAll(allMessages);
  }
}