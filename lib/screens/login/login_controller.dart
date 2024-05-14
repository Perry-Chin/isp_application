import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/data/user.dart';
import '../../common/routes/routes.dart';
import '../../common/storage/user.dart';
import 'login_index.dart';

class LoginController extends GetxController {
  LoginController();

  final state = LoginState();
  final emailController = TextEditingController();
  final pwdController = TextEditingController();
  final db = FirebaseFirestore.instance;

  Future<void> handleSignIn(BuildContext context) async {
     // Show loading dialog
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    
    try {
      // Check if email and password fields are not empty
      if (emailController.text.isEmpty || pwdController.text.isEmpty) {
        throw 'Please fill in all fields.';
      }

      // Check for valid email
      if (!RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(emailController.text)) {
        throw 'Please enter a valid email address.';
      }

      // Attempt to sign in with email and password
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: pwdController.text,
      );

      // Successful login
      UserLoginResponseEntity userProfile = UserLoginResponseEntity();
      userProfile.email = emailController.text;
      userProfile.accessToken = userCredential.user?.uid;
      UserStore.to.saveProfile(userProfile);

      // Redirect to Navbar
      Get.offAndToNamed(AppRoutes.navbar);
    } 
    catch (error) {
      // Dismiss loading dialog
      Navigator.pop(context);

      // Show error message for failed sign-in attempts
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