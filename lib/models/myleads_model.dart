class sellEnquiryData {
  late bool status;
  late SellEnquiry data;
  sellEnquiryData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    print(status);
    data = SellEnquiry.fromJson(json['data']);
  }
}
class SellEnquiry {
  List<SellEnquirydata> Sellenquiry = [];
  SellEnquiry.fromJson(Map<String, dynamic> json) {
    json['sellenquiry'].forEach((element) {
      Sellenquiry.add(SellEnquirydata.fromJson(element));
    });
  }
}

class SellEnquirydata {
  late String farmerId;
  late String farmername;
  late String farmermobile;
  late String farmerlocation;
  late String budget;
  late SellerInfo? sellerInfo;
  SellEnquirydata.fromJson(Map<String, dynamic> json) {
    farmerId = json['userId'] ?? '';
    farmername = json['name'] ?? '';
    farmermobile = json['mobile'] ?? '';
    farmerlocation = json['location'] ?? '';
    budget = json['budget'] ?? '';
    sellerInfo = json['sellerInfo'] != null ? SellerInfo.fromJson(json['sellerInfo']) : null;
  }
}
class SellerInfo {
  late String brand;
  late String modelname;
  late String image;
  late String sellerId;
  SellerInfo.fromJson(Map<String, dynamic> json) {
    brand = json['sellBrand'] ?? '';
    modelname = json['sellmodelName'] ?? '';
    image = json['sell_image'] ?? '';
    sellerId = json['sellerID'] ?? '';

  }
}



class RentEnquiryData {
  late bool status;
  late RentEnquiry data;
  RentEnquiryData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = RentEnquiry.fromJson(json['data']);
  }
}
class RentEnquiry {
  List<RentEnquirydata> Rentenquiry = [];
  RentEnquiry.fromJson(Map<String, dynamic> json) {
    json['rentenquiry'].forEach((element) {
      Rentenquiry.add(RentEnquirydata.fromJson(element));
    });
  }
}

class RentEnquirydata {
  late String farmerId;
  late String farmername;
  late String farmermobile;
  late String farmerlocation;
  late String budget;
  late RenterInfo? renterInfo;
  RentEnquirydata.fromJson(Map<String, dynamic> json) {
    farmerId = json['userId'] ?? '';
    farmername = json['name'] ?? '';
    farmermobile = json['mobile'] ?? '';
    farmerlocation = json['location'] ?? '';
    budget = json['budget'] ?? '';
    renterInfo = json['renterInfo'] != null ? RenterInfo.fromJson(json['renterInfo']) : null;
  }
}
class RenterInfo {
  late String brand;
  late String modelname;
  late String image;
  late String renterId;
  RenterInfo.fromJson(Map<String, dynamic> json) {
    brand = json['sellBrand'] ?? '';
    modelname = json['rentserviceName'] ?? '';
    image = json['rent_image'] ?? '';
    renterId = json['renterID'] ?? '';

  }
}
