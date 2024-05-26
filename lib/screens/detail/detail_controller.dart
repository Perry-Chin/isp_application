// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
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
}
