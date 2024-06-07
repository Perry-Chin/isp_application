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
        timeController.text.isNotEmpty &&
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
  final timeController = TextEditingController();
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
    timeController.clear();
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
              hinttext: 'Select time',
              labeltext: 'Time',
              prefixicon: Icons.alarm,
              obscuretext: false,
              controller: timeController,
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
      timeController.text = pickedTime.format(context);
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
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

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
          title: const Text('Error'),
          content: Text(error.toString()),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
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
        time: timeController.text,
        duration: int.tryParse(durationController.text),
        status: "Requested", //Default status
        statusid: 0,
        reqUserid: token,
        provUserid: "");

    // Set data in Firestore document
    await FirebaseFirestore.instance.collection('service').doc(doc_id).set(
          serviceData.toFirestore(),
        );

    requestCompleted.value = true;
  }
}
