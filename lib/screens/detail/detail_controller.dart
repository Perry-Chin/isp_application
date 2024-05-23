import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';

import '../../common/data/data.dart';
import '../../common/storage/storage.dart';
import 'detail_index.dart';

class DetailController extends GetxController {
  var doc_id = null;
  final token = UserStore.to.token;
  final DetailState state = DetailState();
  final db = FirebaseFirestore.instance;

  final subtotal = 0.0.obs;
  final taxFee = 0.0.obs;
  final totalCost = 0.0.obs;

  // Stream to handle fetching service data
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

  // Combine the streams to get user data for each service item
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

  // Stream to handle data fetching
  Stream<Map<String, UserData?>> get combinedStream async* {
    await asyncLoadAllData();
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

      // Now use the sorted documents for display
      state.serviceList.assignAll(reqDocument);

      // Calculate the subtotal after loading the data
      calculateCosts();
    } catch (e) {
      print("Error fetching: $e");
    }
  }
  
  // Method to calculate the subtotal, tax fee, and total cost
  void calculateCosts() {
    if (state.serviceList.isNotEmpty) {
      var service = state.serviceList.first.data();
      if (service.rate != null && service.duration != null) {
        // Ensure rate and duration are treated as double
        double rate = service.rate!.toDouble();
        double duration = service.duration!.toDouble();
        
        subtotal.value = rate * duration;
        taxFee.value = subtotal.value * 0.1;
        totalCost.value = subtotal.value - taxFee.value;
      }
    }
  }
}
