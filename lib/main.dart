import 'package:cripto/utils/routes/app_routes.dart';
import 'package:cripto/utils/view/profile/portfolio_screen.dart';
import 'package:cripto/utils/view/coin_list/coin_list.dart';
import 'package:cripto/utils/view/splash_screen/splash_scree.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
