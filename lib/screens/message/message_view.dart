// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/theme/custom/custom_theme.dart';
import '../../common/values/values.dart';
import '../../common/widgets/widgets.dart';
import 'message_index.dart';

class MessagePage extends GetView<MessageController> {
  const MessagePage({super.key});

  AppBar _buildAppBar(context) {
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Image(image: AssetImage(AppImage.logo), width: 35, height: 35),
          const SizedBox(width: 8),
          Text(
            "Message",
            style: CustomTextTheme.darkTheme.labelMedium
          ),
        ],
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
            const SizedBox(height: 3),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
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