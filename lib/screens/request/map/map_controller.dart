import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController extends GetxController {

  // Variables
  late GoogleMapController googleMapController;
  var markers = <Marker>{}.obs;
  static CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(0, 0), zoom: 14
  );
  var currentLocation = const LatLng(0, 0);
  var error = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    determinePosition();
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    // Fetch the current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );

    // Update the initial camera position to the current position
    initialCameraPosition = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 14,
    );

    updateCameraPosition(LatLng(position.latitude, position.longitude));

    return position;
  }

  void updateCameraPosition(LatLng target) {
    print(target);
    googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(target: target, zoom: 14))
    );
}

  void setLocation() async {
    if (currentLocation == const LatLng(0, 0)) {
      Position position = await determinePosition();
      currentLocation = LatLng(position.latitude, position.longitude);
    }
    Get.back(result: currentLocation);
  }

  void addMarker(LatLng location) {
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: location, zoom: 14)));
    markers.clear();
    markers.add(Marker(markerId: const MarkerId('tapped'), position: location));
    currentLocation = location;
    update();
  }

  void getCurrentLocation() async {
    Position position = await determinePosition();
    currentLocation = LatLng(position.latitude, position.longitude);
    update();
  }

  @override
  void onClose() {
    googleMapController.dispose();
    super.onClose();
  }
}