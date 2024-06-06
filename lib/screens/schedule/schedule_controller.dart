// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:rxdart/transformers.dart';
import '../../common/data/service.dart';
import '../../common/data/user.dart';
import '../../common/storage/storage.dart';
import 'schedule_state.dart';

class ScheduleController extends GetxController with GetSingleTickerProviderStateMixin {
  ScheduleController();

  late TabController tabController;
  final token = UserStore.to.token;
  final db = FirebaseFirestore.instance;
  final List<String> selectedStatus = ['all'];
  final List<String> selectedRating = ['all'];
  final RefreshController refreshController = RefreshController(initialRefresh: true);
  final RefreshController refreshControllers = RefreshController(initialRefresh: true);

  final Rx<ScheduleState> _state = ScheduleState().obs;
  ScheduleState get state => _state.value;

  RxInt currentTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    asyncLoadAllDataForProvider();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  void filterByProvided() {
    currentTabIndex.value = 0;
    asyncLoadAllDataForProvider();
  }

  void filterByRequested() {
    currentTabIndex.value = 1;
    asyncLoadAllDataForRequester();
  }

  void onRefresh() {
    asyncLoadAllDataForProvider().then((_) {
      refreshController.refreshCompleted(resetFooterState: true);
    }).catchError((_) {
      refreshController.refreshFailed();
    });
  }

  void onLoading() {
    asyncLoadAllDataForProvider().then((_) {
      refreshController.loadComplete();
    }).catchError((_) {
      refreshController.loadFailed();
    });
  }

  void onRefreshControll() {
    asyncLoadAllDataForRequester().then((_) {
      refreshControllers.refreshCompleted(resetFooterState: true);
    }).catchError((_) {
      refreshControllers.refreshFailed();
    });
  }

  void onLoadingControll() {
    asyncLoadAllDataForRequester().then((_) {
      refreshControllers.loadComplete();
    }).catchError((_) {
      refreshControllers.loadFailed();
    });
  }

  Stream<List<QueryDocumentSnapshot<ServiceData>>> getServiceStream(String token) {
    return db.collection('service')
      .where('provider_uid', isEqualTo: token)
      .withConverter<ServiceData>(
        fromFirestore: ServiceData.fromFirestore,
        toFirestore: (ServiceData serviceData, _) => serviceData.toFirestore(),
      )
      .snapshots()
      .map((snapshot) => snapshot.docs);
  }

  Stream<List<QueryDocumentSnapshot<ServiceData>>> getRequesterServiceStream(String token) {
    return db.collection('service')
      .where('requester_uid', isEqualTo: token)
      .withConverter<ServiceData>(
        fromFirestore: ServiceData.fromFirestore,
        toFirestore: (ServiceData serviceData, _) => serviceData.toFirestore(),
      )
      .snapshots()
      .map((snapshot) => snapshot.docs);
  }

  Stream<List<DocumentSnapshot<UserData>>> getUserStream(List<String> userIds) {
    return db.collection('users')
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
      List<String> userIds = serviceDocs.map((doc) => doc.data().reqUserid!).toSet().toList();

      if (userIds.isEmpty) {
        return Stream.value({});
      }

      return getUserStream(userIds).map((userDocs) {
        return Map.fromEntries(userDocs.map((doc) => MapEntry(doc.id, doc.data())));
      });
    });
  }

  Stream<Map<String, UserData?>> getCombinedRequesterStream(String token) {
    return getRequesterServiceStream(token).switchMap((serviceDocs) {
      List<String> userIds = serviceDocs.map((doc) => doc.data().reqUserid!).toSet().toList();

      if (userIds.isEmpty) {
        return Stream.value({});
      }

      return getUserStream(userIds).map((userDocs) {
        return Map.fromEntries(userDocs.map((doc) => MapEntry(doc.id, doc.data())));
      });
    });
  }

  Stream<Map<String, UserData?>> get combinedStream async* {
    await asyncLoadAllDataForProvider();
    yield* getCombinedStream(token);
  }

  Stream<Map<String, UserData?>> get combinedRequesterStream async* {
    await asyncLoadAllDataForRequester();
    yield* getCombinedRequesterStream(token);
  }

  Future<void> asyncLoadAllDataForProvider() async {
    var providerServices = await db.collection("service").withConverter(
      fromFirestore: ServiceData.fromFirestore,
      toFirestore: (ServiceData serviceData, options) => serviceData.toFirestore(),
    ).where("provider_uid", isEqualTo: token).get();

    state.providerList.clear();
    state.ratingState.clear();

    if (providerServices.docs.isNotEmpty) {
      state.providerList.assignAll(providerServices.docs);
    }

    print("Data loaded for provider: ${state.providerList.length} services, ${state.ratingState.length} ratings");
  }

  Future<void> asyncLoadAllDataForRequester() async {
    var requesterServices = await db.collection("service").withConverter(
      fromFirestore: ServiceData.fromFirestore,
      toFirestore: (ServiceData serviceData, options) => serviceData.toFirestore(),
    ).where("requester_uid", isEqualTo: token).get();

    state.providerList.clear();
    state.ratingState.clear();

    if (requesterServices.docs.isNotEmpty) {
      state.providerList.assignAll(requesterServices.docs);
    }

    print("Data loaded for for requester: ${state.providerList.length} services, ${state.ratingState.length} ratings");
  }
}
