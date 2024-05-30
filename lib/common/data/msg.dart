import 'package:cloud_firestore/cloud_firestore.dart';

class Msg {
  final String? fromUserid;
  final String? toUserid;
  final String? lastMsg;
  final Timestamp? lastTime;
  final int? msgNum;

  Msg({
    this.fromUserid,
    this.toUserid,
    this.lastMsg,
    this.lastTime,
    this.msgNum
  });

  factory Msg.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return Msg(
      fromUserid: data?['from_uid'],
      toUserid: data?['to_uid'],
      lastMsg: data?['last_msg'],
      lastTime: data?['last_time'],
      msgNum: data?['msg_num'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (fromUserid != null) "from_uid": fromUserid,
      if (toUserid != null) "to_uid": toUserid,
      if (lastMsg != null) "last_msg": lastMsg,
      if (lastTime != null) "last_time": lastTime,
      if (msgNum != null) "msg_num": msgNum,
    };
  }
}
