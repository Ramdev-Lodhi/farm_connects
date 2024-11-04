import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../network/local/cache_helper.dart';

class LocationHelper {
  static Future<Map<String, String>?> fetchLocationDetails() async {
    try {
      // Check for location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        print("Location permissions are permanently denied.");
        return null;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Perform reverse geocoding
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        CacheHelper.saveData(key: 'state', value: place.administrativeArea ?? 'N/A');
        CacheHelper.saveData(key: 'district', value: place.subAdministrativeArea ?? 'N/A');
        CacheHelper.saveData(key: 'subDistrict', value: place.locality ?? 'N/A');
        CacheHelper.saveData(key: 'village', value: place.subLocality ?? 'N/A');
        CacheHelper.saveData(key: 'pincode', value: place.postalCode ?? 'N/A');

        print("Location details saved successfully.");
        // return {
        //   'state': place.administrativeArea ?? 'N/A',
        //   'district': place.subAdministrativeArea ?? 'N/A',
        //   'subDistrict': place.locality ?? 'N/A',
        //   'village': place.subLocality ?? 'N/A',
        //   'pincode': place.postalCode ?? 'N/A',
        // };
      }
    } catch (e) {
      print("Error fetching location details: $e");
    }
    return null;
  }
}
