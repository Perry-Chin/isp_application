// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../../common/data/data.dart';
import '../../common/middlewares/middlewares.dart';
import '../../common/storage/storage.dart';
import 'detail_index.dart';

class DetailController extends GetxController {
  var doc_id;
  final token = UserStore.to.token;
  final DetailState state = DetailState();
  final db = FirebaseFirestore.instance;
  var isServiceRequested = false.obs;

  final subtotal = 0.0.obs;
  final taxFee = 0.0.obs;
  final totalCost = 0.0.obs;
  final displayController = TextEditingController();
  final selectedDate = DateTime.now().obs;
  final selectedTime = TimeOfDay.now().obs;

  var userData = Rxn<UserData>();
  final userRating = 0.0.obs;
  final serviceRating = 0.0.obs; // New observable for service-specific rating

  bool showPaymentSection = false;

  void togglePaymentSection() {
    showPaymentSection = !showPaymentSection;
    update();
  }

  Stream<List<QueryDocumentSnapshot<ServiceData>>> getServiceStream(
      String token) {
    return db
        .collection('service')
        .where(FieldPath.documentId, isEqualTo: doc_id)
        .withConverter<ServiceData>(
          fromFirestore: ServiceData.fromFirestore,
          toFirestore: (ServiceData serviceData, _) =>
              serviceData.toFirestore(),
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
      List<String> userIds = serviceDocs
          .where((doc) =>
              doc.data().reqUserid != null && doc.data().reqUserid!.isNotEmpty)
          .map((doc) => doc.data().reqUserid!)
          .toList()
        ..addAll(serviceDocs
            .where((doc) =>
                doc.data().provUserid != null &&
                doc.data().provUserid!.isNotEmpty)
            .map((doc) => doc.data().provUserid!));

      if (userIds.isEmpty) {
        return Stream.value({});
      }

      return getUserStream(userIds).map((userDocs) {
        return Map.fromEntries(
            userDocs.map((doc) => MapEntry(doc.id, doc.data())));
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
    print(doc_id);

    combinedStream.listen((userDataMap) {
      if (userDataMap.isNotEmpty) {
        userData.value = userDataMap.values.first;
        fetchUserRating(userData.value!.id!);
        fetchServiceRating(doc_id);
      }
    });

    asyncLoadAllData();
  }

  Future<void> fetchUserRating(String userId) async {
    try {
      QuerySnapshot reviewsSnapshot = await db
          .collection('reviews')
          .where('to_uid', isEqualTo: userId)
          .get();

      if (reviewsSnapshot.docs.isNotEmpty) {
        double totalRating = 0;
        for (var doc in reviewsSnapshot.docs) {
          totalRating += doc['rating'] as num;
        }
        userRating.value = totalRating / reviewsSnapshot.docs.length;
      } else {
        userRating.value = 0;
      }
    } catch (e) {
      print('Error fetching user rating: $e');
      userRating.value = 0;
    }
  }

  Future<void> fetchServiceRating(String serviceId) async {
    try {
      DocumentSnapshot serviceDoc =
          await db.collection('service').doc(serviceId).get();
      if (serviceDoc.exists) {
        Map<String, dynamic> data = serviceDoc.data() as Map<String, dynamic>;
        if (data.containsKey('rating')) {
          serviceRating.value = (data['rating'] as num).toDouble();
        } else {
          serviceRating.value = 0.0;
        }
      }
    } catch (e) {
      print('Error fetching service rating: $e');
      serviceRating.value = 0.0;
    }
  }

  Future<void> updateServiceProvUserid(
      String serviceId, String provUserid) async {
    try {
      await db
          .collection('service')
          .doc(serviceId)
          .update({'provider_uid': provUserid});
    } catch (e) {
      print('Error updating provUserid: $e');
    }
  }

  Future<void> updateServiceStatus(
      String serviceId, String status, int statusid) async {
    try {
      await db
          .collection('service')
          .doc(serviceId)
          .update({'status': status, 'statusid': statusid});
      updateFiltersAndNavigateBack();
    } catch (e) {
      print('Error updating status: $e');
    }
  }

  Future<void> bookServiceStatus(
      String serviceId, String status, int statusid) async {
    try {
      await db
          .collection('service')
          .doc(serviceId)
          .update({'status': status, 'statusid': statusid});
    } catch (e) {
      print('Error updating status: $e');
    }
  }

  Future<void> asyncLoadAllData() async {
    try {
      var reqServices = await db
          .collection("service")
          .withConverter<ServiceData>(
            fromFirestore: ServiceData.fromFirestore,
            toFirestore: (ServiceData serviceData, options) =>
                serviceData.toFirestore(),
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

  Future<void> createProposeDocument(String startTime) async {
    final content = {
      'start_time': startTime,
      'timestamp': FieldValue.serverTimestamp(),
      'userid': token,
    };
    await db
        .collection('service')
        .doc(doc_id)
        .collection('propose')
        .add(content)
        .then((DocumentReference doc) {
      print("Propose document added with id, ${doc.id}");
      updateServiceStatusAndProvider(doc_id, 'Pending', token);
    }).catchError((e) {
      print("Error creating propose document: $e");
    });
  }

  Future<void> updateServiceStatusAndProvider(
      String serviceId, String status, String providerUid) async {
    try {
      await db.collection('service').doc(serviceId).update({
        'status': status,
        'statusid': 1,
        'provider_uid': providerUid,
      });
    } catch (e) {
      print('Error updating status and provider_uid: $e');
    }
  }

  void calculateCosts() {
    if (state.serviceList.isNotEmpty) {
      var service = state.serviceList.first.data();
      if (service.rate != null && service.duration != null) {
        double rate = service.rate!.toDouble();
        double? duration = service.duration;

        subtotal.value = double.parse((rate * duration!).toStringAsFixed(2));
        taxFee.value = double.parse((subtotal.value * 0.1).toStringAsFixed(2));
        totalCost.value = double.parse((subtotal.value - taxFee.value).toStringAsFixed(2));
      }
    }
  }

  void goToReviews() {
    Get.toNamed('/detail_reviews', parameters: {
      'doc_id': doc_id,
      'requested': Get.parameters['requested'] ?? 'false',
    });
  }

  void goChat(UserData userData) async {
    try {
      if (userData.id == null) {
        print("Error: userData.id is null");
        return;
      }

      var fromMessages = await db
          .collection("message")
          .withConverter(
              fromFirestore: Msg.fromFirestore,
              toFirestore: (Msg msg, options) => msg.toFirestore())
          .where("from_uid", isEqualTo: token)
          .where("to_uid", isEqualTo: userData.id)
          .get();

      var toMessages = await db
          .collection("message")
          .withConverter(
              fromFirestore: Msg.fromFirestore,
              toFirestore: (Msg msg, options) => msg.toFirestore())
          .where("from_uid", isEqualTo: userData.id)
          .where("to_uid", isEqualTo: token)
          .get();

      if (fromMessages.docs.isEmpty && toMessages.docs.isEmpty) {
        String profile = await UserStore.to.getProfile();
        UserLoginResponseEntity userdata =
            UserLoginResponseEntity.fromJson(jsonDecode(profile));
        var msgdata = Msg(
            fromUserid: userdata.accessToken,
            toUserid: userData.id,
            lastMsg: "",
            lastTime: Timestamp.now(),
            msgNum: 0);
        db
            .collection("message")
            .withConverter(
                fromFirestore: Msg.fromFirestore,
                toFirestore: (Msg msg, options) => msg.toFirestore())
            .add(msgdata)
            .then((value) {
          Get.toNamed("/chat", parameters: {
            "doc_id": value.id,
            "to_uid": userData.id ?? "",
            "to_name": userData.username ?? "",
            "to_avatar": userData.photourl ?? ""
          });
        });
      } else {
        if (fromMessages.docs.isNotEmpty) {
          Get.toNamed("/chat", parameters: {
            "doc_id": fromMessages.docs.first.id,
            "to_uid": userData.id ?? "",
            "to_name": userData.username ?? "",
            "to_avatar": userData.photourl ?? ""
          });
        }
        if (toMessages.docs.isNotEmpty) {
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

  // void updateServiceStatus(String serviceId, String status) async {
  //   try {
  //     await db.collection('service').doc(serviceId).update({
  //       'status': status,
  //     });
  //   } catch (e) {
  //     print('Error updating status: $e');
  //   }
  // }
}
