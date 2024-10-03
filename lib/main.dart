import 'package:farm_connects/screen/dashboard.dart';
import 'package:farm_connects/screen/homeScreen/home_layout.dart';
import 'package:flutter/material.dart';
import 'package:farm_connects/screen/authScreen/login_signup.dart';
import 'package:get/get.dart';
import 'package:farm_connects/config/network/remote/dio.dart';
import 'package:farm_connects/config/network/local/cache_helper.dart';

void main() async {
  // Ensure that Flutter bindings are initialized before accessing any services
  WidgetsFlutterBinding.ensureInitialized();

  DioHelper.init();
  await CacheHelper.init();

  String token = CacheHelper.getData(key: 'token') ?? '';

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: token != '' ? HomeLayout() :  LoginSignupScreen(),
    ),
  );
}

class LoginSignupUI extends StatelessWidget {
  const LoginSignupUI({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Login Signup UI",
      home: LoginSignupScreen(),
    );
  }
}
