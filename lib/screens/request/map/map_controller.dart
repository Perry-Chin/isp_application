import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController extends GetxController {

  // Variables
  late GoogleMapController googleMapController;
  var markers = <Marker>{}.obs;
  static const CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962), zoom: 14
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

    Position position = await Geolocator.getCurrentPosition();
    return position;
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