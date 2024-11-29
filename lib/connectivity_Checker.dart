import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'constants/styles/colors.dart';  // Connectivity check

class NoInternetScreen extends StatelessWidget {
  final Function onRetry;

  NoInternetScreen({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.wifi_off, size: 80, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'No Internet Connection',
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => onRetry(),
              child: Text('Retry', style: TextStyle(color: Colors.blue)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.0),
                  side: BorderSide(color: Colors.blue, width: 1),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
