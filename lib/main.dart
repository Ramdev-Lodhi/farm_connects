import 'package:farm_connects/config/network/styles/styles.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../config/network/remote/dio.dart';
import '../config/network/local/cache_helper.dart';
import '../layout/home_layout.dart';
import '../screen/authScreen/login_signup.dart';
import '../cubits/home_cubit/home_cubit.dart';
import 'package:farm_connects/cubits/home_cubit/home_states.dart';

import '../cubits/auth_cubit/auth_cubit.dart';

void main() async {
  // Ensure that Flutter bindings are initialized before accessing any services
  WidgetsFlutterBinding.ensureInitialized();

  DioHelper.init();
  await CacheHelper.init();

  String token = CacheHelper.getData(key: 'token') ?? '';
  runApp(MyApp(token != '' ? HomeLayout() : LoginSignupScreen()));
  // runApp(
  //   GetMaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     home: token != '' ? HomeLayout() : LoginSignupScreen(),
  //   ),
  // );
}

class MyApp extends StatefulWidget {
  Widget startWidget;

  MyApp(this.startWidget);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthCubits(),
          child: LoginSignupScreen(),
        ),
        BlocProvider(
          create: (context) => HomeCubit()..getHomeData(),
        ),
      ],
      child: BlocBuilder<HomeCubit, HomeStates>(
        builder: (context, state) {
          var cubit = HomeCubit.get(context);
          return ScreenUtilInit(
            designSize: const Size(360, 690),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) {
              return GetMaterialApp(
                debugShowCheckedModeBanner: false,
                theme: lightTheme,
                themeMode: cubit.isDark ? ThemeMode.dark : ThemeMode.light,
                darkTheme: darkTheme,
                home: widget.startWidget,
              );
            },
          );
        },
      ),
    );
  }
}
