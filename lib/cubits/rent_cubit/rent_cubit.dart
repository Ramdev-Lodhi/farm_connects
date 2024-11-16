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
    print('Token: $token');
    // print('Request URL: $HOME');
    DioHelper.postData(
      method: 'rent/getrentItem',
      token: token,
      data: {
        "pincode":pincode
      },
    ).then((response) {
      print('Parsed SellDataModel: ${response.data}');
      rentDataModel = RentDataModel.fromJson(response.data);
      // You might want to log the parsed data or handle it further
      // print('Home Data Response: ${homeDataModel}');
      emit(RentScreenSuccess());
    }).catchError((error) {
      print('Error: ${error.response?.statusCode} ${error.response?.data}');
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
      print("Images: $_images");
      final mimeType = lookupMimeType(_images.path);
      print('File MIME Type: $mimeType');
      print('Uploading file: ${_images.path}, Filename: ${_images.name}');

      if (mimeType != null && mimeType.startsWith('image/')) {
        // Create FormData
        String fileName = _images.name.contains('.')
            ? _images.name
            : '${_images.name}.jpg'; // Assuming jpg if not present
        dio.FormData formData = dio.FormData.fromMap({
          'image': await dio.MultipartFile.fromFile(_images.path,
              filename: fileName),
          'state': state,
          'district': district,
          'sub_district': sub_district,
          'village': village,
          'pincode': pincode,
          'serviceType': service,
          'price': price,
          'userInfo': {
            'name': name,
            'email': email,
            'mobile': mobile,
          },
        });
        // print('File MIME Type: ${formData.image}');
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
        print(response);
        if (response.statusCode == 200) {
          emit(RentFormSuccess('Data Added Successfully'));
          Get.offAll(() => HomeLayout());
        } else {
          emit(RentFormError('Failed to insert data, please try again.'));
        }
      }
    } catch (error) {
      emit(RentFormError(error.toString()));
      print('Error: $error'); // Optionally log the error for debugging
    }
  }
}