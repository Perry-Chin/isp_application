import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'routes.dart';

import '../../screens/login/index.dart';

class AppPages {
  static const initial = AppRoutes.initial;
  static const navbar = AppRoutes.navbar;
  static final RouteObserver<Route> observer = RouteObservers();
  static List<String> history = [];

  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.initial,
      page: () => const LoginPage(),
      binding: LoginBinding()
    ),
  ];
}