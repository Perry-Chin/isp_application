// Router Welcome

// ignore_for_file: overridden_fields, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/routes.dart';
import '../storage/storage.dart';

// Middleware for the first welcome screen.
class RouteWelcomeMiddleware extends GetMiddleware {
  
  @override
  // Priority: lower number means higher priority.
  int? priority = 0;

  RouteWelcomeMiddleware({required this.priority});

  @override
  RouteSettings? redirect(String? route) {
    print("redirect");
    print(ConfigStore.to.isFirstOpen); //Debugging
    // If it's not the first app open, no redirection needed.
    if (ConfigStore.to.isFirstOpen == false) {
      return null;
    } 
    // If user is logged in and it's the first app open, redirect to navbar
    else if (UserStore.to.isLogin == true) {
      print("redirect to navbar");
      return const RouteSettings(name: AppRoutes.navbar);
    } 
    // If user is not logged in and it's the first app open, redirect to login
    else {
      print("redirect to login");
      return const RouteSettings(name: AppRoutes.login);
    }
  }
}
