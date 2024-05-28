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
                  onTap: () async {
                    _showImageSourceDialog(context);
                  },
                  child: Obx(() {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 160, // Set the size of the border container
                          height: 160, // Set the size of the border container
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color:
                                  AppColor.secondaryColor, // Blue border color
                              width: 4.0, // Border width
                            ),
                          ),
                        ),
                        CircleAvatar(
                          radius:
                              76, // Adjust the radius to fit inside the border
                          backgroundImage: controller
                                  .profileImageUrl.value.isNotEmpty
                              ? NetworkImage(controller.profileImageUrl.value)
                              : const AssetImage('assets/images/profile.png')
                                  as ImageProvider,
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
                    textAlignment: Alignment.center),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showImageSourceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choose Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await controller.pickImageFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await controller.pickImageFromCamera();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
