// Request Service Controller

// ignore_for_file: avoid_init_to_null, non_constant_identifier_names, use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';



import '../../common/data/service.dart';
import '../../common/storage/storage.dart';
import '../../common/utils/utils.dart';
import '../../common/values/values.dart';
import '../../common/widgets/widgets.dart';
import 'request_index.dart';

class RequestController extends GetxController {
  RequestController();

  bool validateFields() {
    return serviceController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        rateController.text.isNotEmpty &&
        locationController.text.isNotEmpty &&
        dateController.text.isNotEmpty &&
        starttimeController.text.isNotEmpty &&
        durationController.text.isNotEmpty;
  }

  final state = RequestState();
  File? photo;
  var doc_id = null;
  final token = UserStore.to.token;
  var requestCompleted = false.obs;
  //
  final serviceController = TextEditingController();
  final descriptionController = TextEditingController();
  final rateController = TextEditingController();
  final imageController = TextEditingController();
  final locationController = TextEditingController();
  final dateController = TextEditingController();
  final starttimeController = TextEditingController();
  final durationController = TextEditingController();
  //Grab the last step, called in the view
  bool get isLastStep => state.currentStep.value == getSteps().length - 1;

  void moveToNextStep() {
    // Check if current step is less then the total steps
    if (state.currentStep < getSteps().length - 1) {
      // Check if the last step
      state.currentStep.value++;
      update(); // Notify GetBuilder to rebuild
    }
    print(token);
  }

  void cancelStep() {
    if (state.currentStep > 0) {
      state.currentStep.value -= 1;
      update(); // Notify listeners to rebuild
    }
  }

  void setStep(int stepIndex) {
    state.currentStep.value = stepIndex;
    update();
  }

  void resetForm() {
    print(requestCompleted.value);
    // Clear text in text controllers
    serviceController.clear();
    descriptionController.clear();
    rateController.clear();
    imageController.clear();
    locationController.clear();
    dateController.clear();
    starttimeController.clear();
    durationController.clear();

    // Reset the current step
    state.currentStep.value = 0;

    // Set requestCompleted to true
    requestCompleted.value = false;
  }

  List<Step> getSteps() {
    return [
      Step(
          state: state.currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: state.currentStep >= 0,
          title: const Text('Details'),
          content: Column(
            children: [
              const SizedBox(height: 5),
              // MySearchField(
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
                controller: serviceController
              ),
              const SizedBox(height: 20),
              // Description
              MyTextField(
                hinttext: 'Your Service',
                labeltext: 'Description',
                prefixicon: Icons.edit_document,
                obscuretext: false,
                controller: descriptionController,
                maxLines: 8,
              ),
              const SizedBox(height: 20),
              // Rate/hour (int)
              MyTextField(
                  hinttext: 'Your rate',
                  labeltext: 'Rate',
                  prefixicon: Icons.price_change,
                  obscuretext: false,
                  controller: rateController),
              const SizedBox(height: 20),
              // Image (img)
              MyTextField(
                hinttext: 'Select image',
                labeltext: 'Image',
                prefixicon: Icons.image,
                obscuretext: false,
                controller: imageController,
                readOnly: true,
                onTap: () => showImagePicker(Get.context!, (selectedImage) {
                  photo = selectedImage; // Update the photo
                  // If user has selected an image, update the textfield
                  if (selectedImage != null) {
                    imageController.text = "Image uploaded successfully";
                  }
                  update(); // Notify GetX to rebuild the UI
                }),
              ),
            ],
          )),
      Step(
          state: state.currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: state.currentStep >= 1,
          title: const Text('Personal'),
          content: Column(children: [
            const SizedBox(height: 5),
            //Location
            MyTextField(
                hinttext: 'Your location',
                labeltext: 'Location',
                prefixicon: Icons.add_location_alt_outlined,
                obscuretext: false,
                controller: locationController),


            const SizedBox(height: 20),
            //Date (YYYY-MM-DD)
            MyTextField(
              hinttext: 'Select date',
              labeltext: 'Date',
              prefixicon: Icons.calendar_month,
              controller: dateController,
              obscuretext: false,

              readOnly: true,
              onTap: () =>
                  Get.find<RequestController>().selectDate(Get.context!),




            ),
            //Time (AM/PM)
            const SizedBox(height: 20),

            MyTextField(
              hinttext: 'Select start time',
              labeltext: 'Time',
              prefixicon: Icons.alarm,
              obscuretext: false,
              controller: starttimeController,
              readOnly: true,
              onTap: () =>
                  Get.find<RequestController>().selectTime(Get.context!),




            ),
            const SizedBox(height: 20),
            // Rate/hour (int)
            MyTextField(
                hinttext: 'Duration of service',
                labeltext: 'Duration',
                prefixicon: Icons.timelapse,
                obscuretext: false,
                controller: durationController),









          ])),
      Step(

          isActive: state.currentStep >= 2,
          title: const Text('Complete'),
          content: Container()),



















    ];
  }

  // Function to select a data using date picker
  Future<void> selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      // Customizing the appearance of the date picker
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            // Customize colors of date picker
            colorScheme: const ColorScheme.light(
              primary: AppColor.secondaryColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColor.secondaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );


    // If a date is selected, update the dateController text with the selected date
    if (pickedDate != null) {
      dateController.text = pickedDate.toString().split(" ")[0];
    }





  }

  // Function to select a time from the time picker
  Future<void> selectTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      // Customizing the appearance of the time picker
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            // Customize colors of date picker
            colorScheme: const ColorScheme.light(
              primary: AppColor.secondaryColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColor.secondaryColor,
              ),



            ),
          ),
          child: child!,
        );
      },
    );

    // If a time is selected, update the timeController text with the selected time
    if (pickedTime != null) {
      starttimeController.text = pickedTime.format(context);
    }
  }

  // Function to get the download URL of an image from Firebase Storage
  Future getImgUrl(String name) async {
    final spaceRef =
        FirebaseStorage.instance.ref("service").child(name); // Reference
    var str = await spaceRef
        .getDownloadURL(); // Getting the download URL of the image
    return str;










  }

  // Function to upload a file to Firebase Storage
  Future uploadFile() async {
    if (photo == null) return;
    // Generating a unique file name for the uploaded file
    final fileName = getRandomString(15) + extension(photo!.path);

    try {
      final ref = FirebaseStorage.instance.ref("service").child(fileName);
      final uploadTask = ref.putFile(photo!);
      // Wait for the upload task to complete
      final snapshot = await uploadTask;

      // Get the download URL
      final imgUrl = await snapshot.ref.getDownloadURL();
      return imgUrl;
    } catch (e) {
      print("There's an error $e");
    }
  }

  Future<void> confirmRequest(BuildContext context) async {
    // Show loading dialog
   appLoading(context);

    try {
      //Check if all fields are filled
      if (!validateFields()) {
        throw 'Please fill in all fields.';
      }

      //Check if rate is number
      if (int.tryParse(rateController.text) == null) {
        throw 'Rate must be a number.';
      }

      // Check if duration is a number
      if (int.tryParse(durationController.text) == null) {
        throw 'Duration must be a number.';
      }

      // Create service document and add to Firestore
      await createServiceDocument();

      Navigator.of(context).pop();
    } catch (error) {
      // Dismiss loading dialog
      Navigator.pop(context);

      // Show error message for failed sign-in attempts
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(AppText.error),
          content: Text(error.toString()),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);



              },
              child: const Text(AppText.confirmation),
            ),
          ],
        ),
      );
    }
  }

  @override
  void onInit() {
    super.onInit();
    var data = Get.parameters;
    doc_id = data['doc_id'];


  }

  Future<void> createServiceDocument() async {
    // String profile = await UserStore.to.getProfile();
    // UserLoginResponseEntity userdata =
    //     UserLoginResponseEntity.fromJson(jsonDecode(profile));

    // Upload the file and get the image URL
    final imgUrl = await uploadFile();

    final serviceData = ServiceData(
        serviceid: doc_id,
        serviceName: serviceController.text,
        description: descriptionController.text,
        rate: int.tryParse(rateController.text),
        image: imgUrl ?? "",
        location: locationController.text,
        date: dateController.text,
        starttime: starttimeController.text,
        // endtime: //end time calculate from starttime and duration
        duration: int.tryParse(durationController.text),
        status: "Requested", //Default status
        statusid: 4,
        reqUserid: token,
        provUserid: "");

    // Set data in Firestore document
    await FirebaseFirestore.instance.collection('service').doc(doc_id).set(
          serviceData.toFirestore(),
        );

    requestCompleted.value = true;
  }
}















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
