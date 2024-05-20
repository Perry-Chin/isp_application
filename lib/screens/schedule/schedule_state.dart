import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../common/data/data.dart';

class ProviderState {
  RxList<QueryDocumentSnapshot<ServiceData>> providerList = <QueryDocumentSnapshot<ServiceData>>[].obs;
}

class RatingState {
  RxList<QueryDocumentSnapshot<UserData>> ratingState = <QueryDocumentSnapshot<UserData>>[].obs;
}

class ScheduleState {
  ProviderState providerState;
  RatingState ratingState;
  ScheduleState(this.providerState, this.ratingState);
}