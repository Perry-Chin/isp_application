import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../common/values/values.dart';
import 'chat_index.dart';
import 'widgets/chat_list.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({super.key});

  AppBar _appBar() {
    return AppBar(
      backgroundColor: AppColor.secondaryColor,
      elevation: 0,
      title: Container(
        padding: EdgeInsets.only(top: 0.w, bottom: 0.w, right: 0.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.only(top: 0.w, bottom: 0.w, right: 0.w),
              child: InkWell(
                child: SizedBox(
                  width: 44.w,
                  height: 44.w,
                ),
              ),
            ),
            Container(
              width: 180.w,
              padding: EdgeInsets.only(top: 0.w, bottom: 0.w, right: 0.w),
              child: Row(
                children: [
                  Text(
                    controller.state.toName.value,
                    overflow: TextOverflow.clip,
                    maxLines: 1,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
    return Scaffold(
      appBar: _appBar(),
      body: SafeArea(
        child: ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: Stack(
            children: [
              const ChatList(),
              Positioned(
                bottom: 0.h,
                height: 50.h,
                child: Container(
                  width: 360.w,
                  height: 50.h,
                  margin: EdgeInsets.only(left: 15.w, bottom: 10.h),
                  color: Colors.white54,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 217.w,
                        height: 50.h,
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          controller: controller.textController,
                          autofocus: false,
                          focusNode: controller.contentNode,
                          decoration: InputDecoration(
                            hintText: "Send messages...",
                          ),
                        ),
                      ),
                      Container(
                        height: 30.h,
                        width: 30.w,
                        margin: EdgeInsets.only(left: 5.w),
                        child: GestureDetector(
                          child: Icon(
                            Icons.photo_outlined,
                            size: 35.w,
                            color: Colors.blue,
                          ),
                          onTap: () {
                            // controller.imgFromGallery();
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10.w, top: 5.h),
                        width: 65.w,
                        height: 35.w,
                        child: ElevatedButton(
                          child: Text("Send"),
                          onPressed: () {
                            controller.sendMessage();
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
