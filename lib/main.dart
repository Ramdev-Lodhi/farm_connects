import 'package:farm_connects/cubits/profile_cubit/profile_cubits.dart';
import 'package:farm_connects/cubits/rent_cubit/rent_cubit.dart';
import 'package:farm_connects/screen/authScreen/otpScreen/LoginScreen_withOTP.dart';
import 'package:farm_connects/screen/authScreen/otpScreen/Provider/OTPProvider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../config/network/remote/dio.dart';
import '../config/network/local/cache_helper.dart';
import '../layout/home_layout.dart';
import '../cubits/home_cubit/home_cubit.dart';
import 'package:farm_connects/cubits/home_cubit/home_states.dart';
import '../cubits/auth_cubit/auth_cubit.dart';
import 'constants/styles/styles.dart';
import 'cubits/location_cubit/location_cubits.dart';
import 'cubits/mylead_cubit/mylead_cubits.dart';
import 'cubits/sell_cubit/sell_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await FirebaseMessaging.instance.requestPermission();
  // String? token1 = await FirebaseMessaging.instance.getToken();
  // print("FCM Token: $token1");
  DioHelper.init();
  await CacheHelper.init();
  String token = CacheHelper.getData(key: 'token') ?? '';
  bool isValidToken = await AuthCubits().validateToken(token);
  runApp(MyApp(isValidToken ? HomeLayout() : OTPScreen()));
  // runApp(MyApp(token != '' ? HomeLayout() : OTPScreen()));
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
          child: OTPScreen(),
        ),
        ChangeNotifierProvider(
          create: (context) => OTPProvider(),
        ),
        BlocProvider(
          create: (context) => HomeCubit()..getHomeData(),
        ),
        BlocProvider(
          create: (context) => LocationCubits()..loadStates()
            ..loadDistricts,
        ),
        BlocProvider(
          create: (context) => ProfileCubits()..getProfileData(),
        ),
        BlocProvider(
          create: (context) => SellCubit()..getModel..getSellData(),
        ),
        BlocProvider(
          create: (context) => RentCubit()..GetRentData(),
        ),
        BlocProvider(
          create: (context) => MyleadCubits()..getSellenquiry()..getRentenquiry()..getBuyenquiry()..getrentItemByUserId(),
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
                // home: OTPScreen(),
              );
            },
          );
        },
      ),
    );
  }
}
