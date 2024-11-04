import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../cubits/home_cubit/home_states.dart';
import '../cubits/home_cubit/home_cubit.dart';
import '../widgets/loadingIndicator.dart';

class HomeLayout extends StatelessWidget {
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
                    Flexible(
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
                      ),
                      // Optional: icon color
                      dropdownColor: cubit.isDark ? Colors.black : Colors.white,
                      // Dropdown background color
                      items: <String>['Sell', 'Rent'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                              color: cubit.isDark
                                  ? Colors.white70
                                  : Colors.black, // Text color
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
                      ),
                      // Text color for the selected item
                      underline: Container(), // Removes the underline
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: CustomRefreshIndicator(
            onRefresh: () async {
              await cubit
                ..getHomeData();
            },
            child: Container(
              color: cubit.isDark ? Colors.black : Colors.white,
              // Background color based on theme
              child: cubit.screens[cubit.currentIndex],
            ),
          ),

          bottomNavigationBar: Material(
            elevation: 50,
            color: cubit.isDark ? Colors.black : Colors.white,
            // Bottom nav bar color
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
        if (scrollInfo.metrics.pixels < -100 && !_isRefreshing) { // 100 is the threshold
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
              child:LoadingIndicator(size: 60),
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