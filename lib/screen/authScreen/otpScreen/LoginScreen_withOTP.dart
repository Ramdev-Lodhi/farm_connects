import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:farm_connects/cubits/rent_cubit/rent_cubit.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:farm_connects/cubits/auth_cubit/auth_states.dart';
import 'package:farm_connects/screen/authScreen/otpScreen/passwordScreen.dart';
import 'package:farm_connects/cubits/profile_cubit/profile_cubits.dart';
import '../../../config/location/location_permission.dart';
import '../../../config/network/local/cache_helper.dart';
import '../../../constants/palette.dart';
import '../../../cubits/auth_cubit/auth_cubit.dart';
import '../../../cubits/home_cubit/home_cubit.dart';
import '../../../cubits/mylead_cubit/mylead_cubits.dart';
import '../../../cubits/sell_cubit/sell_cubit.dart';
import '../../../layout/home_layout.dart';
import '../../../service/notification_service.dart';
import '../../../widgets/loadingIndicator.dart';
import '../../../widgets/permission/notificationPermissionDialog.dart';
import '../../../widgets/snackbar_helper.dart';
import '../../profileScreen/edit_profile_screen.dart';
import '../../profileScreen/update_profile_screen.dart';
import './Provider/OTPProvider.dart';
import 'OTPVerify.dart';
import 'country_code_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class OTPScreen extends StatefulWidget {
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> with WidgetsBindingObserver{
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final TextEditingController _phoneNumberController = TextEditingController();
  bool _isLoading = false;
  bool isDialogVisible = false;
  @override
  void initState() {
    super.initState();
    NotificationService.initialize();
    _firebaseMessaging.requestPermission();

    WidgetsBinding.instance.addObserver(this);
    checkAndroidVersionAndPermission();
    _firebaseMessaging.getToken().then((token) {

      // print("Firebase Token: $token");
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Message received: ${message.notification?.title}");
      String? imageUrl = message.notification?.android?.imageUrl;
      print("Message Image: ${message.notification?.android?.imageUrl}");
      NotificationService.showNotification(
        title: message.notification?.title ?? 'No Title',
        body: message.notification?.body ?? 'No Body',
        imageUrl: imageUrl,
      );
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Message clicked: ${message.notification?.title}");

    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkNotificationPermission();
    }
  }

  Future<void> checkAndroidVersionAndPermission() async {
    if (Platform.isAndroid) {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      int androidVersion = int.parse(androidInfo.version.sdkInt.toString());
      if (androidVersion < 33) {
        checkNotificationPermission();
      } else {
        await FirebaseMessaging.instance.requestPermission();
        print("No permission check needed for Android 13+");
      }
    }
  }
  void checkNotificationPermission() async {
    NotificationSettings settings = await _firebaseMessaging.getNotificationSettings();
    PermissionStatus status = await Permission.notification.status;
    if (status.isDenied && !isDialogVisible) {
      _showPermissionDialog();
    } else if (status.isGranted && isDialogVisible) {
      Navigator.of(context, rootNavigator: true).pop();
      setState(() {
        isDialogVisible = false;
      });
    }
  }

  void _showPermissionDialog() {
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    final bool isDarkMode = brightness == Brightness.dark;
    setState(() {
      isDialogVisible = true;
    });
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => NotificationPermissionDialog(
        isDarkMode: isDarkMode,
        onEnable: () {
          openAppSettings();
        },
        onDeny: () {
          Navigator.of(context).pop();
          setState(() {
            isDialogVisible = false;
          });
        },
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _phoneNumberController.dispose();
    super.dispose();
  }

  void _callBackFunction(String name, String dialCode, String flag) {
    final otpProvider = Provider.of<OTPProvider>(context, listen: false);
    otpProvider.setDialCode(dialCode.substring(1));
  }

  void _sendOTP() {
    if (_phoneNumberController.text.isEmpty) {
      showCustomSnackbar('Please enter your phone number', '', isError: true);
      return;
    }
    final otpProvider = Provider.of<OTPProvider>(context, listen: false);
    otpProvider.setPhoneNumber(_phoneNumberController.text);
    otpProvider.sendOTP();
    // BlocProvider.of<AuthCubits>(context).sendOTP(_phoneNumberController.text);
    Get.to(() => OTPVerify());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocListener<AuthCubits, Authstates>(
          listener: (context, state) async {

            if (state is Authstates && state.showSnackbar != null) {
              state.showSnackbar(context);
            }
            if (state is LoginSuccessState) {
              await LocationHelper.fetchLocationDetails();
              CacheHelper.getData(key: 'token');
              HomeCubit.get(context).getHomeData();
              SellCubit.get(context).getSellData();
              RentCubit.get(context).GetRentData();
              MyleadCubits.get(context).getSellenquiry();
              await ProfileCubits.get(context).getProfileData();
              var profileData = ProfileCubits.get(context).profileModel.data;
              if (profileData != null) {
                if (profileData.mobile != null &&
                    profileData.email != null &&
                    profileData.name != null ) {
                  Get.offAll(() => HomeLayout());
                }else{
                  Get.offAll(() => UpdateProfileScreen());
                }
              }else{
                Get.offAll(() => HomeLayout());
              }
            }
            if (state is LoginLoadingState || state is SendOtpLoadingState ) {
              setState(() => _isLoading = true);
            } else {
              setState(() => _isLoading = false);
            }
          },
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(ScreenUtil().setWidth(24)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/farm_connects.png',
                              width: ScreenUtil().setWidth(200),
                              height: ScreenUtil().setWidth(200),
                            ),
                            SizedBox(height: ScreenUtil().setHeight(16)),
                            Text(
                              'Welcome to Farm Connects',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenUtil().setSp(24),
                              ),
                            ),
                            SizedBox(height: ScreenUtil().setHeight(16)),
                            Text(
                              'Log in or Sign up to access your account.',
                              // textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(16),
                              ),
                            ),
                            SizedBox(height: ScreenUtil().setHeight(16)),
                            Text(
                              'We will send you a one-time password to this mobile number',
                              // textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(10),
                              ),
                            ),
                            SizedBox(height: ScreenUtil().setHeight(20)),
                            Container(
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: TextField(
                                      controller: _phoneNumberController,
                                      decoration: InputDecoration(
                                        prefixIcon: Container(
                                          width: ScreenUtil().setWidth(150),
                                          padding: EdgeInsets.only(left: 8),
                                          child: CountryPicker(
                                            callBackFunction: _callBackFunction,
                                            headerText: 'Select Country',
                                            headerBackgroundColor:
                                                Theme.of(context).primaryColor,
                                            headerTextColor: Colors.white,
                                          ),
                                        ),
                                        labelText: 'Phone Number',
                                        // hintText: 'Please enter your phone number',
                                        hintStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20.sp),
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          // borderSide: BorderSide.none,
                                        ),
                                      ),
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 20.sp),
                                      keyboardType: TextInputType.phone,
                                      textInputAction: TextInputAction.done,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: ScreenUtil().setHeight(30)),
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey,
                                    thickness: 1.0,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 8.0),
                                  // Space around text
                                  child: Text(
                                    'Or Sign in With',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey,
                                    thickness: 1.0,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: ScreenUtil().setHeight(30)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    // AuthCubits.get(context).signInWithGoogle();
                                    openPasswordBottomSheet(context);
                                  },
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      side: BorderSide(
                                          width: 1, color: Colors.grey),
                                      // minimumSize: Size(145, 40),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      backgroundColor: Colors.blue),
                                  child: Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.user,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        " Password ",
                                      )
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    AuthCubits.get(context).signInWithGoogle();
                                  },
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      side: BorderSide(
                                          width: 1, color: Colors.grey),
                                      // minimumSize: Size(145, 40),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      backgroundColor: Palette.googleColor),
                                  child: Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.google,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "  Google      ",
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    color: Colors.grey,
                    thickness: 1.0,
                    height: 1.0,
                  ),
                  SizedBox(height: ScreenUtil().setHeight(5)),
                  Container(
                    width: ScreenUtil()
                        .setWidth(0.9 * MediaQuery.of(context).size.width),
                    height: 55.h,
                    child: ElevatedButton(
                      onPressed: _sendOTP,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(143, 130, 244, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setHeight(16),
                        ),
                      ),
                      child: Text(
                        'Send OTP',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(18),
                            color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(5)),
                ],
              ),
              if (_isLoading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(child: LoadingIndicator(size: 100)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

void openPasswordBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.white,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          minChildSize: 0.6,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.offAll(() => OTPScreen());
                    },
                    child: Container(
                      height: 5.0,
                      width: 80.0,
                      color: Colors.grey,
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                    ),
                  ),
                  PasswordScreen(),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
