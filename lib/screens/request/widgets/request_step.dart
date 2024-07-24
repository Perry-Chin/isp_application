import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'request_map.dart';

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
      title: Text(
        'Details',
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500
        )
      ), 
      content: Column(
        children: [
          const SizedBox(height: 7),
          // Service Name
          MyDropdownField(
            hintText: 'Your Service',
            labelText: 'Service',
            prefixIcon: Icons.room_service,
            items: const [
              "Sitting",
              "Walking",
              "Training",
              "Grooming"
            ],
            value: controller.selectedService,
            onChanged: (newValue) {
              controller.selectedService = newValue;
              controller.update();
            },
            validator: (value) => RouteValidateServiceMiddleware.validateService(value)
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
            hinttext: 'Your rate in SGD per hour',
            labeltext: 'Rate/hour',
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
            onTap: () => showImagePicker(Get.context!, (selectedImage) {
              controller.photo = selectedImage; // Update the photo
              // If user has selected an image, update the textfield
              if (selectedImage != null) {
                controller.imageController.text = "Image uploaded successfully";
              }
            }),
          ),
        ],
      )
    ),
    Step(
      state: currentStep > 1 ? StepState.complete : StepState.indexed,
      isActive: currentStep >= 1,
      title: Text(
        'Personal Details',
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500
        )
      ),
      content: Column(
        children: [
          const SizedBox(height: 5),
          // Location Name
            // onTap: () {
            //     Get.to(RequestMap());
            //   },
            MyTextField(
              hinttext: 'Your location',
              labeltext: 'Location',
              prefixicon: Icons.add_location_alt_outlined,
              textController: controller.locationController,
              //onTap: () => selectLocation(Get.context!, controller.locationController),
              onTap: () {
                  Get.to(RequestMap());
              },
              // validator: (value) => RouteValidateServiceMiddleware.validateLocation(value)
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