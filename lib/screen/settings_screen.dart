import 'dart:io';
import 'package:farm_connects/config/network/styles/colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:farm_connects/layout/home_layout.dart';
import 'package:farm_connects/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../config/server_url.dart';
import '../config/network/local/cache_helper.dart';
import '../screen/authScreen/login_signup.dart';
import '../cubits/home_cubit/home_cubit.dart';
import '../cubits/home_cubit/home_states.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        HomeCubit cubit = HomeCubit.get(context);
        bool isDark = cubit.isDark; // Reference to dark mode state

        // Define colors based on theme
        Color cardColor = isDark ? Colors.white12 : Colors.white;
        Color textColor = isDark ? Colors.white : Colors.black;
        Color profileCardColor = isDark ? Colors.black54 : Colors.white;
        Color logoutColor = isDark ? asmarFate7 : offWhite;

        return WillPopScope(
          onWillPop: () async {
            HomeCubit.get(context).resetToHome(); // Reset to Home when back is pressed
            return false; // Prevent default back action
          },
          child: Scaffold(
            backgroundColor: cubit.isDark ? Colors.black : Colors.white,
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Profile image
                      InkWell(
                        child: Card(
                          color: profileCardColor,
                          elevation: 1,
                          child: Container(
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 45.0,
                                  backgroundColor: Colors.transparent,
                                  child: ClipRRect(
                                    clipBehavior: Clip.hardEdge,
                                    borderRadius: BorderRadius.circular(45.0),
                                    child: CacheHelper.getData(key: 'image') != null
                                        ? Image.network(
                                      '${CacheHelper.getData(key: 'image')}',
                                      height: 120,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Image.network(
                                            'https://res.cloudinary.com/farmconnects/image/upload/v1728409875/user_kzxegi.jpg'); // Fallback image
                                      },
                                    )
                                        : Image.network(
                                        'https://res.cloudinary.com/farmconnects/image/upload/v1728409875/user_kzxegi.jpg'), // Default profile image
                                  ),
                                ),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      CacheHelper.getData(key: 'name') ?? 'User Name',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w500,
                                        color: isDark ? Colors.white : Colors.grey,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "My Account",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: isDark ? Colors.white : Colors.black,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          print("profile");
                        },
                      ),
                      SizedBox(height: 10.0),
                      Card(
                        color: cardColor,
                        elevation: 3,
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.dark_mode, color: textColor),
                              title: Text("Dark Mode", style: TextStyle(color: textColor)),
                              trailing: CupertinoSwitch(
                                value: isDark,
                                onChanged: (state) {
                                  cubit.changeThemeMode(state);
                                },
                                activeColor: Colors.white24,
                                thumbColor: isDark ? Colors.white12 : Colors.white,
                              ),
                            ),
                            ListTile(
                              leading: Icon(Icons.notifications, color: textColor),
                              title: Text("NOTIFICATION", style: TextStyle(color: textColor)),
                              trailing: Text("On", style: TextStyle(color: Colors.grey)),
                            ),
                            ListTile(
                              leading: Icon(Icons.add_circle_outline, color: textColor),
                              title: Text("ADD VEHICLE", style: TextStyle(color: textColor)),
                              trailing: Icon(Icons.keyboard_arrow_right_sharp, color: textColor),
                            ),
                            ListTile(
                              leading: Icon(FontAwesomeIcons.tractor, size: 20.0, color: textColor),
                              title: Text("NEW TRACTOR", style: TextStyle(color: textColor)),
                              trailing: Icon(Icons.keyboard_arrow_right_sharp, color: textColor),
                            ),
                            ListTile(
                              leading: Icon(Icons.agriculture_outlined, color: textColor),
                              title: Text("BUY USED TRACTOR", style: TextStyle(color: textColor)),
                              trailing: Icon(Icons.keyboard_arrow_right_sharp, color: textColor),
                            ),
                            ListTile(
                              leading: Icon(Icons.sell, color: textColor),
                              title: Text("SELL USED TRACTOR", style: TextStyle(color: textColor)),
                              trailing: Icon(Icons.keyboard_arrow_right_sharp, color: textColor),
                            ),
                            ListTile(
                              leading: Icon(Icons.import_export, color: textColor),
                              title: Text("FARM EQUIPMENT'S", style: TextStyle(color: textColor)),
                              trailing: Icon(Icons.keyboard_arrow_right_sharp, color: textColor),
                            ),
                            ListTile(
                              leading: Icon(FontAwesomeIcons.retweet, size: 20.0, color: textColor),
                              title: Text("RENT TRACTOR / EQUIPMENT'S", style: TextStyle(color: textColor)),
                              trailing: Icon(Icons.keyboard_arrow_right_sharp, color: textColor),
                            ),
                            ListTile(
                              leading: Icon(Icons.info, color: textColor),
                              title: Text("About", style: TextStyle(color: textColor)),
                              trailing: Text("Version:1.0.0", style: TextStyle(color: textColor)),
                            ),
                          ],
                        ),
                      ),


                      Container(
                        color: logoutColor,
                        width: double.infinity,
                        padding: EdgeInsets.only(
                            left: 20.0.w, top: 7.5.h, bottom: 7.5.h),
                        child: Text(
                          'Logout'.toUpperCase(),
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.0.sp),
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0.h, horizontal: 20.0.w),
                        child: Row(
                          children: [
                            Icon(
                              Icons.logout,
                              size: 28.sp,
                              color: isDark ? skin : Colors.black54,
                            ),
                            SizedBox(width: 10.0.w),
                            Text(
                              'Logout',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 17.0.sp,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            Spacer(),
                            InkWell(
                              borderRadius: BorderRadius.circular(10.0.sp),
                              highlightColor: isDark ? asmarFate7 : offWhite,
                              onTap: () {
                                CacheHelper.removeData(key: 'token');
                                HomeCubit.get(context).resetToHome();
                                Get.offAll(() => LoginSignupScreen());
                              },
                              child: Container(
                                padding: EdgeInsets.all(10.0.sp),
                                child: Row(
                                  children: [
                                    Text(
                                      'Logout',
                                      style: TextStyle(
                                        color: orange,
                                        fontSize: 14.0.sp,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 18.0.sp,
                                      color: orange,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
