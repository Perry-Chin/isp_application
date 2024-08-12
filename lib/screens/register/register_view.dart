import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/middlewares/middlewares.dart';
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
        appBar: AppBar(
          backgroundColor: AppColor.backgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Get.back(),
          ),

        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Register an account",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontFamily: "Sitka Display",
                  ),
                ),
                const SizedBox(height: 20),
                // Text field for username input
                MyTextField(
                    hinttext: 'Your username',
                    labeltext: 'Name',
                    prefixicon: Icons.person,
                    textController: controller.usernameController,
                    validator: (value) =>
                        RouteValidateMiddleware.validateUsername(value)),
                const SizedBox(height: 20),
                // Text field for email input
                MyTextField(
                    hinttext: 'Your email',
                    labeltext: 'Email',
                    prefixicon: Icons.email,
                    textController: controller.emailController,
                    validator: (value) =>
                        RouteValidateMiddleware.validateEmail(value)),
                const SizedBox(height: 20),
                // Text field for phone number input
                MyTextField(
                    hinttext: 'Your phone number',
                    labeltext: 'Phone Number',
                    prefixicon: Icons.phone,
                    textController: controller.phoneNoController,
                    validator: (value) =>
                        RouteValidateMiddleware.validatePhoneNumber(value)),
                const SizedBox(height: 20),
                // Password field
                Obx(() => MyTextField(
                    hinttext: 'Your password',
                    labeltext: 'Password',
                    prefixicon: Icons.key,
                    obscuretext: controller.isPasswordHidden.value,
                    textController: controller.pwdController,
                    validator: (value) =>
                        RouteValidateMiddleware.validatePassword(value))),
                const SizedBox(height: 20),
                // Confirm password field
                Obx(() => MyTextField(
                    hinttext: 'Confirm your password',
                    labeltext: 'Confirm Password',
                    prefixicon: Icons.key,
                    obscuretext: controller.isPasswordHidden.value,
                    textController: controller.confirmpwdController,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
