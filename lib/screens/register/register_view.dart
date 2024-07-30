import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/middlewares/middlewares.dart';
import '../../common/routes/routes.dart';
import '../../common/values/values.dart';
import '../../common/widgets/widgets.dart';
import 'register_index.dart';

class RegisterPage extends GetView<RegisterController> {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.registerFormKey,
      child: Scaffold(
        backgroundColor: AppColor.backgroundColor,
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    "Register an account",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontFamily: "Sitka Display",
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Text field for username input
                  MyTextField(
                      hinttext: 'Your username',
                      labeltext: 'Name',
                      prefixicon: Icons.person,
                      obscuretext: false,
                      textController: controller.usernameController,
                      validator: (value) =>
                          RouteValidateMiddleware.validateUsername(value)),
                  const SizedBox(height: 10),
                  // Text field for email input
                  MyTextField(
                      hinttext: 'Your email',
                      labeltext: 'Email',
                      prefixicon: Icons.email,
                      obscuretext: false,
                      textController: controller.emailController,
                      validator: (value) =>
                          RouteValidateMiddleware.validateEmail(value)),
                  const SizedBox(height: 10),
                  // Text field for phone number input
                  MyTextField(
                      hinttext: 'Your phone number',
                      labeltext: 'Phone Number',
                      prefixicon: Icons.phone,
                      obscuretext: false,
                      textController: controller.phoneNoController,
                      validator: (value) =>
                          RouteValidateMiddleware.validatePhoneNumber(value)),
                  const SizedBox(height: 10),
                  // Password field
                  Obx(() => MyTextField(
                      hinttext: 'Your password',
                      labeltext: 'Password',
                      prefixicon: Icons.key,
                      obscuretext: controller.isPasswordHidden.value,
                      textController: controller.pwdController,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordHidden.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () => controller.togglePasswordVisibility(),
                      ),
                      validator: (value) =>
                          RouteValidateMiddleware.validatePassword(value))),
                  const SizedBox(height: 10),
                  // Confirm password field
                  Obx(() => MyTextField(
                      hinttext: 'Confirm your password',
                      labeltext: 'Confirm Password',
                      prefixicon: Icons.key,
                      obscuretext: controller.isPasswordHidden.value,
                      textController: controller.confirmpwdController,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordHidden.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () => controller.togglePasswordVisibility(),
                      ),
                      validator: (value) =>
                          RouteValidateMiddleware.validateConfirmPassword(
                              value, controller.confirmpwdController.text))),
                  const SizedBox(height: 30),
                  // Button to create account
                  ApplyButton(
                    // button.dart
                    onPressed: () {
                      controller.handleRegister(context);
                    },
                    buttonText: "Create Account",
                    buttonWidth: double.infinity,
                    textAlignment: Alignment.center,
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
                          Get.offAndToNamed(AppRoutes.home);
                        },
                        child: const Text(
                          "Log In",
                          style: TextStyle(
                              color: AppColor.secondaryColor,
                              fontSize: 15,
                              fontFamily: "Sitka Display"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
