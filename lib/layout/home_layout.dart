import 'dart:async';
import 'package:farm_connects/cubits/profile_cubit/profile_cubits.dart';
import 'package:farm_connects/screen/rentScreen/rent_form_screen.dart';
import 'package:farm_connects/screen/sellScreen/sell_Screen.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/location/location_permission.dart';
import '../constants/styles/colors.dart';
import '../cubits/home_cubit/home_states.dart';
import '../cubits/home_cubit/home_cubit.dart';
import '../cubits/rent_cubit/rent_cubit.dart';
import '../cubits/sell_cubit/sell_cubit.dart';
import '../widgets/loadingIndicator.dart';
import '../widgets/sell_rent_dialog.dart';

class HomeLayout extends StatefulWidget {
  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  late Timer _timer;
  bool _isSell = true;

  @override
  void initState() {
    super.initState();
    ProfileCubits.get(context)..getProfileData();
    RentCubit.get(context)..GetRentData();
    SellCubit.get(context)..getSellData();
    _startButtonTextChange();
  }

  void _startButtonTextChange() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        _isSell = !_isSell;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        LocationHelper.fetchLocationDetails();
        var cubit = HomeCubit.get(context);
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 40.0,
                floating: true,
                pinned: true,
                // backgroundColor: Colors.white,
                elevation: 0,
                // shadowColor: Colors.black.withOpacity(0.5),
                // flexibleSpace: FlexibleSpaceBar(
                flexibleSpace: Container(
                  decoration: BoxDecoration(
                    color: cubit.isDark ? asmarFate7 : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: asmarFate7.withOpacity(0.2),
                        offset: Offset(0, 2),
                        blurRadius: 5,
                      ),
                    ],
                  ),
                ),
                title: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/logo/FarmConnects_logo.png',
                        height: 110,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),

                actions: [
                  IconButton(
                    onPressed: () {
                      // Handle search action
                    },
                    icon: Icon(
                      CupertinoIcons.search,
                      size: 20.0,
                      color: cubit.isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SellRentDialog(
                              onSell: () {
                                Get.to(() => SellScreen());
                              },
                              onRent: () {
                                Get.to(() => RentFormScreen());
                              },
                              isDark: false,
                            );
                          },
                        );
                      },
                      child: Container(
                        width: 70.sp,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black87, width: 2),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Image.asset(
                          _isSell
                              ? 'assets/images/rent_sell/sell.png'
                              : 'assets/images/rent_sell/rent.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SliverFillRemaining(
                child: CustomRefreshIndicator(
                  onRefresh: () async {
                    if (cubit.currentIndex == 0 || cubit.currentIndex == 1) {
                      await cubit
                        ..getHomeData();
                    } else if (cubit.currentIndex == 2) {
                      await SellCubit.get(context)
                        ..getSellData();
                    } else if (cubit.currentIndex == 3) {
                      await RentCubit.get(context)
                        ..GetRentData();
                    } else {
                      await ProfileCubits.get(context)
                        ..getProfileData();
                    }
                  },
                  child: Container(
                    color: cubit.isDark ? Colors.black : Colors.white,
                    child: cubit.screens[cubit.currentIndex],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: Material(
            elevation: 50,
            color: cubit.isDark ? Colors.black : Colors.white,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10.0),
                topLeft: Radius.circular(10.0),
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 12.8,
                child: BottomNavigationBar(
                  onTap: (index) {
                    cubit.changeNavIndex(index);
                  },
                  unselectedFontSize: 11.0.sp,
                  selectedFontSize: 12.0.sp,
                  currentIndex: cubit.currentIndex,
                  items: cubit.navItems,
                  unselectedItemColor:
                  cubit.isDark ? Colors.white70 : Colors.black,
                  selectedItemColor: cubit.isDark ? Colors.white : Colors.black,
                  type: BottomNavigationBarType.fixed,
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

class CustomRefreshIndicator extends StatefulWidget {
  final Future<void> Function() onRefresh;
  final Widget child;

  const CustomRefreshIndicator({
    Key? key,
    required this.onRefresh,
    required this.child,
  }) : super(key: key);

  @override
  _CustomRefreshIndicatorState createState() => _CustomRefreshIndicatorState();
}

class _CustomRefreshIndicatorState extends State<CustomRefreshIndicator> {
  bool _isRefreshing = false;
  bool _isPulling = false; // Track if the user is pulling down

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        // Check if the user is pulling down
        if (scrollInfo.metrics.pixels < 0 && !_isRefreshing) {
          setState(() {
            _isPulling = true;
          });
        } else if (scrollInfo.metrics.pixels >= 0 && _isPulling) {
          setState(() {
            _isPulling = false;
          });
        }

        // Trigger refresh when user releases the pull
        if (scrollInfo.metrics.pixels < -100 && !_isRefreshing) {
          // 100 is the threshold
          _startRefreshing();
          return true; // Prevent other notifications
        }
        return false; // Pass notifications on
      },
      child: Stack(
        children: [
          widget.child,
          if (_isRefreshing || _isPulling)
            Positioned(
              top: 0,
              left: MediaQuery.of(context).size.width / 2 - 30,
              child: LoadingIndicator(size: 60),
            ),
        ],
      ),
    );
  }

  void _startRefreshing() async {
    setState(() {
      _isRefreshing = true;
    });
    await widget.onRefresh();
    setState(() {
      _isRefreshing = false;
    });
  }
}