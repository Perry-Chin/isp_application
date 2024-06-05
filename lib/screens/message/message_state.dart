import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../common/data/data.dart';

class MessageState {
  RxList<QueryDocumentSnapshot<Msg>> msgList = <QueryDocumentSnapshot<Msg>>[].obs;
  RxList<QueryDocumentSnapshot<Msg>> filteredMsgList = <QueryDocumentSnapshot<Msg>>[].obs;
  RxMap userDataMap = {}.obs;
  var messageCount = 0.obs;
}