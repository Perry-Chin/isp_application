// Request Page

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/theme/custom/custom_theme.dart';
import '../../common/values/values.dart';
import '../../common/widgets/widgets.dart';
import 'request_index.dart';

class RequestPage extends GetView<RequestController> {
  
  const RequestPage({super.key});

  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Image(image: AssetImage(AppImage.logo), width: 35, height: 35),
          const SizedBox(width: 8),
          Text(
            "Request Service",
            style: CustomTextTheme.lightTheme.titleMedium
          ),
        ],
      ),
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