import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../../../common/data/data.dart';
import '../../../common/storage/storage.dart';
import '../schedule_index.dart';

class ScheduleRequesterController extends GetxController {
  final db = FirebaseFirestore.instance;
  final token = UserStore.to.token;
  final ScheduleState state = ScheduleState();
  final RxMap<String, UserData?> userDataMap = RxMap<String, UserData?>();

  // Stream to handle fetching service data for requester
  Stream<List<QueryDocumentSnapshot<ServiceData>>> getRequesterStream(String token) {
    return db
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

  // Stream to handle combined requester data (service + user)
  Stream<Map<String, UserData?>> get combinedRequesterStream async* {
    await asyncLoadAllDataForRequester();
    yield* getCombinedReqStream(UserStore.to.token);
  }

  // Load all data for requester
  Future<void> asyncLoadAllDataForRequester() async {
    try {
      Query<ServiceData> query = db
          .collection("service")
          .withConverter<ServiceData>(
            fromFirestore: ServiceData.fromFirestore,
            toFirestore: (ServiceData serviceData, options) => serviceData.toFirestore(),
          )
          .where("requester_uid", isEqualTo: token)
          .where("statusid", isGreaterThanOrEqualTo: 0)
          .orderBy("statusid", descending: true)
          .orderBy("date", descending: false);
      
      if (state.selectedStatus.isNotEmpty && !state.selectedStatus.contains('All')) {
        query = query.where("status", whereIn: state.selectedStatus);
      }
      var provServices = await query.get();
      print(provServices);
      state.requesterList.assignAll(provServices.docs);
    } catch (e) {
      print("Error fetching: $e");
    }
  }

  // Combine the streams to get user data for each service item (requester)
  Stream<Map<String, UserData?>> getCombinedReqStream(String token) {
    return getRequesterStream(token).switchMap((serviceDocs) {
      List<String> userIds = serviceDocs.map((doc) => doc.data().reqUserid!).toList();
      if (userIds.isEmpty) {
        return Stream.value({});
      }
      return getUserStream(userIds).map((userDocs) {
        var userDataMap = Map.fromEntries(userDocs.map((doc) => MapEntry(doc.id, doc.data())));
        this.userDataMap.assignAll(userDataMap);
        return userDataMap;
      });
    });
  }
}