import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: AppColor.backgroundColor, // Apply the background color here
          child: Column(
            children: [
              Expanded(
                child: Stepper(
                  steps: getSteps(controller.currentStep.value),
                  currentStep: controller.currentStep.value,
                  onStepContinue: controller.isLastStep
                      ? () => controller.confirmRequest(context)
                      : controller.moveToNextStep,
                  onStepCancel: controller.cancelStep,
                  onStepTapped: (index) => controller.setStep(index),
                  controlsBuilder: (BuildContext context, ControlsDetails controls) {
                    return Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: Row(
                        children: [
                          Expanded(
                            child: Obx(
                              () => ElevatedButton(
                                onPressed: controller.isProcessing.value ? null : controls.onStepContinue,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    controller.isLastStep ? 'CONFIRM' : 'NEXT',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16
                                    ),
                                  ),
                                ),
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
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    'BACK',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}