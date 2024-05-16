import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../common/data/service.dart';
import '../../common/storage/storage.dart';
import '../home/home_index.dart';


class ScheduleController extends GetxController {
  ScheduleController();

  final token = UserStore.to.token;
  final db = FirebaseFirestore.instance;
  final HomeState state = HomeState();
  final RefreshController refreshController = RefreshController (
    initialRefresh: true
  );


    void onRefresh() {
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

   asyncLoadAllData() async {
    var reqServices = await db.collection("service").withConverter( 
      fromFirestore: ServiceData.fromFirestore, 
      toFirestore: (ServiceData serviceData, options) => serviceData.toFirestore()
    ).where("provider_uid", isNotEqualTo: token).get();

    state.serviceList.clear();

    if(reqServices.docs.isNotEmpty) {
      state.serviceList.assignAll(reqServices.docs);
    }
  }

}