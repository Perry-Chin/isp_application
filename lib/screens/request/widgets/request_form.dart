import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/values/values.dart';
import '../request_index.dart';

Widget requestForm(RequestController controller, BuildContext context) {
  return Form(
    key: controller.requestFormKey,
    child: Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(
          primary: AppColor.secondaryColor
        )
      ),
      child: Stepper(
        steps: getSteps(controller.currentStep.value),
        currentStep: controller.currentStep.value,
        onStepContinue: controller.isLastStep
            ? () => controller.confirmRequest(context) // If current step is last
            : controller.moveToNextStep, // Move 1 step forward
        onStepCancel: controller.cancelStep, // Move 1 step back
        onStepTapped: (index) => controller.setStep(index), // Move to step selected
        controlsBuilder: (BuildContext context, ControlsDetails controls) {
          return Container(
            margin: const EdgeInsets.only(top: 15),
            child: Row(
              children: [
                Expanded(
                  child: Obx(
                    () => ElevatedButton(
                      onPressed: controller.isProcessing.value ? null : controls.onStepContinue,
                      child: Text(controller.isLastStep ? 'CONFIRM' : 'NEXT'),
                    ),
                  ),
                ),
                Visibility(
                  visible: controller.currentStep.value != 0,
                  child: const SizedBox(width: 12),
                ),
                Visibility(
                  visible: controller.currentStep.value != 0,
                  child: Expanded(
                    child: ElevatedButton(
                      onPressed: controls.onStepCancel,
                      child: const Text('BACK'),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}