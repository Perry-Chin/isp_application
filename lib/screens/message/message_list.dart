import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../common/data/data.dart';
import '../../common/utils/utils.dart';
import 'message_index.dart';

class MessageList extends GetView<MessageController> {
  const MessageList({super.key});
  
  Widget messageListItem(QueryDocumentSnapshot<Msg> item, UserData? userData) {
    return Container(
      padding: EdgeInsets.only(top: 10.w, left: 15.w, right: 15.w),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 14.0),
              child: Container(
                width: 57.w,
                height: 57.w,
                child: ClipOval(
                  child: userData?.photourl != null && userData!.photourl!.isNotEmpty
                    ? FadeInImage.assetNetwork(
                        placeholder: "assets/images/profile.png",
                        image: userData.photourl!,
                        fadeInDuration: const Duration(milliseconds: 100),
                        fit: BoxFit.cover,
                        width: 57.w,
                        height: 57.w,
                        imageErrorBuilder: (context, error, stackTrace) {
                          print("Error loading image: $error");
                          return Image.asset("assets/images/profile.png");
                        },
                      )
                  : Image.asset("assets/images/profile.png"),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 0.w, left: 0.w, right: 5.w),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1, color: Colors.black12)
                )
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 190.w,
                    height: 48.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userData?.username ?? "",
                          overflow: TextOverflow.clip,
                          maxLines: 1,   
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp
                          ),                  
                        ),
                        Text(
                          item.data().lastMsg ?? "",
                          overflow: TextOverflow.clip,
                          maxLines: 1,   
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 14.sp
                          ),                  
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 60.w,
                    height: 54.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          duTimeLineFormat(
                            (item.data().lastTime as Timestamp).toDate()
                          ),
                          overflow: TextOverflow.clip,
                          maxLines: 1,   
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 12.sp
                          ),                  
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, UserData?>>(
      stream: controller.combinedStream,
      builder: (context, snapshot) {
        final userDataMap = snapshot.data ?? {};
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return const ShimmerLoading();
        // }
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
                        var item = controller.state.msgList[index];
                        var userData = userDataMap[
                          item.data().fromUserid == controller.token
                            ? item.data().toUserid!
                            : item.data().fromUserid!
                          ]; 
                        return messageListItem(item, userData);
                      },
                      childCount: controller.state.msgList.length
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