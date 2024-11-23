import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart' as dio;
import 'package:farm_connects/cubits/mylead_cubit/mylead_state.dart';
import 'package:farm_connects/layout/home_layout.dart';
import 'package:farm_connects/screen/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../config/network/local/cache_helper.dart';
import '../../config/network/remote/dio.dart';
import '../../models/myleads_model.dart';

class MyleadCubits extends Cubit<MyleadState> {
  MyleadCubits() : super(MyleadInitial());

  static MyleadCubits get(context) => BlocProvider.of(context);
  sellEnquiryData? sellEnquirydata = null;
  Future<void> InsertContactData(
      String image,
      String modelname,
      String brand,
      String sellerId,
      String name,
      String mobile,
      String location ,
      String budget) async {
    emit(MyleadLoading());
    String token = CacheHelper.getData(key: 'token') ?? '';
    try {
      final response = await DioHelper.postData(
          method: 'contact/sellContact',
          token: token,
          data: {
            "name" : name,
            "mobile": mobile,
            "location":location,
            "budget":budget,
            "sellerInfo":{
              "sellerID": sellerId,
              "sell_image": image,
              "sellmodelName": modelname,
              "sellBrand": brand
            }
          });

        if (response.statusCode == 200) {
          emit(MyleadSuccess('Data Added Successfully'));
          // sellDataModel = SellDataModel.fromJson(response.data);
          Get.offAll(()=>HomeLayout());
        } else {
          emit(MyleadError('Failed to insert data, please try again.'));
        }

    } catch (error) {
      emit(MyleadError(error.toString()));
    }
  }


  void getSellenquiry() {
    emit(MyleadLoading());
    String token = CacheHelper.getData(key: 'token') ?? '';
    String lang = CacheHelper.getData(key: 'lang') ?? 'en';
    DioHelper.getData(
      method: 'contact/getsellContact',
      token: token,
      lang: lang,
    ).then((response) {
      print('sellenquerydata : ${response.data}');
      sellEnquirydata = sellEnquiryData.fromJson(response.data);
      // print('sellEnquirydata: ${sellEnquirydata?.data.Sellenquiry}');

      emit(MyleadSuccess("Data Getted Successfully"));
    }).catchError((error) {
      emit(MyleadError(error));
    });
  }
}
