import 'package:farm_connects/repository/loginR.dart';
import 'package:farm_connects/screen/dashboard.dart';
import 'package:farm_connects/screen/login_signup.dart';
import 'package:get/get.dart';

class LoginC extends GetxController {
  final loginrepository = LoginR();

  Future<void> Signup(String name, int phone, String address, int pincode,
      String password) async {
    var signupResponse = await loginrepository.signup(name, phone,address,pincode,password);

    if (signupResponse['status'] == '200') {

      Get.offAll(() => LoginSignupScreen());
    }
  } Future<void> Signin(int phone,
      String password) async {
    var signinResponse = await loginrepository.signin(phone,password);
    if (signinResponse['status'] == '200') {

      Get.offAll(() => DashboardScreen());
    }
  }


}
