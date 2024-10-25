import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../config/network/local/cache_helper.dart';
import '../../config/network/styles/colors.dart';
import '../../cubits/home_cubit/home_states.dart';
import '../../cubits/home_cubit/home_cubit.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
    Color cardColor = cubit.isDark ? Colors.white12 : Colors.white;
    Color textColor = cubit.isDark ? Colors.white : Colors.black;
    Color profileCardColor = cubit.isDark ? Colors.black54 : Colors.white;
    Color logoutColor = cubit.isDark ? asmarFate7 : offWhite;
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(40.0),
            child: Material(
              elevation: 5,
              shadowColor: Colors.black.withOpacity(0.2),
              child: AppBar(
                backgroundColor: cubit.isDark ? Colors.black : Colors.white,
                title: Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Image.asset(
                    'assets/images/logo/FarmConnects_logo.png',
                    height: 100,
                    fit: BoxFit.contain,
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      // Handle search action
                    },
                    icon: Icon(
                      CupertinoIcons.search,
                      size: 24.0,
                      color: cubit.isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  Container(
                    width: 60.0,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      icon: Text(
                        "Sell/Rent",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                      dropdownColor: cubit.isDark ? Colors.black : Colors.white,
                      items: <String>['Sell', 'Rent'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                              color: cubit.isDark ? Colors.white70 : Colors.black,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value == 'Sell') {
                          // Handle sell action
                        } else if (value == 'Rent') {
                          // Handle rent action
                        }
                      },
                      style: TextStyle(
                        color: cubit.isDark ? Colors.white70 : Colors.black,
                      ),
                      underline: Container(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Container(
            color: cubit.isDark ? Colors.black : Colors.white,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  child: Card(
                    color: profileCardColor,
                    elevation: 1,
                    child: Container(
                      height: 150,
                      child: Row(

                        children: [
                          CircleAvatar(
                            radius: 45.0,
                            backgroundColor: Colors.transparent,
                            child: ClipRRect(
                              clipBehavior: Clip.hardEdge,
                              borderRadius: BorderRadius.circular(45.0),
                              child: CacheHelper.getData(key: 'image') !=
                                  null
                                  ? Image.network(
                                '${CacheHelper.getData(key: 'image')}',
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) {
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                CacheHelper.getData(key: 'name') ?? 'User Name',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                  color: cubit.isDark ? Colors.white : Colors.grey,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                CacheHelper.getData(key: 'email') ?? 'someone@example.com',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: cubit.isDark ? Colors.white : Colors.black,
                                  fontSize: 12.0,
                                ),
                              ),
                            ],
                          ),

                          Spacer(),
                          TextButton(
                            onPressed: () {
                              // Handle edit action
                              // Get.to(() => EditProfileScreen()); // Navigate to edit screen
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min, // Ensures the button doesn't take too much space
                              children: [
                                Icon(
                                  Icons.edit, // Edit icon
                                  color: cubit.isDark ? Colors.white : Colors.black,
                                ),
                                SizedBox(width: 5), // Space between icon and text
                                Text(
                                  'Edit',
                                  style: TextStyle(
                                    color: cubit.isDark ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
}