  import 'package:farm_connects/models/sell_model.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter/services.dart';
  import '../../config/network/local/cache_helper.dart';
  import '../../constants/palette.dart';
  import '../../cubits/home_cubit/home_cubit.dart';
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
    final TextEditingController locationController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController mobileController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    @override
    Widget build(BuildContext context) {
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
                  _buildOverviewSection(widget.selltractor,tractorPrice)),
              _buildVerticalScrollableContent(
                  _buildOtherFeaturesSection(widget.selltractor)),
              _buildVerticalScrollableContent(
                  _buildSellerSection(widget.selltractor)),
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
    Widget _buildOverviewSection(SellData? selltractor ,tractorPrice  ) {
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
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildIconWithText(
                    Icons.location_on, 'Location', ' ${selltractor?.state}'),
                _buildIconWithText(
                    Icons.timeline, 'Year', ' ${selltractor?.year}'),
                _buildIconWithText(Icons.power, 'HP', ' ${selltractor?.modelHP}'),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.currency_rupee, size: 25),
                SizedBox(width: 8),
                Column(
                  children: [
                    Text("${selltractor.price}",
                        style:
                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
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
    Widget _buildIconWithText(IconData icon, String text, String value) {
      return Row(
        children: [
          Icon(icon, size: 20),
          SizedBox(width: 8),
          Column(
            children: [
              Text(text, style: TextStyle(fontSize: 14)),
              Text(value,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      );
    }
    Widget _buildOtherFeaturesSection(SellData? selltractor) {
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
                    Icons.location_city, 'City', '${selltractor?.location}'),
                _buildFeatureItem(Icons.power, 'HP', '${selltractor?.modelHP}'),
                _buildFeatureItem(Icons.settings, 'Engine Condition',
                    '${selltractor?.engine_Condition}'),
                _buildFeatureItem(
                    Icons.timeline, 'Hour Driven', '${selltractor?.hourDriven}'),
                _buildFeatureItem(Icons.car_repair, 'RC', '${selltractor?.RC}'),
                _buildFeatureItem(
                    Icons.electric_bolt, 'Model Year', '${selltractor?.year}'),
                _buildFeatureItem(Icons.directions_car, 'Tyre Condition',
                    '${selltractor?.tyre_Condition}'),
              ],
            ),
          ),
        ],
      );
    }

    Widget _buildFeatureItem(IconData icon, String label, String value) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30),
            SizedBox(height: 5),
            Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(value),
          ],
        ),
      );
    }
    Widget sellerContactDialog(selltractors, BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        insetPadding: EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Container(
            height: 400.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Seller Contact Form", style: TextStyle(fontSize: 20)),
                    TextFormField(
                      initialValue: CacheHelper.getData(key: 'name') ?? "",
                      decoration: InputDecoration(
                        labelText: 'Name',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: '${CacheHelper.getData(key: 'state') ?? ''}, ${CacheHelper.getData(key: 'subDistrict') ?? ''}',
                      decoration: InputDecoration(
                        labelText: 'Location',
                        prefixIcon: Icon(Icons.location_on),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Location';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: ProfileCubits.get(context).profileModel.data?.mobile ?? "",
                      decoration: InputDecoration(
                        labelText: 'Mobile',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Mobile';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Budget',
                        prefixIcon: Icon(Icons.currency_rupee),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Budget';
                        }
                        return null;
                      },
                    ),
                    Divider(
                      thickness: 1.5,
                      color: Colors.black12,
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 0), // Set bottom margin to 0
                      child: SizedBox(
                        width: 150, // Set the desired width here
                        child: ElevatedButton(
                          onPressed: () {
                if (_formKey.currentState!.validate()) {
          // Get.to(()=> UsedTractorDetails(selltractor: selltractors));
                }
                          },
                          child: Text("Contact Seller", style: TextStyle(color: Colors.white)),
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

    Widget _buildSellerSection(SellData? selltractor) {
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
                _buildTableRow(Icons.person, 'Name', '${selltractor?.name}'),
                _buildTableRow(Icons.phone, 'Mobile', '${selltractor?.mobile}'),
                _buildTableRow(Icons.location_on, 'Location', '${selltractor?.state}'),
                _buildTableRow(Icons.location_city, 'City', '${selltractor?.location}'),
              ],
            ),
          ),
        ],
      );
    }

    TableRow _buildTableRow(IconData icon, String label, String value) {
      return TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(icon, size: 20),
                SizedBox(width: 8),
                Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(value, style: TextStyle(fontSize: 14)),
          ),
        ],
      );
    }

  }