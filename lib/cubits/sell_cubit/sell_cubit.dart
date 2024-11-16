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
  SellAllTractorData? sellAllTractorData = null;

  // Fetch profile data
  Future<void> getBrand() async {
    String token = CacheHelper.getData(key: 'token') ?? '';

    try {
      final response = await DioHelper.getData(
        method: 'Sell',
        token: token,
      );

      // Ensure proper assignment to sellDataModel instance
      sellDataModel = SellDataModel.fromJson(response.data);
    } catch (error) {
      // Add error handling
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
      sellDataModel = SellDataModel.fromJson(response.data);
    } catch (error) {
      // Add error handling
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
      String price,
      XFile _images) async {
    emit(SellFormLoading());
    String token = CacheHelper.getData(key: 'token') ?? '';
    try {

      // Create FormData to send the request
      final mimeType = lookupMimeType(_images.path);
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
          'price' : price
        });
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
          // sellDataModel = SellDataModel.fromJson(response.data);
          Get.offAll(()=>HomeLayout());
        } else {
          emit(SellFormError('Failed to insert data, please try again.'));
        }
      }
    } catch (error) {
      emit(SellFormError(error.toString()));
    }
  }
  void getSellData() {
    emit(SellScreenLoading());
    String token = CacheHelper.getData(key: 'token') ?? '';
    String lang = CacheHelper.getData(key: 'lang') ?? 'en';
    DioHelper.getData(
      method: 'sell/getSelltractor',
      token: token,
      lang: lang,
    ).then((response) {
      sellAllTractorData = SellAllTractorData.fromJson(response.data);
      // You might want to log the parsed data or handle it further
      emit(SellScreenSuccess());
    }).catchError((error) {
      emit(SellScreenError());
    });
  }
}