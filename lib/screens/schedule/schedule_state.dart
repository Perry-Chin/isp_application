import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../common/data/service.dart';
import '../../common/data/user.dart';

class ScheduleState {
  List<QueryDocumentSnapshot<ServiceData>> providerList = [];
  List<QueryDocumentSnapshot<ServiceData>> requesterList = [];
  final RxList<QueryDocumentSnapshot<UserData>> ratingState = <QueryDocumentSnapshot<UserData>>[].obs;
  final List<String> selectedStatus = ['All'];
  // Map to store UserData objects with their IDs
  Map<String, UserData?> userDataMap = {};
  
  ScheduleState();
}
