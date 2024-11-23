import 'package:cached_network_image/cached_network_image.dart';
import 'package:farm_connects/cubits/mylead_cubit/mylead_cubits.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../constants/palette.dart';
import '../../cubits/home_cubit/home_cubit.dart';
import '../../models/myleads_model.dart';

class ListedItemScreen extends StatefulWidget {
  @override
  State<ListedItemScreen> createState() => _ListedItemScreenState();
}


class _ListedItemScreenState extends State<ListedItemScreen> {
  @override
  Widget build(BuildContext context) {
    final sellenquiry = MyleadCubits.get(context).sellEnquirydata;
    print(sellenquiry?.data.Sellenquiry);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
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
                  Tab(text: 'Buy'),
                  Tab(text: 'Sell'),
                  Tab(text: 'Rent'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildVerticalScrollableContent(
                _buildsellenquiry(sellenquiry)),
            _buildVerticalScrollableContent(
                _buildsellenquiry(sellenquiry)),
            _buildVerticalScrollableContent(
                _buildsellenquiry(sellenquiry)),
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

  Widget _buildsellenquiry(sellEnquiryData? sellenquiry) {
    HomeCubit cubits = HomeCubit.get(context);
    return Transform.translate(
      offset: Offset(0, -20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: sellenquiry?.data.Sellenquiry.length,
            itemBuilder: (context, index) =>
                ItemBuilder(sellenquiry?.data.Sellenquiry, context),
          ),
        ),
      ),
    );
  }

  Widget ItemBuilder(sellEnquiry, BuildContext context) {
    HomeCubit cubit = HomeCubit.get(context);
// print(sellEnquiry.);
    return GestureDetector(
      onTap: (){
        // Get.to(() => RentDetialsScreen(rentdata: product));
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
                          // child: CachedNetworkImage(
                          //   imageUrl: product?.image ?? '',
                          //   fit: BoxFit.cover,
                          //   errorWidget: (context, url, error) =>
                          //       Icon(Icons.error_outline),
                          // ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // children: [
                        //   Text(
                        //     '${product?.servicetype}'.trim(),
                        //     maxLines: 1,
                        //     textAlign: TextAlign.start,
                        //     overflow: TextOverflow.ellipsis,
                        //     style: TextStyle(
                        //       fontSize: 16.0.sp,
                        //       fontWeight: FontWeight.bold,
                        //       color: cubit.isDark ? Colors.white : Colors.black,
                        //     ),
                        //   ),
                        //
                        //   SizedBox(height: 8.0),
                        //   Text("₹ ${product?.price}",
                        //       style: TextStyle(
                        //           fontSize: 15, fontWeight: FontWeight.bold)),
                        //   SizedBox(height: 8.0),
                        //   Text(
                        //     'Location: ${product?.village == 'No villages' ? product?.sub_district : product?.village}  (${product?.pincode}) ',
                        //     maxLines: 2,
                        //     overflow: TextOverflow.ellipsis,
                        //     style: TextStyle(
                        //       fontSize: 14.0.sp,
                        //       color:
                        //       cubit.isDark ? Colors.white70 : Colors.black54,
                        //     ),
                        //   ),
                        //   ElevatedButton(
                        //     onPressed: () {
                        //       showDialog(
                        //         context: context,
                        //         builder: (context) {
                        //           return rentContactDialog(
                        //               product, context);
                        //         },
                        //       );
                        //     },
                        //     child: Text("Contact Owner",
                        //         style: TextStyle(color: Colors.white)),
                        //     style: ElevatedButton.styleFrom(
                        //       backgroundColor: Color(0xFF009688),
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(2.0),
                        //       ),
                        //     ),
                        //   ),
                        // ],
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
}