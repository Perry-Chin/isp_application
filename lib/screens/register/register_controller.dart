import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../login/login_index.dart';

class RegisterController extends GetxController {
  RegisterController();
  
  final usernameController = TextEditingController();
  final phoneNoController = TextEditingController();
  final emailController = TextEditingController();
  final pwdController = TextEditingController();
  final confirmpwdController = TextEditingController();
  

  Future<void> handleRegister(BuildContext context) async {
     // Show loading dialog
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    
    try {
      // Check if email and password fields are not empty
      if (emailController.text.isEmpty || usernameController.text.isEmpty || phoneNoController.text.isEmpty || pwdController.text.isEmpty) {
        throw 'Please fill in all fields';
      }

      // Check for valid email
      if (!RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(emailController.text)) {
        throw 'Please enter a valid email';
      }

      // Make sure passwords match
      if (pwdController.text != confirmpwdController.text) {
        throw 'Please make sure passwords match';
      }

      // Create the user
      UserCredential? userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text, 
        password: pwdController.text
      );
      
      // Create user document and add to Firestore
      await createUserDocument(userCredential);

      // Navigate to the main screen (NavBar)
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      }
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
  
  // Create user document
  Future<void> createUserDocument(UserCredential userCredential) async {
    String uid = userCredential.user!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'user_id': uid,
      'username': usernameController.text,
      'photourl': '',
      'email': emailController.text,
      'phone_number': phoneNoController.text,
    });
  }
}