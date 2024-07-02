import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Local Dependencies
import '../../../common/widgets/widgets.dart';
import '../request_index.dart';

List<Step> getSteps(int currentStep) {
  final controller = Get.put(RequestController());
  return [
    Step(
      state: currentStep > 0 ? StepState.complete : StepState.indexed, 
      isActive: currentStep >= 0,
      title: const Text('Details'), 
      content: Column(
        children: [
          const SizedBox(height: 5),
          // Service Name
          MySearchField(
            hinttext: 'Your Service', 
            labeltext: 'Service', 
            prefixicon: Icons.room_service,
            suggestions: const [
              "Sitting",
              "Walking",
              "Training",
              "Grooming"
            ], 
            focusNode: FocusNode(), 
            controller: controller.serviceController,
          ),
          const SizedBox(height: 20),
          // Description
          MyTextField(
            hinttext: 'Your Service',
            labeltext: 'Description',
            prefixicon: Icons.edit_document,
            obscuretext: false,
            textController: controller.descriptionController,
            maxLines: 8,
          ),
          const SizedBox(height: 20),
          // Rate/hour (int)
          MyTextField(
            hinttext: 'Your rate',
            labeltext: 'Rate',
            prefixicon: Icons.price_change,
            obscuretext: false,
            textController: controller.rateController
          ),
          const SizedBox(height: 20),
          // Image (img)
          MyTextField(
            hinttext: 'Select image',
            labeltext: 'Image',
            prefixicon: Icons.image,
            obscuretext: false,
            textController: controller.imageController,
            readOnly: true,
            onTap: () => showImagePicker(Get.context!, (selectedImage) {
              
            })
          ),
        ],
      )
    ),
    Step(
      state: currentStep > 1 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 1,
      title: const Text('Personal Details'),
      content: Column(
        children: [
          const SizedBox(height: 5),
          // Location Name
          MyTextField(
            hinttext: 'Your location',
            labeltext: 'Location',
            prefixicon: Icons.add_location_alt_outlined,
            obscuretext: false,
            textController: controller.locationController
          ),
          const SizedBox(height: 20),
          //Date (YYYY-MM-DD)
          MyTextField(
            hinttext: 'Select date',
            labeltext: 'Date',
            prefixicon: Icons.calendar_month,
            textController: controller.dateController,
            obscuretext: false,
            readOnly: true,
            onTap: () => controller.selectDate(Get.context!),
          ),
          //Time (AM/PM)
          const SizedBox(height: 20),
          MyTextField(
            hinttext: 'Select start time',
            labeltext: 'Start Time',
            prefixicon: Icons.timelapse,
            textController: controller.starttimeController,
            obscuretext: false,
            readOnly: true,
            onTap: () => controller.selectTime(Get.context!, true),
          ),
          const SizedBox(height: 20),
          // End Time
          MyTextField(
            hinttext: 'Select end time',
            labeltext: 'End Time',
            prefixicon: Icons.timelapse,
            textController: controller.endtimeController,
            obscuretext: false,
            readOnly: true,
            onTap: () => controller.selectTime(Get.context!, false),
          ),
        ]
      ) 
    )
  ];
}