import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  EditProfileController();

  final usernameController = TextEditingController();
  final phoneNoController = TextEditingController();
  final emailController = TextEditingController();
  final pwdController = TextEditingController();
  final confirmpwdController = TextEditingController();

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
      usernameController.text = userData['username'];
      phoneNoController.text = userData['phone_number'];
      emailController.text = user.email!;
    }
  }

  Future<void> handleUpdateProfile(BuildContext context) async {
    showDialog(
      context: context,
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
      if (pwdController.text.isNotEmpty &&
          pwdController.text != confirmpwdController.text) {
        throw 'Passwords do not match';
      }

      // Update user email
      if (user != null && user.email != emailController.text) {
        await user.updateEmail(emailController.text);
      }

      // Update user password if provided
      if (user != null && pwdController.text.isNotEmpty) {
        await user.updatePassword(pwdController.text);
      }

      // Update user document in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        'username': usernameController.text,
        'phone_number': phoneNoController.text,
      });

      Navigator.pop(context); // Dismiss loading dialog
      Get.back(); // Go back to the previous screen
    } catch (error) {
      Navigator.pop(context); // Dismiss loading dialog

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(error.toString()),
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
}
