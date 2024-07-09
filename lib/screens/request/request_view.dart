// Request Page

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/values/values.dart';
import '../../common/widgets/widgets.dart';
import 'request_index.dart';

class RequestPage extends GetView<RequestController> {
  
  const RequestPage({super.key});

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: const Text("Request service"),
      backgroundColor: AppColor.secondaryColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Reset the form when the back button is pressed
        controller.resetForm();
        return true; //Allow the back navigation
      },
      child: Scaffold(
        backgroundColor: AppColor.secondaryColor,
        appBar: _buildAppBar(),
        body: CustomContainer(
          child: Obx(() {
            //Request submitted successfully
            if (controller.requestCompleted.value) {
              return requestSuccess(controller, context);
            } else {
              return requestForm(controller, context);
            }
          }),
        ),
      ),
    );
  }
}