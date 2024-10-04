import 'package:farm_connects/screen/settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeLayout extends StatefulWidget {
  @override
  _HomeLayoutState createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex = 0; // To keep track of the current index
  final Color orange = Color(0xFFFFA500); // Define the orange color

  final List<Widget> screens = [
    Center(child: Text('Home Screen')), // Placeholder for Home screen
    Center(child: Text('Category Screen')), // Placeholder for Category screen
    Center(child: Text('Favorites Screen')), // Placeholder for Favorites screen
    SettingsScreen(), // Settings screen
  ];

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> navItems = [
      BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        label: 'Home',
        activeIcon: Icon(
          Icons.home,
          color: orange, // Change active icon color
        ),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.category_outlined),
        label: 'Category',
        activeIcon: Icon(
          Icons.category,
          color: orange, // Change active icon color
        ),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.favorite_outline),
        label: 'Favorites',
        activeIcon: Icon(
          Icons.favorite,
          color: orange, // Change active icon color
        ),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.settings_outlined),
        label: 'Settings',
        activeIcon: Icon(
          Icons.settings,
          color: orange, // Change active icon color
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Image.asset(
                'assets/images/logo1.png',
                height: 50, // Adjust the height
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
      body: screens[currentIndex], // Display the selected screen
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10.0),
          topLeft: Radius.circular(10.0),
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 12.8,
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              setState(() {
                currentIndex = index; // Update the current index
              });
            },
            unselectedFontSize: 11.0,
            selectedFontSize: 12.0,
            items: navItems,
            iconSize: MediaQuery.of(context).size.height / 30.0,
            unselectedItemColor: Colors.black,
            backgroundColor: Colors.blue,
          ),
        ),
      ),
    );
  }
}
