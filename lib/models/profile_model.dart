class ProfileModel {
  late bool status;
  late String message;
  UserData? data;
  ProfileModel({this.status = false, this.message = '', this.data});
  ProfileModel.fromJson(Map<String, dynamic> json) {
    status = json['status']?.toString() == 'true';
    message = json['message'];
    data = json['data'] != null ? UserData.fromJson(json['data']) : null;

  }
}

class UserData {
  late String id;
  String? name;
  String? email;
  String? mobile;
  late String image;
  String? pincode;
  String? state;
  String? district;
  String? sub_district;
  String? village;
  String? password;

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? '';
    name = json['name'] ?? '';
    email = json['email'] ?? '';
    mobile = json['mobile'] != null ? json['mobile'] : null;
    image = json['image'] ?? '';
    state = json['state'] != null  ? json['state'] : null;
    district = json['district'] != null  ? json['district'] : null;
    sub_district = json['sub_district'] != null  ? json['sub_district'] : null;
    village = json['village'] != null  ? json['village'] : null;
    pincode = json['pincode'] != null ? json['pincode'] : null;
    password = json['password'] != null ? json['password'] : null;
  }
}
