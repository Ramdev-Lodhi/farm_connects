class LoginModel
{
  late bool status;
  late String message;
  late UserData? data;

  LoginModel.fromJson(Map<String, dynamic> json)
  {
    status = json['status']?.toString() == 'true';
    message = json['message'];
    data = json['data'] != null ? UserData.fromJson(json['data']) : null;
  }
}

class UserData
{
  late String id;
  late String name;
  late String email;
  late String phone;
  late String image;
  late String token;

  UserData.fromJson(Map<String, dynamic> json)
  {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    image = json['image'];
    token = json['token'];
  }
}