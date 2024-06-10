import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../profile_index.dart';

class EditProfileController extends GetxController {
  EditProfileController();

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
        profileImageUrl.value = userData.data().toString().contains('photourl')
            ? userData['photourl']
            : '';
      } else {
        // Handle the case where the document does not exist
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

    showDialog(
      context: dialogContext,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      User? user = FirebaseAuth.instance.currentUser;

      // Check if fields are not empty
      if (emailController.text.isEmpty ||
          usernameController.text.isEmpty ||
          phoneNoController.text.isEmpty) {
        throw 'Please fill in all fields';
      }

      // Check for valid email
      if (!RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+')
          .hasMatch(emailController.text)) {
        throw 'Please enter a valid email';
      }

      // Check for password update and validation
      if (pwdController.text.isNotEmpty) {
        if (pwdController.text == currentPwdController.text) {
          throw 'New password cannot be the same as the current password';
        }
        if (pwdController.text != confirmpwdController.text) {
          throw 'Passwords do not match';
        }
      }

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

      showRoundedErrorDialog(dialogContext, error.toString());
    }
  }

  void showEmailVerificationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Verify Your Email'),
        content: const Text(
            'A verification email has been sent to your new email address. Confirmation would be needed to change your email.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
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
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
