import 'package:farm_connects/layout/home_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dart:async';

import '../screen/rentScreen/rent_form_screen.dart';
import '../screen/sellScreen/sell_Screen.dart';
import '../widgets/sell_rent_dialog.dart';

class AppBarLayout extends StatefulWidget implements PreferredSizeWidget {
  final bool isDark;
  final VoidCallback? onSearchPressed;
  final VoidCallback? onDropdownChanged;

  AppBarLayout({
    required this.isDark,
    this.onSearchPressed,
    this.onDropdownChanged,
  });

  @override
  _AppBarLayoutState createState() => _AppBarLayoutState();

  @override
  Size get preferredSize => Size.fromHeight(56.0);
}

class _AppBarLayoutState extends State<AppBarLayout> {
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
    return PreferredSize(
      preferredSize: Size.fromHeight(40.0),
      child: Material(
        elevation: 5,
        shadowColor: Colors.black.withOpacity(0.2),
        child: AppBar(
          automaticallyImplyLeading: false,
          // backgroundColor: widget.isDark ? Colors.black : Colors.white,
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
              onPressed: widget.onSearchPressed,
              icon: Icon(
                CupertinoIcons.search,
                size: 24.0,
                color: widget.isDark ? Colors.white : Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
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
                        isDark: widget.isDark,
                      );
                    },
                  );
                },
                child: Container(
                  width: 55.w,
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
      ),
    );
  }
}
