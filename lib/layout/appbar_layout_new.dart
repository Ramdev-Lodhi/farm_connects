import 'package:farm_connects/layout/home_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dart:async';

import '../constants/styles/colors.dart';
import '../cubits/home_cubit/home_cubit.dart';
import '../screen/rentScreen/rent_form_screen.dart';
import '../screen/sellScreen/sell_Screen.dart';
import '../widgets/sell_rent_dialog.dart';

class AppBarLayoutNew extends StatefulWidget implements PreferredSizeWidget {
  final bool isDark;
  final VoidCallback? onSearchPressed;
  final VoidCallback? onDropdownChanged;

  AppBarLayoutNew({
    required this.isDark,
    this.onSearchPressed,
    this.onDropdownChanged,
  });

  @override
  _AppBarLayoutNewState createState() => _AppBarLayoutNewState();

  @override
  Size get preferredSize => Size.fromHeight(56.0);
}

class _AppBarLayoutNewState extends State<AppBarLayoutNew> {
  late Timer _timer;
  bool _isSell = true;

  @override
  void initState() {
    super.initState();
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
    var cubit = HomeCubit.get(context);
    return SliverAppBar(
          // automaticallyImplyLeading: false,
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
          title: Transform.translate(
            offset: Offset(-40, 0),
            child: Padding(
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
            // Padding(
            //   padding: const EdgeInsets.only(right: 10),
            //   child: GestureDetector(
            //     onTap: () {
            //       showDialog(
            //         context: context,
            //         builder: (BuildContext context) {
            //           return SellRentDialog(
            //             onSell: () {
            //               Get.to(() => SellScreen());
            //             },
            //             onRent: () {
            //               Get.to(() => RentFormScreen());
            //             },
            //             isDark: false,
            //           );
            //         },
            //       );
            //     },
            //     child: Container(
            //       width: 70.sp,
            //       decoration: BoxDecoration(
            //         border: Border.all(color: Colors.black87, width: 2),
            //         borderRadius: BorderRadius.circular(5.0),
            //       ),
            //       child: Image.asset(
            //         _isSell
            //             ? 'assets/images/rent_sell/sell.png'
            //             : 'assets/images/rent_sell/rent.png',
            //         fit: BoxFit.contain,
            //       ),
            //     ),
            //   ),
            // )
          ],
        );
  }
}
