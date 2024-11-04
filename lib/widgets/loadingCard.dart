import 'package:flutter/material.dart';

class LoadingCard extends StatelessWidget {
  final double height;

  const LoadingCard({Key? key, this.height = 100}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 10),
          // Placeholder for title
          Container(
            height: 20,
            width: 100,
            color: Colors.grey[400],
          ),
          SizedBox(height: 5),
          // Placeholder for subtitle or additional info
          Container(
            height: 15,
            width: 150,
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }
}
