import 'package:farm_connects/cubits/auth_cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import '../Data/OTPService.dart';
import 'package:provider/provider.dart';

class OTPProvider with ChangeNotifier {
  AuthCubits _otpService = AuthCubits();
  String _phoneNumber = '';
  String _otpCode = '';
  String _dialCode = '';
  String _hash_Code = '';
  bool _isVerified = false;

  String get phoneNumber => _phoneNumber;
  String get otpCode => _otpCode;
  String get dialCode => _dialCode;
  String get hash_Code => _hash_Code;
  bool get isVerified => _isVerified;

  void setPhoneNumber(String value) {
    _phoneNumber = value;
    notifyListeners();
  }

  void setOTPCode(String value) {
    _otpCode = value;
    notifyListeners();
  }

  void setDialCode(String value) {
    _dialCode = value;
    notifyListeners();
  }

  Future<void> sendOTP() async {
    try {
      await _otpService.sendOTP('+'+_dialCode + _phoneNumber);
      notifyListeners();
    } catch (error) {
      print(error.toString());
    }
  }


}
