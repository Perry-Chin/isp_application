import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/values/values.dart';
import '../../common/widgets/widgets.dart';
import '../login/login_index.dart';
import 'register_index.dart';

class RegisterPage extends GetView<RegisterController> {
  const RegisterPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
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
                  prefixicon: Icons.person,
                  obscuretext: false, 
                  controller: controller.usernameController
                ),
                const SizedBox(height: 10),
                // Text field for email input
                MyTextField(
                  hinttext: 'Your email', 
                  labeltext: 'Email', 
                  prefixicon: Icons.email,
                  obscuretext: false, 
                  controller: controller.emailController
                ),
                const SizedBox(height: 10),
                // Text field for email input
                MyTextField(
                  hinttext: 'Your phone number', 
                  labeltext: 'Phone Number',
                  prefixicon: Icons.phone, 
                  obscuretext: false, 
                  controller: controller.phoneNoController
                ),
                const SizedBox(height: 10),
                // Text field for password input
                MyTextField(
                  hinttext: 'Your password', 
                  labeltext: 'Password', 
                  prefixicon: Icons.key,
                  obscuretext: true, 
                  controller: controller.pwdController
                ),
                const SizedBox(height: 10),
                // Text field for confirming password input
                MyTextField(
                  hinttext: 'Your password', 
                  labeltext: 'Confirm Password', 
                  prefixicon: Icons.key,
                  obscuretext: true, 
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
                  buttonWidth: double.infinity,
                  textAlignment: Alignment.center
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