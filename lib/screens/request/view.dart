import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/widgets/button.dart';
import '../../common/widgets/textfield.dart';
import 'index.dart';

class RequestPage extends GetView<RequestController> {
  const RequestPage({super.key});

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: const Text("Request service"),
      backgroundColor: Colors.amber,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyTextField(
                  hinttext: 'Your service', 
                  labeltext: 'Service', 
                  prefixicon: Icons.room_service,
                  obscuretext: false, 
                  controller: controller.usernameController
                ),
                const SizedBox(height: 20),
                MyTextField(
                  hinttext: 'Your location', 
                  labeltext: 'Location', 
                  prefixicon: Icons.add_location_alt_outlined,
                  obscuretext: false, 
                  controller: controller.usernameController
                ),
                const SizedBox(height: 20),
                MyTextField(
                  hinttext: 'Your rate', 
                  labeltext: 'Rate', 
                  prefixicon: Icons.price_change,
                  obscuretext: false, 
                  controller: controller.usernameController
                ),
                const SizedBox(height: 20),
                MyTextField(
                  hinttext: 'Your date', 
                  labeltext: 'Date', 
                  prefixicon: Icons.price_change,
                  obscuretext: false, 
                  controller: controller.usernameController
                ),
                const SizedBox(height: 20),
                MyTextField(
                  hinttext: 'Start date', 
                  labeltext: 'Rate', 
                  prefixicon: Icons.price_change,
                  obscuretext: false, 
                  controller: controller.usernameController
                ),
                const SizedBox(height: 20),
                MyTextField(
                  hinttext: 'Your rate', 
                  labeltext: 'Description', 
                  prefixicon: Icons.price_change,
                  obscuretext: false, 
                  controller: controller.usernameController
                ),
                const SizedBox(height: 20),
                MyTextField(
                  hinttext: 'Your rate', 
                  labeltext: 'Rate', 
                  prefixicon: Icons.price_change,
                  obscuretext: false, 
                  controller: controller.usernameController
                ),
                // Button to create account
                ApplyButton(  // button.dart
                  onPressed: () {
                    // controller.handleRegister(context);
                  }, 
                  buttonText: "Confirm", 
                  buttonWidth: double.infinity
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}