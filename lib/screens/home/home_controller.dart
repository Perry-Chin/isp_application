import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:rxdart/rxdart.dart';
import '../../common/data/data.dart';
import '../../common/storage/storage.dart';
import 'home_index.dart';

class HomeController extends GetxController {
  HomeController();

  final db = FirebaseFirestore.instance;
  final HomeState state = HomeState();
  TextEditingController searchController = TextEditingController();
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);

  // The pull_to_refresh dependency requires these functions to work
  void onRefresh() {
    asyncLoadAllData().then((_) {
      refreshController.refreshCompleted(resetFooterState: true);
    }).catchError((_) {
      refreshController.refreshFailed();
    });
  }

  void onLoading() {
    asyncLoadAllData().then((_) {
      refreshController.loadComplete();
    }).catchError((_) {
      refreshController.loadFailed();
    });
  }

  /// Search filter logic
  void filterServiceList(String username) {
    if (username.isEmpty) {
      // Reset to original service list if search box is empty
      state.filteredServiceList
          .assignAll(state.serviceList); // Assign original service list
    } else {
      // Filter service list based on username
      state.filteredServiceList.assignAll(state.serviceList.where((service) {
        var userData = state.userDataMap[service.data().reqUserid];
        // Check if userData is not null and if the username contains the search query
        var usernameMatch = userData?.username
                ?.toLowerCase()
                ?.contains(username.toLowerCase()) ??
            false;
        return usernameMatch;
      }).toList());
    }
    // Trigger UI update
    update();
  }

  // Stream to handle fetching service data
  Stream<List<QueryDocumentSnapshot<ServiceData>>> getServiceStream(
      String token) {
    return FirebaseFirestore.instance
        .collection('service')
        .where('requester_uid', isNotEqualTo: token)
        .where('status', isEqualTo: 'Requested')
        .withConverter<ServiceData>(
          fromFirestore: ServiceData.fromFirestore,
          toFirestore: (ServiceData serviceData, _) =>
              serviceData.toFirestore(),
        )
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  // Stream to handle fetching user data
  Stream<List<DocumentSnapshot<UserData>>> getUserStream(List<String> userIds) {
    return FirebaseFirestore.instance
        .collection('users')
        .where(FieldPath.documentId, whereIn: userIds)
        .withConverter<UserData>(
          fromFirestore: UserData.fromFirestore,
          toFirestore: (UserData userData, _) => userData.toFirestore(),
        )
        .snapshots()
        .map((snapshot) {
      return snapshot.docs;
    });
  }

  void searchAndNavigate(String username) {
    // Only navigate if we're not already on the SearchResultsPage
    if (!(Get.currentRoute.startsWith('/searchresults'))) {
      Get.toNamed('/searchresults', arguments: username);
    }
  }

  // Combine the streams to get user data for each service item
  Stream<Map<String, UserData?>> getCombinedStream(String token) {
    return getServiceStream(token).switchMap((serviceDocs) {
      List<String> userIds =
          serviceDocs.map((doc) => doc.data().reqUserid!).toList();

      if (userIds.isEmpty) {
        return Stream.value({});
      }

      return getUserStream(userIds).map((userDocs) {
        var userDataMap = Map.fromEntries(
            userDocs.map((doc) => MapEntry(doc.id, doc.data())));
        state.userDataMap.assignAll(userDataMap); // Update userDataMap in state
        return userDataMap;
      });
    });
  }

  // Stream to handle data fetching
  Stream<Map<String, UserData?>> get combinedStream async* {
    await asyncLoadAllData();
    yield* getCombinedStream(UserStore.to.token);
  }

  @override
  void onInit() {
    super.onInit();
    asyncLoadAllData();
    // Listen to token changes and refresh data accordingly
    ever(UserStore.to.obs, (_) {
      asyncLoadAllData();
    });
  }

  Future<void> asyncLoadAllData() async {
    try {
      String token = UserStore.to.token;

      // Add a delay of 1 second
      // await Future.delayed(const Duration(milliseconds: 200));

      var reqServices = await db
          .collection("service")
          .withConverter(
              fromFirestore: ServiceData.fromFirestore,
              toFirestore: (ServiceData serviceData, options) =>
                  serviceData.toFirestore())
          .where("requester_uid",
              isNotEqualTo:
                  token) // Make sure the field matches the orderBy field
          .where("status", isEqualTo: "Requested")
          .get();

      List<QueryDocumentSnapshot<ServiceData>> documents = reqServices.docs;

      // Sort the documents based on date and time
      documents.sort((a, b) {
        DateTime dateTimeA =
            combineDateTime(a.data().date!, a.data().starttime!);
        DateTime dateTimeB =
            combineDateTime(b.data().date!, b.data().starttime!);
        return dateTimeA.compareTo(dateTimeB);
      });

      // Now use the sorted documents for display
      state.serviceList.assignAll(documents);

      // Apply the filter only if the applyFilter flag is true
      filterServiceList(searchController.text);
    } catch (e) {
      print("Error fetching: $e");
    }
  }

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

  // Method to get a random subset of services
  List<QueryDocumentSnapshot<ServiceData>> getRandomRecommendedServices(
      int count) {
    final List<QueryDocumentSnapshot<ServiceData>> allServices =
        state.serviceList;
    final Random random = Random();

    // Ensure we don't exceed the number of available services
    if (allServices.length <= count) {
      return allServices;
    }

    final List<QueryDocumentSnapshot<ServiceData>> randomServices = [];
    while (randomServices.length < count) {
      final service = allServices[random.nextInt(allServices.length)];
      if (!randomServices.contains(service)) {
        randomServices.add(service);
      }
    }

    return randomServices;
  }

  // Define the getter for the current user ID
  String get currentUserId => UserStore.to.token; // or whatever method gets the user ID from UserStore
}
