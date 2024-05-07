import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/widgets/button.dart';
import '../../common/widgets/textfield.dart';
import '../login/index.dart';
import 'index.dart';

class RegisterPage extends GetView<RegisterController> {
  const RegisterPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                const Image(
                  image: AssetImage('assets/images/profile.png'),
                  height: 180,
                  width: 180,
                  fit: BoxFit.fitWidth,
                ),
                const SizedBox(height: 10),
                // Text field for username input
                MyTextField(
                  hinttext: 'Your username', 
                  labeltext: 'Name', 
                  obscuretext: false, 
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  controller: controller.usernameController
                ),
                const SizedBox(height: 10),
                // Text field for email input
                MyTextField(
                  hinttext: 'Your email', 
                  labeltext: 'Email', 
                  obscuretext: false, 
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  controller: controller.emailController
                ),
                const SizedBox(height: 10),
                // Text field for email input
                MyTextField(
                  hinttext: 'Your phone number', 
                  labeltext: 'Phone Number', 
                  obscuretext: false, 
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  controller: controller.phoneNoController
                ),
                const SizedBox(height: 10),
                // Text field for password input
                MyTextField(
                  hinttext: 'Your password', 
                  labeltext: 'Password', 
                  obscuretext: true, 
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  controller: controller.pwdController
                ),
                const SizedBox(height: 10),
                // Text field for confirming password input
                MyTextField(
                  hinttext: 'Your password', 
                  labeltext: 'Confirm Password', 
                  obscuretext: true, 
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  controller: controller.confirmpwdController
                ),
                const SizedBox(
                  height: 30,
                ),
                // Button to create account
                ApplyButton(  // button.dart
                  onPressed: () {
                    controller.handleRegister(context);
                  }, 
                  buttonText: "Create Account", 
                  buttonWidth: double.infinity
                ),
                // Row for navigation to the login screen
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have account?",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to the login screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                        ));
                      },
                      child: const Text(
                        "Log In",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}