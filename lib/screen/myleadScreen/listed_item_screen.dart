import 'package:cached_network_image/cached_network_image.dart';
import 'package:farm_connects/cubits/mylead_cubit/mylead_cubits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../constants/palette.dart';
import '../../cubits/home_cubit/home_cubit.dart';
import '../../cubits/profile_cubit/profile_cubits.dart';
import '../../cubits/rent_cubit/rent_cubit.dart';
import '../../models/myleads_model.dart';
import '../../models/rent_model.dart';

class ListedItemScreen extends StatefulWidget {
  @override
  State<ListedItemScreen> createState() => _ListedItemScreenState();
}

class _ListedItemScreenState extends State<ListedItemScreen> {

  String? userId;
  String _formatDate(DateTime dateTime) {
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }
  // List<RentData> filteredRentServices = [];
  List<RentServiceRequest> filteredRentServices = [];
  @override
  void initState() {
    super.initState();
    userId = ProfileCubits.get(context).profileModel.data?.id ?? "";
    MyleadCubits.get(context)..getallSellenquiry();
    MyleadCubits.get(context)..getRentenquiry();
    MyleadCubits.get(context)..getBuyenquiry();
    RentCubit.get(context)..GetRentData();
  }

  @override
  Widget build(BuildContext context) {
    final databuyEnquiry = MyleadCubits.get(context).buyEnquiryData;
    final rentservicedata = RentCubit.get(context).rentDataModel;
    final sellserviceData = MyleadCubits.get(context).allsellEnquirydata;
    HomeCubit cubit = HomeCubit.get(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Enquiry List",style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,color: cubit.isDark ? Colors.white70 : Colors.black,
          ),),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Container(
              color: Palette.tabbarColor,
              child: TabBar(
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.black,
                tabs: [
                  Tab(text: 'Buyer Request'),
                  Tab(text: 'Sell Request'),
                  Tab(text: 'Rent Request'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildVerticalScrollableContent(
                _buildBuyEnquiry(databuyEnquiry!)),
            _buildVerticalScrollableContent(
                _buildSellEnquiry(sellserviceData!)),
            _buildVerticalScrollableContent(
                _buildRentRequestEnquiry(rentservicedata!)),
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


  Widget _buildSellEnquiry(sellAllEnquiryData dataSellEnquiry) {
    var tractor=dataSellEnquiry.data.Sellallenquiry;
    final filteredTractors = tractor.where((tractor) => tractor.farmerId == userId).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: filteredTractors.length,
        itemBuilder: (context, index) {
          return ItemBuilder(filteredTractors[index], context);
        },
      ),
    );
  }

  Widget ItemBuilder( sellEnquiry, BuildContext context) {
    HomeCubit cubit = HomeCubit.get(context);

    return GestureDetector(
      onTap: () {
        // Implement navigation to details screen if needed
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.0.h),
        child: Card(
          elevation: 1,
          child: Material(
            elevation: 3.0,
            borderRadius: BorderRadius.circular(8.0),
            color: cubit.isDark ? Colors.grey[800] : Colors.white,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Column(
                children: [
                  // Header Card for Model Name and Status
                  Card(
                    margin: EdgeInsets.zero,
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                      ),
                    ),
                    color: cubit.isDark ? Colors.grey[700] : Colors.grey[200],
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Model Name
                          Text(
                            sellEnquiry.farmername ?? 'Unknown',
                            style: TextStyle(
                              fontSize: 16.0.sp,
                              fontWeight: FontWeight.bold,
                              color: cubit.isDark ? Colors.white : Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Pending',
                            style: TextStyle(
                              fontSize: 14.0.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.red,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Main content of the card
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6.0),
                            child: SizedBox(
                              height: 120.w,
                              width: 120.w,
                              child: CachedNetworkImage(
                                imageUrl: sellEnquiry.allsellerInfo?.image ?? '',
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 8.0),
                                Text(
                                  'Price: ₹ ${sellEnquiry.budget}',
                                  style: TextStyle(
                                      fontSize: 14.0.sp,
                                      color: cubit.isDark ? Colors.white70 : Colors.black54
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Mobile: ${sellEnquiry.farmermobile}',
                                  style: TextStyle(
                                      fontSize: 12.0.sp,
                                      color: cubit.isDark ? Colors.white70 : Colors.black54
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Location: ${sellEnquiry.farmerlocation.replaceAll(",", "\n")}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12.0.sp,
                                      color: cubit.isDark ? Colors.white70 : Colors.black54
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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


  Widget _buildrentEnquiry(RentEnquiryData dataRentEnquiry) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: dataRentEnquiry.data.Rentenquiry.length,
        itemBuilder: (context, index) {
          return RentItemBuilder(dataRentEnquiry.data.Rentenquiry[index], context);
        },
      ),
    );
  }
  Widget RentItemBuilder(RentEnquirydata rentEnquiry, BuildContext context) {
    HomeCubit cubit = HomeCubit.get(context);

    return GestureDetector(
      onTap: () {
        // Implement navigation to details screen if needed
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.0.h),
        child: Card(
          elevation: 1,
          child: Material(
            elevation: 3.0,
            borderRadius: BorderRadius.circular(8.0),
            color: cubit.isDark ? Colors.grey[800] : Colors.white,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Column(
                children: [
                  // Header Card for Farmer Name and Status
                  Card(
                    margin: EdgeInsets.zero,
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                      ),
                    ),
                    color: cubit.isDark ? Colors.grey[700] : Colors.grey[200],
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Farmer Name
                          Text(
                            rentEnquiry.renterInfo?.modelname ?? 'Unknown Farmer',
                            style: TextStyle(
                              fontSize: 16.0.sp,
                              fontWeight: FontWeight.bold,
                              color: cubit.isDark ? Colors.white : Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          // Status
                          Text(
                            rentEnquiry.renterInfo?.requestStatus ?? 'Unknown',
                            style: TextStyle(
                              fontSize: 14.0.sp,
                              fontWeight: FontWeight.w500,
                              color: rentEnquiry.renterInfo?.requestStatus == 'Pending'
                                  ? Color(0xFFF57F17)
                                  : rentEnquiry.renterInfo?.requestStatus == 'Approved'
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Main content of the card
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6.0),
                            child: SizedBox(
                              height: 120.w,
                              width: 120.w,
                              child: CachedNetworkImage(
                                imageUrl: rentEnquiry.renterInfo?.image ?? '',
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 8.0),
                                Text(
                                  'Name: ${rentEnquiry.farmername}',
                                  style: TextStyle(
                                      fontSize: 14.0.sp,fontWeight: FontWeight.bold,
                                      color: cubit.isDark ? Colors.white70 : Colors.black54
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Price: ₹ ${rentEnquiry.budget}',
                                  style: TextStyle(
                                      fontSize: 14.0.sp,
                                      color: cubit.isDark ? Colors.white70 : Colors.black54
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Mobile: ${rentEnquiry.farmermobile}',
                                  style: TextStyle(
                                      fontSize: 12.0.sp,
                                      color: cubit.isDark ? Colors.white70 : Colors.black54
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Location: ${rentEnquiry.farmerlocation.replaceAll(",", "\n")}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12.0.sp,
                                      color: cubit.isDark ? Colors.white70 : Colors.black54
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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


  Widget _buildBuyEnquiry(BuyEnquiryData databuyEnquiry) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        itemCount: databuyEnquiry.data.buyenquiry.length,
        itemBuilder: (context, index) {
          return BuyItemBuilder(databuyEnquiry.data.buyenquiry[index], context);
        },
      ),
    );
  }

  Widget BuyItemBuilder(buyEnquiry, BuildContext context) {
    HomeCubit cubit = HomeCubit.get(context);

    return GestureDetector(
      onTap: () {
        // Implement navigation to details screen if needed
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.0.h),
        child: Card(
          elevation: 1,
          child: Material(
            elevation: 3.0,
            borderRadius: BorderRadius.circular(8.0),
            color: cubit.isDark ? Colors.grey[800] : Colors.white,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6.0),
                        child: SizedBox(
                          height: 120.w,
                          width: 120.w,
                          child: CachedNetworkImage(
                            imageUrl: buyEnquiry.dealerInfo?.image ?? '',
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            buyEnquiry.farmername ?? 'Unknown Farmer',
                            style: TextStyle(
                              fontSize: 16.0.sp,
                              fontWeight: FontWeight.bold,
                              color: cubit.isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Budget: ₹ ${buyEnquiry.budget}',
                            style: TextStyle(
                                fontSize: 14.0.sp,
                                color: cubit.isDark
                                    ? Colors.white70
                                    : Colors.black54),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Mobile: ${buyEnquiry.farmermobile}',
                            style: TextStyle(
                                fontSize: 12.0.sp,
                                color: cubit.isDark
                                    ? Colors.white70
                                    : Colors.black54),

                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Location: ${buyEnquiry.farmerlocation.replaceAll(",", "\n")}',
                            // softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 12.0.sp,
                                color: cubit.isDark
                                    ? Colors.white70
                                    : Colors.black54),

                          ),
                          SizedBox(height: 8.0),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildRentRequestEnquiry(RentDataModel rentDataModel) {
    final rentData = rentDataModel.data.rentData ?? [];
    print(rentData.length);
    List<Widget> rentItems = [];
    filteredRentServices.clear();
    for (var data in rentData) {
      List<RentServiceRequest>? rentServiceRequest = data.rentServiceRequest;
      var filteredRequests = rentServiceRequest.where((request) {
        return request.requestedBy == userId;
      }).toList();
      filteredRentServices.addAll(filteredRequests);
      print(filteredRequests.length);
      print(filteredRentServices.length);
      if(filteredRequests.length != 0){
        rentItems.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child:filteredRentServices.length != 0 ? ListView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: filteredRentServices.length,
            itemBuilder: (context, index) {
              return ItemBuilderRent(filteredRentServices[index],data, context);
            },
          ) : Center(
            child: Text('No Requests'),
          ),
        ));
      }
    }
    // print(rentItems.length);
    if(rentItems.length == 0){
      return Center(
        child: Text('No Your Service Request'),
      );
    }
    return Column(
      children: rentItems,
    );
  }

  Widget ItemBuilderRent(
      RentServiceRequest filteredRentServices,RentData rentData, BuildContext context) {
    HomeCubit cubit = HomeCubit.get(context);
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.0.h),
        child: Card(
          elevation: 1,
          child: Material(
            elevation: 3.0,
            borderRadius: BorderRadius.circular(8.0),
            color: cubit.isDark ? Colors.grey[800] : Colors.white,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Column(
                children: [
                  Card(
                    margin: EdgeInsets.zero,
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0),
                      ),
                    ),
                    color: cubit.isDark ? Colors.grey[700] : Colors.grey[200],
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Model Name
                          Text(
                            '${rentData.servicetype}',
                            style: TextStyle(
                              fontSize: 16.0.sp,
                              fontWeight: FontWeight.bold,
                              color: cubit.isDark ? Colors.white : Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          // Status
                          Text(
                            filteredRentServices.requestStatus ?? 'Unknown',
                            style: TextStyle(
                              fontSize: 14.0.sp,
                              fontWeight: FontWeight.w500,
                              color: filteredRentServices.requestStatus ==
                                  'Pending'
                                  ? Color(0xFFF57F17)
                                  : filteredRentServices.requestStatus ==
                                  'Approved'
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Main content of the card
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6.0),
                            child: SizedBox(
                              height: 120.w,
                              width: 120.w,
                              child: CachedNetworkImage(
                                imageUrl: rentData.image ?? '',
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                SizedBox(height: 8.0),
                                Text(
                                  'Price: ₹ ${rentData.price}',
                                  style: TextStyle(
                                      fontSize: 14.0.sp,
                                      color: cubit.isDark
                                          ? Colors.white70
                                          : Colors.black54),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Mobile: ${filteredRentServices.mobile}',
                                  style: TextStyle(
                                      fontSize: 12.0.sp,
                                      color: cubit.isDark
                                          ? Colors.white70
                                          : Colors.black54),
                                ),
                                SizedBox(height: 8.0),
                                Text(
                                  'Location: ${filteredRentServices.location.replaceAll(",", "\n")}',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12.0.sp,
                                      color: cubit.isDark
                                          ? Colors.white70
                                          : Colors.black54),
                                ),
                                SizedBox(height: 8.0),

                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    'Requested Date: ${_formatDate(filteredRentServices.requestedFrom)} To ${_formatDate(filteredRentServices.requestedTo)}',
                    style: TextStyle(
                      fontSize: 14.0.sp,
                      color: cubit.isDark ? Colors.white70 : Colors.black54,
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
