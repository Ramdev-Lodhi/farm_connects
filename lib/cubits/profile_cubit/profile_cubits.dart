import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:farm_connects/cubits/profile_cubit/profile_states.dart';
import 'package:farm_connects/layout/home_layout.dart';
import 'package:farm_connects/screen/profileScreen/profile_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import '../../config/network/local/cache_helper.dart';
import '../../config/network/remote/dio.dart';
import '../../models/profile_model.dart';
import 'package:dio/dio.dart' as dio;

class ProfileCubits extends Cubit<ProfileState> {
  ProfileCubits() : super(ProfileInitialState());

  static ProfileCubits get(context) => BlocProvider.of(context);

  late ProfileModel profileModel = ProfileModel();

  Future<void> getProfileData() async {
    emit(GetProfileDataLoadingSate());

    String token = CacheHelper.getData(key: 'token') ?? '';

    try {
      final response = await DioHelper.getData(
        method: 'user/profile',
        token: token,
      );
      profileModel = ProfileModel.fromJson(response.data);
      emit(ProfileSuccessState());
    } catch (error) {
      emit(ProfileErrorState());
    }
  }

  Future<void> changePassword(
      String password) async {
    emit(ProfileUpdateLoading());
    String token = CacheHelper.getData(key: 'token') ?? '';
    try {
      print('password changepass: $password');
      final response = await DioHelper.putData(
          method: 'user/change_password',
          token: token,
          data: {
            "password": password,
          });
      profileModel = ProfileModel.fromJson(response.data);
      if (profileModel.status) {
        emit(ProfileUpdateSuccess(' Password Changed Successfully'));
        Get.offAll(() => HomeLayout());
      } else {
        emit(ProfileUpdateError('Failed to Password Change Account'));
      }
    } catch (error) {
      emit(ProfileUpdateError(error.toString()));
    }
  }


  Future<void> updateProfile(
      String name,
      String email,
      String mobile,
      String state,
      String district,
      String sub_district,
      String village,
      String pincode) async {
    emit(ProfileUpdateLoading());
    String token = CacheHelper.getData(key: 'token') ?? '';
    try {
      // print('Name: $name, Email: $email, Mobile: $mobile');
      // print('State: $state, District: $district, Sub-District: $sub_district, Village: $village, Pincode: $pincode');
      final response = await DioHelper.putData(
          method: 'user/update_profile',
          token: token,
          data: {
            "name": name,
            "email": email,
            "mobile": mobile,
            "state": state,
            "district": district,
            "sub_district": sub_district,
            "village": village,
            "pincode": pincode,
          });
      // print('API Response: ${response.data}');
      profileModel = ProfileModel.fromJson(response.data);
      // print('profileModel : ${profileModel.status}');

      if (profileModel.status) {
        CacheHelper.saveData(
            key: 'image', value: profileModel.data?.image ?? "");
        CacheHelper.saveData(key: 'name', value: profileModel.data?.name ?? "");
        CacheHelper.saveData(
            key: 'email', value: profileModel.data?.email ?? "");
        emit(ProfileUpdateSuccess('Profile Update Successfully'));
        Get.offAll(() => ProfileScreen());
      } else {
        emit(ProfileUpdateError('Failed to update profile'));
      }
    } catch (error) {
      emit(ProfileUpdateError(error.toString()));
    }
  }

  Future<void> updateInformation(
      String name,
      String email,
      String mobile,
      String state,
      String district,
      String sub_district,
      String village,
      String pincode,
      String password
      ) async {
    emit(ProfileUpdateLoading());
    String token = CacheHelper.getData(key: 'token') ?? '';
    try {
      // print('Name: $name, Email: $email, Mobile: $mobile');
      // print('State: $state, District: $district, Sub-District: $sub_district, Village: $village, Pincode: $pincode');
      final response = await DioHelper.putData(
          method: 'user/update_profile',
          token: token,
          data: {
            "name": name,
            "email": email,
            "mobile": mobile,
            "state": state,
            "district": district,
            "sub_district": sub_district,
            "village": village,
            "pincode": pincode,
            "password":password,
          });
      // print('API Response: ${response.data}');
      profileModel = ProfileModel.fromJson(response.data);
      // print('profileModel : ${profileModel.status}');

      if (profileModel.status) {
        CacheHelper.saveData(
            key: 'image', value: profileModel.data?.image ?? null);
        CacheHelper.saveData(key: 'name', value: profileModel.data?.name ?? null);
        CacheHelper.saveData(
            key: 'email', value: profileModel.data?.email ?? null);
        emit(ProfileUpdateSuccess('Profile Update Successfully'));
        Get.offAll(() => ProfileScreen());
      } else {
        emit(ProfileUpdateError('Failed to update profile'));
      }
    } catch (error) {
      emit(ProfileUpdateError(error.toString()));
    }
  }

  bool isPersonalInfo = true;

  void toggleView(bool isPersonal) {
    isPersonalInfo = isPersonal;
    emit(ProfileInitialState());
  }

  Future<void> updateProfileImage(XFile? image) async {
    if (image != null) {
      emit(ProfileImageLaodingState());
      String token = CacheHelper.getData(key: 'token') ?? '';
      print('Image selected: ${image.path}');

      // Check the MIME type
      final mimeType = lookupMimeType(image.path);
      print('File MIME Type: $mimeType');
      print('Uploading file: ${image.path}, Filename: ${image.name}');
      // Validate MIME type
      if (mimeType != null && mimeType.startsWith('image/')) {
        // Create FormData
        String fileName = image.name.contains('.')
            ? image.name
            : '${image.name}.jpg'; // Assuming jpg if not present
        dio.FormData formData = dio.FormData.fromMap({
          'image':
              await dio.MultipartFile.fromFile(image.path, filename: fileName),
        });

        try {
          final response = await DioHelper.dio.put(
            'user/image',
            data: formData,
            options: dio.Options(
              headers: {
                'Authorization': 'Bearer $token',
                'lang': 'en',
              },
            ),
          );

          print('response: ${response.data}');
          profileModel = ProfileModel.fromJson(response.data);
          if (profileModel.status) {
            CacheHelper.saveData(
                key: 'image', value: profileModel.data?.image ?? "");
            emit(ProfileImageUpdatedState());
          }
        } catch (e) {
          print('Error uploading image: $e');
        }
      } else {
        print('Error: Invalid image type.');
        // Handle invalid image type (e.g., show a message to the user)
      }
    }
  }

  List<String> stateNames = [];

  Future<void> loadStates() async {
    emit(ProfileUpdateLoading()); // Optional loading state
    try {
      String jsonString = await rootBundle.loadString('assets/state.json');
      final List<dynamic> statesJson = json.decode(jsonString)['states'];
      // Populate state names
      stateNames = List<String>.from(
          statesJson.map((state) => state['name']['en'] as String));
      // print('StateName:$stateNames');
      emit(ProfileUpdateLoading());
    } catch (error) {
      emit(ProfileUpdateLoading());
      // print(error.toString());
    }
  }

  Future<List<District>> loadDistricts(String selectedState) async {
    String jsonString =
        await rootBundle.loadString('assets/states/$selectedState.json');
    final List<dynamic> districtJson = json.decode(jsonString)['districts'];
    return districtJson.map((district) => District.fromJson(district)).toList();
  }
}

class District {
  final String district;
  final List<SubDistrict> subDistricts;

  District({required this.district, required this.subDistricts});

  factory District.fromJson(Map<String, dynamic> json) {
    var subDistrictList = json['subDistricts'] as List;
    List<SubDistrict> subDistricts =
        subDistrictList.map((i) => SubDistrict.fromJson(i)).toList();
    return District(district: json['district'], subDistricts: subDistricts);
  }
}

class SubDistrict {
  final String subDistrict;
  final List<String> villages;

  SubDistrict({required this.subDistrict, required this.villages});

  factory SubDistrict.fromJson(Map<String, dynamic> json) {
    return SubDistrict(
      subDistrict: json['subDistrict'],
      villages: List<String>.from(json['villages']),
    );
  }
}
