import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart' as dio;
import 'package:farm_connects/cubits/mylead_cubit/mylead_state.dart';
import 'package:farm_connects/layout/home_layout.dart';
import 'package:farm_connects/screen/home_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../config/network/end_points.dart';
import '../../config/network/local/cache_helper.dart';
import '../../config/network/remote/dio.dart';
import '../../models/myleads_model.dart';
import '../../models/rent_model.dart';

class MyleadCubits extends Cubit<MyleadState> {
  MyleadCubits() : super(MyleadInitial());

  static MyleadCubits get(context) => BlocProvider.of(context);
  sellEnquiryData? sellEnquirydata = null;
  RentEnquiryData? rentEnquiryData = null;
  BuyEnquiryData? buyEnquiryData= null;
  Future<void> InsertContactData(
      String image,
      String modelname,
      String brand,
      String sellerId,
      String sellerName,
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

      await DioHelper.postData(
          method: CONTACT_NOTIFICATION,
          token: token,
          data: {
            "id":sellerId,
            "title": "New Contact Request for You, ${sellerName}",
            "message": "User ${name} has sent a message: \"I'm interested in buy a ${brand} ${modelname}. Please get in touch!\"",
            "image":image,
          });

        if (response.statusCode == 200) {
          emit(MyleadSuccess('Data Added Successfully'));
          // sellDataModel = SellDataModel.fromJson(response.data);
          // Get.offAll(()=>HomeLayout());
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
      // print('sellenquerydata : ${response.data}');
      sellEnquirydata = sellEnquiryData.fromJson(response.data);
      // print('sellEnquirydata: ${sellEnquirydata?.data.Sellenquiry.length}');

      emit(MyleadSuccess("Data Getted Successfully"));
    }).catchError((error) {
      emit(MyleadError(error));
    });
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
    emit(MyleadLoading());
    String token = CacheHelper.getData(key: 'token') ?? '';
    try {
      final response = await DioHelper.postData(
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
        emit(MyleadSuccess('Data Added Successfully'));
        // sellDataModel = SellDataModel.fromJson(response.data);
        // Get.offAll(()=>HomeLayout());
      } else {
        emit(MyleadError('Failed to insert data, please try again.'));
      }

    } catch (error) {
      emit(MyleadError(error.toString()));
    }
  }

  void getRentenquiry() {
    emit(MyleadLoading());
    String token = CacheHelper.getData(key: 'token') ?? '';
    String lang = CacheHelper.getData(key: 'lang') ?? 'en';
    DioHelper.getData(
      method: 'contact/getrentContact',
      token: token,
      lang: lang,
    ).then((response) {
      print(response);
      rentEnquiryData = RentEnquiryData.fromJson(response.data);
      emit(MyleadSuccess("Data Getted Successfully"));
    }).catchError((error) {
      emit(MyleadError(error));
    });
  }

  Future<void> InsertbuyContactData(
      String image,
      String brand,
      String modelname,
      String name,
      String mobile,
      String location ,
      String budget) async {
    emit(MyleadLoading());
    String token = CacheHelper.getData(key: 'token') ?? '';
    try {
      final response = await DioHelper.postData(
          method: 'contact/buyContact',
          token: token,
          data: {
            "name" : name,
            "mobile": mobile,
            "location":location,
            "budget":budget,
            "dealerInfo":{
              "image": image,
              "modelName": modelname,
              "Brand": brand,
            }
          });

      // await DioHelper.postData(
      //     method: 'notification/send-contact-notification',
      //     token: token,
      //     data: {
      //       "id":userId,
      //       "title": "New Contact Request for You, ${rentername}",
      //       "message": "User ${name} has sent a message: \"I'm interested in buy a  ${servicetype}. Please get in touch!\"",
      //       "image":image,
      //     });

      if (response.statusCode == 200) {
        emit(MyleadSuccess('Data Added Successfully'));
        // sellDataModel = SellDataModel.fromJson(response.data);
        // Get.offAll(()=>HomeLayout());
      } else {
        emit(MyleadError('Failed to insert data, please try again.'));
      }

    } catch (error) {
      emit(MyleadError(error.toString()));
    }
  }

  void getBuyenquiry() {
    emit(MyleadLoading());
    String token = CacheHelper.getData(key: 'token') ?? '';
    String lang = CacheHelper.getData(key: 'lang') ?? 'en';
    DioHelper.getData(
      method: 'contact/getbuyContact',
      token: token,
      lang: lang,
    ).then((response) {
      buyEnquiryData = BuyEnquiryData.fromJson(response.data);

      emit(MyleadSuccess("Data Getted Successfully"));
    }).catchError((error) {
      emit(MyleadError(error));
    });
  }
  late RentDataModel? rentDataModel = null;
  void getrentItemByUserId() {
    emit(MyleadLoading());
    String token = CacheHelper.getData(key: 'token') ?? '';
    print(token);
    String lang = CacheHelper.getData(key: 'lang') ?? 'en';
    DioHelper.getData(
      method: 'rent/getrentItemByUserId',
      token: token,
      lang: lang,
    ).then((response) {
      // print(response);
      rentDataModel = RentDataModel.fromJson(response.data);
      emit(MyleadSuccess("Data Getted Successfully"));
    }).catchError((error) {
      emit(MyleadError(error));
    });
  }
}
