// Router Authentication

// ignore_for_file: overridden_fields

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/routes.dart';
import '../storage/storage.dart';

// Middleware to check if the user is authenticated.
class RouteAuthMiddleware extends GetMiddleware {
  
  @override
  // Priority: lower number means higher priority.
  int? priority = 0;

  RouteAuthMiddleware({required this.priority});

  // Method to handle redirection based on authentication status.
  @override
  RouteSettings? redirect(String? route) {
    // Check if user is logged in or if the route is a signin or initial route.
    if (UserStore.to.isLogin || route == AppRoutes.login || route == AppRoutes.initial) {
      return null;
    } 
    else {
      //Login expired
      Future.delayed(
        const Duration(seconds: 1), () => Get.snackbar("Hint", "Login expired, please sign in again")
      );
      return const RouteSettings(name: AppRoutes.login);
    }
  }
}
