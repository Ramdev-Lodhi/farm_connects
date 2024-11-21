import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class RentscreenPlaceholder extends StatelessWidget {
  const RentscreenPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: List.generate(
                2,
                    (index) => _ListViewContainer(),
              ),
            ),
            SizedBox(height: 10.h),
            _sectionHeader(),
            SizedBox(height: 10.h),
            _ListViewbuilderContainner(),
            SizedBox(height: 20.h),
            Column(
              children: List.generate(
                6,
                    (index) => _ListViewContainer(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 40.h,
        color: Colors.grey,
        width: double.infinity,
      ),
    );
  }

  Widget _ListViewbuilderContainner() {
    return Container(
      height: 110.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.0.w),
            child: Card(
              elevation: 1,
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 110.w,
                  color: Colors.grey,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _ListViewContainer() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.0.w,vertical: 5.0.h),
      child: Card(
        elevation: 1,
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 120.h,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
