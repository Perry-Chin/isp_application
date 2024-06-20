// Chat View

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
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(top: 0.w, bottom: 0.w, right: 10.w),
            child: InkWell(
              child: SizedBox(
                width: 40.w,
                height: 40.w,
                child: ClipOval(
                  child: controller.state.toAvatar.value.isNotEmpty
                  ? FadeInImage.assetNetwork(
                      placeholder: AppImage.profile,
                      image: controller.state.toAvatar.value,
                      fadeInDuration: const Duration(milliseconds: 100),
                      fit: BoxFit.cover,
                      width: 50.w,
                      height: 50.w,
                      imageErrorBuilder: (context, error, stackTrace) {
                        print("Error loading image: $error");
                        return Image.asset(AppImage.profile);
                      },
                    )
                  : Image.asset(AppImage.profile),
                )
              ),
            )
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
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {controller.imgFromGallery();}, 
                                icon: const Icon(
                                  Icons.emoji_emotions,
                                  size: 26,
                                  color: AppColor.secondaryColor,
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  keyboardType: TextInputType.multiline,
                                  minLines: 1,
                                  maxLines: 3,
                                  controller: controller.textController,
                                  autofocus: false,
                                  focusNode: controller.contentNode,
                                  decoration: const InputDecoration(
                                    hintText: "Type a message",
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(color: AppColor.secondaryColor)
                                  ),
                                )
                              ),
                              IconButton(
                                onPressed: () {controller.imgFromGallery();}, 
                                icon: const Icon(
                                  Icons.photo_outlined,
                                  size: 26,
                                  color: AppColor.secondaryColor,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          controller.sendMessage();
                        },
                        minWidth: 0,
                        shape: const CircleBorder(),
                        color: AppColor.secondaryColor,
                        padding: const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
