import 'package:cached_network_image/cached_network_image.dart';
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
  
  Widget messageListItem(QueryDocumentSnapshot<Msg> item) {
    return Container(
      padding: EdgeInsets.only(top: 10.w, left: 15.w, right: 15.w),
      child: InkWell(
        onTap: () {
          // var to_uid = "";
          // var to_name = "";
          // var to_avatar = "";
          // if(item.data().fromUserid == controller.token) {
          //   to_uid = item.data().toUserid ?? "";
          //   to_name = item.data() ?? "";
          //   to_avatar = item.data().to_avatar ?? "";
          // }
          // else {
          //   to_uid = item.data().from_uid ?? "";
          //   to_name = item.data().from_name ?? "";
          //   to_avatar = item.data().from_avatar ?? "";
          // }
          // Get.toNamed("/chat", parameters: {
          //   "doc_id": item.id,
          //   "to_uid": to_uid,
          //   "to_name": to_name,
          //   "to_avatar": to_avatar
          // });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Container(
            //   padding: EdgeInsets.only(top: 0.w, left: 0.w, right: 15.w),
            //   child: SizedBox(
            //     width: 54.w,
            //     height: 54.w,
            //     child: CachedNetworkImage(
            //       //Check the uid of the current user and show only other users
            //       imageUrl: item.data().fromUserid == controller.token 
            //         ? item.data().toUserid!:
            //         item.data().from_avatar!,
            //         imageBuilder: (context, ImageProvider) => Container(
            //         width: 54.w,
            //         height: 54.w,
            //         decoration: BoxDecoration(
            //           borderRadius: const BorderRadius.all(Radius.circular(54)),
            //           image: DecorationImage(
            //             image: ImageProvider,
            //             fit: BoxFit.cover
            //           )
            //         ),
            //       ),
            //       //If the user does not have a profile picture
            //       errorWidget: (context, url, error) => const Image(
            //         image: AssetImage('assets/images/feature-1.png')
            //       ),
            //     ),
            //   ),
            // ),
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
                          item.data().fromUserid == controller.token
                            ? item.data().toUserid!
                            : item.data().toUserid!,
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
                    return messageListItem(item);
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
}