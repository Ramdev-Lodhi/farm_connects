import 'package:farm_connects/models/rent_model.dart';
import 'package:farm_connects/models/sell_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/network/local/cache_helper.dart';
import '../../constants/palette.dart';
import '../../cubits/home_cubit/home_cubit.dart';
import '../../cubits/profile_cubit/profile_cubits.dart';
class RentDetialsScreen extends StatefulWidget {
  final RentData? rentdata;
  RentDetialsScreen({required this.rentdata});
  @override
  State<RentDetialsScreen> createState() => _TractorsDetailsState();
}
class _TractorsDetailsState extends State<RentDetialsScreen> {
  int _expandedIndex = -1;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          title: Text(
              '${widget.rentdata?.servicetype}',
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
                  Tab(text: 'Owner Information'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildVerticalScrollableContent(
                _buildOverviewSection(widget.rentdata)),
            _buildVerticalScrollableContent(
                _buildownerSection(widget.rentdata)),

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
  Widget _buildOverviewSection(RentData? rentdata  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            rentdata!.image,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 10),
          Text(
            '${rentdata?.servicetype} ',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildIconWithText(
                  Icons.location_on, 'Location', ' ${rentdata?.state}'),
              _buildIconWithText(
                  Icons.timeline, 'Price', ' ${rentdata?.price}'),
              _buildIconWithText(Icons.power, 'Status', ' ${rentdata?.rentedStatus}'),
            ],
          ),
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
                        return rentContactDialog(
                            rentdata, context);
                      },
                    );
                  },
                  child: Text("Contact Owner ",
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

  Widget rentContactDialog(rent, BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        height: 450.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Owner Contact Form", style: TextStyle(fontSize: 20)),
                SizedBox(height: 10.0),
                TextFormField(
                  initialValue: CacheHelper.getData(key: 'name') ?? "",
                  decoration: InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
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
                      child: Text("Contact Owner", style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF202A44),
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
    );
  }

  Widget _buildownerSection(RentData? rentdata) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '${rentdata?.servicetype}  Owner Information',
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
              _buildTableRow(Icons.location_on, 'State', '${rentdata?.state}'),
              _buildTableRow(Icons.my_location, 'District', '${rentdata?.district}'),
              _buildTableRow(Icons.location_city, 'SubDistrict', '${rentdata?.sub_district}'),
              _buildTableRow(Icons.maps_home_work, 'Pincode', '${rentdata?.pincode}'),
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