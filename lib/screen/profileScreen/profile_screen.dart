import 'package:farm_connects/cubits/profile_cubit/profile_cubits.dart';
import 'package:farm_connects/cubits/profile_cubit/profile_states.dart';
import 'package:farm_connects/screen/profileScreen/password_change_screen.dart';
import 'package:farm_connects/screen/profileScreen/edit_profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../config/network/local/cache_helper.dart';
import '../../config/network/styles/colors.dart';
import '../../cubits/home_cubit/home_states.dart';
import '../../cubits/home_cubit/home_cubit.dart';
import '../../layout/appbar_layout.dart';
import '../../config/location/location_permission.dart';
import 'package:image_picker/image_picker.dart';

import 'imageUpload_screen.dart';

class ProfileScreen extends StatelessWidget {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubits, ProfileState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        var profileCubit = ProfileCubits.get(context);
        print("Current state: $state");
        Color cardColor = cubit.isDark ? Colors.white12 : Colors.white;
        Color textColor = cubit.isDark ? Colors.white : Colors.black;
        Color profileCardColor = cubit.isDark ? Colors.white12 : Colors.white;

        return Scaffold(
          appBar: AppBarLayout(
            isDark: cubit.isDark,
            onSearchPressed: () {},
            onDropdownChanged: () {},
          ),
          body: Container(
            color: cubit.isDark ? Colors.black : Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildProfileCard(
                    context, profileCubit, profileCardColor, textColor),
                _buildToggleOptions(context, cubit, profileCubit),
                Transform.translate(
                  offset: Offset(0, -5),
                  child: Divider(
                      thickness: 1.5,
                      color: cubit.isDark ? Colors.white30 : Colors.black12,
                      height: 10),
                ),
                _buildContentSection(profileCubit, textColor),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 0),
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(() => ChangePasswordScreen());
                      },
                      child: Text("Change Password",
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
                            CacheHelper.getData(key: 'image') ??
                                'https://res.cloudinary.com/farmconnects/image/upload/v1728409875/user_kzxegi.jpg',
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

  Widget _buildToggleOptions(
      BuildContext context, HomeCubit cubit, ProfileCubits profileCubit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildToggleOption('Personal Info', true, profileCubit.isPersonalInfo,
            cubit, profileCubit),
        _buildToggleOption('My Leads', false, !profileCubit.isPersonalInfo,
            cubit, profileCubit),
      ],
    );
  }

  Widget _buildToggleOption(String title, bool isPersonal, bool isActive,
      HomeCubit cubit, ProfileCubits profileCubit) {
    return GestureDetector(
      onTap: () => profileCubit.toggleView(isPersonal),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16.0.sp,
              fontWeight: FontWeight.w600,
              color: isActive
                  ? Colors.green
                  : cubit.isDark
                      ? Colors.white70
                      : Colors.grey,
            ),
          ),
          SizedBox(height: 2),
          Container(
            width: 90,
            height: 2,
            color: isActive ? Colors.green : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _buildContentSection(ProfileCubits profileCubit, Color textColor) {
    return Expanded(
      child: profileCubit.isPersonalInfo
          ? _buildPersonalInfoSection(textColor, profileCubit)
          : _buildMyLeadsSection(textColor),
    );
  }

  Widget _buildPersonalInfoSection(
      Color textColor, ProfileCubits profileCubit) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // ListTile(
          //   leading: Icon(Icons.supervised_user_circle, color: textColor),
          //   title: Text('Name',style: TextStyle(color: textColor)),
          //   trailing: Text(profileCubit.profileModel.data?.name ?? 'User Name',style: TextStyle(color: textColor)),
          // ),
          // ListTile(
          //   leading: Icon(Icons.email, color: textColor),
          //   title: Text('Email',style: TextStyle(color: textColor)),
          //   trailing: Text(profileCubit.profileModel.data?.email ?? 'someone@example.com',style: TextStyle(color: textColor)),
          // ),
          ListTile(
            leading: Icon(Icons.phone, color: textColor),
            title: Text('Mobile', style: TextStyle(color: textColor)),
            trailing: Text(profileCubit.profileModel.data?.mobile ?? 'N/A',
                style: TextStyle(color: textColor)),
          ),
          ListTile(
            leading: Icon(Icons.map, color: textColor),
            title: Text('State', style: TextStyle(color: textColor)),
            trailing: Text(CacheHelper.getData(key: 'state') ?? 'N/A',
                style: TextStyle(color: textColor)),
          ),
          ListTile(
            leading: Icon(Icons.location_city, color: textColor),
            title: Text('District', style: TextStyle(color: textColor)),
            trailing: Text(CacheHelper.getData(key: 'district') ?? 'N/A',
                style: TextStyle(color: textColor)),
          ),
          ListTile(
            leading: Icon(Icons.location_on, color: textColor),
            title: Text('Sub District', style: TextStyle(color: textColor)),
            trailing: Text(CacheHelper.getData(key: 'subDistrict') ?? 'N/A',
                style: TextStyle(color: textColor)),
          ),
          ListTile(
            leading: Icon(Icons.holiday_village, color: textColor),
            title: Text('village', style: TextStyle(color: textColor)),
            trailing: Text(profileCubit.profileModel.data?.village ?? 'N/A',
                style: TextStyle(color: textColor)),
          ),
          ListTile(
            leading: Icon(Icons.pin_drop, color: textColor),
            title: Text('Pincode', style: TextStyle(color: textColor)),
            trailing: Text(CacheHelper.getData(key: 'pincode') ?? 'N/A',
                style: TextStyle(color: textColor)),
          ),
        ],
      ),
    );
  }

  Widget _buildMyLeadsSection(Color textColor) {
    return Center(
      child:
          Text('Your leads data goes here', style: TextStyle(color: textColor)),
    );
  }
}
