import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../common/data/data.dart';

class HomeState {
  RxList<QueryDocumentSnapshot<ServiceData>> serviceList = <QueryDocumentSnapshot<ServiceData>>[].obs;
}