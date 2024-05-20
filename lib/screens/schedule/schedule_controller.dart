import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../common/data/service.dart';
import '../../common/data/user.dart';
import '../../common/storage/storage.dart';
import 'schedule_index.dart';


class ScheduleController extends GetxController {
  ScheduleController();

  final token = UserStore.to.token;
  final db = FirebaseFirestore.instance;
  final ProviderState _providerState = ProviderState();
  final RatingState _ratingState = RatingState();
  final RefreshController refreshController = RefreshController(
    initialRefresh: true,
  );

  final Rx<ScheduleState> _state = ScheduleState(ProviderState(), RatingState()).obs;
  ScheduleState get state => _state.value;

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

  Future<void> asyncLoadAllData() async {
    var reqServices = await db.collection("service").withConverter(
      fromFirestore: ServiceData.fromFirestore,
      toFirestore: (ServiceData serviceData, options) => serviceData.toFirestore(),
    ).where("provider_uid", isNotEqualTo: token).get();

    var reqRatings = await db.collection("user").withConverter(
      fromFirestore: UserData.fromFirestore,
      toFirestore: (UserData userData, options) => userData.toFirestore(),
    ).where("user_id", isNotEqualTo: token).get();

    _providerState.providerList.clear();
    _ratingState.ratingState.clear();

    if (reqServices.docs.isNotEmpty) {
      _providerState.providerList.assignAll(reqServices.docs);
    }

    if (reqRatings.docs.isNotEmpty) {
      _ratingState.ratingState.assignAll(reqRatings.docs);
    }

    _state.value = ScheduleState(_providerState, _ratingState);
  }
}
