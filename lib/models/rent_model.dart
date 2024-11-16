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
  String? pincode;
  String? state;
  String? district;
  String? sub_district;
  String? village;
  late UserInfo? userInfo; // Nullable to handle missing or null
  late ServiceRequests? serviceRequests; // Nullable to handle missing or null

  RentData.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    userId = json['userId'];
    image = json['image'];
    servicetype = json['serviceType'];
    rentedStatus = json['rentedStatus'];
    price = json['price'];
    state = json['state'];
    district = json['district'];
    sub_district = json['sub_district'];
    village = json['village'];
    pincode = json['pincode'];

    // Safely initialize nested objects
    userInfo = json['engine'] != null ? UserInfo.fromJson(json['engine']) : null;
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
}

class ServiceRequests {
  late String requestedBy;
  late String requestStatus;
  ServiceRequests.fromJson(Map<String, dynamic> json) {
    requestedBy = json['requestedBy'];
    requestStatus = json['requestStatus'];
  }
}