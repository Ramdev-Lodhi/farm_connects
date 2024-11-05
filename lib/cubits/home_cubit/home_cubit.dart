import 'package:bloc/bloc.dart';
import 'package:farm_connects/models/home_data_model.dart';
import 'package:farm_connects/screen/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../models/login_model.dart';
import '../../models/profile_model.dart';
import '../../screen/BuyScreen/new_tractors_screen.dart';
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
    // Center(child: Text('Home Screen')),
    HomeScreen(),
    NewTractorScreen(),
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


  HomeDataModel? homeDataModel = null;
  void getHomeData() {
    emit(GetHomeDataLoadingSate());

    String token = CacheHelper.getData(key: 'token') ?? '';
    String lang = CacheHelper.getData(key: 'lang') ?? 'en';

    print('Token: $token');
    // print('Request URL: $HOME');

    DioHelper.getData(
      method: HOME,
      token: token,
      lang: lang,
    ).then((response) {
      // print('Home Data Response: ${response.data}');
      homeDataModel = HomeDataModel.fromJson(response.data);
      // print('Home Data Response: ${homeDataModel}');
      emit(GetHomeDataSuccessSate());
    }).catchError((error) {
      print('Error: ${error.response?.statusCode} ${error.response?.data}');
      emit(GetHomeDataErrorSate());
    });
  }
  // ProfileModel? profileModel = null;
  // Future<void> getProfileData() async {
  //   String token = CacheHelper.getData(key: 'token') ?? '';
  //   try {
  //     final response = await DioHelper.getData(
  //       method: 'user/profile',
  //       token: token,
  //     );
  //     print('respense: $response');
  //     profileModel = ProfileModel.fromJson(response.data);
  //   } catch (error) {
  //   }
  // }
  bool isNewTractor = true;
  bool isUsedTractor = false;

  // Add methods to toggle these
  void toggleNewTractor(bool value) {
    isNewTractor = value;
    isUsedTractor = !value;
    emit(HomeInitialState());
  }

  void toggleUsedTractor(bool value) {
    isUsedTractor = value;
    isNewTractor = !value;
    emit(HomeInitialState());
  }
}
