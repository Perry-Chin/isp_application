// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/values/values.dart';
import '../../common/widgets/widgets.dart';
import 'message_index.dart';

class MessagePage extends GetView<MessageController> {
  const MessagePage({super.key});

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: const Text("Message"),
      backgroundColor: AppColor.secondaryColor,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final MessageController messageController = Get.put(MessageController());
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 25, left: 25, right: 25),
            child: SearchBoxBar(
              controller: controller.searchController, 
              onChanged: (value) {
                // Call controller function to filter service list based on username
                controller.filterMessages(value);
              },
              showSuffixIcon: false,
            ),
          ),
          const SizedBox(height: 15),
          const Expanded(
            child: MessageList()
          ),
        ]
      ) 
    );
  }
}