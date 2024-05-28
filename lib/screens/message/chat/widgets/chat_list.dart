import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../common/values/values.dart';
import '../chat_index.dart';
import 'chat_left_item.dart';
import 'chat_right_item.dart';

class ChatList extends GetView<ChatController> {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        color: AppColor.backgroundColor,
        padding: EdgeInsets.only(bottom: 50.w),
        child: CustomScrollView(
          reverse: true,
          controller: controller.msgScrolling,
          slivers: [
            SliverPadding(
              padding: EdgeInsets.symmetric(
                vertical: 0.w,
                horizontal: 0.w
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    var item = controller.state.msgcontentList[index];
                    if(controller.user_id == item.uid) {
                      return chatRightItem(item);
                    }
                    return chatLeftItem(item);
                  },
                  childCount: controller.state.msgcontentList.length
                )
              ),
            ),
          ],
        ),
      )
    );
  }
}