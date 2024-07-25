import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../common/values/values.dart';
import 'map_index.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MapController());
    return Scaffold(
      body: Obx(() {
        if (controller.error.value.isNotEmpty) {
          return Center(child: Text(controller.error.value));
        } else {
          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: MapController.initialCameraPosition,
                onMapCreated: (GoogleMapController mapController) {
                  controller.googleMapController = mapController;
                },
                markers: Set<Marker>.from(controller.markers),
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                onTap: (LatLng location) => controller.addMarker(location),
              ),
              Positioned(
                top: 25,
                left: 15,
                child: Opacity(
                  opacity: 0.6,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 15,
                left: 10,
                child: Column(
                  children: [
                    FloatingActionButton(
                      backgroundColor: AppColor.primaryColor,
                      heroTag: "currentLocation",
                      onPressed: () => controller.googleMapController.animateCamera(CameraUpdate.newCameraPosition(MapController.initialCameraPosition)),
                      mini: true,
                      child: const Icon(Icons.my_location, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    FloatingActionButton(
                      backgroundColor: AppColor.primaryColor,
                      heroTag: "zoomIn",
                      onPressed: () => controller.googleMapController.animateCamera(CameraUpdate.zoomIn()),
                      mini: true,
                      child: const Icon(Icons.zoom_in, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    FloatingActionButton(
                      backgroundColor: AppColor.primaryColor,
                      heroTag: "zoomOut",
                      onPressed: () => controller.googleMapController.animateCamera(CameraUpdate.zoomOut()),
                      mini: true,
                      child: const Icon(Icons.zoom_out, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      }),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColor.primaryColor,
        icon: const Icon(Icons.my_location, color: Colors.white),
        onPressed: () => controller.setLocation(),
        label: const Text('Set Location', style: TextStyle(color: Colors.white),),
      ),
    );
  }
}