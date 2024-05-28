import 'package:get/get.dart';

import '../../../common/data/data.dart';

class ChatState {
  RxList<Msgcontent> msgcontentList = <Msgcontent>[].obs;
  var to_uid = "".obs;
  var to_name = "".obs;
  var to_avatar = "".obs;
  var to_location = "unknown".obs;
}