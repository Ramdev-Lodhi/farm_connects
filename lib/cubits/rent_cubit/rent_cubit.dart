import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart' as dio;
import 'package:farm_connects/cubits/rent_cubit/rent_states.dart';
import 'package:farm_connects/layout/home_layout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mime/mime.dart';
import 'package:image_picker/image_picker.dart';
import '../../config/network/local/cache_helper.dart';
import '../../config/network/remote/dio.dart';
import '../../models/rent_model.dart';

class RentCubit extends Cubit<RentStates> {
  RentCubit() : super(RentFormInitial());
  static RentCubit get(context) => BlocProvider.of(context);
  late RentDataModel? rentDataModel = null;
  void GetRentData() {
    emit(RentScreenLoading());
    String token = CacheHelper.getData(key: 'token') ?? '';
    String lang = CacheHelper.getData(key: 'lang') ?? 'en';
    String pincode = CacheHelper.getData(key: 'pincode') ?? '';
    DioHelper.postData(
      method: 'rent/getrentItem',
      token: token,
      data: {
        'address':{
          'pincode': pincode,
        },
      },
    ).then((response) {
      print(response);
      rentDataModel = RentDataModel.fromJson(response.data);
      emit(RentScreenSuccess());
    }).catchError((error) {
      emit(RentScreenError());
    });
  }


  Future<void> InsertRentData(
      String name,
      String email,
      String mobile,
      String state,
      String district,
      String sub_district,
      String village,
      String pincode,
      String service,
      String price,
      XFile _images) async {
    emit(RentFormLoading());
    String token = CacheHelper.getData(key: 'token') ?? '';
    try {
      final mimeType = lookupMimeType(_images.path);

      if (mimeType != null && mimeType.startsWith('image/')) {
        // Create FormData
        String fileName = _images.name.contains('.')
            ? _images.name
            : '${_images.name}.jpg'; // Assuming jpg if not present
        dio.FormData formData = dio.FormData.fromMap({
          'image': await dio.MultipartFile.fromFile(_images.path,
              filename: fileName),
          'address':{
            'state': state,
            'district': district,
            'sub_district': sub_district,
            'village': village,
            'pincode': pincode,
          },
          'serviceType': service,
          'price': price,
          'userInfo': {
            'name': name,
            'email': email,
            'mobile': mobile,
          },
        });
        final response = await DioHelper.dio.post(
          'rent/rentItem',
          data: formData,
          options: dio.Options(
            headers: {
              'Authorization': 'Bearer $token',
              'lang': 'en',
            },
          ),
        );
        if (response.statusCode == 200) {
          emit(RentFormSuccess('Data Added Successfully'));
          Get.offAll(() => HomeLayout());
        } else {
          emit(RentFormError('Failed to insert data, please try again.'));
        }
      }
    } catch (error) {
      emit(RentFormError(error.toString()));
    }
  }


  Future<void> InsertrentContactData(
      String image,
      String servicetype,
      String userId,
      String rentername,
      String name,
      String mobile,
      String location ,
      String budget) async {
    emit(RentFormLoading());
    String token = CacheHelper.getData(key: 'token') ?? '';
    try {
      final response = await DioHelper.putData(
          method: 'contact/rentContact',
          token: token,
          data: {
            "name" : name,
            "mobile": mobile,
            "location":location,
            "budget":budget,
            "renterInfo":{
              "renterID": userId,
              "rent_image": image,
              "rentserviceName": servicetype,
            }
          });

      await DioHelper.postData(
          method: 'notification/send-contact-notification',
          token: token,
          data: {
            "id":userId,
            "title": "New Contact Request for You, ${rentername}",
            "message": "User ${name} has sent a message: \"I'm interested in buy a  ${servicetype}. Please get in touch!\"",
            "image":image,
          });

      if (response.statusCode == 200) {
        emit(RentFormSuccess('Data Added Successfully'));
      } else {
        emit(RentFormError('Failed to insert data, please try again.'));
      }

    } catch (error) {
      emit(RentFormError(error.toString()));
    }
  }
}
