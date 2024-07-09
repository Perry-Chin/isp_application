// Request Service Controller

// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:get/get.dart';

import '../../common/data/service.dart';
import '../../common/middlewares/middlewares.dart';
import '../../common/storage/storage.dart';
import '../../common/utils/utils.dart';
import '../../common/values/values.dart';
import '../../common/widgets/widgets.dart';
import 'request_index.dart';

class RequestController extends GetxController {

  // Variables
  File? photo;
  String? docId;
  final currentStep = 0.obs;
  final token = UserStore.to.token;
  final isProcessing = false.obs;
  final requestCompleted = false.obs;
  
  final serviceController = TextEditingController();
  final descriptionController = TextEditingController();
  final rateController = TextEditingController();
  final imageController = TextEditingController();
  final locationController = TextEditingController();
  final dateController = TextEditingController();
  final starttimeController = TextEditingController();
  final endtimeController = TextEditingController();

  GlobalKey<FormState> requestFormKey = GlobalKey<FormState>();
  bool get isLastStep => currentStep.value == getSteps(currentStep.value).length - 1;

  @override
  void onInit() {
    super.onInit();
    docId = Get.parameters['doc_id'];
  }
  
  // Move to next step
  void moveToNextStep() {
    if (currentStep < getSteps(currentStep.value).length - 1) {
      currentStep.value++;
      update();
    }
  }

  // Move back to previous step
  void cancelStep() {
    if (currentStep > 0) {
      currentStep.value--;
      update();
    }
  }

  // Set current step to selected step
  void setStep(int stepIndex) {
    currentStep.value = stepIndex;
    update();
  }

  void clearForm() {
    // Clear text fields
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

    // Set requestCompleted to false
    isProcessing.value = false;
    requestCompleted.value = false;
  }

  void resetForm() {
    // Clear text fields
    clearForm();

    // Update schedule page
    updateFiltersAndNavigateBack();
  }

  Future<String?> uploadFile() async {
    if (photo == null) return null;
    final fileName = getRandomString(15) + extension(photo!.path);

    try {
      final ref = FirebaseStorage.instance.ref("service").child(fileName);
      final uploadTask = ref.putFile(photo!);
      final snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error Uploading Image: $e');
      return null;
    }
  }

  Future<void> confirmRequest(BuildContext context) async {
    appLoading(context);
    try {
      isProcessing.value = true;
      // if (!requestFormKey.currentState!.validate()) {
      //   throw Exception("Please fill all required fields");
      // }

      validateTimeInputs();
      final duration = calculateDuration(starttimeController.text, endtimeController.text);
      final amount = (double.parse(rateController.text) * duration * 100).toInt().toString();

      await PaymentService.makePayment(context, amount);
      await createServiceDocument(context);
    } catch (error) {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(AppText.error),
          content: Text(error.toString()),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(AppText.confirmation),
            ),
          ],
        ),
      );
    } finally {
      Navigator.pop(context); // Dismiss loading dialog
      isProcessing.value = false;
    }
  }

  void validateTimeInputs() {
    if (starttimeController.text == endtimeController.text) {
      throw Exception("Start time cannot be the same as end time");
    }

    final startDateTimeString = '2000-01-01 ${starttimeController.text}';
    final endDateTimeString = '2000-01-01 ${endtimeController.text}';
    final start = DateFormat('yyyy-MM-dd h:mm a').parse(startDateTimeString);
    final end = DateFormat('yyyy-MM-dd h:mm a').parse(endDateTimeString);

    if (start.isAfter(end)) {
      throw Exception("Start time cannot be after end time");
    }
  }

  double calculateDuration(String startTime, String endTime) {
    final startDateTimeString = '2000-01-01 $startTime';
    final endDateTimeString = '2000-01-01 $endTime';
    final start = DateFormat('yyyy-MM-dd h:mm a').parse(startDateTimeString);
    final end = DateFormat('yyyy-MM-dd h:mm a').parse(endDateTimeString);
    final duration = end.difference(start);
    return duration.inMinutes / 60.0;
  }

  Future<void> createServiceDocument(BuildContext context) async {
    final imgUrl = await uploadFile();
    final duration = calculateDuration(starttimeController.text, endtimeController.text);

    final serviceData = ServiceData(
      serviceid: docId,
      serviceName: serviceController.text,
      description: descriptionController.text,
      rate: int.tryParse(rateController.text),
      image: imgUrl ?? "",
      location: locationController.text,
      date: dateController.text,
      starttime: starttimeController.text,
      endtime: endtimeController.text,
      duration: duration,
      status: "Requested",
      statusid: 3,
      reqUserid: token,
      provUserid: "",
    );

    final amount = (double.parse(rateController.text) * duration);
  
    await FirebaseFirestore.instance.collection('service').doc(docId).set(serviceData.toFirestore());
    await RoutePaymentMiddleware().createPaymentDocument(docId, amount);
    requestCompleted.value = true;
  }
}