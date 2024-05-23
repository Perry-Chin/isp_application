import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'settings_index.dart';
import '../../common/values/values.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: const Text("Settings"),
      backgroundColor: AppColor.secondaryColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: const SetSettingsPage(),
    );
  }
}

class SetSettingsPage extends StatelessWidget {
  const SetSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [

        // SizedBox(
        //   height: 75,
        //   child: InkWell(
        //     onTap: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => const EditProfilePage(),
        //         ),
        //       );
        //     },
        //     child: Container(
        //       margin: EdgeInsets.all(8.0),
        //       decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(16.0), // Rounded edges
        //         border: Border.all(
        //           color: Colors.black, // Border color
        //           width: 2.0, // Border width
        //         ),
        //       ),
        //       child: Center(
        //         child: Text(
        //           'Edit Profile',
        //           style: TextStyle(color: Colors.black, fontSize: 18),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),

        SizedBox(
          height: 75,
          child: InkWell(
            onTap: () {
              // Handle the tap event for the blue box
              print("box2 tapped");
            },
            child: Container(
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0), // Rounded edges
                border: Border.all(
                  color: Colors.black, // Border color
                  width: 2.0, // Border width
                ),
              ),
              child: Center(
                child: Text(
                  'Any Problems? Contact Us!',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ),
          ),
        ),

        SizedBox(
          height: 75,
          child: InkWell(
            onTap: () {
              // Handle the tap event for the blue box
              print("box3 tapped");
            },
            child: Container(
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0), // Rounded edges
                border: Border.all(
                  color: Colors.black, // Border color
                  width: 2.0, // Border width
                ),
              ),
              child: Center(
                child: Text(
                  'View Payment Details',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
            ),
          ),
        ),

      ],
    );
  }
}

