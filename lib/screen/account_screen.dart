import 'dart:io';
import 'package:farm_connects/screen/authScreen/otpScreen/LoginScreen_withOTP.dart';
import 'package:farm_connects/screen/profileScreen/edit_profile_screen.dart';
import 'package:farm_connects/screen/profileScreen/imageUpload_screen.dart';
import 'package:farm_connects/screen/profileScreen/password_change_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../config/network/local/cache_helper.dart';
import '../constants/styles/colors.dart';
import '../cubits/auth_cubit/auth_cubit.dart';
import '../cubits/profile_cubit/profile_cubits.dart';
import '../cubits/home_cubit/home_cubit.dart';
import '../cubits/home_cubit/home_states.dart';

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLocationOn =
        CacheHelper.getData(key: 'pincode') != null ? true : false;
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        HomeCubit cubit = HomeCubit.get(context);
        bool isDark = cubit.isDark;
        var profileCubit = ProfileCubits.get(context);

        Color cardColor = isDark ? Colors.white12 : Colors.white;
        Color textColor = isDark ? Colors.white : Colors.black;
        Color iconColor = isDark ? skin : Colors.black45;
        Color profileCardColor = isDark ? Colors.white12 : Colors.white;
        Color logoutColor = isDark ? asmarFate7 : offWhite;

        return WillPopScope(
          onWillPop: () async {
            HomeCubit.get(context)
                .resetToHome(); // Reset to Home when back is pressed
            return false;
          },
          child: Scaffold(
            backgroundColor: cubit.isDark ? Colors.black : Colors.white,
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildProfileCard(
                        context, profileCubit, profileCardColor, textColor),
                    SizedBox(height: 10.0),
                    _AccountTypeTabBar(textColor),
                    SizedBox(
                      height: 350.h,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildMyLeads(isDark),
                          _buildPersonalInfoSection(textColor,iconColor, profileCubit),
                        ],
                      ),
                    ),
                    Container(
                      color: logoutColor,
                      width: double.infinity,
                      padding: EdgeInsets.only(
                          left: 20.0.w, top: 7.5.h, bottom: 7.5.h),
                      child: Text(
                        'Setting'.toUpperCase(),
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0.sp),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.dark_mode, color: isDark ? skin : Colors.black45 ),
                      title: Text("Dark Mode",
                          style: TextStyle(color: textColor)),
                      trailing: CupertinoSwitch(
                        value: isDark,
                        onChanged: (state) {
                          cubit.changeThemeMode(state);
                        },
                        activeColor: Colors.white24,
                        thumbColor:
                        isDark ? Colors.white12 : Colors.white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0.h, horizontal: 20.0.w),
                      child: GestureDetector(
                        onTap: ()=>{
                          Get.to(ChangePasswordScreen())
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.edit,
                              size: 25.sp,
                              color: isDark ? skin : Colors.black45,
                            ),
                            SizedBox(width: 10.0.w),
                            Text(
                              'Change Password',
                              style: TextStyle(
                                fontWeight: FontWeight.w100,
                                fontSize: 15.0.sp,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            Spacer(),
                            InkWell(
                              borderRadius: BorderRadius.circular(10.0.sp),
                              highlightColor: isDark ? asmarFate7 : offWhite,
                              onTap: () {
                                Get.to(() => ChangePasswordScreen());
                              },
                              child: Container(
                                padding: EdgeInsets.all(10.0.sp),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 18.0.sp,
                                      color: isDark ? Colors.white38 : Colors.black45 ,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
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
                              AuthCubits.get(context).signOut();
                              CacheHelper.removeData(key: 'token');
                              CacheHelper.removeData(key: 'image');
                              CacheHelper.removeData(key: 'name');
                              CacheHelper.removeData(key: 'email');
                              CacheHelper.removeData(key: 'state');
                              CacheHelper.removeData(key: 'district');
                              CacheHelper.removeData(key: 'subDistrict');
                              CacheHelper.removeData(key: 'village');
                              CacheHelper.removeData(key: 'pincode');
                              HomeCubit.get(context).resetToHome();
                              Get.offAll(() => OTPScreen());
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
        );
      },
    );
  }

  Widget _buildProfileCard(BuildContext context, ProfileCubits profileCubit,
      Color profileCardColor, Color textColor) {
    return Card(
      color: profileCardColor,
      elevation: 1,
      child: Container(
        height: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ImageDialog(profileCubit: profileCubit);
                    },
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 45.0,
                        backgroundColor: Colors.transparent,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(45.0),
                          child: Image.network(
                            ProfileCubits.get(context)
                                    .profileModel
                                    .data
                                    ?.image ??
                                CacheHelper.getData(key: 'image'),
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.person, size: 45),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.blue,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 10),
                // _buildProfileDetails(profileCubit, textColor),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildProfileDetails(profileCubit, textColor),
                Container(
                  width: 100,
                  child: TextButton(
                    onPressed: () => Get.to(() => EditProfileScreen()),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      // padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 5.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        // Rounded corners
                        side: BorderSide(
                            color: Colors.blue,
                            width: 2.0), // Border color and width
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.edit, color: Colors.white), // Icon color
                        SizedBox(width: 5),
                        Text(
                          'Edit',
                          style: TextStyle(color: Colors.white), // Text color
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileDetails(ProfileCubits profileCubit, Color textColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          CacheHelper.getData(key: 'name') ?? 'User Name',
          style: TextStyle(
              fontSize: 16.0, fontWeight: FontWeight.w500, color: textColor),
        ),
        SizedBox(height: 5),
        Text(
          CacheHelper.getData(key: 'email') ?? 'someone@example.com',
          style: TextStyle(fontSize: 12.0, color: textColor),
        ),
        SizedBox(height: 5),
      ],
    );
  }

  Widget _AccountTypeTabBar(Color textcolor) {
    return TabBar(
      controller: _tabController,
      labelColor:textcolor,
      unselectedLabelColor: textcolor,
      indicatorColor: textcolor,
      tabs: [
        Tab(text: 'My Leads'),
        Tab(text: 'Personal Information'),
      ],
    );
  }

  Widget _buildMyLeads(bool isDark) {
    Color gridColor = isDark ? Colors.white12 : Colors.white;
    Color textColor = isDark ? Colors.white : Colors.black;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 1.0,
        ),
        children: [
          _buildGridItem(Icons.list_alt, 'Listed Item', Colors.blue,gridColor,textColor),
          // _buildGridItem(Icons.shopping_cart, 'Buy Item', Colors.green),
          _buildGridItem(Icons.receipt_long, 'Purchase Item', Colors.orange,gridColor,textColor),
          _buildGridItem(Icons.home_work, 'Rent Hiring Service', Colors.purple,gridColor,textColor),
          _buildGridItem(Icons.inventory, 'My Inventory', Colors.red,gridColor,textColor),
        ],
      ),
    );
  }

  Widget _buildGridItem(IconData icon, String title, Color color,Color gridColor,Color textColor) {
    return Card(
      elevation: 2.0,
      color: gridColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: () {
          // Handle tap event for each item
          print('$title tapped');
        },
        borderRadius: BorderRadius.circular(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40.0, color: color),
            SizedBox(height: 8.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }




  Widget _buildPersonalInfoSection(
      Color textColor,Color iconColor, ProfileCubits profileCubit) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.phone, color: iconColor),
            title: Text('Mobile', style: TextStyle(color: textColor)),
            trailing: Text(profileCubit.profileModel.data?.mobile ?? 'N/A',
                style: TextStyle(color: textColor,fontSize: 12)),
          ),
          // ListTile(
          //   leading: Icon(Icons.location_city_rounded, color: textColor),
          //   title: Text(
          //     'Address',
          //     style: TextStyle(color: textColor),
          //   ),
          //   subtitle: Text(
          //     CacheHelper.getData(key: 'fullAddress') ?? 'N/A',
          //     style: TextStyle(color: textColor),
          //     softWrap: true,
          //   ),
          // ),
          ListTile(
            leading: Icon(Icons.map, color: iconColor),
            title: Text('Locality', style: TextStyle(color: textColor)),
            trailing: Text(CacheHelper.getData(key: 'locality') ?? 'N/A',
                style: TextStyle(color: textColor,fontSize: 12)),
          ),
          ListTile(
            leading: Icon(Icons.map, color: iconColor),
            title: Text('State', style: TextStyle(color: textColor)),
            trailing: Text(CacheHelper.getData(key: 'state') ?? 'N/A',
                style: TextStyle(color: textColor,fontSize: 12)),
          ),
          ListTile(
            leading: Icon(Icons.location_city, color: iconColor),
            title: Text('District', style: TextStyle(color: textColor)),
            trailing: Text(CacheHelper.getData(key: 'district') ?? 'N/A',
                style: TextStyle(color: textColor,fontSize: 12)),
          ),
          // ListTile(
          //   leading: Icon(Icons.location_on, color: textColor),
          //   title: Text('Sub District', style: TextStyle(color: textColor)),
          //   trailing: Text(CacheHelper.getData(key: 'subDistrict') ?? 'N/A',
          //       style: TextStyle(color: textColor)),
          // ),
          // ListTile(
          //   leading: Icon(Icons.holiday_village, color: textColor),
          //   title: Text('village', style: TextStyle(color: textColor)),
          //   trailing: Text(profileCubit.profileModel.data?.village ?? 'N/A',
          //       style: TextStyle(color: textColor)),
          // ),
          ListTile(
            leading: Icon(Icons.pin_drop, color: iconColor),
            title: Text('Pincode', style: TextStyle(color: textColor)),
            trailing: Text(CacheHelper.getData(key: 'pincode') ?? 'N/A',
                style: TextStyle(color: textColor,fontSize: 12)),
          ),
        ],
      ),
    );
  }
}
