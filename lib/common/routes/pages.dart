import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../screens/detail/detail_index.dart';
import '../../screens/settings/settings_index.dart';
import 'routes.dart';
import '../middlewares/middlewares.dart';
import '../../screens/login/login_index.dart';
import '../../screens/register/register_index.dart';
import '../../screens/navbar/navbar_index.dart';
import '../../screens/welcome/welcome_index.dart';

//Basic structure for managing routes using the GetX package
class AppPages {
  static const initial = AppRoutes.welcome;
  static const navbar = AppRoutes.navbar;
  static final RouteObserver<Route> observer =
  RouteObservers(); //Observers.dart
  static List<String> history = [];

  static final List<GetPage> routes = [
    //Welcome Page
    GetPage(
      name: AppRoutes.welcome,
      page: () => const WelcomePage(),
      binding: WelcomeBinding(),
      middlewares: [
        //Redirect user directly to navbar
        //Comment off this line if need logout
        // RouteWelcomeMiddleware(priority: 1)
      ]
    ),
    //Navbar Page
    GetPage(
      name: AppRoutes.navbar,
      page: () => NavbarPage(),
      binding: NavbarBinding()
    ),
    //Login Page
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: LoginBinding()
    ),
    //Register Page
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterPage(),
      binding: RegisterBinding()
    ),
    //Settings Page
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsPage(),
      binding: SettingsBinding()
    ),
    //Detail Page
    GetPage(
      name: AppRoutes.detail,
      page: () => DetailPage(),
      binding: DetailBinding()
    ),
  ];
}
