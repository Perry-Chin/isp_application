import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/values/values.dart';
import '../../../common/widgets/widgets.dart';
import 'edit_profile_controller.dart';

class EditProfilePage extends GetView<EditProfileController> {
  final String initialProfileImageUrl;

  const EditProfilePage({super.key, required this.initialProfileImageUrl});

  @override
  Widget build(BuildContext context) {
    controller.setInitialProfileImageUrl(initialProfileImageUrl);

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
                  onTap: () async {
                    showImagePicker(context, (selectedImage) async {
                      if (selectedImage != null) {
                        await controller.updateProfileImage(selectedImage);
                      }
                    });
                  },
                  child: Obx(() {
                    final profileImage =
                        controller.profileImageUrl.value.isNotEmpty
                            ? NetworkImage(controller.profileImageUrl.value)
                            : const AssetImage('assets/images/profile.png');

                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColor.secondaryColor,
                              width: 4.0,
                            ),
                          ),
                        ),
                        CircleAvatar(
                          radius: 76,
                          backgroundImage: profileImage as ImageProvider,
                        ),
                      ],
                    );
                  }),
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
                Obx(() {
                  return controller.isPasswordVerified.value
                      ? Column(
                          children: [
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
                          ],
                        )
                      : MyTextField(
                          hinttext: 'Current Password',
                          labeltext: 'Current Password',
                          prefixicon: Icons.lock,
                          obscuretext: true,
                          controller: controller.currentPwdController,
                        );
                }),
                const SizedBox(height: 30),
                Obx(() {
                  return controller.isPasswordVerified.value
                      ? Container()
                      : ApplyButton(
                          onPressed: () {
                            controller.verifyCurrentPassword(context);
                          },
                          buttonText: "Verify Password",
                          buttonWidth: double.infinity,
                          textAlignment: Alignment.center,
                        );
                }),
                const SizedBox(height: 10),
                ApplyButton(
                  onPressed: () {
                    controller.handleUpdateProfile(context);
                  },
                  buttonText: "Update Profile",
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
