import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../cubits/home_cubit/home_states.dart';
import '../../cubits/home_cubit/home_cubit.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(40.0),
            child: Material(
              elevation: 5,
              shadowColor: Colors.black.withOpacity(0.2),
              child: AppBar(
                backgroundColor: cubit.isDark ? Colors.black : Colors.white,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 30.0), // Adjust the left margin here
                      child: Image.asset(
                        'assets/images/logo/FarmConnects_logo.png',
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
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
                      ), // Optional: icon color
                      dropdownColor: cubit.isDark ? Colors.black : Colors.white, // Dropdown background color
                      items: <String>['Sell', 'Rent'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                              color: cubit.isDark ? Colors.white70 : Colors.black, // Text color
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        // Handle selection
                        if (value == 'Sell') {
                          // Handle sell action
                        } else if (value == 'Rent') {
                          // Handle rent action
                        }
                      },
                      style: TextStyle(
                        color: cubit.isDark ? Colors.white70 : Colors.black,
                      ), // Text color for the selected item
                      underline: Container(), // Removes the underline
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Container(
            color: cubit.isDark ? Colors.black : Colors.white, // Background color based on theme
            // child: cubit.screens[cubit.currentIndex],
          ),
        );
      },
    );
  }
}
