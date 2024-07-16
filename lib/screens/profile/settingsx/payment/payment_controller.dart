import 'package:get_storage/get_storage.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../common/data/data.dart';
import '../../../../common/middlewares/middlewares.dart';
import '../../../../common/storage/storage.dart';

class PaymentController extends GetxController {

  // Variables
  final user = Rx<UserData?>(null);
  final userToken = UserStore.to.token;
  final db = FirebaseFirestore.instance;
  late final Rx<PaymentFilter> currentFilter;
  final paymentList = <QueryDocumentSnapshot<PaymentData>>[].obs;
  final refreshControllerPayment = RefreshController(initialRefresh: false);

  void onRefreshPayment() => refreshData(refreshControllerPayment, asyncLoadAllPayment);
  void onLoadingPayment() => loadData(refreshControllerPayment, asyncLoadAllPayment);
  
  @override
  void onInit() {
    super.onInit();
    // Set current filter to stored value or default to newestFirst
    String? storedFilter = GetStorage().read("payment_filter");
    currentFilter = Rx<PaymentFilter>(
      storedFilter != null
          ? PaymentFilter.values.firstWhere((e) => e.toString() == storedFilter)
          : PaymentFilter.newestFirst
    );
    asyncLoadAllPayment();
    fetchUserData();
  }

  // Load payments from users collection 
  Future<void> asyncLoadAllPayment() async {
    var payments = await db.collection("users").doc(userToken).collection("payments")
      .withConverter<PaymentData>(
        fromFirestore: PaymentData.fromFirestore,
        toFirestore: (PaymentData payment, _) => payment.toFirestore(),
      )
      .where("dismiss", isEqualTo: false)
      .orderBy("timestamp", descending: currentFilter.value == PaymentFilter.newestFirst).get();
    paymentList.assignAll(payments.docs);
  }

  // Stream to handle fetching user data
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

  // Stream to handle fetching payment data
  Stream<List<QueryDocumentSnapshot<PaymentData>>> getPaymentStream(String userToken) {
    return db.collection("users").doc(userToken).collection("payments")
      .withConverter<PaymentData>(
        fromFirestore: PaymentData.fromFirestore,
        toFirestore: (PaymentData payment, _) => payment.toFirestore(),
      )
      .where("dismiss", isEqualTo: false)
      .snapshots()
      .map((snapshot) => snapshot.docs);
  }

  // Combine the streams to get user data for each payment
  Stream<Map<String, UserData?>> getCombinedStream() {
    return RouteFirestoreMiddleware.getCombinedStream<PaymentData, UserData>(
      primaryStream: () => getPaymentStream(userToken),
      secondaryStream: (userIds) => getUserStream(userIds),
      getSecondaryId: (payment) => payment.uid!,
    );
  }

  Stream<Map<String, UserData?>> get combinedStream => getCombinedStream();

  void deletePayment(String paymentId) {
    // Remove the payment from the list
    paymentList.removeWhere((payment) => payment.id == paymentId);

    // Dismiss the payment from the database
    db.collection("users").doc(userToken).collection("payments").doc(paymentId).update({
      "dismiss": true
    });

    // Update the UI
    update();
  }

  // Change the filter
  void changeFilter(PaymentFilter filter) {
    currentFilter.value = filter;

    // Update the filter in storage
    GetStorage().write('payment_filter', filter.toString());

    // Refresh the payments
    asyncLoadAllPayment();
  }

  void fetchUserData([String? userId]) async {
    final String fetchUserId = userId ?? userToken;

    if (fetchUserId.isEmpty) {
      print('Error: User ID is null or empty');
      return;
    }

    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await db.collection('users').doc(fetchUserId).get();

      if (userDoc.exists) {
        user.value = UserData.fromFirestore(userDoc, null);
      } else {
        print('User not found');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }
}

enum PaymentFilter {
  newestFirst,
  oldestFirst,
}