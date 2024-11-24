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
            _buildVerticalScrollableContent(_buildOverviewSection(widget.tractor)),
            _buildVerticalScrollableContent(
                _buildOtherFeaturesSection(widget.tractor)),
            _buildVerticalScrollableContent(_buildSpecializationSection(widget.tractor)),
            _buildVerticalScrollableContent(_buildTyresSection()),
            _buildVerticalScrollableContent(_buildReviewSection()),
            _buildVerticalScrollableContent(_buildDealersSection()),
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

  Widget _buildOverviewSection(Tractors tractor) {
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
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildIconWithText(
                  Icons.settings, 'Drive',' ${tractor.wheelTyres.wheelDrive}'),
              _buildIconWithText(
                  Icons.timeline, 'No. of Cylinders',' ${tractor.engine.noOfCylinder} Cylinders'),
              _buildIconWithText(
                  Icons.power, 'HP',' ${tractor.engine.hpCategory}'),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Text("Price: ",
                  style:
                  TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              SizedBox(width: 8),
              Icon(Icons.currency_rupee, size: 25),
              SizedBox(width: 4),
              Text("${tractor.price}",
                  style:
                  TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
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

  Widget _buildIconWithText(IconData icon, String text,String value) {
    return Row(

      children: [
        Icon(icon, size: 20),
        SizedBox(width: 8),
        Column(
          children: [
            Text(text, style: TextStyle(fontSize: 14)),
            Text(value, style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  Widget _buildOtherFeaturesSection(Tractors tractor) {
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
              _buildFeatureItem(Icons.power, 'HP', '50'),
              _buildFeatureItem(Icons.settings, 'Clutch', 'Single'),
              _buildFeatureItem(Icons.timeline, 'Gearbox', '6+1'),
              _buildFeatureItem(Icons.car_repair, 'Brake', 'Disc'),
              _buildFeatureItem(
                  Icons.electric_bolt, 'Lifting Capacity', '1500 kg'),
              _buildFeatureItem(Icons.directions_car, 'Wheel Drive', '4WD'),
              _buildFeatureItem(Icons.verified, 'Warranty', '3 years'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewSection() {
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
            ),
          ),
        ),
        Center(child: Text('Review Section')),
      ],
    );
  }

  Widget _buildDealersSection() {
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
            ),
          ),
        ),
        Center(child: Text('Dealers Section')),
      ],
    );
  }

  Widget _buildTyresSection() {
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
            ),
          ),
        ),
        Center(child: Text('Tyres Section')),
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

  @override
  Widget _buildSpecializationSection(Tractors tractor) {
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
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
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
                  Text("Seller Contact Form", style: TextStyle(fontSize: 20)),
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
                    initialValue: location,
                    decoration: InputDecoration(
                      labelText: 'Location',
                      prefixIcon: Icon(Icons.location_on),
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
                      } else if (value.length != 13) {
                        return 'please enter 10 digit number';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Budget',
                      prefixIcon: Icon(Icons.currency_rupee),
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
                            insertbuydata(newtractors);
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
}
