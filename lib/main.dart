import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'common/routes/routes.dart';
import 'common/storage/storage.dart';
import 'firebase_options.dart';

Future<void> main() async {

  // Ensuring Flutter widgets are initialized.
  WidgetsFlutterBinding.ensureInitialized();

  // Initializing the storage service asynchronously and registering it with GetX.
  await Get.putAsync<StorageService>(() => StorageService().init());

  // Registering ConfigStore and UserStore with GetX.
  Get.put<ConfigStore>(ConfigStore());
  Get.put<UserStore>(UserStore());

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  // Initialize Stripe
  Stripe.publishableKey = 'pk_test_51PW9k609OEdaNyd6cGvFdgCq7GX3ecDeHCWNHVHIZrpYpXQIWugLnetf8yhndG46JGhzCpIZp6DgeyiFxebz1g0400cB03RQdT';
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (BuildContext context, Widget? child) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        initialRoute: AppPages.initial,
        getPages: AppPages.routes
      )
    );
  }
}
