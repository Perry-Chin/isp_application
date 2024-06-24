import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../../common/data/data.dart';
import '../../common/storage/storage.dart';
import 'schedule_index.dart';

class ScheduleProviderController extends GetxController {
  final db = FirebaseFirestore.instance;
  final token = UserStore.to.token;
  final ScheduleState state = ScheduleState();
  final RxMap<String, UserData?> userDataMap = RxMap<String, UserData?>();

  // Stream to handle fetching service data for provider
  Stream<List<QueryDocumentSnapshot<ServiceData>>> getProviderStream(
      String token) {
    return db
        .collection('service')
        .where('provider_uid', isEqualTo: token)
        .withConverter<ServiceData>(
          fromFirestore: ServiceData.fromFirestore,
          toFirestore: (ServiceData serviceData, _) =>
              serviceData.toFirestore(),
        )
        .snapshots()
        .map((snapshot) => snapshot.docs);
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

  // Combine the streams to get user data for each service item (provider)
  Stream<Map<String, UserData?>> getCombinedProvStream(String token) {
    return getProviderStream(token).switchMap((serviceDocs) {
      List<String> userIds =
          serviceDocs.map((doc) => doc.data().reqUserid!).toList();
      if (userIds.isEmpty) {
        return Stream.value({});
      }
      return getUserStream(userIds).map((userDocs) {
        var userDataMap = Map.fromEntries(
            userDocs.map((doc) => MapEntry(doc.id, doc.data())));
        this.userDataMap.assignAll(userDataMap);
        return userDataMap;
      });
    });
  }

  // Stream to handle combined provider data (service + user)
  Stream<Map<String, UserData?>> get combinedProviderStream async* {
    await asyncLoadAllDataForProvider();
    yield* getCombinedProvStream(UserStore.to.token);
  }

  // Load all data for provider
  Future<void> asyncLoadAllDataForProvider() async {
    try {
      Query<ServiceData> query = db
          .collection("service")
          .withConverter<ServiceData>(
            fromFirestore: ServiceData.fromFirestore,
            toFirestore: (ServiceData serviceData, options) =>
                serviceData.toFirestore(),
          )
          .where("provider_uid", isEqualTo: token)
          .where("statusid", isGreaterThanOrEqualTo: 0)
          .orderBy("statusid", descending: false)
          .orderBy("date", descending: false);

      var provServices = await query.get();
      state.providerList.assignAll(provServices.docs);
    } catch (e) {
      print("Error fetching: $e");
    }
  }



}
