import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBarLayout extends StatelessWidget implements PreferredSizeWidget {
  final bool isDark;
  final VoidCallback? onSearchPressed;
  final VoidCallback? onDropdownChanged;

  AppBarLayout({
    required this.isDark,
    this.onSearchPressed,
    this.onDropdownChanged,
  });

  @override
  Widget build(BuildContext context) {
    return  PreferredSize(
      preferredSize: Size.fromHeight(40.0),
      child: Material(
        elevation: 5,
        shadowColor: Colors.black.withOpacity(0.2),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: isDark ? Colors.black : Colors.white,
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
                color: isDark ? Colors.white : Colors.black,
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
                dropdownColor: isDark ? Colors.black : Colors.white,
                // Dropdown background color
                items: <String>['Sell', 'Rent'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                        color: isDark
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
                  color: isDark ? Colors.white70 : Colors.black,
                ),
                // Text color for the selected item
                underline: Container(), // Removes the underline
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.0);
}
