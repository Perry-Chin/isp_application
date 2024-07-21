import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../common/theme/custom/custom_theme.dart';
// import '../../../common/values/values.dart';
// import '../../../common/widgets/widgets.dart';
// import '../../../common/theme/custom/appbar_theme.dart';
import '../../../common/theme/custom/text_theme.dart';

class RequestMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(1.3521, 103.8198),
    zoom: 15.75,
  );

  late GoogleMapController _googleMapController;

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  AppBar _buildAppBar(context) {
    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          //const Image(image: AssetImage(AppImage.logo), width: 35, height: 35),
          const SizedBox(width: 8),
          Text("Choose Request Location",
              style: CustomTextTheme.darkTheme.labelMedium),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: GoogleMap(
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        initialCameraPosition: _initialCameraPosition,
        onMapCreated: (controller) => _googleMapController = controller,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(_initialCameraPosition),
        ),
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }
}
