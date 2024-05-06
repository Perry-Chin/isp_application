import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'routes.dart';

import '../../screens/login/index.dart';

//Basic structure for managing routes using the GetX package
class AppPages {
  static const initial = AppRoutes.initial;
  static const navbar = AppRoutes.navbar;
  static final RouteObserver<Route> observer = RouteObservers(); //Observers.dart
  static List<String> history = [];

  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.initial,
      page: () => const LoginPage(),
      binding: LoginBinding()
    ),
  ];
}