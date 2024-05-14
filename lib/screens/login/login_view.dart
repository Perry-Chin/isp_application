import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:isp_application/screens/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isp_application/screens/login/login_index.dart';

import '../../common/values/values.dart';
import '../../common/widgets/button.dart';
import '../../common/widgets/textfield.dart';
import '../register/register_index.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  // Static text style for login text subheading
  static TextStyle loginText = TextStyle(
    fontSize: 16.sp,
    color: AppColor.secondaryText
  );

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
                //Title text
                Text(
                  "Welcome Back!",
                  style: TextStyle(
                    color: AppColor.secondaryColor,
                    fontSize: 24.sp,
                    fontFamily: "Sitka Display"
                  ),
                ),
                const SizedBox(height: 25),
                Column(
                  children: [
                    Row( 
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Log in with your", 
                          style: loginText
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "BuzzBuddy",
                          style: TextStyle(
                            color: AppColor.secondaryColor,
                            fontSize: 16.sp,
                            fontFamily: "Sitka Display"
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "ID to finish",
                          style: loginText
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "where you've left off with!",
                      style: loginText
                    ),
                  ]
                ),
                const SizedBox(height: 40),
                MyTextField(
                  hinttext: 'Your email', 
                  labeltext: 'Email', 
                  prefixicon: Icons.mail,
                  obscuretext: false, 
                  controller: controller.emailController
                ),
                const SizedBox(height: 30),
                MyTextField(
                  hinttext: 'Your password', 
                  labeltext: 'Password', 
                  prefixicon: Icons.key,
                  obscuretext: true, 
                  controller: controller.pwdController
                ),
                const SizedBox(height: 40),
                ApplyButton( 
                  onPressed: () {
                    controller.handleSignIn(context);
                  }, 
                  buttonText: "Login", 
                  buttonWidth: double.infinity
                ),
                //Sign up option
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account yet?",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                      ),
                    ),  
                    TextButton(
                      onPressed: () {
                        // Navigate to the register screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const RegisterPage();
                            },
                        ));
                      },
                      child: const Text(
                        "Sign Up!",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColor.secondaryColor,
                        ),
                      ),
                    ),                   
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}