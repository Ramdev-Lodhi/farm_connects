import 'package:farm_connects/repository/loginR.dart';
import 'package:farm_connects/config/network/local/cache_helper.dart';
import 'package:farm_connects/screen/authScreen/login_signup.dart';
import 'package:farm_connects/layout/home_layout.dart';
import 'package:get/get.dart';
import 'package:farm_connects/config/network/end_points.dart';
import 'package:farm_connects/config/network/remote/dio.dart';
import 'package:farm_connects/models/login_model.dart';
class LoginC extends GetxController {
  final loginrepository = LoginR();
  late LoginModel loginModel;
  Future<void> Signup(String name, int phone, String address, int pincode,
      String password) async {
    var signupResponse = await loginrepository.signup(name, phone,address,pincode,password);

    if (signupResponse['status'] == '200') {

      Get.offAll(() => LoginSignupScreen());
    }
  }

  Future<void> Signin(String email,
      String password) async {
    print('Login URL: $email');
    print('Login URL: $password');
    // Log the URL before making the request
    String fullUrl = '${DioHelper.dio.options.baseUrl}$LOGIN';
    print('Login URL: $fullUrl');
    DioHelper.postData(
      method: LOGIN,
      data: {
        "email" : email,
        "password" : password,
      },
      lang: 'en',
    ).then((value) {
      print(value);
      loginModel = LoginModel.fromJson(value.data);
        print(loginModel.status);
      if(loginModel.status){
        CacheHelper.saveData(key: 'token', value: loginModel.data?.token);
        CacheHelper.saveData(key: 'image', value: loginModel.data?.image);
        CacheHelper.saveData(key: 'name', value: loginModel.data?.name);
        CacheHelper.saveData(key: 'email', value: loginModel.data?.email);
        Get.offAll(() => HomeLayout());
      }
      // print(loginModel.data?.token);
    }).catchError((error) {
      print('error : ' + error.toString());
    });
  }


}
