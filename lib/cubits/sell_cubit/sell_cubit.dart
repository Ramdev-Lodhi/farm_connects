import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart' as dio;
import 'package:farm_connects/layout/home_layout.dart';
import 'package:farm_connects/screen/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:mime/mime.dart';
import '../sell_cubit/sell_States.dart';
import 'package:image_picker/image_picker.dart';
import '../../config/network/end_points.dart';
import '../../config/network/local/cache_helper.dart';
import '../../config/network/remote/dio.dart';
import '../../models/sell_model.dart';
import '../../screen/sellScreen/multi_step_sell_screen.dart';
import 'package:flutter/material.dart';

class SellCubit extends Cubit<SellFormState> {
  SellCubit() : super(SellFormInitial());

  static SellCubit get(context) => BlocProvider.of(context);

  SellDataModel? sellDataModel = null;

  // Fetch profile data
  Future<void> getBrand() async {
    String token = CacheHelper.getData(key: 'token') ?? '';

    try {
      final response = await DioHelper.getData(
        method: 'Sell',
        token: token,
      );
      print('response: $response');

      // Ensure proper assignment to sellDataModel instance
      sellDataModel = SellDataModel.fromJson(response.data);
    } catch (error) {
      // Add error handling
      print('Error fetching brand data: $error');
      emit(SellFormError('Failed to load brand data'));
    }
  }

  Future<void> getModel(String selectedBrand) async {
    String token = CacheHelper.getData(key: 'token') ?? '';
    try {
      final response =
          await DioHelper.postData(method: Sell_Model, token: token, data: {
        'name': selectedBrand,
      });
      print('response: $response');
      sellDataModel = SellDataModel.fromJson(response.data);
      print('model: ${sellDataModel?.data.models}');
    } catch (error) {
      // Add error handling
      print('Error fetching model data: $error');
      emit(SellFormError('Failed to load Model data'));
    }
  }

  Future<void> InsertSellData(
      String year,
      String brand,
      String driven,
      String hp,
      String model,
      String tyre,
      String engin,
      String state,
      String city,
      RC,
      String name,
      String mobile,
      XFile _images) async {
    emit(SellFormLoading());
    String token = CacheHelper.getData(key: 'token') ?? '';
    try {
      print("Images: $_images");

      // Create FormData to send the request
      final mimeType = lookupMimeType(_images.path);
      print('File MIME Type: $mimeType');
      print('Uploading file: ${_images.path}, Filename: ${_images.name}');
      // Validate MIME type
      if (mimeType != null && mimeType.startsWith('image/')) {
        // Create FormData
        String fileName = _images.name.contains('.')
            ? _images.name
            : '${_images.name}.jpg'; // Assuming jpg if not present
        dio.FormData formData = dio.FormData.fromMap({
          'image': await dio.MultipartFile.fromFile(_images.path,
              filename: fileName),
          'location': city,
          'state': state,
          'name': name,
          'mobile': mobile,
          'brand': brand,
          'modelName': model,
          'manufacturingYear': year,
          'engineCondition': engin,
          'enginePower': hp,
          'RC': RC,
          'tyreCondition': tyre,
          'hoursDriven': driven,
        });
      // print('File MIME Type: ${formData.image}');
        final response = await DioHelper.dio.post(
          'sell/selltractor',
          data: formData,
          options: dio.Options(
            headers: {
              'Authorization': 'Bearer $token',
              'lang': 'en',
            },
          ),
        );

        if (response.statusCode == 200) {
          emit(SellFormSuccess('Data Added Successfully'));
          Get.offAll(()=>HomeLayout());
        } else {
          emit(SellFormError('Failed to insert data, please try again.'));
        }
      }
    } catch (error) {
      emit(SellFormError(error.toString()));
      print('Error: $error'); // Optionally log the error for debugging
    }
  }
}
