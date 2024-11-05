class HomeDataModel
{
  late bool status;
  late DataModel data;

  HomeDataModel.fromJson(Map<String, dynamic> json)
  {
    status = json['status'];
    data = DataModel.fromJson(json['data']);
    print('Homedata=${data}');
  }

}

class DataModel
{
  List<Banner> banners = [];
  List<Brand> brands = [];
  List<Tractors> tractors = [];

  DataModel.fromJson(Map<String, dynamic> json)
  {
    json['banners'].forEach((element) {
      banners.add(Banner.fromJson(element));
    });
    json['brands'].forEach((element){
      brands.add(Brand.fromJson(element));
    });
    json['tractors'].forEach((element){
      tractors.add(Tractors.fromJson(element));
    });
  }
}

class Banner
{
  late String id;
  late String image;

  Banner.fromJson(Map<String, dynamic> json)
  {
    id = json['_id'];
    image = json['banner'];
  }
}

class Brand
{
  late String id;
  late String image;
  late String name;


  Brand.fromJson(Map<String, dynamic> json)
  {
    id = json['_id'];
    image = json['logo'];
    name = json['name'];

  }

}
class Tractors {
  late String id;
  late String image;
  late String name;
  late String brand;
  late Engine engine;
  late Transmission transmission;
  late Steering steering;
  late DimensionsWeight dimensionsWeight;
  late Hydraulics hydraulics;
  late WheelTyres wheelTyres;
  late OtherInformation otherInformation;
  late PowerTakeoff powerTakeoff;

  Tractors.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    image = json['tractor_image'];
    name = json['name'];
    brand = json['brand'];
    engine = Engine.fromJson(json['engine']);
    transmission = Transmission.fromJson(json['transmission']);
    steering = Steering.fromJson(json['steering']);
    dimensionsWeight = DimensionsWeight.fromJson(json['dimensionsWeight']);
    hydraulics = Hydraulics.fromJson(json['hydraulics']);
    wheelTyres = WheelTyres.fromJson(json['wheelTyres']);
    otherInformation = OtherInformation.fromJson(json['otherInformation']);
    powerTakeoff = PowerTakeoff.fromJson(json['powerTakeoff']);
  }
}

class Engine {
  late int noOfCylinder;
  late String hpCategory;
  late String capacityCC;
  late int rpm;
  late String cooling;
  late String fuelType;

  Engine.fromJson(Map<String, dynamic> json) {
    noOfCylinder = json['no_of_cylinder'];
    hpCategory = json['HP_category'];
    capacityCC = json['capacity_cc'];
    rpm = json['RPM'];
    cooling = json['cooling'];
    fuelType = json['fuelType'];
  }
}

class Transmission {
  late String clutch;
  late String gearBox;
  late String forwardSpeed;
  late String reverseSpeed;

  Transmission.fromJson(Map<String, dynamic> json) {
    clutch = json['clutch'];
    gearBox = json['gearBox'];
    forwardSpeed = json['forwordSpeed'];
    reverseSpeed = json['reverseSpeed'];
  }
}

class Steering {
  late String steeringType;
  late String steeringColumn;

  Steering.fromJson(Map<String, dynamic> json) {
    steeringType = json['steeringType'];
    steeringColumn = json['steeringColumn'];
  }
}

class DimensionsWeight {
  late String totalWeight;
  late String wheelBase;

  DimensionsWeight.fromJson(Map<String, dynamic> json) {
    totalWeight = json['totalWeight'];
    wheelBase = json['wheelBase'];
  }
}

class Hydraulics {
  late String liftingCapacity;
  late String pointLinkage;

  Hydraulics.fromJson(Map<String, dynamic> json) {
    liftingCapacity = json['liftingCapacity'];
    pointLinkage = json['pointLinkage'];
  }
}

class WheelTyres {
  late String wheelDrive;
  late String front;
  late String rear;

  WheelTyres.fromJson(Map<String, dynamic> json) {
    wheelDrive = json['wheelDrive'];
    front = json['front'];
    rear = json['rear'];
  }
}

class OtherInformation {
  late String accessories;
  late int warranty;
  late String status;

  OtherInformation.fromJson(Map<String, dynamic> json) {
    accessories = json['accessories'];
    warranty = json['warranty'];
    status = json['status'];
  }
}

class PowerTakeoff {
  late String powerType;
  late String rpm;

  PowerTakeoff.fromJson(Map<String, dynamic> json) {
    powerType = json['poweType'];
    rpm = json['RPM'];
  }
}


