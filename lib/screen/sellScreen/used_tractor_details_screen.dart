import 'package:farm_connects/models/sell_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/palette.dart';
import '../../cubits/home_cubit/home_cubit.dart';
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
      length: 2,
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
                    if (selltractor?.mobile != null) {
                      // Copy the phone number to clipboard
                      Clipboard.setData(ClipboardData(text: selltractor!.mobile))
                          .then((_) {
                        showCustomSnackbar(
                            'Alert', 'Phone number copied to clipboard!');
                      });
                    }
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
}