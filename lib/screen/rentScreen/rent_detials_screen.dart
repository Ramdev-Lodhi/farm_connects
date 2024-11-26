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
    HomeCubit cubit =HomeCubit.get(context);
    var textcolor = cubit.isDark ? Colors.white : Colors.black;
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
                _buildOverviewSection(widget.rentdata,textcolor)),
            _buildVerticalScrollableContent(
                _buildownerSection(widget.rentdata,textcolor)),
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

  Widget _buildOverviewSection(RentData? rentdata ,textcolor) {

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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: textcolor),
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
                  Icons.currency_rupee, 'Price', '${rentdata?.price}',textcolor),
              _buildTableRow(Icons.location_on, 'Location', '${rentdata?.address?.state}',textcolor),

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

  Widget rentContactDialog(rentdata, BuildContext context) {
    HomeCubit cubit =HomeCubit.get(context);
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
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Owner Contact Form", style: TextStyle(fontSize: 20,color: cubit.isDark ? Colors.white : Colors.black)),
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
                    initialValue:
                    location,
                    style: TextStyle(color: cubit.isDark ? Colors.white : Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Location',
                      labelStyle: TextStyle(color: cubit.isDark ? Colors.white : Colors.black),
                      prefixIcon: Icon(Icons.location_on,color: cubit.isDark ? Colors.white : Colors.black,),
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
                    style: TextStyle(color: cubit.isDark ? Colors.white : Colors.black),
                    decoration: InputDecoration(
                      labelText: 'Mobile',
                      labelStyle: TextStyle(color: cubit.isDark ? Colors.white : Colors.black),
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
                      }else if (value.length != 13) {
                        return 'please enter 10 digit number';
                      }
                      return null;
                    },
                  ),

                  Divider(
                    thickness: 1.5,
                    color: cubit.isDark ? Colors.white : Colors.black12,
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

  Widget _buildownerSection(RentData? rentdata,textcolor) {
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
              color: textcolor
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
                  Icons.person, 'Name', '${rentdata?.userInfo?.name}',textcolor),
              _buildTableRow(
                  Icons.phone, 'Mobile', '${rentdata?.userInfo?.mobile}',textcolor),
              _buildTableRow(
                  Icons.email, 'Email', '${rentdata?.userInfo?.email}',textcolor),
              _buildTableRow(Icons.location_on, 'State', '${rentdata?.address?.state}',textcolor),
              _buildTableRow(
                  Icons.my_location, 'District', '${rentdata?.address?.district}',textcolor),
              _buildTableRow(Icons.location_city, 'SubDistrict',
                  '${rentdata?.address?.sub_district}',textcolor),
              _buildTableRow(
                  Icons.maps_home_work, 'Pincode', '${rentdata?.address?.pincode}',textcolor),
            ],
          ),
        ),
      ],
    );
  }


}
