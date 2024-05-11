// Request Service State

import 'package:get/get.dart';

import '../../common/data/user.dart';

class RequestState {
  final currentStep = 0.obs;
  RxList<UserData> contactList = <UserData>[].obs;
}