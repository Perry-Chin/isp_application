import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

import '../../common/data/data.dart';
import '../../common/storage/storage.dart';
import 'home_index.dart';

class HomeController extends GetxController {
  HomeController();
  //Grab current login user token
  final token = UserStore.to.token;
  final db = FirebaseFirestore.instance;
  final HomeState state = HomeState();
  final RefreshController refreshController = RefreshController (
    initialRefresh: true
  );

  //The pull_to_refresh dependency requires this 2 functions to work
  void onRefresh() {
    asyncLoadAllData().then((_){
      refreshController.refreshCompleted(resetFooterState: true);
    }).catchError((_){
      refreshController.refreshFailed();
    });
  }
 
  void onLoading() {
    asyncLoadAllData().then((_){
      refreshController.loadComplete();
    }).catchError((_){
      refreshController.loadFailed();
    });
  }
  //

  asyncLoadAllData() async {
    try {
      var reqServices = await db.collection("service").withConverter(
      fromFirestore: ServiceData.fromFirestore, 
      toFirestore: (ServiceData serviceData, options) => serviceData.toFirestore()
      ).where("requester_uid", isNotEqualTo: token)  // Make sure the field matches the orderBy field
      .where("status", isEqualTo: "Requested").get();
      
      List<QueryDocumentSnapshot<ServiceData>> documents = reqServices.docs;

      // Sort the documents based on date and time
      documents.sort((a, b) {
        DateTime dateTimeA = combineDateTime(a.data().date!, a.data().time!);
        DateTime dateTimeB = combineDateTime(b.data().date!, b.data().time!);
        
        return dateTimeA.compareTo(dateTimeB);
      });

      // Now use the sorted documents for display
      state.serviceList.assignAll(documents);

      // Fetch user data for each service item
      for (var i = 0; i < state.serviceList.length; i++) {
        var serviceItem = state.serviceList[i];
        var userDoc = await db.collection('users').doc(serviceItem.data().reqUserid).get();

        // Assign the entire UserData object to userData property
        serviceItem.data().userData = UserData.fromFirestore(userDoc, null);
      }
    }
    catch(e) {
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
}