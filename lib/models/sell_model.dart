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

  class SellAllTractorData {
    late bool status;
    late SellAllTractors data;

    SellAllTractorData.fromJson(Map<String, dynamic> json) {
      status = json['status'];
      data = SellAllTractors.fromJson(json['data']);
      print('Homedata=${data}');
    }
  }

  class SellAllTractors {
    List<SellData> SellTractor = [];
    SellAllTractors.fromJson(Map<String, dynamic> json) {
      json['sellTractor'].forEach((element) {
        SellTractor.add(SellData.fromJson(element));
      });
    }
  }


  class ModelName {
    late String id;
    late String name;
    late String hpCategory;

    ModelName.fromJson(Map<String, dynamic> json) {
      id = json['_id'];
      name = json['name'];
      hpCategory = json['engine']['HP_category'];
    }
  }

  class SellData {
    late String name;
    late String mobile;
    late String location;
    late String state;
    late String brand;
    late String modelname;
    late String modelHP;
    late String RC;
    late String year;
    late String engine_Condition;
    late String tyre_Condition;
    late String hourDriven;
    late String price;
    late String image;

    SellData.fromJson(Map<String, dynamic> json) {
      name = json['name'] ?? '';
      mobile = json['mobile'] ?? '';
      location = json['location'] ?? '';
      state = json['state'] ?? '';
      brand = json['brand'] ?? '';
      modelname = json['modelName'] ?? '';
      modelHP = json['enginePower'] ?? '';
      year = json['manufacturingYear'] ?? '';
      RC = json['RC'] ?? '';
      engine_Condition = json['engineCondition'] ?? '';
      tyre_Condition = json['tyreCondition'] ?? '';
      hourDriven = json['hoursDriven'] ?? '';
      price = json['price'] ?? '';
      image = json['image'] ?? '';
    }
  }
