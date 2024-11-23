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