import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../common/data/data.dart';
import '../../common/storage/storage.dart';
import 'schedule_index.dart';

class ScheduleController extends GetxController with GetSingleTickerProviderStateMixin {
  ScheduleController();
  
  late TabController tabController;
  final ScheduleState state = ScheduleState();
  final db = FirebaseFirestore.instance;
  final token = UserStore.to.token;
  final RefreshController refreshController = RefreshController(initialRefresh: false);

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    asyncLoadAllDataForProvider();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  // The pull_to_refresh dependency requires these functions to work
  void onRefresh() {
    if (tabController.index == 0) {
      asyncLoadAllDataForProvider().then((_) {
        refreshController.refreshCompleted();
      }).catchError((error) {
        refreshController.refreshFailed();
        print("Error refreshing provider data: $error");
      });
    } else {
      asyncLoadAllDataForRequester().then((_) {
        refreshController.refreshCompleted();
      }).catchError((error) {
        refreshController.refreshFailed();
        print("Error refreshing requester data: $error");
      });
    }
  }

  void onLoading() {
    if (tabController.index == 0) {
      asyncLoadAllDataForProvider().then((_) {
        refreshController.loadComplete();
      }).catchError((error) {
        refreshController.loadFailed();
        print("Error loading more provider data: $error");
      });
    } else {
      asyncLoadAllDataForRequester().then((_) {
        refreshController.loadComplete();
      }).catchError((error) {
        refreshController.loadFailed();
        print("Error loading more requester data: $error");
      });
    }
  }

  // Load all data for requester
  Future<void> asyncLoadAllDataForRequester() async {
    try {
      String token = UserStore.to.token;
      
      // Add a delay of 1 second
      await Future.delayed(const Duration(milliseconds: 500));

      var reqServices = await db.collection("service").withConverter(
          fromFirestore: ServiceData.fromFirestore,
          toFirestore: (ServiceData serviceData, options) => serviceData.toFirestore())
          .where("requester_uid", isNotEqualTo: token)  // Make sure the field matches the orderBy field
          .orderBy("statusid", descending: false).get();

      List<QueryDocumentSnapshot<ServiceData>> documents = reqServices.docs;

      // Sort the documents based on date and time
      documents.sort((a, b) {
        DateTime dateTimeA = combineDateTime(a.data().date!, a.data().time!);
        DateTime dateTimeB = combineDateTime(b.data().date!, b.data().time!);
        return dateTimeA.compareTo(dateTimeB);
      });

      // Now use the sorted documents for display
      state.requesterList.assignAll(documents);
    } 
    catch (e) {
      print("Error fetching: $e");
    }
  }

  // Load all data for provider
  Future<void> asyncLoadAllDataForProvider() async {
    try {
      String token = UserStore.to.token;
      
      // Add a delay of 1 second
      await Future.delayed(const Duration(milliseconds: 500));

      var reqServices = await db.collection("service").withConverter(
          fromFirestore: ServiceData.fromFirestore,
          toFirestore: (ServiceData serviceData, options) => serviceData.toFirestore())
          .where("provider_uid", isNotEqualTo: token)  // Make sure the field matches the orderBy field
          .orderBy("statusid", descending: false).get();

      List<QueryDocumentSnapshot<ServiceData>> documents = reqServices.docs;

      // Sort the documents based on date and time
      documents.sort((a, b) {
        DateTime dateTimeA = combineDateTime(a.data().date!, a.data().time!);
        DateTime dateTimeB = combineDateTime(b.data().date!, b.data().time!);
        return dateTimeA.compareTo(dateTimeB);
      });

      // Now use the sorted documents for display
      state.requesterList.assignAll(documents);
    } 
    catch (e) {
      print("Error fetching: $e");
    }
  }

  // IGNORE: This function is for sorting date and time
  DateTime combineDateTime(String dateString, String timeString) {
    // Parse the date and time strings
    DateTime date = DateTime.parse(dateString);
    DateTime time = parseTime(timeString);

    // Combine date and time into a single DateTime object
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  DateTime parseTime(String timeString) {
    // Split the time string into hours, minutes, and AM/PM parts
    List<String> parts = timeString.split(' ');
    List<String> timeParts = parts[0].split(':');
    int hours = int.parse(timeParts[0]);
    int minutes = int.parse(timeParts[1]);

    // Adjust hours if it's PM
    if (parts[1] == 'PM' && hours < 12) {
      hours += 12;
    }

    // Construct and return the DateTime object using the correct year from the date
    return DateTime(DateTime.now().year, 1, 1, hours, minutes);
  }
}