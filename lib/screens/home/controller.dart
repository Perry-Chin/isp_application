import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../common/data/service.dart';
import '../../common/storage/storage.dart';
import 'index.dart';

class HomeController extends GetxController {
  HomeController();
  //Grab current login user token
  final token = UserStore.to.token;
  final db = FirebaseFirestore.instance;
  final HomeState state = HomeState();
  final RefreshController refreshController = RefreshController (
    initialRefresh: true
  );

  //The dependency requires this 2 functions to work
  void onRefresh() {
      print(token);
    asyncLoadAllData().then((_){
      refreshController.refreshCompleted(resetFooterState: true);
    }).catchError((_){
      refreshController.refreshFailed();
    });
  }
 
  void onLoading() {
    asyncLoadAllData().then((_){
      refreshController.loadComplete();
    }).catchError((_){
      refreshController.loadFailed();
    });
  }
  //

  asyncLoadAllData() async {
    var req_services = await db.collection("service").withConverter(
      fromFirestore: ServiceData.fromFirestore, 
      toFirestore: (ServiceData serviceData, options) => serviceData.toFirestore()
    ).where("requester_uid", isEqualTo: token).get();

    state.serviceList.clear();

    if(req_services.docs.isNotEmpty) {
      state.serviceList.assignAll(req_services.docs);
    } 
  }
}