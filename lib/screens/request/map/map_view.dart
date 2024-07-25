import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'map_index.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Get.put to initialize the MapController
    final controller = Get.put(MapController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: Obx(() {
        // Check if the position has been fetched
        if (controller.currentPosition.value == null) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return GoogleMap(
            myLocationButtonEnabled: true, // Enable the location button
            zoomControlsEnabled: true, // Enable zoom controls
            initialCameraPosition: CameraPosition(
              target: LatLng(
                controller.currentPosition.value!.latitude,
                controller.currentPosition.value!.longitude,
              ),
              zoom: 14, // Zoom level
            ),
            onMapCreated: (mapController) {
              // Set the map controller to the instance in the controller
              controller.googleMapController = mapController;
            },
            onTap: (LatLng position) {
              controller.setMarker(position);
            },
            markers: controller.markers,
          );
        }
      })
    );
  }
}