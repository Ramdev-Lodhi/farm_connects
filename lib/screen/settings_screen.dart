import 'dart:io';
import 'package:get/get.dart';
import 'package:farm_connects/screen/authScreen/login_signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../config/network/local/cache_helper.dart';
import '../cubits/home_cubit/home_cubit.dart';
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
        onWillPop: () async {
      HomeCubit.get(context).resetToHome();
      return false;
    },
    child:Scaffold(
      // appBar: AppBar(
      //   title: Text('Profile'),
      // ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile image
              InkWell(
                child: Card(
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
                                    'http://192.168.170.22:3000/${CacheHelper.getData(key: 'image')}',
                                    // Adjust the URL if necessary
                                    height: 120,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    'assets/images/background.jpg'), // Default profile image
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
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
                            SizedBox(
                              height: 5,
                            ),
                            // Email
                            Text(
                              "My Account",
                              // CacheHelper.getData(key: 'email') ?? 'user@example.com',
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
              SizedBox(height: 20.0),
              // Name

              SizedBox(height: 20.0),
              // Logout button
              ElevatedButton(
                onPressed: () {
                  HomeCubit.get(context).resetToHome();
                  // Handle logout logic here
                  CacheHelper.removeData(key: 'token');
                  Get.offAll(() =>
                      LoginSignupScreen()); // Navigate to LoginSignupScreen
                },
                child: Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Change button color as needed
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
