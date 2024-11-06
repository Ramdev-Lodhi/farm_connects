import 'package:farm_connects/layout/home_layout.dart';
import 'package:farm_connects/screen/otpScreen/LoginScreen_withOTP.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field_style.dart';
import '../../config/location/location_permission.dart';
import '../../config/network/local/cache_helper.dart';
import '../../cubits/auth_cubit/auth_cubit.dart';
import '../../cubits/auth_cubit/auth_states.dart';
import '../../cubits/home_cubit/home_cubit.dart';
import '../../cubits/profile_cubit/profile_cubits.dart';
import '../../widgets/snackbar_helper.dart';
import '../profileScreen/update_profile_screen.dart';
import './Provider/OTPProvider.dart';
import './VerificationSuccessScreen.dart';

import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class OTPVerify extends StatefulWidget {
  @override
  State<OTPVerify> createState() => _OTPVerifyState();
}

class _OTPVerifyState extends State<OTPVerify> {
  final TextEditingController otpController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final otpProvider = Provider.of<OTPProvider>(context, listen: false);
    final String phoneNumber = Provider.of<OTPProvider>(context).phoneNumber;
    final String dialCode = Provider.of<OTPProvider>(context).dialCode;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: BlocListener<AuthCubits, Authstates>(
          listener: (context, state) async {
            print("Current state: $state");
            if (state is Authstates && state.showSnackbar != null) {
              state.showSnackbar(context);
            }
            if (state is LoginSuccessState) {
              await LocationHelper.fetchLocationDetails();
              CacheHelper.getData(key: 'token');
              print(CacheHelper.getData(key: 'name'));
              print(CacheHelper.getData(key: 'email'));
              HomeCubit.get(context).getHomeData();
              await ProfileCubits.get(context).getProfileData();
              var profileData = ProfileCubits.get(context).profileModel.data;
              // print('profiledata:$profileData');
              if (profileData != null) {
                print(
                    'profiledata:${profileData.mobile},${profileData.name},${profileData.password}');
                if (profileData.mobile != null &&
                    profileData.email != null &&
                    profileData.name != null) {
                  Get.offAll(() => HomeLayout());
                } else {
                  Get.offAll(() => UpdateProfileScreen());
                }
              } else {
                print('HomeLayout:$profileData');
                Get.offAll(() => HomeLayout());
              }
            }
            if (state is VerifyOtpLoadingState) {
              setState(() => _isLoading = true);
            } else {
              setState(() => _isLoading = false);
            }
          },
          child: Column(
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
                      // OTPTextField(
                      //   length: 6,
                      //   otpFieldStyle: OtpFieldStyle(
                      //     backgroundColor: Colors.grey,
                      //     borderColor: Colors.white,
                      //     focusBorderColor: Colors.white,
                      //   ),
                      //   width: MediaQuery.of(context).size.width,
                      //   fieldWidth: 50,
                      //   style: TextStyle(fontSize: 20.sp, color: Colors.black),
                      //   textFieldAlignment: MainAxisAlignment.spaceAround,
                      //   fieldStyle: FieldStyle.underline,
                      //   onCompleted: (pin) {
                      //     otpProvider.setOTPCode(pin);
                      //   },
                      // ),

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
                        style: TextStyle(fontSize: 20.sp, color: Colors.black),
                      ),
                      SizedBox(height: ScreenUtil().setHeight(15)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Didn`t you receive any code ?',
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(12),
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              otpProvider.sendOTP();
                            },
                            child: Text(
                              'Resend OTP',
                              style: TextStyle(
                                color: const Color.fromRGBO(143, 130, 244, 1),
                                fontSize: ScreenUtil().setSp(20),
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
                    otpProvider.setOTPCode(otpController.text);
                    await otpProvider.verifyOTP();
                    _handleButtonPress(context);
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
                        fontSize: ScreenUtil().setSp(18), color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleButtonPress(BuildContext context) {
    bool isVerified =
        Provider.of<OTPProvider>(context, listen: false).isVerified;
    if (isVerified) {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => HomeLayout()),
      // );
      Get.offAll(() => HomeLayout());
      // Perform verification and navigate to OTP login page if successful
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.grey[900],
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      color: const Color.fromRGBO(
                          143, 130, 244, 1), // Set the text color to white
                      fontSize: ScreenUtil().setSp(16),
                      fontWeight: FontWeight.bold),
                ),
              ),
            ], // Set the background color to black
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.circular(10), // Add a border radius of 8.0
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
                    // textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white, // Set the text color to white
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
