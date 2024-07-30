import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/middlewares/middlewares.dart';
import '../../../common/theme/custom/custom_theme.dart';
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
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Image(
                image: AssetImage(AppImage.logo), width: 35, height: 35),
            const SizedBox(width: 8),
            Text("Edit Profile", style: CustomTextTheme.darkTheme.labelMedium),
          ],
        ),
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
                            : const AssetImage(AppImage.profile);

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
                    textController: controller.usernameController,
                    validator: (value) =>
                        RouteValidateMiddleware.validateUsername(value)),
                const SizedBox(height: 10),
                MyTextField(
                    hinttext: 'Your email',
                    labeltext: 'Email',
                    prefixicon: Icons.email,
                    obscuretext: false,
                    textController: controller.emailController,
                    validator: (value) =>
                        RouteValidateMiddleware.validateEmail(value)),
                const SizedBox(height: 10),
                MyTextField(
                  hinttext: 'Your phone number',
                  labeltext: 'Phone Number',
                  prefixicon: Icons.phone,
                  obscuretext: false,
                  textController: controller.phoneNoController,
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
                                textController: controller.pwdController,
                                validator: (value) =>
                                    RouteValidateMiddleware.validatePassword(
                                        value)),
                            const SizedBox(height: 10),
                            MyTextField(
                                hinttext: 'Confirm your password',
                                labeltext: 'Confirm Password',
                                prefixicon: Icons.key,
                                obscuretext: true,
                                textController: controller.confirmpwdController,
                                validator: (value) => RouteValidateMiddleware
                                    .validateConfirmPassword(value,
                                        controller.confirmpwdController.text)),
                          ],
                        )
                      : MyTextField(
                          hinttext: 'Current Password',
                          labeltext: 'Current Password',
                          prefixicon: Icons.lock,
                          obscuretext: true,
                          textController: controller.currentPwdController,
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
