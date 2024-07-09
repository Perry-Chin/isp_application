// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/values/values.dart';
import '../../common/widgets/widgets.dart';
import 'message_index.dart';

class MessagePage extends GetView<MessageController> {
  const MessagePage({super.key});

  AppBar _buildAppBar(context) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: Text(
        "Message",
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      backgroundColor: AppColor.secondaryColor,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    // IGNORE: Initiate controller if missing
    final MessageController messageController = Get.put(MessageController());
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(context),
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