import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:rxdart/transformers.dart';


import '../../common/data/service.dart';
import '../../common/data/user.dart';
import '../../common/storage/storage.dart';
import 'schedule_state.dart';


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

  @override
  void onInit() {
    super.onInit();
    asyncLoadAllData();
  }

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

  // Stream to handle fetching service data
  Stream<List<QueryDocumentSnapshot<ServiceData>>> getServiceStream(String token) {
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
      .map((snapshot) => snapshot.docs);
  }

  // Combine the streams to get user data for each service item
  Stream<Map<String, UserData?>> getCombinedStream(String token) {
    return getServiceStream(token).switchMap((serviceDocs) {
      List<String> userIds = serviceDocs
        .map((doc) => doc.data().reqUserid!)
        .toSet()
        .toList();

      if (userIds.isEmpty) {
        return Stream.value({});
      }

      return getUserStream(userIds).map((userDocs) {
        return Map.fromEntries(userDocs.map((doc) => MapEntry(doc.id, doc.data())));
      });
    });
  }

  // Stream to handle data fetching
  Stream<Map<String, UserData?>> get combinedStream async* {
    await asyncLoadAllData();
    yield* getCombinedStream(token);
  }

  Future<void> asyncLoadAllData() async {
    var reqServices = await db.collection("service").withConverter(
      fromFirestore: ServiceData.fromFirestore,
      toFirestore: (ServiceData serviceData, options) => serviceData.toFirestore(),
    ).where("provider_uid", isEqualTo: token).get();

    _providerState.providerList.clear();
    _ratingState.ratingState.clear();

    if (reqServices.docs.isNotEmpty) {
      _providerState.providerList.assignAll(reqServices.docs);
    }

    _state.value = ScheduleState(_providerState, _ratingState);
    print("Data loaded: ${_state.value.providerState.providerList.length} services, ${_state.value.ratingState.ratingState.length} ratings");
  }
}
