import 'package:farm_connects/cubits/home_cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/network/local/cache_helper.dart';
import '../../constants/palette.dart';
import '../../cubits/mylead_cubit/mylead_cubits.dart';
import '../../cubits/profile_cubit/profile_cubits.dart';
import '../../models/home_data_model.dart';
import 'customExpansionTile.dart';


class TractorsDetails extends StatefulWidget {
  final Tractors tractor;

  TractorsDetails({required this.tractor});

  @override
  State<TractorsDetails> createState() => _TractorsDetailsState();
}

class _TractorsDetailsState extends State<TractorsDetails> {
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
  void insertbuydata(buycontactdata) {

    var mylead = MyleadCubits.get(context);
    mylead.InsertbuyContactData(
        buycontactdata.image,
        buycontactdata.brand,
        // buycontactdata.userId,
        buycontactdata.name,
        name!,
        mobile!,
        location!,
        price!);
  }
  @override
  Widget build(BuildContext context) {
    HomeCubit cubit = HomeCubit.get(context);
    var textcolor = cubit.isDark ? Colors.white : Colors.black;
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          // automaticallyImplyLeading: false,
          title: Text('${widget.tractor.brand} ${widget.tractor.name}',style: TextStyle(fontWeight: FontWeight.bold)),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Container(
              color: Palette.tabbarColor,
              child: TabBar(
                isScrollable: true,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.black,
                tabs: [
                  Tab(text: 'Overview'),
                  Tab(text: 'Features'),
                  Tab(text: 'Specialization'),
                  Tab(text: 'Tyres'),
                  Tab(text: 'Review'),
                  Tab(text: 'Dealers'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildVerticalScrollableContent(_buildOverviewSection(widget.tractor,textcolor)),
            _buildVerticalScrollableContent(
                _buildOtherFeaturesSection(widget.tractor,textcolor)),
            _buildVerticalScrollableContent(_buildSpecializationSection(widget.tractor,textcolor)),
            _buildVerticalScrollableContent(_buildTyresSection(textcolor)),
            _buildVerticalScrollableContent(_buildReviewSection(textcolor)),
            _buildVerticalScrollableContent(_buildDealersSection(textcolor)),
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

  Widget _buildOverviewSection(Tractors tractor,textcolor) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            tractor.image,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 10),
          Text(
            '${tractor.brand} ${tractor.name}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: textcolor),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildIconWithText(
                  Icons.settings, 'Drive',' ${tractor.wheelTyres.wheelDrive}',textcolor),
              _buildIconWithText(
                  Icons.timeline, 'No. of Cylinders',' ${tractor.engine.noOfCylinder} Cylinders',textcolor),
              _buildIconWithText(
                  Icons.power, 'HP',' ${tractor.engine.hpCategory}',textcolor),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Text("Price: ",
                  style:
                  TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: textcolor)),
              SizedBox(width: 8),
              Icon(Icons.currency_rupee, size: 25,color: textcolor,),
              SizedBox(width: 4),
              Text("${tractor.price}",
                  style:
                  TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: textcolor)),
            ],
          ),
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
                        return newTractorContactDialog(tractor, context);
                      },
                    );
                  },
                  child: Text("Check Tractor Price",
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF009688),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(2.0),
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

  Widget _buildIconWithText(IconData icon, String text,String value,textcolor) {
    return Row(

      children: [
        Icon(icon, size: 20,color: textcolor),
        SizedBox(width: 8),
        Column(
          children: [
            Text(text, style: TextStyle(fontSize: 14,color: textcolor)),
            Text(value, style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: textcolor)),
          ],
        ),
      ],
    );
  }

  Widget _buildOtherFeaturesSection(Tractors tractor,textcolor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '${tractor.brand} ${tractor.name} Features',
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
              _buildFeatureItem(Icons.power, 'HP', '50',textcolor),
              _buildFeatureItem(Icons.settings, 'Clutch', 'Single',textcolor),
              _buildFeatureItem(Icons.timeline, 'Gearbox', '6+1',textcolor),
              _buildFeatureItem(Icons.car_repair, 'Brake', 'Disc',textcolor),
              _buildFeatureItem(
                  Icons.electric_bolt, 'Lifting Capacity', '1500 kg',textcolor),
              _buildFeatureItem(Icons.directions_car, 'Wheel Drive', '4WD',textcolor),
              _buildFeatureItem(Icons.verified, 'Warranty', '3 years',textcolor),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewSection(textcolor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Review',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textcolor
            ),
          ),
        ),
        Center(child: Text('Review Section',style: TextStyle(color: textcolor),)),
      ],
    );
  }

  Widget _buildDealersSection(textcolor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Dealers',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textcolor
            ),
          ),
        ),
        Center(child: Text('Dealers Section',style: TextStyle(color: textcolor),)),
      ],
    );
  }

  Widget _buildTyresSection(textcolor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Tyres', // Tyres section heading
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textcolor
            ),
          ),
        ),
        Center(child: Text('Tyres Section',style: TextStyle(color: textcolor),)),
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
          Text(value,style: TextStyle(color: textcolor),),
        ],
      ),
    );
  }

  @override
  Widget _buildSpecializationSection(Tractors tractor,textcolor) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Specialization',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: textcolor
                ),
              ),
            ),
            CustomExpansionTile(
              title: 'Engine',
              details: [
                {'Number of Cylinders': '${tractor.engine.noOfCylinder}'},
                {'HP Category': '${tractor.engine.hpCategory}'},
                {'Capacity (CC)': '${tractor.engine.capacityCC}'},
                {'RPM': '${tractor.engine.rpm}'},
                {'Cooling': '${tractor.engine.cooling}'},
                {'Fuel Type': '${tractor.engine.fuelType}'},
              ],
              isExpanded: _expandedIndex == 0,
              onTap: () {
                setState(() {
                  _expandedIndex = _expandedIndex == 0 ? -1 : 0;
                });
              },
            ),
            CustomExpansionTile(
              title: 'Transmission',
              details: [
                {'Clutch': '${tractor.transmission.clutch}'},
                {'Gearbox': '${tractor.transmission.gearBox}'},
                {'Forward Speed': '${tractor.transmission.forwardSpeed}'},
                {'Reverse Speed': '${tractor.transmission.reverseSpeed}'},
              ],
              isExpanded: _expandedIndex == 1,
              onTap: () {
                setState(() {
                  _expandedIndex = _expandedIndex == 1 ? -1 : 1;
                });
              },
            ),
            CustomExpansionTile(
              title: 'Steering',
              details: [
                {'Steering Type': '${tractor.steering.steeringType}'},
                {'Steering Column': '${tractor.steering.steeringColumn}'},
              ],
              isExpanded: _expandedIndex == 2,
              onTap: () {
                setState(() {
                  _expandedIndex = _expandedIndex == 2 ? -1 : 2;
                });
              },
            ),
            CustomExpansionTile(
              title: 'Dimensions & Weight',
              details: [
                {'Total Weight': '${tractor.dimensionsWeight.totalWeight}'},
                {'Wheel Base': '${tractor.dimensionsWeight.wheelBase}'},
              ],
              isExpanded: _expandedIndex == 3,
              onTap: () {
                setState(() {
                  _expandedIndex = _expandedIndex == 3 ? -1 : 3;
                });
              },
            ),
            CustomExpansionTile(
              title: 'Hydraulics',
              details: [
                {'Lifting Capacity': '${tractor.hydraulics.liftingCapacity}'},
                {'Point Linkage': '${tractor.hydraulics.pointLinkage}'},
              ],
              isExpanded: _expandedIndex == 4,
              onTap: () {
                setState(() {
                  _expandedIndex = _expandedIndex == 4 ? -1 : 4;
                });
              },
            ),
            CustomExpansionTile(
              title: 'Wheel & Tyres',
              details: [
                {'Wheel Drive': '${tractor.wheelTyres.wheelDrive}'},
                {'Front Tyre Size': '${tractor.wheelTyres.front}'},
                {'Rear Tyre Size': '${tractor.wheelTyres.rear}'},
              ],
              isExpanded: _expandedIndex == 5,
              onTap: () {
                setState(() {
                  _expandedIndex = _expandedIndex == 5 ? -1 : 5;
                });
              },
            ),
            CustomExpansionTile(
              title: 'Power Takeoff',
              details: [
                {'Power Type': '${tractor.powerTakeoff.powerType}'},
                {'RPM': '${tractor.powerTakeoff.rpm}'},
              ],
              isExpanded: _expandedIndex == 6,
              onTap: () {
                setState(() {
                  _expandedIndex = _expandedIndex == 6 ? -1 : 6;
                });
              },
            ),
            CustomExpansionTile(
              title: 'Other Information',
              details: [
                {'Accessories': '${tractor.otherInformation.accessories}'},
                {'Warranty': '${tractor.otherInformation.warranty}'},
                {'Status': '${tractor.otherInformation.status}'},

              ],
              isExpanded: _expandedIndex == 7,
              onTap: () {
                setState(() {
                  _expandedIndex = _expandedIndex == 7 ? -1 : 7;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
  Widget newTractorContactDialog(newtractors, BuildContext context) {
    HomeCubit cubit = HomeCubit.get(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),backgroundColor: cubit.isDark ? Colors.grey[800] : Colors.white,
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
                  Text("Contact Form", style: TextStyle(fontSize: 20,color: cubit.isDark ? Colors.white : Colors.black)),
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
                    ),
                    onSaved: (value) => price = value,
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
                    color:cubit.isDark ? Colors.white : Colors.black12,
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
                            insertbuydata(newtractors);
                            Navigator.pop(context);
                            Get.to(() => TractorsDetails(tractor: newtractors));
                          }
                        },
                        child: Text("Contact",
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
}
