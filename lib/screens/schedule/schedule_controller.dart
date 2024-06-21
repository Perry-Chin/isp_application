import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

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

  final ScheduleRequesterController requesterController = Get.put(ScheduleRequesterController());
  final ScheduleProviderController providerController = Get.put(ScheduleProviderController());

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
    // Listen to token changes and refresh data accordingly
    ever(UserStore.to.obs, (_) {
      if (tabController.index == 0) {
        asyncLoadAllDataForProvider();
      } else {
        asyncLoadAllDataForRequester();
      }
    });
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  void onRefreshProv() => _refreshData(refreshControllerProv, asyncLoadAllDataForProvider);
  void onLoadingProv() => _loadData(refreshControllerProv, asyncLoadAllDataForProvider);
  void onRefreshReq() => _refreshData(refreshControllerReq, asyncLoadAllDataForRequester);
  void onLoadingReq() => _loadData(refreshControllerReq, asyncLoadAllDataForRequester);

  // Helper functions for refresh and load
  void _refreshData(RefreshController controller, Future<void> Function() loadData) {
    loadData().then((_) {
      controller.refreshCompleted(resetFooterState: true);
      update();
    }).catchError((_) {
      controller.refreshFailed();
    });
  }

  void _loadData(RefreshController controller, Future<void> Function() loadData) {
    loadData().then((_) {
      controller.loadComplete();
    }).catchError((_) {
      controller.loadFailed();
    });
  }

  // Stream to handle combined requester data (service + user)
  Stream<Map<String, UserData?>> get combinedRequesterStream async* {
    await asyncLoadAllDataForRequester();
    yield* requesterController.getCombinedReqStream(UserStore.to.token);
  }

  // Load all data for requester
  Future<void> asyncLoadAllDataForRequester() async {
    try {
      print("Reload Req");
      Query<ServiceData> query = db
          .collection("service")
          .withConverter<ServiceData>(
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
      state.requesterList.assignAll(provServices.docs);
    } catch (e) {
      print("Error fetching: $e");
    }
  }

  // Stream to handle combined provider data (service + user)
  Stream<Map<String, UserData?>> get combinedProviderStream async* {
    await asyncLoadAllDataForProvider();
    yield* providerController.getCombinedProvStream(UserStore.to.token);
  }

  // Load all data for provider
  Future<void> asyncLoadAllDataForProvider() async {
    try {
      Query<ServiceData> query = db
          .collection("service")
          .withConverter<ServiceData>(
            fromFirestore: ServiceData.fromFirestore,
            toFirestore: (ServiceData serviceData, options) => serviceData.toFirestore(),
          )
          .where("provider_uid", isEqualTo: token)
          .where("statusid", isGreaterThanOrEqualTo: 0)
          .orderBy("statusid", descending: false)
          .orderBy("date", descending: false);

      if (!selectedStatus.contains('All') && selectedStatus.isNotEmpty) {
        query = query.where("status", whereIn: selectedStatus);
      }

      var provServices = await query.get();
      state.providerList.assignAll(provServices.docs);
    } catch (e) {
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

  void redirectToServiceDetail(QueryDocumentSnapshot<ServiceData> item, String requested) {
    ServiceData serviceData = item.data();
    if(serviceData.status == "Pending" && requested == "true") {
      Get.toNamed("/detail", parameters: {
        "doc_id": item.id,
        "req_uid": serviceData.reqUserid ?? "",
        "hide_buttons": "false",
        "requested": requested,
        "status": serviceData.status ?? "",
      });
    }
    else {
      Get.toNamed("/detail", parameters: {
        "doc_id": item.id,
        "req_uid": serviceData.reqUserid ?? "",
        "prov_uid": serviceData.provUserid ?? "",
        "hide_buttons": "true",
        "requested": requested,
        "status": serviceData.status ?? "",
      });
    }
  }
}