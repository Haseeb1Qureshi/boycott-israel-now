import 'package:boycott_app/controller/global_controller.dart';
import 'package:boycott_app/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'BoycottApp',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      initialBinding: BindingsBuilder(() {
        Get.put(GlobalController());
      }),
    );
  }
}
