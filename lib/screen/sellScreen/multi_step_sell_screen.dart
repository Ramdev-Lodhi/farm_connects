import 'package:flutter/material.dart';

class SubmissionPage extends StatelessWidget {
  final String location;
  final String name;
  final String mobile;

  const SubmissionPage({
    Key? key,
    required this.location,
    required this.name,
    required this.mobile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Submission Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Location: $location", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Name: $name", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Mobile: $mobile", style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
