// Request Service Controller

// ignore_for_file: avoid_init_to_null, non_constant_identifier_names, use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';


import '../../common/data/service.dart';
import '../../common/middlewares/middlewares.dart';
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
        endtimeController.text.isNotEmpty;
  }

  File? photo;
  var doc_id = null;
  final currentStep = 0.obs;
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
  final endtimeController = TextEditingController();
  GlobalKey<FormState> requestFormKey = GlobalKey<FormState>();
  //Grab the last step, called in the view
  bool get isLastStep => currentStep.value == getSteps(currentStep.value).length - 1;

  void moveToNextStep() {
    // Check if current step is less then the total steps
    if (currentStep < getSteps(currentStep.value).length - 1) {
      // Check if the last step
      currentStep.value++;
      update(); // Notify GetBuilder to rebuild
    }
    print(token);
  }

  void cancelStep() {
    if (currentStep > 0) {
      currentStep.value -= 1;
      update(); // Notify listeners to rebuild
    }
  }

  void setStep(int stepIndex) {
    currentStep.value = stepIndex;
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
    endtimeController.clear();

    // Reset the current step
    currentStep.value = 0;

    // Set requestCompleted to true
    requestCompleted.value = false;

    updateFiltersAndNavigateBack();
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
  Future<void> selectTime(BuildContext context, bool isStartTime) async {
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
      final formattedTime = pickedTime.format(context);
      if (isStartTime) {
        starttimeController.text = formattedTime;
      } else {
        endtimeController.text = formattedTime;
      }
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

    final duration = calculateDuration(
        starttimeController.text, endtimeController.text);

    final serviceData = ServiceData(
        serviceid: doc_id,
        serviceName: serviceController.text,
        description: descriptionController.text,
        rate: int.tryParse(rateController.text),
        image: imgUrl ?? "",
        location: locationController.text,
        date: dateController.text,
        starttime: starttimeController.text,
        endtime: endtimeController.text,
        duration: duration,
        status: "Requested", //Default status
        statusid: 3,
        reqUserid: token,
        provUserid: "");

    // Set data in Firestore document
    await FirebaseFirestore.instance.collection('service').doc(doc_id).set(
      serviceData.toFirestore(),
    );

    requestCompleted.value = true;
  }

  double calculateDuration(String startTime, String endTime) {
    // Combine the hardcoded date with the provided time strings
    final startDateTimeString = '2000-01-01 $startTime';
    final endDateTimeString = '2000-01-01 $endTime';

    // Parse the combined date and time strings
    final start = DateFormat('yyyy-MM-dd h:mm a').parse(startDateTimeString);
    final end = DateFormat('yyyy-MM-dd h:mm a').parse(endDateTimeString);

    final duration = end.difference(start);

    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    return hours + minutes / 60.0;
  }

  Future<String> getClientSecret(int amount) async {
    final res = await FirebaseFunctions.instance
        .httpsCallable('createPaymentIntent')
        .call({'amount': '$amount', 'currency': 'sgd'});
    return res.data['clientSecret'];
  }
}