// Request Service Controller

// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';
import 'package:path/path.dart';
import 'package:get/get.dart';

import '../../common/data/service.dart';
import '../../common/middlewares/middlewares.dart';
import '../../common/storage/storage.dart';
import '../../common/utils/utils.dart';
import '../../common/values/values.dart';
import '../../common/widgets/widgets.dart';
import 'map/map_index.dart';
import 'request_index.dart';

class RequestController extends GetxController {

  // Variables
  File? photo;
  String? docId;
  String? selectedService;
  final currentStep = 0.obs;
  final token = UserStore.to.token;
  final isProcessing = false.obs;
  final requestCompleted = false.obs;
  final latitude = 0.0.obs;
  final longitude = 0.0.obs;
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
    selectedService = null;
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
      if (!requestFormKey.currentState!.validate()) {
        isProcessing.value = false;
        Navigator.pop(context);
        return;
      } 

      final duration = calculateDuration(starttimeController.text, endtimeController.text);
      final amount = (double.parse(rateController.text) * duration * 100).toInt().toString();
    
      await PaymentService.initPaymentSheet(
        context, 
        email: UserStore.to.profile.email ?? '',
        amount: int.parse(amount)
      );

      await createServiceDocument(context);
    } catch (error) {
      Navigator.pop(context);
      showDialog(
        context: context, 
        builder: (BuildContext context) => AlertDialog(
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
        )
      );
      isProcessing.value = false;
    }
  }

  void validateTimeInputs() {
    print("Validating time inputs");
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

  
  // Open map
  void openMap() async {
    var result = await Get.to(() => const MapPage());
    if (result != null && result is LatLng) {
      locationController.text = "Loading...";
      latitude.value = result.latitude;
      longitude.value = result.longitude;
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(result.latitude, result.longitude);
        Placemark place = placemarks[0];
        locationController.text = place.street!;
      } catch (e) {
        print(e);
        locationController.text = "Unknown Location";
      }
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
    final docRef = FirebaseFirestore.instance.collection('service').doc();
    final String serviceDoc = docRef.id;
    final duration = calculateDuration(starttimeController.text, endtimeController.text);

    final serviceData = ServiceData(
      serviceid: serviceDoc,
      serviceName: selectedService,
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
  
    await docRef.set(serviceData.toFirestore());
    await RoutePaymentMiddleware().createPaymentDocument(serviceDoc, amount, token, token, false);
    requestCompleted.value = true;
    Navigator.pop(context);
  }
}