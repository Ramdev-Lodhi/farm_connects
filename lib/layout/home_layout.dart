import 'package:farm_connects/cubits/home_cubit/home_states.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../cubits/home_cubit/home_cubit.dart';

class HomeLayout extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = HomeCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Image.asset(
                    'assets/images/logo/FarmConnects_logo.png',
                    height: 100, // Adjust the height
                    fit: BoxFit.contain, // Ensure the image scales properly
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
                ),
              ),
            ],

          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: Material(
            elevation: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.only(topRight: Radius.circular(10.0), topLeft: Radius.circular(10.0),),
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 12.8,
                child: BottomNavigationBar(
                  onTap: (index){
                    cubit.changeNavIndex(index);

                  },
                  unselectedFontSize: 11.0.sp,
                  selectedFontSize: 12.0.sp,
                  currentIndex: cubit.currentIndex,
                  items: cubit.navItems,
                  unselectedItemColor: Colors.black,
                  selectedItemColor: Colors.black, // Selected label color
                  // backgroundColor: Colors.blue,

                  iconSize: MediaQuery.of(context).size.height / 30.0,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
