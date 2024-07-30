import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/data/data.dart';
import '../../common/values/values.dart';
import '../../common/widgets/widgets.dart';
import '../../common/routes/routes.dart'; // Add this import for navigation
import '../../common/storage/storage.dart'; // Add this import to save profile
// import '../login/login_index.dart';

class RegisterController extends GetxController {
  final registerFormKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final phoneNoController = TextEditingController();
  final emailController = TextEditingController();
  final pwdController = TextEditingController();
  final confirmpwdController = TextEditingController();

  final isPasswordHidden = true.obs;

  void togglePasswordVisibility() => isPasswordHidden.toggle();

  Future<void> handleRegister(BuildContext context) async {
    print("Starting registration process"); // Debug statement

    if (!registerFormKey.currentState!.validate()) {
      print("Form validation failed"); // Debug statement
      return;
    }

    appLoading(context);

    try {
      if (await isUsernameTaken(usernameController.text)) {
        throw 'Username is already taken';
      }

      print(
          "Creating user with email: ${emailController.text}"); // Debug statement
      UserCredential? userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: pwdController.text);

      print(
          "User created successfully, creating user document"); // Debug statement
      await createUserDocument(userCredential);

      print("Registration complete, logging in user"); // Debug statement
      await handleSignInAfterRegister(userCredential);

      print("User logged in, navigating to home page"); // Debug statement
      if (context.mounted) {
        Get.offAllNamed(AppRoutes.navbar); // Navigate to the home page
      }
    } catch (error) {
      print("Error during registration: $error"); // Debug statement
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(AppText.error),
          content: Text(error.toString()),
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

  Future<bool> isUsernameTaken(String username) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .limit(1)
        .get();
    return result.docs.isNotEmpty;
  }

  Future<void> createUserDocument(UserCredential userCredential) async {
    String uid = userCredential.user!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'user_id': uid,
      'username': usernameController.text,
      'photourl': '',
      'email': emailController.text,
      'phone_number': phoneNoController.text,
      'rating': 0,
      'isOnline': false,
    });
  }

  Future<void> handleSignInAfterRegister(UserCredential userCredential) async {
    // Save user profile after registration
    UserLoginResponseEntity userProfile = UserLoginResponseEntity(
      email: emailController.text,
      accessToken: userCredential.user?.uid,
    );
    await UserStore.to.saveProfile(userProfile);
  }
}
