import 'package:farm_connects/models/rent_model.dart';
import 'package:farm_connects/models/sell_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../config/network/local/cache_helper.dart';
import '../../constants/palette.dart';
import '../../cubits/home_cubit/home_cubit.dart';
import '../../cubits/mylead_cubit/mylead_cubits.dart';
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

  String? name;

  String? mobile;

  String? location;

  String? price;

  void insertrentdata(rentcontactdata) {

    var mylead = MyleadCubits.get(context);
    mylead.InsertrentContactData(
        rentcontactdata.image,
        rentcontactdata.servicetype,
        rentcontactdata.userId,
        rentcontactdata.userInfo.name,
        name!,
        mobile!,
        location!,
        rentcontactdata.price!);
  }

  @override
  void initState() {
    super.initState();
    name = CacheHelper.getData(key: 'name') ?? "";
    location =
    '${CacheHelper.getData(key: 'state') ?? ''}, ${CacheHelper.getData(key: 'subDistrict') ?? ''}';
    mobile = ProfileCubits.get(context).profileModel.data?.mobile ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          title: Text('${widget.rentdata?.servicetype}',
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

  Widget _buildOverviewSection(RentData? rentdata) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${rentdata?.servicetype} ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              rentdata.rentedStatus == false ?
              Text(
                   "Unavailable" ,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold ,color: Colors.red),
              ):Text(
                "Available" ,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color: Colors.green),
              ) ,
            ],
          ),
          SizedBox(height: 10),
          Table(
            border: TableBorder.all(color: Colors.grey, width: 1),
            columnWidths: {
              0: FlexColumnWidth(1.5),
              1: FlexColumnWidth(2),
            },
            children: [
              _buildTableRow(
                  Icons.currency_rupee, 'Price', '${rentdata?.price}'),
              _buildTableRow(Icons.location_on, 'Location', '${rentdata?.state}'),

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
                        return rentContactDialog(rentdata, context);
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

  Widget rentContactDialog(rentdata, BuildContext context) {
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
                  Text("Owner Contact Form", style: TextStyle(fontSize: 20)),
                  TextFormField(
                    initialValue: name,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.person),
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
                    initialValue:
                    location,
                    decoration: InputDecoration(
                      labelText: 'Location',
                      prefixIcon: Icon(Icons.location_on),
                      border: OutlineInputBorder(),
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                    ),onSaved: (value) => location = value,
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
                    initialValue:
                    mobile,
                    decoration: InputDecoration(
                      labelText: 'Mobile',
                      prefixIcon: Icon(Icons.phone),
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
                      }else if (value.length != 13) {
                        return 'please enter 10 digit number';
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
                    margin: EdgeInsets.only(bottom: 0),
                    // Set bottom margin to 0
                    child: SizedBox(
                      width: 150, // Set the desired width here
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            insertrentdata(rentdata);
                            Get.back();
                          }
                        },
                        child: Text("Contact Owner",
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
              0: FlexColumnWidth(1.5),
              1: FlexColumnWidth(2),
            },
            children: [
              _buildTableRow(
                  Icons.person, 'Name', '${rentdata?.userInfo?.name}'),
              _buildTableRow(
                  Icons.phone, 'Mobile', '${rentdata?.userInfo?.mobile}'),
              _buildTableRow(
                  Icons.email, 'Email', '${rentdata?.userInfo?.email}'),
              _buildTableRow(Icons.location_on, 'State', '${rentdata?.state}'),
              _buildTableRow(
                  Icons.my_location, 'District', '${rentdata?.district}'),
              _buildTableRow(Icons.location_city, 'SubDistrict',
                  '${rentdata?.sub_district}'),
              _buildTableRow(
                  Icons.maps_home_work, 'Pincode', '${rentdata?.pincode}'),
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
