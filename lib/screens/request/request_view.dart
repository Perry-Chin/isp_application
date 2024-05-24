// Request Service View

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

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
        backgroundColor: AppColor.backgroundColor,
          appBar: _buildAppBar(),
          body: Obx(() {
            //Request submitted successfully
            if (controller.requestCompleted.value) {
              return Stack(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Request submitted!",
                            style: TextStyle(
                              color: AppColor.secondaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 24.sp
                            )
                          ),
                          Lottie.asset('assets/animations/success.json',
                              width: 250, height: 250, repeat: false),
                          const SizedBox(height: 20),
                          ApplyButton(
                            onPressed: () {
                              controller.resetForm();
                            },
                            buttonText: "Reset",
                            buttonWidth: double.infinity,
                            textAlignment: Alignment.center
                          )
                        ],
                      ),
                    ),
                  ),
                  Lottie.asset(
                    "assets/animations/confetti.json",
                    width: MediaQuery.sizeOf(context).height,
                    height: MediaQuery.sizeOf(context).width,
                    fit: BoxFit.cover,
                  )
                ],
              );
            } 
            else {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: AppColor.secondaryColor
                  )
                ),
                child: Stepper(
                  steps: controller.getSteps(),
                  currentStep: controller.state.currentStep.value,
                  onStepContinue: controller.isLastStep
                      ? () => controller
                          .confirmRequest(context) //If current step is last
                      : controller.moveToNextStep, //Move 1 step forward
                  onStepCancel: controller.cancelStep, //Move 1 step back
                  onStepTapped: (index) => controller.setStep(index), //Move to step selected
                  controlsBuilder: (BuildContext context, ControlsDetails controls) {
                    return Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: controls.onStepContinue,
                              child: Text(controller.isLastStep
                                  ? 'CONFIRM'
                                  : 'NEXT')
                            )
                          ),
                          const SizedBox(width: 12),
                          if (controller.state.currentStep.value != 0)
                            Expanded(
                              child: ElevatedButton(
                                onPressed: controls.onStepCancel,
                                child: const Text('BACK')
                              )
                            )
                        ],
                      ),
                    );
                  }
                )
              );
            }
          }
        )
      ),
    );
  }
}