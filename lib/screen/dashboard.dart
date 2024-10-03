import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  final Color orange = Color(0xFFFFA500); // Define the orange color

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> navItems = [
      BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        label: 'Home',
        activeIcon: Icon(
          Icons.home,
          color: Colors.orange, // Change active icon color
        ),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.category_outlined),
        label: 'Category',
        activeIcon: Icon(
          Icons.category,
          color: Colors.orange, // Change active icon color
        ),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.favorite_outline),
        label: 'Favorites',
        activeIcon: Icon(
          Icons.favorite,
          color: Colors.orange, // Change active icon color
        ),
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.settings_outlined),
        label: 'Settings',
        activeIcon: Icon(
          Icons.settings,
          color: Colors.orange, // Change active icon color
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Farm Connects"),
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
      body: Container(
        height: MediaQuery.of(context).size.height, // Adjusted for responsiveness
        width: MediaQuery.of(context).size.width, // Adjusted for responsiveness
        color: Colors.blue,
        child: Center(child: Text('Dashboard Content')), // Placeholder for dashboard content
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10.0),
          topLeft: Radius.circular(10.0),
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 12.8,
          child: BottomNavigationBar(
            onTap: (index) {
              // Ensure cubit is defined in your context
              // Replace 'cubit' with the actual instance of your cubit
              // cubit.changeNavIndex(index);
            },
            unselectedFontSize: 11.0,
            selectedFontSize: 12.0,
            // currentIndex: cubit.currentIndex, // Ensure cubit is defined in your context
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
