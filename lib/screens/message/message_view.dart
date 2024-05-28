import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/values/values.dart';
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
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(),
      body: MessageList()
    );
  }
}