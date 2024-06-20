import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../common/data/data.dart';
import '../../common/utils/utils.dart';
import '../../common/values/values.dart';
import 'message_index.dart';

class MessageList extends GetView<MessageController> {
  const MessageList({super.key});
  
  Widget messageListItem(QueryDocumentSnapshot<Msg> item, UserData? userData) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.w),
      color: AppColor.backgroundColor,
      elevation: 0.5,
      child: InkWell(
        onTap: () {
          var toUserid = "";
          var toName = "";
          var toAvatar = "";
          if(item.data().fromUserid == controller.token) {
            toUserid = item.data().toUserid ?? "";
            toName = userData?.username ?? "";
            toAvatar = userData!.photourl!;
          }
          else {
            toUserid = item.data().fromUserid ?? "";
            toName = userData?.username ?? "";
            toAvatar = userData!.photourl!;
          }
          print(toAvatar);
          Get.toNamed("/chat", parameters: {
            "doc_id": item.id,
            "to_uid": toUserid,
            "to_name": toName,
            "to_avatar": toAvatar
          });
        },
        child: ListTile(
          leading: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 50.w
            ),
            child: ClipOval(
              child: userData?.photourl != null && userData!.photourl!.isNotEmpty ?
              FadeInImage.assetNetwork(
                placeholder: AppImage.profile,
                image: userData.photourl ?? "",
                fadeInDuration: const Duration(milliseconds: 100),
                fit: BoxFit.cover,
                width: 54.w,
                height: 54.w,
              ) :
              Image.asset(AppImage.profile),
            ),
          ),
          title: Text(
            userData?.username ?? "",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            item.data().lastMsg ?? "",
            maxLines: 1,
          ),
          trailing: Text(
            duTimeLineFormat(
              (item.data().lastTime as Timestamp).toDate()
            ),
            style: const TextStyle(
              color: Colors.black54
            ),
          ),
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, UserData?>>(
      stream: controller.combinedStream,
      builder: (context, snapshot) {
        final userDataMap = snapshot.data ?? {};
        if (snapshot.connectionState == ConnectionState.waiting) {    
          return const Center(child: CircularProgressIndicator());
        }
        return Obx(
          () => SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            controller: controller.refreshController,
            onLoading: controller.onLoading,
            onRefresh: controller.onRefresh,
            header: const WaterDropHeader(),
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.w),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        var item = controller.state.filteredMsgList[index];
                        var userData = userDataMap[
                          item.data().fromUserid == controller.token
                            ? item.data().toUserid!
                            : item.data().fromUserid!
                          ]; 
                        return messageListItem(item, userData);
                      },
                      childCount: controller.state.filteredMsgList.length
                    )
                  ),
                ),
              ],
            ),
          )
        );
      }
    );
  }
}