// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/theme/custom/custom_theme.dart';
import '../../common/values/values.dart';
import '../../common/widgets/custom_container.dart';
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
        style: TextStyle(
          fontSize: 20,
          color: AppColor.darkColor,
          fontWeight: FontWeight.bold,
        )
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    // IGNORE: Initiate controller if missing
    final MessageController messageController = Get.put(MessageController());
    return Scaffold(
      backgroundColor: AppColor.secondaryColor,
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
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
              child: CustomContainer(
                child: Padding(
                  padding: EdgeInsets.only(top: 12.0, left: 4, right: 4),
                  child: MessageList(),
                ),
              ),
            ),
          ]
        ),
      ) 
    );
  }
}