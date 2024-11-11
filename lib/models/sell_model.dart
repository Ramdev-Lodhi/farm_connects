  class SellDataModel {
    late bool status;
    late SellDataModelData data;

    SellDataModel.fromJson(Map<String, dynamic> json) {
      status = json['status'];
      data = SellDataModelData.fromJson(json['data']);
      print('Homedata=${data}');
    }
  }

  class SellDataModelData {
    List<ModelName> models = [];

    SellDataModelData.fromJson(Map<String, dynamic> json) {
        json['modelname'].forEach((element) {
          models.add(ModelName.fromJson(element));
        });
    }
  }



  class ModelName {
    late String id;
    late String name;

    ModelName.fromJson(Map<String, dynamic> json) {
      id = json['_id'];
      name = json['name'];
    }
  }

  class SellData {
    late String name;
    late String mobile;
    late String location;
    late String brand;
    late String modelname;
    late String year;
    late String engine_Condition;
    late String tyre_Condition;
    late String hourDriven;
    late String image;

    SellData.fromJson(Map<String, dynamic> json) {
      name = json['name'] ?? '';
      mobile = json['mobile'] ?? '';
      location = json['location'] ?? '';
      brand = json['brand'] ?? '';
      modelname = json['modelname'] ?? '';
      year = json['year'] ?? '';
      engine_Condition = json['engine_condition'] ?? '';
      tyre_Condition = json['tyre_condition'] ?? '';
      hourDriven = json['hour_driven'] ?? '';
      image = json['image'] ?? '';
    }
  }
