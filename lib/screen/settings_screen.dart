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

        return WillPopScope(
          onWillPop: () async {
            HomeCubit.get(context)
                .resetToHome(); // Reset to Home when back is pressed
            return false; // Prevent default back action
          },
          child: Scaffold(
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
                          color: Colors.white,
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
                                        return Image.network('https://res.cloudinary.com/farmconnects/image/upload/v1728409875/user_kzxegi.jpg'); // Fallback image
                                      },
                                    )
                                        : Image.network('https://res.cloudinary.com/farmconnects/image/upload/v1728409875/user_kzxegi.jpg'), // Default profile image
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
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "My Account",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.black,
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
                        color: Colors.white,
                        // color: Theme.of(context).cardColor, // Use theme color for the card
                        elevation: 3,
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.dark_mode),
                              title: Text("Dark Mode"),
                              trailing: CupertinoSwitch(
                                value: cubit.isDark,
                                onChanged: (state) {
                                  cubit.changeThemeMode(state);
                                },
                                activeColor: Colors.black45,
                                thumbColor: cubit.isDark ? asmarFate7 : Colors.white,
                              ),
                            ),
                            ListTile(
                              leading: Icon(Icons.notifications),
                              title: Text("NOTIFICATION"),
                              trailing: Text("On", style: TextStyle(color: Colors.grey)),
                            ),
                            ListTile(
                              leading: Icon(Icons.add_circle_outline),
                              title: Text("ADD VEHICLE"),
                              trailing: Icon(Icons.keyboard_arrow_right_sharp),
                            ),
                            ListTile(
                              leading: Icon(FontAwesomeIcons.tractor,  size: 20.0, ),
                              title: Text("NEW TRACTOR"),
                              trailing: Icon(Icons.keyboard_arrow_right_sharp),
                            ),
                            ListTile(
                              leading: Icon(Icons.agriculture_outlined),
                              title: Text("BUY USED TRACTOR"),
                              trailing: Icon(Icons.keyboard_arrow_right_sharp),
                            ),
                            ListTile(
                              leading: Icon(Icons.sell),
                              title: Text("SELL USED TRACTOR"),
                              trailing: Icon(Icons.keyboard_arrow_right_sharp),
                            ),
                            ListTile(
                              leading: Icon(Icons.import_export),
                              title: Text("FARM EQUIPMENT'S"),
                              trailing: Icon(Icons.keyboard_arrow_right_sharp),
                            ), ListTile(
                              leading: Icon(FontAwesomeIcons.retweet,size: 20.0),
                              title: Text("RENT TRACTOR / EQUIPMENT'S"),
                              trailing: Icon(Icons.keyboard_arrow_right_sharp),
                            ),
                            ListTile(
                              leading: Icon(Icons.info),
                              title: Text("About"),
                              trailing: Icon(Icons.keyboard_arrow_right_sharp),
                            ),
                          ],
                        ),
                      ),
                      // Dark Mode Toggle


                      // Logout button

                      Container(
                        color: cubit.isDark ? asmarFate7 : offWhite,
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
                      //logout
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0.h, horizontal: 20.0.w),
                        child: Row(
                          children: [
                            Icon(
                              Icons.logout,
                              size: 28.sp,
                              color: cubit.isDark ? skin : Colors.black54,
                            ),
                            SizedBox(
                              width: 10.0.w,
                            ),
                            Text(
                              'Logout',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 17.0.sp,
                                color: cubit.isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            Spacer(),
                            InkWell(
                              borderRadius: BorderRadius.circular(10.0.sp),
                              highlightColor: cubit.isDark ? asmarFate7 : offWhite,
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
