import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/routes/routes.dart';
import '../../common/values/values.dart';
import '../../common/widgets/input/button.dart';
import '../../common/widgets/input/textfield.dart';
import '../register/register_index.dart';
import 'login_index.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  // Static text style for login text subheading
  static TextStyle loginText =
      TextStyle(fontSize: 16.sp, color: AppColor.secondaryText);

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
                      fontFamily: "Sitka Display"),
                ),
                const SizedBox(height: 25),
                Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AppText.loginSubtitle1, style: loginText),
                      const SizedBox(width: 5),
                      Text(
                        AppText.loginSubtitle2,
                        style: TextStyle(
                            color: AppColor.secondaryColor,
                            fontSize: 16.sp,
                            fontFamily: "Sitka Display"),
                      ),
                      const SizedBox(width: 5),
                      Text(AppText.loginSubtitle3, style: loginText),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(AppText.loginSubtitle4, style: loginText),
                ]),
                const SizedBox(height: 40),
                MyTextField(
                    hinttext: 'Your email',
                    labeltext: 'Email',
                    prefixicon: Icons.mail,
                    obscuretext: false,
                    textController: controller.emailController),
                const SizedBox(height: 30),
                Obx(() => MyTextField(
                      hinttext: 'Your password',
                      labeltext: 'Password',
                      prefixicon: Icons.key,
                      obscuretext: controller.isPasswordHidden.value,
                      textController: controller.pwdController
                    )),
                const SizedBox(height: 40),
                ApplyButton(
                  onPressed: () {
                    controller.handleSignIn(context);
                  },
                  buttonText: "Login",
                  buttonWidth: double.infinity,
                  textAlignment: Alignment.center,
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
                        Get.toNamed(AppRoutes.register);
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
