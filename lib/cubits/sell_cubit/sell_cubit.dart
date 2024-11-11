// sell_cubit.dart
import 'package:bloc/bloc.dart';
import '../sell_cubit/sell_States.dart';
import 'package:image_picker/image_picker.dart';
import '../../config/network/end_points.dart';
import '../../config/network/local/cache_helper.dart';
import '../../config/network/remote/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
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




}
