import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../screens/detail/reviews/detail_reviews_index.dart';
import '../../screens/schedule/schedule_index.dart';
import 'routes.dart';
import '../middlewares/middlewares.dart';
import '../../screens/message/chat/chat_index.dart';
import '../../screens/detail/detail_index.dart';
import '../../screens/message/message_index.dart';
import '../../screens/login/login_index.dart';
import '../../screens/register/register_index.dart';
import '../../screens/navbar/navbar_index.dart';
import '../../screens/welcome/welcome_index.dart';
import '../../screens/profile/settingsx/settingsx_index.dart';
import '../../screens/home/filterHome/filterHome_index.dart';
import '../../screens/schedule/filterSchedule/filterSchedule_index.dart';
import '../../screens/addreviews/addreviews_index.dart';

//Basic structure for managing routes using the GetX package
class AppPages {
  static const initial = AppRoutes.welcome;
  static final RouteObserver<Route> observer =
      RouteObservers(); //Observers.dart
  static List<String> history = [];

  static final List<GetPage> routes = [
    // Welcome Page
    GetPage(
        name: AppRoutes.welcome,
        page: () => const WelcomePage(),
        binding: WelcomeBinding(),
        middlewares: [
          //Redirect user directly to navbar
          //Comment off this line if need logout
          RouteWelcomeMiddleware(priority: 1)
        ]),
    // Navbar Page
    GetPage(
        name: AppRoutes.navbar,
        page: () => const NavbarPage(), // Pass pageController here
        binding: NavbarBinding()),
    // Login Page
    GetPage(
        name: AppRoutes.login,
        page: () => const LoginPage(),
        binding: LoginBinding()),
    // Register Page
    GetPage(
        name: AppRoutes.register,
        page: () => const RegisterPage(),
        binding: RegisterBinding()),
    // Setting Page
    GetPage(
        name: AppRoutes.settingsx,
        page: () => const SettingsxPage(),
        binding: SettingsxBinding()),
    // Detail Page
    GetPage(
        name: AppRoutes.detail,
        page: () => const DetailPage(),
        binding: DetailBinding()),
    // Message Page
    GetPage(
        name: AppRoutes.message,
        page: () => const MessagePage(),
        binding: MessageBinding()),
    // Chat Page
    GetPage(
        name: AppRoutes.chat,
        page: () => const ChatPage(),
        binding: ChatBinding()),
    // Filter Home Page
    GetPage(
        name: AppRoutes.filterHome,
        page: () => const FilterHomePage(),
        binding: FilterHomeBinding()),
    // Schedule Page
    GetPage(
        name: AppRoutes.schedule,
        page: () => const SchedulePage(),
        binding: ScheduleBinding()),
    // Filter Schedule Page
    GetPage(
        name: AppRoutes.filterSchedule,
        page: () => const FilterSchedulePage(),
        binding: FilterScheduleBinding()),
    GetPage(
        name: AppRoutes.addReviews,
        page: () => const AddReviewPage(),
        binding: AddReviewsBinding()),
    GetPage(
      name: AppRoutes.detailReview,
      page: () => const DetailReviewView(),
      binding: DetailReviewBinding(),
    ),
  ];
}
