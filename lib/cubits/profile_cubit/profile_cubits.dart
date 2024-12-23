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
// print(response);
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
      profileModel = ProfileModel.fromJson(response.data);

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
      profileModel = ProfileModel.fromJson(response.data);

      if (profileModel.status) {
        CacheHelper.saveData(
            key: 'image', value: profileModel.data?.image ?? null);
        CacheHelper.saveData(key: 'name', value: profileModel.data?.name ?? null);
        CacheHelper.saveData(
            key: 'email', value: profileModel.data?.email ?? null);
        emit(ProfileUpdateSuccess('Profile Update Successfully'));
        Get.offAll(() => HomeLayout());
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


      final mimeType = lookupMimeType(image.path);
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

          profileModel = ProfileModel.fromJson(response.data);
          if (profileModel.status) {
            CacheHelper.saveData(
                key: 'image', value: profileModel.data?.image ?? "");
            emit(ProfileImageUpdatedState());
          }
        } catch (e) {
        }
      } else {
        // Handle invalid image type (e.g., show a message to the user)
      }
    }
  }

}


