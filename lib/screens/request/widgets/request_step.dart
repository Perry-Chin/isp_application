import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Local Dependencies
import '../../../common/middlewares/middlewares.dart';
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
            maxLines: 8,
            hinttext: 'Your Service',
            labeltext: 'Description',
            prefixicon: Icons.edit_document,
            textController: controller.descriptionController,
            validator: (value) => RouteValidateServiceMiddleware.validateDescription(value)
          ),
          const SizedBox(height: 20),
          // Rate/hour (int)
          MyTextField(
            hinttext: 'Your rate',
            labeltext: 'Rate',
            prefixicon: Icons.price_change,
            keyboardType: TextInputType.number,
            textController: controller.rateController,
            validator: (value) => RouteValidateServiceMiddleware.validateRate(value)
          ),
          const SizedBox(height: 20),
          // Image (img)
          MyTextField(
            readOnly: true,
            obscuretext: false,
            hinttext: 'Select image',
            labeltext: 'Image',
            prefixicon: Icons.image,
            textController: controller.imageController,
            onTap: () => showImagePicker(Get.context!, (selectedImage) {}),
            validator: (value) => RouteValidateServiceMiddleware.validateImage(value)
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
            textController: controller.locationController,
            validator: (value) => RouteValidateServiceMiddleware.validateLocation(value)
          ),
          const SizedBox(height: 20),
          //Date (YYYY-MM-DD)
          MyTextField( 
            readOnly: true,
            hinttext: 'Select date',
            labeltext: 'Date',
            prefixicon: Icons.calendar_month,
            textController: controller.dateController,
            onTap: () => selectDate(Get.context!, controller.dateController),
            validator: (value) => RouteValidateServiceMiddleware.validateDate(value)
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
            onTap: () => selectTime(Get.context!, controller.starttimeController),
            validator: (value) => RouteValidateServiceMiddleware.validateStartTime(value)
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
            onTap: () => selectTime(Get.context!, controller.endtimeController),
            validator: (value) => RouteValidateServiceMiddleware.validateEndTime(value)
          ),
        ]
      ) 
    )
  ];
}