import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../models/login_model.dart';
import '../../screen/settings_screen.dart';
import '../../cubits/home_cubit/home_states.dart';
import '../../config/network/end_points.dart';
import '../../config/network/local/cache_helper.dart';
import '../../config/network/remote/dio.dart';
import '../../config/network/styles/colors.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

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
      icon: Icon(
        FontAwesomeIcons.tractor,
        size: 20.0, // Set icon size for New Tractor
      ),
      label: 'New Tractor',
      activeIcon: Icon(
        FontAwesomeIcons.tractor,
        size: 20.0,
        color: orange, // Change active icon color
      ),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.agriculture_outlined),
      label: 'Used Tractor',
      activeIcon: Icon(
        Icons.agriculture,
        color: orange, // Change active icon color
      ),
    ),
    BottomNavigationBarItem(
      icon: Icon(
        FontAwesomeIcons.retweet,
        size: 20.0,
      ),
      label: 'Rent',
      activeIcon: Icon(
        FontAwesomeIcons.retweet,
        size: 20.0,
        color: orange,
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

  List<Widget> screens = [
    Center(child: Text('Home Screen')),
    Center(child: Text('New Machine Screen')),
    Center(child: Text('Used Machine Screen')),
    Center(child: Text('Rent Screen')),
    SettingsScreen(),
  ];

  int currentIndex = 0;

  void changeNavIndex(int index) {
      currentIndex = index;
      emit(ChangeHomeNavIndexState());
  }

  void resetToHome() {
    currentIndex = 0; // Reset to Home
    emit(ChangeHomeNavIndexState());
  }

  bool isDark = false;

  void changeThemeMode(bool modeState) {
    isDark = modeState;
    emit(ChangeThemeMode());
  }
}
