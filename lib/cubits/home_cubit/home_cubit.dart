import 'package:bloc/bloc.dart';
import 'package:farm_connects/models/home_data_model.dart';
import 'package:farm_connects/screen/home_screen.dart';
import '../../screen/rentScreen/rent_screen.dart';
import '../../screen/sellScreen/used_tractor_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../constants/styles/colors.dart';
import '../../models/login_model.dart';
import '../../models/profile_model.dart';
import '../../screen/BuyScreen/new_tractors_screen.dart';
import '../../screen/account_screen.dart';
import '../../cubits/home_cubit/home_states.dart';
import '../../config/network/end_points.dart';
import '../../config/network/local/cache_helper.dart';
import '../../config/network/remote/dio.dart';


class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  List<BottomNavigationBarItem> navItems = [
    BottomNavigationBarItem(
      icon: Icon(
        FontAwesomeIcons.home,
        size: 20.0,
      ),
      label: 'Home',
      activeIcon: Icon(
        FontAwesomeIcons.home,
        size: 20.0,
        color: orange,
      ),
    ),
    BottomNavigationBarItem(
      icon: Icon(
        FontAwesomeIcons.tractor,
        size: 20.0,
      ),
      label: 'New Tractor',
      activeIcon: Icon(
        FontAwesomeIcons.tractor,
        size: 20.0,
        color: orange,
      ),
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.agriculture_outlined,
        size: 20.0,
      ),
      label: 'Used Tractor',
      activeIcon: Icon(
        Icons.agriculture_outlined,
        size: 20.0,
        color: orange,
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
      icon: Icon(
        FontAwesomeIcons.sliders,
        size: 20.0,
      ),
      label: 'Account',
      activeIcon: Icon(
        FontAwesomeIcons.sliders,
        size: 20.0,
        color: orange,
      ),
    ),
  ];

  List<Widget> screens = [
    // Center(child: Text('Home Screen')),
    HomeScreen(),
    NewTractorScreen(),
    UsedTractorScreen(),
    RentScreen(),
    AccountScreen(),
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


    DioHelper.getData(
      method: HOME,
      token: token,
      lang: lang,
    ).then((response) {
      homeDataModel = HomeDataModel.fromJson(response.data);
      emit(GetHomeDataSuccessSate());
    }).catchError((error) {
      emit(GetHomeDataErrorSate());
    });
  }

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
