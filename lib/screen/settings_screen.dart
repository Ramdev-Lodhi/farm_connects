import 'dart:io';
import 'package:get/get.dart';
import 'package:farm_connects/screen/authScreen/login_signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../config/network/local/cache_helper.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile image
              CircleAvatar(
                radius: 45.0,
                backgroundColor: Colors.transparent,
                child: ClipRRect(
                  clipBehavior: Clip.hardEdge,
                  borderRadius: BorderRadius.circular(45.0),
                  child: CacheHelper.getData(key: 'image') != null
                      ? Image.network(
                    'http://192.168.170.22:3000/${CacheHelper.getData(key: 'image')}', // Adjust the URL if necessary
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                      : Image.asset(
                      'assets/images/background.jpg'), // Default profile image
                ),
              ),
              SizedBox(height: 20.0),
              // Name
              Text(
                CacheHelper.getData(key: 'name') ?? 'User Name',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10.0),
              // Email
              Text(
                CacheHelper.getData(key: 'email') ?? 'user@example.com',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 20.0),
              // Logout button
              ElevatedButton(
                onPressed: () {
                  // Handle logout logic here
                  CacheHelper.removeData(key: 'token');
                  Get.offAll(() => LoginSignupScreen()); // Navigate to LoginSignupScreen
                },
                child: Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Change button color as needed
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
