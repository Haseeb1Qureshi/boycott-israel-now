// ignore_for_file: must_be_immutable

import 'package:boycott_app/controller/global_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  GlobalController gc = Get.put(GlobalController());
  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/splash_screen_image.gif',
      fit: BoxFit.cover,
    );
  }
}
