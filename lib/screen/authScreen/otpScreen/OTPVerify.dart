import 'dart:async';

import 'package:farm_connects/layout/home_layout.dart';
import 'package:farm_connects/screen/authScreen/otpScreen/LoginScreen_withOTP.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../config/location/location_permission.dart';
import '../../../config/network/local/cache_helper.dart';
import '../../../cubits/auth_cubit/auth_cubit.dart';
import '../../../cubits/auth_cubit/auth_states.dart';
import '../../../cubits/home_cubit/home_cubit.dart';
import '../../../cubits/profile_cubit/profile_cubits.dart';
import '../../../widgets/loadingIndicator.dart';
import '../../../widgets/snackbar_helper.dart';
import '../../profileScreen/update_profile_screen.dart';
import './Provider/OTPProvider.dart';
import 'package:provider/provider.dart';


class OTPVerify extends StatefulWidget {
  @override
  State<OTPVerify> createState() => _OTPVerifyState();
}

class _OTPVerifyState extends State<OTPVerify> {
  final TextEditingController otpController = TextEditingController();

  bool _isLoading = false;
  bool isVerified = true;
  int remainingTime = 60; // 1-minute countdown
  late Timer timer;
  bool isResendEnabled = false;

  @override
  void initState() {
    super.initState();
    startResendTimer();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
  void startResendTimer() {
    setState(() {
      remainingTime = 60;
      isResendEnabled = false;
    });

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        setState(() {
          isResendEnabled = true;
        });
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final otpProvider = Provider.of<OTPProvider>(context, listen: false);
    final authcubit = Provider.of<OTPProvider>(context, listen: false);
    final String phoneNumber = Provider.of<OTPProvider>(context).phoneNumber;
    final String dialCode = Provider.of<OTPProvider>(context).dialCode;
    final phonenumber = '+' + dialCode + phoneNumber;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocListener<AuthCubits, Authstates>(
          listener: (context, state) async {
            if (state is VerifyOtpSuccessState) {
              showCustomSnackbar('Success', 'Login successful.', isError: false);
            }
            if (state is VerifyOtpSuccessState) {

              await LocationHelper.fetchLocationDetails();
              CacheHelper.getData(key: 'token');
              HomeCubit.get(context).getHomeData();
              await ProfileCubits.get(context).getProfileData();
              var profileData = ProfileCubits.get(context).profileModel.data;
              if (profileData != null) {
                if (profileData.mobile != null &&
                    profileData.email != null &&
                    profileData.name != null) {
                  Get.offAll(() => HomeLayout());
                } else {
                  Get.offAll(() => UpdateProfileScreen());
                }
              } else {
                Get.offAll(() => HomeLayout());
              }
            }else{
              isVerified=false;
            }
            if (state is VerifyOtpLoadingState) {
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
                      padding: EdgeInsets.all(ScreenUtil().setWidth(24)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/message.png',
                            width: ScreenUtil().setWidth(200),
                            height: ScreenUtil().setWidth(200),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(10)),
                          Text(
                            'OTP Verification',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenUtil().setSp(24),
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(10)),
                          Text(
                            'Please enter the OTP sent to',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(16),
                            ),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(10)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '+$dialCode-$phoneNumber',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: ScreenUtil().setSp(16),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.offAll(() => OTPScreen());
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      color: Colors.black,
                                      size: ScreenUtil().setSp(16),
                                    ),
                                    SizedBox(width: 2),
                                    Text(
                                      'change no.',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: ScreenUtil().setSp(16),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: ScreenUtil().setHeight(15)),
                          TextField(
                            controller: otpController,
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            // Set to 6 for OTP
                            decoration: InputDecoration(
                              labelText: 'Enter OTP',
                              hintText: 'Enter OTP',
                              hintStyle: TextStyle(color: Colors.black38),
                              counterText: '',
                              // Hide counter text
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                // borderSide: BorderSide.none,
                              ),
                            ),
                            style:
                                TextStyle(fontSize: 20.sp, color: Colors.black),
                          ),
                          SizedBox(height: ScreenUtil().setHeight(15)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Didn`t you receive any code ?',
                                style: TextStyle(
                                  fontSize: ScreenUtil().setSp(12),
                                ),
                              ),
                              TextButton(
                                onPressed: isResendEnabled
                                    ? () {
                                  BlocProvider.of<AuthCubits>(context).sendOTP(phonenumber);
                                  startResendTimer();
                                }
                                    : null,
                                child: Text(
                                  isResendEnabled
                                      ? 'Resend OTP'
                                      : 'Resend OTP in $remainingTime s',
                                  style: TextStyle(
                                    color: isResendEnabled
                                        ? const Color.fromRGBO(143, 130, 244, 1)
                                        : Colors.grey,
                                    fontSize: isResendEnabled ? ScreenUtil().setSp(20) : ScreenUtil().setSp(12) ,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  // BottomSheet for Verify Button
                  const Divider(
                    color: Colors.grey,
                    thickness: 1.0,
                    height: 1.0,
                  ),

                  Container(
                    padding: EdgeInsets.all(ScreenUtil().setWidth(16)),
                    width: ScreenUtil()
                        .setWidth(0.9 * MediaQuery.of(context).size.width),
                    height: 82.h,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (otpController.text.isEmpty) {
                          showCustomSnackbar(
                              'Please enter the OTP sent to this phone number $dialCode-$phoneNumber ',
                              '',
                              isError: true);
                          return;
                        }
                        await BlocProvider.of<AuthCubits>(context)
                            .verifyOTP(phonenumber, otpController.text);
                      },
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
                        'Verify',
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(18),
                            color: Colors.white),
                      ),
                    ),
                  ),
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

  void _handleButtonPress(BuildContext context) {
    if (isVerified) {
      // Get.offAll(() => HomeLayout());
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      color: const Color.fromRGBO(143, 130, 244, 1),
                      fontSize: ScreenUtil().setSp(16),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'assets/wrong.png',
                    width: ScreenUtil().setWidth(120),
                    height: ScreenUtil().setWidth(120),
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(16)),
                Center(
                  child: Text(
                    'Your OTP is invalid or has expired. Please enter a valid OTP or click "Resend" to request a new OTP. The OTP expires after 3 minutes.',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil().setSp(18),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }
}
