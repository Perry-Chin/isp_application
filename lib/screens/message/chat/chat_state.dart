import 'package:get/get.dart';

import '../../../common/data/data.dart';

class ChatState {
  RxList<Msgcontent> msgcontentList = <Msgcontent>[].obs;
  var toUserid = "".obs;
  var toName = "".obs;
  var toAvatar = "".obs;
}