import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/data/data.dart';
import '../../common/routes/routes.dart';
import '../../common/storage/storage.dart';
import 'login_index.dart';
class LoginController extends GetxController {
  final state = LoginState();
  final emailController = TextEditingController();
  final pwdController = TextEditingController();
  final db = FirebaseFirestore.instance;

  Future<void> handleSignIn(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      if (emailController.text.isEmpty || pwdController.text.isEmpty) {
        throw 'Please fill in all fields.';
      }

      if (!RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(emailController.text)) {
        throw 'Please enter a valid email address.';
      }

      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: pwdController.text,
      );

      UserLoginResponseEntity userProfile = UserLoginResponseEntity(
        email: emailController.text,
        accessToken: userCredential.user?.uid,
      );
      await UserStore.to.saveProfile(userProfile);

      Get.offAndToNamed(AppRoutes.navbar);
    } catch (error) {
      Navigator.pop(context);

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
