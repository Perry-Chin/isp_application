import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../common/data/service.dart';
import '../../common/data/user.dart';

class ScheduleState {
  final RxList<QueryDocumentSnapshot<ServiceData>> providerList = <QueryDocumentSnapshot<ServiceData>>[].obs;
  final RxList<QueryDocumentSnapshot<UserData>> ratingState = <QueryDocumentSnapshot<UserData>>[].obs;

  ScheduleState();
}
