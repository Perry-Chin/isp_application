import 'package:isp_application/screens/login/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    AppBar buildAppBar() {
      return AppBar(
        backgroundColor: Colors.red,
        title: const Text("Login"),
      );
    }
    return Scaffold(
      appBar: buildAppBar()
    );
  }
}