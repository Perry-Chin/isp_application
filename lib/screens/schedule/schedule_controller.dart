import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:rxdart/rxdart.dart';

import '../../common/data/data.dart';
import '../../common/storage/storage.dart';
import '../../common/utils/utils.dart';
import 'schedule_index.dart';

class ScheduleController extends GetxController with GetSingleTickerProviderStateMixin {
  ScheduleController();
  
  late TabController tabController;
  final ScheduleState state = ScheduleState();
  final token = UserStore.to.token;
  final db = FirebaseFirestore.instance;
  final List<String> selectedStatus = ['All'];
  int selectedRating = 0;
  final RefreshController refreshControllerReq = RefreshController(initialRefresh: false);
  final RefreshController refreshControllerProv = RefreshController(initialRefresh: false);
  RxInt currentTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        currentTabIndex.value = tabController.index;
        if (tabController.index == 0) {
          asyncLoadAllDataForProvider();
        } else {
          asyncLoadAllDataForRequester();
        }
      }
    });
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  // The pull_to_refresh dependency requires these functions to work
  void onRefreshProv() {
    asyncLoadAllDataForProvider().then((_) {
      refreshControllerProv.refreshCompleted(resetFooterState: true);
    }).catchError((_) {
      refreshControllerProv.refreshFailed();
    });
  }

  void onLoadingProv() {
    asyncLoadAllDataForProvider().then((_) {
      refreshControllerProv.loadComplete();
    }).catchError((_) {
      refreshControllerProv.loadFailed();
    });
  }

  void onRefreshReq() {
    asyncLoadAllDataForRequester().then((_) {
      refreshControllerReq.refreshCompleted(resetFooterState: true);
    }).catchError((_) {
      refreshControllerReq.refreshFailed();
    });
  }

  void onLoadingReq() {
    asyncLoadAllDataForRequester().then((_) {
      refreshControllerReq.loadComplete();
    }).catchError((_) {
      refreshControllerReq.loadFailed();
    });
  }

  // Stream to handle fetching service data
  Stream<List<QueryDocumentSnapshot<ServiceData>>> getRequesterStream(String token) {
    return FirebaseFirestore.instance
      .collection('service')
      .where('requester_uid', isEqualTo: token)
      .withConverter<ServiceData>(
        fromFirestore: ServiceData.fromFirestore,
        toFirestore: (ServiceData serviceData, _) => serviceData.toFirestore(),
      )
      .snapshots()
      .map((snapshot) => snapshot.docs);
  }

  // Stream to handle fetching user data
  Stream<List<DocumentSnapshot<UserData>>> getUserStream(List<String> userIds) {
    return FirebaseFirestore.instance
        .collection('users')
        .where(FieldPath.documentId, whereIn: userIds)
        .withConverter<UserData>(
          fromFirestore: UserData.fromFirestore,
          toFirestore: (UserData userData, _) => userData.toFirestore(),
        )
        .snapshots()
        .map((snapshot) {
          return snapshot.docs;
        });
  }

  // Stream to handle data fetching
  Stream<Map<String, UserData?>> get combinedRequesterStream async* {
    await asyncLoadAllDataForRequester();
    yield* getCombinedReqStream(UserStore.to.token);
  }

  // Load all data for requester
  Future<void> asyncLoadAllDataForRequester() async {
    try {
      String token = UserStore.to.token;
      
      // Add a delay of 1 second
      // await Future.delayed(const Duration(milliseconds: 200));

      Query<ServiceData> query = db
        .collection("service")
        .withConverter(
          fromFirestore: ServiceData.fromFirestore,
          toFirestore: (ServiceData serviceData, options) => serviceData.toFirestore(),
        )
        .where("requester_uid", isEqualTo: token)
        .where("statusid", isGreaterThanOrEqualTo: 0)
        .orderBy("statusid", descending: false)
        .orderBy("date", descending: false);

      if (selectedStatus.isNotEmpty && !selectedStatus.contains('All')) {
        query = query.where("status", whereIn: selectedStatus);
      }
      
      var provServices = await query.get();

      List<QueryDocumentSnapshot<ServiceData>> documents = provServices.docs;

      // Sort documents by user rating
      documents.sort((a, b) {
        final userDataA = state.userDataMap[a.data().reqUserid];
        final userDataB = state.userDataMap[b.data().reqUserid];
        final ratingA = userDataA?.rating ?? 0;
        final ratingB = userDataB?.rating ?? 0;
        return ratingA.compareTo(ratingB);
      });

      // Now use the sorted documents for display
      state.requesterList.assignAll(documents);
    } 
    catch (e) {
      print("Error fetching: $e");
    }
  }

    // Stream to handle fetching service data
  Stream<List<QueryDocumentSnapshot<ServiceData>>> getProviderStream(String token) {
    return FirebaseFirestore.instance
        .collection('service')
        .where('provider_uid', isEqualTo: token)
        .withConverter<ServiceData>(
          fromFirestore: ServiceData.fromFirestore,
          toFirestore: (ServiceData serviceData, _) => serviceData.toFirestore(),
        )
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  // Combine the streams to get user data for each service item
  Stream<Map<String, UserData?>> getCombinedReqStream(String token) {
    return getRequesterStream(token).switchMap((serviceDocs) {
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

  // Combine the streams to get user data for each service item
  Stream<Map<String, UserData?>> getCombinedProvStream(String token) {
    return getProviderStream(token).switchMap((serviceDocs) {
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
  Stream<Map<String, UserData?>> get combinedProviderStream async* {
    await asyncLoadAllDataForProvider();
    yield* getCombinedProvStream(UserStore.to.token);
  }
  
  // Load all data for provider
  Future<void> asyncLoadAllDataForProvider() async {
    try {
      String token = UserStore.to.token;
      
      // Add a delay of 1 second
      // await Future.delayed(const Duration(milliseconds: 200));

      Query<ServiceData> query = db
        .collection("service")
        .withConverter(
          fromFirestore: ServiceData.fromFirestore,
          toFirestore: (ServiceData serviceData, options) => serviceData.toFirestore(),
        )
        .where("provider_uid", isEqualTo: token)  // Apply all filters on the same field
        .where("statusid", isGreaterThanOrEqualTo: 0)
        .orderBy("statusid", descending: false)
        .orderBy("date", descending: false);
      
      if (!selectedStatus.contains('All') && selectedStatus.isNotEmpty) {
        query = query.where("status", whereIn: selectedStatus);
      }

      var provServices = await query.get();

      List<QueryDocumentSnapshot<ServiceData>> documents = provServices.docs;

      state.providerList.assignAll(documents); // Update state with fetched data
    } 
    catch (e) {
      print("Error fetching: $e");
    }
  }

  void filterServices({
    required List<String> selectedStatus,
    required int selectedRating,
  }) {
    this.selectedStatus.clear();
    this.selectedStatus.addAll(selectedStatus);
    this.selectedRating = selectedRating;
    currentTabIndex.value = tabController.index;
    update();
  }

  void updateFilterFromStorage() {
    // Update filters based on stored values
    List<bool>? storedStatus = GetStorage().read('selectedStatus');
    int? storedRating = GetStorage().read('selectedRating');

    if (storedStatus != null) {
      // Map boolean values to selected status strings
      List<String> selectedStatus = FilterStatus.filters
          .asMap()
          .entries
          .where((entry) => storedStatus[entry.key])
          .map((entry) => entry.value.status)
          .toList();

      filterServices(
        selectedStatus: selectedStatus,
        selectedRating: storedRating ?? 0,
      );
    }
  }
}