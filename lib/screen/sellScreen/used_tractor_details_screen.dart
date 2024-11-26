  import 'package:farm_connects/models/sell_model.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter/services.dart';
import 'package:get/get.dart';
  import '../../config/network/local/cache_helper.dart';
  import '../../constants/palette.dart';
  import '../../cubits/home_cubit/home_cubit.dart';
  import '../../cubits/mylead_cubit/mylead_cubits.dart';
import '../../cubits/profile_cubit/profile_cubits.dart';
  import '../../models/home_data_model.dart';
  import '../../widgets/snackbar_helper.dart';
  import '../BuyScreen/customExpansionTile.dart';
  class UsedTractorDetails extends StatefulWidget {
    final SellData? selltractor;
    UsedTractorDetails({required this.selltractor});
    @override
    State<UsedTractorDetails> createState() => _TractorsDetailsState();
  }
  class _TractorsDetailsState extends State<UsedTractorDetails> {
    int _expandedIndex = -1;
    final _formKey = GlobalKey<FormState>();
    String? name;
    String? mobile;
    String? location;
    String? price;

    @override
    void initState() {
      super.initState();
      name = CacheHelper.getData(key: 'name') ?? "";
      location =
      '${CacheHelper.getData(key: 'state') ?? ''}, ${CacheHelper.getData(key: 'subDistrict') ?? ''}';
      mobile = ProfileCubits.get(context).profileModel.data?.mobile ?? "";
    }

    void insertselldata(sellcontactdata) {
      var mylead = MyleadCubits.get(context);
      mylead.InsertContactData(
          sellcontactdata.image,
          sellcontactdata.modelname,
          sellcontactdata.brand,
          sellcontactdata.sellerId,
          sellcontactdata.name,
          name!,
          mobile!,
          location!,
          price!);
    }
    @override
    Widget build(BuildContext context) {
      HomeCubit cubit = HomeCubit.get(context);
      var textcolor = cubit.isDark ? Colors.white : Colors.black;
      // Get tractors list from HomeCubit
      final tractors = HomeCubit.get(context).homeDataModel?.data.tractors ?? [];
      // Function to get the tractor price based on brand and model name
      String getTractorPrice(String brand, String modelName) {
        final tractor = tractors.firstWhere((tractorData) =>
        tractorData.brand == brand &&
            tractorData.name == modelName // Default price if not found
        );
        return tractor.price;
      }
      // Get price for the current selltractor
      String tractorPrice = getTractorPrice(
          widget.selltractor?.brand ?? '', widget.selltractor?.modelname ?? '');
      return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            // automaticallyImplyLeading: false,
            title: Text(
                '${widget.selltractor?.brand} ${widget.selltractor?.modelname}',
                style: TextStyle(fontWeight: FontWeight.bold)),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(kToolbarHeight),
              child: Container(
                color: Palette.tabbarColor,
                child: TabBar(
                  // isScrollable: true,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  indicatorColor: Colors.black,
                  tabs: [
                    Tab(text: 'Overview'),
                    Tab(text: 'Features'),
                    Tab(text: 'Seller Information'),
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(
            children: [
              _buildVerticalScrollableContent(
                  _buildOverviewSection(widget.selltractor,tractorPrice,textcolor)),
              _buildVerticalScrollableContent(
                  _buildOtherFeaturesSection(widget.selltractor,textcolor)),
              _buildVerticalScrollableContent(
                  _buildSellerSection(widget.selltractor,textcolor)),
            ],
          ),
        ),
      );
    }
    Widget _buildVerticalScrollableContent(Widget child) {
      return SingleChildScrollView(
        child: child,
      );
    }
    Widget _buildOverviewSection(SellData? selltractor ,tractorPrice ,textcolor ) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              selltractor!.image,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 10),
            Text(
              '${selltractor?.brand} ${selltractor?.modelname}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: textcolor),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildIconWithText(
                    Icons.location_on, 'Location', ' ${selltractor?.state}',textcolor),
                _buildIconWithText(
                    Icons.timeline, 'Year', ' ${selltractor?.year}',textcolor),
                _buildIconWithText(Icons.power, 'HP', ' ${selltractor?.modelHP}',textcolor),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.currency_rupee, size: 25,color: textcolor,),
                SizedBox(width: 8),
                Column(
                  children: [
                    Text("${selltractor.price}",
                        style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: textcolor)),
                  ],
                ),
              ],
            ),
            SizedBox(width: 8),
            Text('New Tractor Price: ${tractorPrice}',
                style:
                TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.red)),
            SizedBox(height: 20),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 0),
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return sellerContactDialog(
                              selltractor, context);
                        },
                      );
                    },
                    child: Text("Contact Seller ",
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF009688),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    Widget _buildIconWithText(IconData icon, String text, String value,textcolor) {
      return Row(
        children: [
          Icon(icon, size: 20,color: textcolor,),
          SizedBox(width: 8),
          Column(
            children: [
              Text(text, style: TextStyle(fontSize: 14,color: textcolor)),
              Text(value,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: textcolor)),
            ],
          ),
        ],
      );
    }
    Widget _buildOtherFeaturesSection(SellData? selltractor,textcolor) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${selltractor?.brand} ${selltractor?.modelname} Features',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textcolor
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              childAspectRatio: 1,
              children: [
                _buildFeatureItem(
                    Icons.location_city, 'City', '${selltractor?.location}',textcolor),
                _buildFeatureItem(Icons.power, 'HP', '${selltractor?.modelHP}',textcolor),
                _buildFeatureItem(Icons.settings, 'Engine Condition',
                    '${selltractor?.engine_Condition}',textcolor),
                _buildFeatureItem(
                    Icons.timeline, 'Hour Driven', '${selltractor?.hourDriven}',textcolor),
                _buildFeatureItem(Icons.car_repair, 'RC', '${selltractor?.RC}',textcolor),
                _buildFeatureItem(
                    Icons.electric_bolt, 'Model Year', '${selltractor?.year}',textcolor),
                _buildFeatureItem(Icons.directions_car, 'Tyre Condition',
                    '${selltractor?.tyre_Condition}',textcolor),
              ],
            ),
          ),
        ],
      );
    }

    Widget _buildFeatureItem(IconData icon, String label, String value,textcolor) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30,color: textcolor,),
            SizedBox(height: 5),
            Text(label, style: TextStyle(fontWeight: FontWeight.bold,color: textcolor)),
            SizedBox(height: 5),
            Text(value ,style: TextStyle(color: textcolor),),
          ],
        ),
      );
    }
    Widget sellerContactDialog(selltractors, BuildContext context) {
      HomeCubit cubit = HomeCubit.get(context);
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        backgroundColor: cubit.isDark ? Colors.grey[800] : Colors.white,
        insetPadding: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Container(
            height: 400.0,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Seller Contact Form", style: TextStyle(fontSize: 20,color: cubit.isDark ? Colors.white : Colors.black)),
                    TextFormField(
                      initialValue: name,
                      style: TextStyle(color: cubit.isDark ? Colors.white : Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(color: cubit.isDark ? Colors.white : Colors.black),
                        prefixIcon: Icon(Icons.person,color: cubit.isDark ? Colors.white : Colors.black,),
                        border: OutlineInputBorder(),
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                      ),
                      onSaved: (value) => name = value,
                      onChanged: (value) {
                        setState(() {
                          name = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: location,
                      style: TextStyle(color: cubit.isDark ? Colors.white : Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Location',
                        labelStyle: TextStyle(color: cubit.isDark ? Colors.white : Colors.black),
                        prefixIcon: Icon(Icons.location_on,color: cubit.isDark ? Colors.white : Colors.black,),
                        border: OutlineInputBorder(),
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                      ),
                      onSaved: (value) => location = value,
                      onChanged: (value) {
                        setState(() {
                          location = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Location';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: mobile,
                      style: TextStyle(color: cubit.isDark ? Colors.white : Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Mobile',
                        labelStyle:  TextStyle(color: cubit.isDark ? Colors.white : Colors.black),
                        prefixIcon: Icon(Icons.phone,color: cubit.isDark ? Colors.white : Colors.black,),
                        border: OutlineInputBorder(),
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                      ),
                      onSaved: (value) => mobile = value,
                      onChanged: (value) {
                        setState(() {
                          mobile = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Mobile';
                        } else if (value.length != 13) {
                          return 'please enter 10 digit number';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      style: TextStyle(color: cubit.isDark ? Colors.white : Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Budget',
                        labelStyle: TextStyle(color: cubit.isDark ? Colors.white : Colors.black),
                        prefixIcon: Icon(Icons.currency_rupee,color: cubit.isDark ? Colors.white : Colors.black,),
                        border: OutlineInputBorder(),
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                      ),onSaved: (value) => price = value,
                      onChanged: (value) {
                        setState(() {
                          price = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Budget';
                        }
                        return null;
                      },
                    ),
                    Divider(
                      thickness: 1.5,
                      color: cubit.isDark ? Colors.white :Colors.black12,
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 0),
                      // Set bottom margin to 0
                      child: SizedBox(
                        width: 150, // Set the desired width here
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              insertselldata(selltractors);
                              Get.back();
                            }
                          },
                          child: Text("Contact Seller",
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF009688),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(2.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    Widget _buildSellerSection(SellData? selltractor,textcolor) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${selltractor?.brand} ${selltractor?.modelname} Seller Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textcolor
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Table(
              border: TableBorder.all(color: Colors.grey, width: 1),
              columnWidths: {
                0: FlexColumnWidth(1.5), // Flex for the first column
                1: FlexColumnWidth(2), // Flex for the second column
              },
              children: [
                _buildTableRow(Icons.person, 'Name', '${selltractor?.name}',textcolor),
                _buildTableRow(Icons.phone, 'Mobile', '${selltractor?.mobile}',textcolor),
                _buildTableRow(Icons.location_on, 'Location', '${selltractor?.state}',textcolor),
                _buildTableRow(Icons.location_city, 'City', '${selltractor?.location}',textcolor),
              ],
            ),
          ),
        ],
      );
    }

    TableRow _buildTableRow(IconData icon, String label, String value,textcolor) {
      return TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(icon, size: 20,color: textcolor,),
                SizedBox(width: 8),
                Text(label, style: TextStyle(fontWeight: FontWeight.bold,color: textcolor)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(value, style: TextStyle(fontSize: 14,color: textcolor)),
          ),
        ],
      );
    }

  }