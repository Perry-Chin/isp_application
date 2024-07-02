// Request Service Controller

// ignore_for_file: avoid_init_to_null, non_constant_identifier_names, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
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
  var doc_id = null;
  final currentStep = 0.obs;
  final token = UserStore.to.token;
  var isProcessing = false.obs;
  var requestCompleted = false.obs;
  Map<String, dynamic>? paymentIntent;
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

  void clearForm() {
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
  }

  void resetForm() {
    clearForm();
    updateFiltersAndNavigateBack();
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
      // Show error message to the user
      print('Error Uploading Image $e');
    }
  }
  Future<void> confirmRequest(BuildContext context) async {
    // Show loading dialog
   appLoading(context);
    try {
      isProcessing.value = true;
      // Form validation
      if (!requestFormKey.currentState!.validate()) {
        // Dismiss loading dialog
        Navigator.pop(context);
        isProcessing.value = false;
        return;
      }

      print(isProcessing.value);

      final duration = calculateDuration(starttimeController.text, endtimeController.text);

      // Assuming rateController.text contains a valid number and duration is defined
      String amount = (double.parse(rateController.text) * duration * 100).toInt().toString();

      // Dismiss loading dialog
      Navigator.pop(context);

      makePayment(amount);
    } catch (error) {
      // Dismiss loading dialog
      Navigator.pop(context);

      isProcessing.value = false;

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

  void makePayment(String amount) async {
    try {
      paymentIntent = await createPaymentIntent(amount);

      var gpay = const PaymentSheetGooglePay(
        merchantCountryCode: 'SG',
        currencyCode: 'SG',
        testEnv: true,
      );
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          merchantDisplayName: 'Flutter Stripe Store Demo',
          style: ThemeMode.dark,
          googlePay: gpay,
          billingDetails: const BillingDetails(
            address: Address(
              city: '', country: 'SG', state: '', 
              line1: '', line2: '', postalCode: '',
            )
          )
      ));

      displayPaymentSheet();
        
      print("objectsdfsd");
    } catch (e) {
      isProcessing.value = false;
      print('Exception: $e');
    }
  }

  createPaymentIntent(String amount) async {
    try {
      final body = {
        'amount': amount,
        'currency': "SGD",
      };
      http.Response response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization': 'Bearer sk_test_51PW9k609OEdaNyd6QgHUeSko1k4I8mfw6sgnZBqHdgGaFru0PibwOxAejWOM7ETDIJUlCKWXze5ME4KBBMyDdi55002kBJbgBe',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      );
      return json.decode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  void displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      // Create service document and add to Firestore
      await createServiceDocument();
    } catch (e) {
      isProcessing.value = false;
      print('Exception: $e');
    }
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

    isProcessing.value = false;
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
}