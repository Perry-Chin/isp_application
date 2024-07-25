import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController extends GetxController {
  // Reactive variable to store the current position
  var currentPosition = Rxn<Position>();
  var selectedLocation = Rxn<LatLng>();
  late GoogleMapController googleMapController;
  var markers = <Marker>{}.obs;

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar('Error', 'Location services are disabled.');
        return;
      }

      // Check for location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar('Error', 'Location permissions are denied.');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          'Error',
          'Location permissions are permanently denied. Please enable them in settings.',
        );
        return;
      }

      // Get the current position and update the reactive variable
      currentPosition.value = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      // Handle exceptions related to location fetching
      Get.snackbar('Error', 'Failed to get current location: $e');
    }
  }

  void setMarker(LatLng position) {
    selectedLocation.value = position;
    markers.clear();
    markers.add(Marker(
      markerId: const MarkerId('selectedLocation'),
      position: position,
    ));
  }

  @override
  void dispose() {
    // Dispose of the map controller when not in use
    googleMapController.dispose();
    super.dispose();
  }
}