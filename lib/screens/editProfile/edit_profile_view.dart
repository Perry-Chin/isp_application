import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/values/values.dart';
import '../../common/widgets/widgets.dart';
import 'edit_profile_controller.dart';

class EditProfilePage extends GetView<EditProfileController> {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    controller.loadUserData();

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text("Edit Profile"),
        backgroundColor: AppColor.secondaryColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    // Add logic to upload an image
                  },
                  child: const CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage('assets/images/profile.png'),
                  ),
                ),
                const SizedBox(height: 10),
                MyTextField(
                  hinttext: 'Your username',
                  labeltext: 'Name',
                  prefixicon: Icons.person,
                  obscuretext: false,
                  controller: controller.usernameController,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  hinttext: 'Your email',
                  labeltext: 'Email',
                  prefixicon: Icons.email,
                  obscuretext: false,
                  controller: controller.emailController,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  hinttext: 'Your phone number',
                  labeltext: 'Phone Number',
                  prefixicon: Icons.phone,
                  obscuretext: false,
                  controller: controller.phoneNoController,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  hinttext: 'Your password',
                  labeltext: 'Password',
                  prefixicon: Icons.key,
                  obscuretext: true,
                  controller: controller.pwdController,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  hinttext: 'Confirm your password',
                  labeltext: 'Confirm Password',
                  prefixicon: Icons.key,
                  obscuretext: true,
                  controller: controller.confirmpwdController,
                ),
                const SizedBox(height: 30),
                ApplyButton(
                  onPressed: () {
                    controller.handleUpdateProfile(context);
                  },
                  buttonText: "Update Profile",
                  buttonWidth: double.infinity,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
