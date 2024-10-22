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

  DataModel.fromJson(Map<String, dynamic> json)
  {
    json['banners'].forEach((element) {
      banners.add(Banner.fromJson(element));
    });
    json['brands'].forEach((element){
      brands.add(Brand.fromJson(element));
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