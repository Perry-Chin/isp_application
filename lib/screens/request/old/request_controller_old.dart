











// // request_controller.dart

// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:path/path.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart'; // Import Google Maps
// import 'custom_duration_picker.dart'; // Import the custom duration picker

// import '../../common/data/service.dart';
// import '../../common/storage/storage.dart';
// import '../../common/utils/utils.dart';
// import '../../common/values/values.dart';
// import '../../common/widgets/widgets.dart';
// import 'request_index.dart';

// class RequestController extends GetxController {
//   RequestController();

//   bool validateFields() {
//     return serviceController.text.isNotEmpty &&
//         descriptionController.text.isNotEmpty &&
//         rateController.text.isNotEmpty &&
//         locationController.text.isNotEmpty &&
//         dateController.text.isNotEmpty &&
//         starttimeController.text.isNotEmpty &&
//         durationController.text.isNotEmpty;
//   }

//   final state = RequestState();
//   File? photo;
//   var doc_id = null;
//   final token = UserStore.to.token;
//   var requestCompleted = false.obs;
//   //
//   final serviceController = TextEditingController();
//   final descriptionController = TextEditingController();
//   final rateController = TextEditingController();
//   final imageController = TextEditingController();
//   final locationController = TextEditingController();
//   final dateController = TextEditingController();
//   final starttimeController = TextEditingController();
//   final durationController = TextEditingController();
//   //Grab the last step, called in the view
//   bool get isLastStep => state.currentStep.value == getSteps().length - 1;

//   void moveToNextStep() {
//     // Check if current step is less then the total steps
//     if (state.currentStep < getSteps().length - 1) {
//       // Check if the last step
//       state.currentStep.value++;
//       update(); // Notify GetBuilder to rebuild
//     }
//     print(token);
//   }

//   void cancelStep() {
//     if (state.currentStep > 0) {
//       state.currentStep.value -= 1;
//       update(); // Notify listeners to rebuild
//     }
//   }

//   void setStep(int stepIndex) {
//     state.currentStep.value = stepIndex;
//     update();
//   }

//   void resetForm() {
//     print(requestCompleted.value);
//     // Clear text in text controllers
//     serviceController.clear();
//     descriptionController.clear();
//     rateController.clear();
//     imageController.clear();
//     locationController.clear();
//     dateController.clear();
//     starttimeController.clear();
//     durationController.clear();

//     // Reset the current step
//     state.currentStep.value = 0;

//     // Set requestCompleted to true
//     requestCompleted.value = false;
//   }

//   List<Step> getSteps() {
//     return [
//       Step(
//           state: state.currentStep > 0 ? StepState.complete : StepState.indexed,
//           isActive: state.currentStep >= 0,
//           title: const Text('Details'),
//           content: Column(
//             children: [
//               const SizedBox(height: 5),
//               // MySearchField(
//               MySearchField(
//                 hinttext: 'Your Service', 
//                 labeltext: 'Service', 
//                 prefixicon: Icons.room_service,
//                 suggestions: const [
//                   "Sitting",
//                   "Walking",
//                   "Training",
//                   "Grooming"
//                 ], 
//                 focusNode: FocusNode(), 
//                 controller: serviceController
//               ),
//               const SizedBox(height: 20),
//               // Description
//               MyTextField(
//                 hinttext: 'Your Service',
//                 labeltext: 'Description',
//                 prefixicon: Icons.edit_document,
//                 obscuretext: false,
//                 controller: descriptionController,
//                 maxLines: 8,
//               ),
//               const SizedBox(height: 20),
//               // Rate/hour (int)
//               MyTextField(
//                   hinttext: 'Your rate',
//                   labeltext: 'Rate',
//                   prefixicon: Icons.price_change,
//                   obscuretext: false,
//                   controller: rateController),
//               const SizedBox(height: 20),
//               // Image (img)
//               MyTextField(
//                 hinttext: 'Select image',
//                 labeltext: 'Image',
//                 prefixicon: Icons.image,
//                 obscuretext: false,
//                 controller: imageController,
//                 readOnly: true,
//                 onTap: () => showImagePicker(Get.context!, (selectedImage) {
//                   photo = selectedImage; // Update the photo
//                   // If user has selected an image, update the textfield
//                   if (selectedImage != null) {
//                     imageController.text = "Image uploaded successfully";
//                   }
//                   update(); // Notify GetX to rebuild the UI
//                 }),
//               ),
//             ],
//           )),
//       Step(
//           state: state.currentStep > 1 ? StepState.complete : StepState.indexed,
//           isActive: state.currentStep >= 1,
//           title: const Text('Personal'),
//           content: Column(children: [
//             const SizedBox(height: 5),
//             //Location
//             MyTextField(
//                 hinttext: 'Your location',
//                 labeltext: 'Location',
//                 prefixicon: Icons.add_location_alt_outlined,
//                 obscuretext: false,
//                 controller: locationController,
//                 readOnly: true,
//                 onTap: () => showLocationPicker(Get.context!)), // Add onTap for location picker
//             const SizedBox(height: 20),
//             //Date (date)
//             MyTextField(
//               hinttext: 'Select date',
//               labeltext: 'Date',
//               prefixicon: Icons.date_range,
//               obscuretext: false,
//               controller: dateController,
//               readOnly: true,
//               onTap: () => showDatePickerDialog(Get.context!, (selectedDate) {
//                 if (selectedDate != null) {
//                   dateController.text = formatDate(selectedDate);
//                   update();
//                 }
//               }),
//             ),
//             const SizedBox(height: 20),
//             //Start time
//             MyTextField(
//               hinttext: 'Select start time',
//               labeltext: 'Start time',
//               prefixicon: Icons.access_time,
//               obscuretext: false,
//               controller: starttimeController,
//               readOnly: true,
//               onTap: () => showTimePickerDialog(Get.context!, (selectedTime) {
//                 if (selectedTime != null) {
//                   starttimeController.text = selectedTime.format(Get.context!);
//                   update();
//                 }
//               }),
//             ),
//             const SizedBox(height: 20),
//             //Duration
//             MyTextField(
//               hinttext: 'Select duration',
//               labeltext: 'Duration',
//               prefixicon: Icons.timer,
//               obscuretext: false,
//               controller: durationController,
//               readOnly: true,
//               onTap: () => showDurationPickerDialog(Get.context!, (selectedDuration) {
//                 if (selectedDuration != null) {
//                   durationController.text =
//                       '${selectedDuration.inHours}h ${selectedDuration.inMinutes % 60}m';
//                   update();
//                 }
//               }),
//             ),
//           ])),
//       Step(
//           state: state.currentStep > 2 ? StepState.complete : StepState.indexed,
//           isActive: state.currentStep >= 2,
//           title: const Text('Confirmation'),
//           content: Column(
//             children: [
//               const SizedBox(height: 5),
//               // Description
//               MyTextField(
//                   hinttext: 'Details',
//                   labeltext: 'Please confirm your request details',
//                   prefixicon: Icons.room_service,
//                   obscuretext: false,
//                   controller: descriptionController,
//                   maxLines: 8),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () async {
//                   await confirmRequest();
//                 },
//                 child: Text('Submit'),
//               ),
//             ],
//           ))
//     ];
//   }

//   // Add duration picker dialog method
//   Future<void> showDurationPickerDialog(BuildContext context, Function(Duration?) onDurationSelected) async {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return CustomDurationPicker(
//           initialDuration: Duration(minutes: 30),
//           onDurationSelected: onDurationSelected,
//         );
//       },
//     );
//   }

//   // Existing methods for showing other dialogs
//   Future<void> showDatePickerDialog(BuildContext context, Function(DateTime?) onDateSelected) async {
//     DateTime? selectedDate = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//     onDateSelected(selectedDate);
//   }

//   Future<void> showTimePickerDialog(BuildContext context, Function(TimeOfDay?) onTimeSelected) async {
//     TimeOfDay? selectedTime = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//     );
//     onTimeSelected(selectedTime);
//   }

//   Future<void> showErrorDialog(BuildContext context, String message) async {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Error'),
//           content: Text(message),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> showLoadingDialog(BuildContext context, String message) async {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Loading'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               CircularProgressIndicator(),
//               SizedBox(height: 20),
//               Text(message),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Future<void> showSuccessDialog(BuildContext context, String message) async {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Success'),
//           content: Text(message),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> showLocationPicker(BuildContext context) async {
//     LatLng? selectedLocation;
//     await showDialog<LatLng>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Select Location'),
//           content: Container(
//             width: double.maxFinite,
//             height: 400,
//             child: GoogleMap(
//               initialCameraPosition: CameraPosition(
//                 target: LatLng(37.7749, -122.4194),
//                 zoom: 12.0,
//               ),
//               onTap: (location) {
//                 selectedLocation = location;
//               },
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 if (selectedLocation != null) {
//                   locationController.text = '${selectedLocation!.latitude}, ${selectedLocation!.longitude}';
//                   Navigator.of(context).pop();
//                 }
//               },
//               child: const Text('Select'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> confirmRequest() async {
//     if (validateFields()) {
//       await saveRequest();
//       showSuccessDialog(Get.context!, 'Request successfully submitted!');
//     } else {
//       showErrorDialog(Get.context!, 'Please fill in all fields before submitting.');
//     }
//   }

//   Future<void> saveRequest() async {
//     // Implement the logic to save the request here
//   }
// }
