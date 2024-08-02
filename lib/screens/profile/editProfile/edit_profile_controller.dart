import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../common/values/values.dart';
import '../../../common/widgets/widgets.dart';
import '../profile_index.dart';

class EditProfileController extends GetxController {
  EditProfileController();
  final editProfileFormKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final phoneNoController = TextEditingController();
  final emailController = TextEditingController();
  final pwdController = TextEditingController();
  final confirmpwdController = TextEditingController();
  final currentPwdController = TextEditingController();
  final profileImageUrl = ''.obs;
  final isPasswordVerified = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  // Method to set the initial profile image URL
  void setInitialProfileImageUrl(String url) {
    profileImageUrl.value = url;
  }

  // Load current user data
  void loadUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userData.exists) {
        usernameController.text =
            userData.data().toString().contains('username')
                ? userData['username']
                : '';
        phoneNoController.text =
            userData.data().toString().contains('phone_number')
                ? userData['phone_number']
                : '';
        emailController.text = user.email!;
        if (userData.data().toString().contains('photourl')) {
          profileImageUrl.value = userData['photourl'];
        }
      } else {
        usernameController.text = '';
        phoneNoController.text = '';
        emailController.text = user.email!;
        profileImageUrl.value = '';
      }
    }
  }

  Future<void> updateProfileImage(File image) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Upload image to Firebase Storage
        String fileName = '${user.uid}.jpg';
        UploadTask uploadTask = FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child(fileName)
            .putFile(image);
        TaskSnapshot taskSnapshot = await uploadTask;
        String imageUrl = await taskSnapshot.ref.getDownloadURL();

        // Update user document in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'photourl': imageUrl});

        profileImageUrl.value = imageUrl;
        print('Profile image URL updated: $imageUrl');
      }
    } catch (e) {
      print("Error updating profile image: $e");
    }
  }

  Future<void> verifyCurrentPassword(BuildContext context) async {
    if (currentPwdController.text.isEmpty) {
      showRoundedErrorDialog(context, 'Password field is empty.');
      return;
    }

    // Store the context in a local variable before the await
    BuildContext dialogContext = context;

    showDialog(
      context: dialogContext,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      User? user = FirebaseAuth.instance.currentUser;
      AuthCredential credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: currentPwdController.text,
      );

      await user.reauthenticateWithCredential(credential);
      isPasswordVerified.value = true;

      if (dialogContext.mounted) {
        Navigator.pop(dialogContext); // Dismiss loading dialog
      }
    } catch (error) {
      if (dialogContext.mounted) {
        Navigator.pop(dialogContext); // Dismiss loading dialog
      }

      showRoundedErrorDialog(
          dialogContext, 'Wrong password, please try again.');
    }
  }

  Future<void> handleUpdateProfile(BuildContext context) async {
    // Store the context in a local variable before the await
    BuildContext dialogContext = context;
    if (!editProfileFormKey.currentState!.validate()) {
      return;
    }
    appLoading(context);

    try {
      User? user = FirebaseAuth.instance.currentUser;

      // Only reauthenticate if the email is being changed
      if (user!.email != emailController.text) {
        if (currentPwdController.text.isEmpty) {
          throw 'Please enter the current password to change the email';
        }
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPwdController.text,
        );

        await user.reauthenticateWithCredential(credential);

        // Send email verification to the new email address
        await user.verifyBeforeUpdateEmail(emailController.text);

        // Show a dialog informing the user to verify their new email
        if (dialogContext.mounted) {
          showEmailVerificationDialog(dialogContext);
        }

        if (dialogContext.mounted) {
          Navigator.pop(dialogContext); // Dismiss loading dialog
        }
        return; // Exit the method to wait for email verification
      }

      // Update user password if provided
      if (pwdController.text.isNotEmpty) {
        await user.updatePassword(pwdController.text);
      }

      // Update user document in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'username': usernameController.text,
        'phone_number': phoneNoController.text,
      });

      // Fetch and update the profile controller with new data
      Get.find<ProfileController>().fetchUserData();

      if (dialogContext.mounted) {
        Navigator.pop(dialogContext); // Dismiss loading dialog
        Get.back(); // Go back to the previous screen
      }
    } catch (error) {
      if (dialogContext.mounted) {
        Navigator.pop(dialogContext); // Dismiss loading dialog
      }
    }
  }

  void showEmailVerificationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(AppText.verifyEmailTitle),
        content: const Text(AppText.verifyEmailSubtitle),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(AppText.confirmation),
          ),
        ],
      ),
    );
  }

  void showRoundedErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(AppText.error),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(AppText.confirmation),
          ),
        ],
      ),
    );
  }
}
