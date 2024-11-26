class RentDataModel
{
  late bool status;
  late DataModel data;

  RentDataModel.fromJson(Map<String, dynamic> json)
  {
    status = json['status'];
    data = DataModel.fromJson(json['data']);
  }

}

class DataModel
{
  List<RentData> rentData = [];
  DataModel.fromJson(Map<String, dynamic> json)
  {
    json['RentData'].forEach((element) {
      rentData.add(RentData.fromJson(element));
    });

  }
}

class RentData {
  late String id;
  late String userId;
  late String image;
  late String servicetype;
  late String price;
  late bool rentedStatus;
  late Address? address;
  late UserInfo? userInfo;
  late ServiceRequests? serviceRequests;

  RentData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    userId = json['userId'];
    image = json['image'];
    servicetype = json['serviceType'];
    rentedStatus = json['rentedStatus'];
    price = json['price'];

    address = json['address'] != null ? Address.fromJson(json['address']) : null;
    userInfo = json['userInfo'] != null ? UserInfo.fromJson(json['userInfo']) : null;
    serviceRequests = json['transmission'] != null
        ? ServiceRequests.fromJson(json['transmission'])
        : null;
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
}class Address {
  late String? pincode;
  late String? state;
  late String? district;
  late String? sub_district;
  late String? village;
  Address.fromJson(Map<String, dynamic> json) {
    state = json['state'];
    district = json['district'];
    sub_district = json['sub_district'];
    village = json['village'];
    pincode = json['pincode'];
  }
}

class ServiceRequests {
  late String requestedBy;
  late String requestStatus;
  ServiceRequests.fromJson(Map<String, dynamic> json) {
    requestedBy = json['requestedBy'];
    requestStatus = json['requestStatus'];
  }
}