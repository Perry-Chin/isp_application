// Detail Controller

// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../../common/data/data.dart';
import '../../common/storage/storage.dart';
import 'detail_index.dart';

class DetailController extends GetxController {
  var doc_id;
  final token = UserStore.to.token;
  final DetailState state = DetailState();
  final db = FirebaseFirestore.instance;

  final subtotal = 0.0.obs;
  final taxFee = 0.0.obs;
  final totalCost = 0.0.obs;
  final selectedDate = DateTime.now().obs; // Observable for selected date
  final selectedTime = TimeOfDay.now().obs; // Observable for selected time

   bool showPaymentSection = false; 

  void togglePaymentSection() {
    showPaymentSection = !showPaymentSection;
    update(); // Notify listeners about the change
  }

  Stream<List<QueryDocumentSnapshot<ServiceData>>> getServiceStream(String token) {
    return db
      .collection('service')
      .where(FieldPath.documentId, isEqualTo: doc_id)
      .withConverter<ServiceData>(
        fromFirestore: ServiceData.fromFirestore,
        toFirestore: (ServiceData serviceData, _) => serviceData.toFirestore(),
      )
      .snapshots()
      .map((snapshot) => snapshot.docs);
  }

  


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

  Stream<Map<String, UserData?>> getCombinedStream(String token) {
    return getServiceStream(token).switchMap((serviceDocs) {
      List<String> userIds = serviceDocs.map((doc) => doc.data().reqUserid!).toList();

      if (userIds.isEmpty) {
        return Stream.value({});
      }

      return getUserStream(userIds).map((userDocs) {
        return Map.fromEntries(userDocs.map((doc) => MapEntry(doc.id, doc.data())));
      });
    });
  }

  Stream<Map<String, UserData?>> get combinedStream async* {
    yield* getCombinedStream(token);
  }

  @override
  void onInit() {
    super.onInit();
    var data = Get.parameters;
    doc_id = data['doc_id'];
  }

  Future<void> asyncLoadAllData() async {
    try {
      var reqServices = await db
        .collection("service")
        .withConverter<ServiceData>(
          fromFirestore: ServiceData.fromFirestore,
          toFirestore: (ServiceData serviceData, options) => serviceData.toFirestore(),
        )
        .where(FieldPath.documentId, isEqualTo: doc_id)
        .get();

      List<QueryDocumentSnapshot<ServiceData>> reqDocument = reqServices.docs;

      state.serviceList.assignAll(reqDocument);

      calculateCosts();
    } catch (e) {
      print("Error fetching: $e");
    }
  }

  void calculateCosts() {
    if (state.serviceList.isNotEmpty) {
      var service = state.serviceList.first.data();
      if (service.rate != null && service.duration != null) {
        double rate = service.rate!.toDouble();
        double duration = service.duration!.toDouble();
        
        subtotal.value = rate * duration;
        taxFee.value = subtotal.value * 0.1;
        totalCost.value = subtotal.value - taxFee.value;
      }
    }
  }

  void goChat(UserData userData) async {
    try {
      if (userData.id == null) {
        print("Error: userData.id is null");
        return;
      }

      var fromMessages = await db.collection("message").withConverter(
        fromFirestore: Msg.fromFirestore, 
        toFirestore: (Msg msg, options) => msg.toFirestore()
      ).where("from_uid", isEqualTo: token)
      .where("to_uid", isEqualTo: userData.id).get();

      var toMessages = await db.collection("message").withConverter(
        fromFirestore: Msg.fromFirestore, 
        toFirestore: (Msg msg, options) => msg.toFirestore()
      ).where("from_uid", isEqualTo: userData.id)
      .where("to_uid", isEqualTo: token).get();

      //If both users have not messaged before
      if(fromMessages.docs.isEmpty && toMessages.docs.isEmpty) {
        //Get user information
        String profile = await UserStore.to.getProfile();
        UserLoginResponseEntity userdata = UserLoginResponseEntity.fromJson(jsonDecode(profile));
        var msgdata = Msg(
          fromUserid: userdata.accessToken,
          toUserid: userData.id,
          lastMsg: "",
          lastTime: Timestamp.now(),
          msgNum: 0
        );
        db.collection("message").withConverter(
          fromFirestore: Msg.fromFirestore, 
          toFirestore: (Msg msg, options) => msg.toFirestore()
        ).add(msgdata).then((value) {
          Get.toNamed("/chat", parameters: {
            "doc_id": value.id,
            "to_uid": userData.id ?? "",
            "to_name": userData.username ?? "",
            "to_avatar": userData.photourl ?? ""
          });
        });
      }
      //If the user has messaged the other party
      else {
        if(fromMessages.docs.isNotEmpty) {
          Get.toNamed("/chat", parameters: {
            "doc_id": fromMessages.docs.first.id,
            "to_uid": userData.id ?? "",
            "to_name": userData.username ?? "",
            "to_avatar": userData.photourl ?? ""
          });
        }
        if(toMessages.docs.isNotEmpty) {
          Get.toNamed("/chat", parameters: {
            "doc_id": toMessages.docs.first.id,
            "to_uid": userData.id ?? "",
            "to_name": userData.username ?? "",
            "to_avatar": userData.photourl ?? ""
          });
        }
      }
    } catch (e) {
      print("Error in goChat: $e");
    }
  }
}
