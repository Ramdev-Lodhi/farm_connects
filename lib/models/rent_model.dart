class RentDataModel {
  late bool status;
  late DataModel data;

  RentDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = DataModel.fromJson(json['data']);
  }
}

class DataModel {
  List<RentData> rentData = [];

  DataModel.fromJson(Map<String, dynamic> json) {
    if (json['RentData'] != null) {
      json['RentData'].forEach((element) {
        rentData.add(RentData.fromJson(element));
      });
    }
  }
}

class RentData {
  List<RentServiceRequest> rentServiceRequest = [];
  late String id;
  late String userId;
  late String image;
  late String servicetype;
  late String price;
  late bool rentedStatus;
  Address? address;
  UserInfo? userInfo;

  RentData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    userId = json['userId'];
    image = json['image'];
    servicetype = json['serviceType'];
    rentedStatus = json['rentedStatus'];
    price = json['price'];
    address = json['address'] != null ? Address.fromJson(json['address']) : null;
    userInfo = json['userInfo'] != null ? UserInfo.fromJson(json['userInfo']) : null;
    if (json['serviceRequests'] != null) {
      json['serviceRequests'].forEach((element) {
        rentServiceRequest.add(RentServiceRequest.fromJson(element));
      });
    }
  }
}

class UserInfo {
  late String name;
  late String email;
  late String mobile;

  UserInfo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
  }
}

class Address {
  String? pincode;
  String? state;
  String? district;
  String? sub_district;
  String? village;

  Address.fromJson(Map<String, dynamic> json) {
    pincode = json['pincode'];
    state = json['state'];
    district = json['district'];
    sub_district = json['sub_district'];
    village = json['village'];
  }
}

class RentServiceRequest {
  late String id;
  late String requestedBy;
  late String requestStatus;
  late String name;
  late String location;
  late String mobile;
  late DateTime requestedFrom;
  late DateTime requestedTo;

  RentServiceRequest.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    requestedBy = json['requestedBy'];
    requestStatus = json['requestStatus'];
    name = json['name'];
    location = json['location'];
    mobile = json['mobile'];
    requestedFrom = DateTime.parse(json['requestedFrom']);
    requestedTo = DateTime.parse(json['requestedTo']);
  }
}
