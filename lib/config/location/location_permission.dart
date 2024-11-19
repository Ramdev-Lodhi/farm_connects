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


        String country = place.country ?? 'N/A';
        String state = place.administrativeArea ?? 'N/A';
        String district = place.subAdministrativeArea ?? 'N/A';
        String subDistrict = place.locality ?? 'N/A';
        String village = place.subLocality ?? 'N/A';
        String street = place.street ?? 'N/A';
        String name = place.name ?? 'N/A';
        String thoroughfare = place.thoroughfare ?? 'N/A';
        String subThoroughfare = place.subThoroughfare ?? 'N/A';
        String pincode = place.postalCode ?? 'N/A';


        String fullAddress = [
          if (name != '' && name != 'N/A') name,
          if (street != '' && street != 'N/A') street,
          if (subThoroughfare != '' && subThoroughfare != 'N/A') subThoroughfare,
          if (village != '' && village != 'N/A') village,
          if (subDistrict != '' && subDistrict != 'N/A') subDistrict,
          if (district != '' && district != 'N/A') district,
          if (state != '' && state != 'N/A') state,
          if (country != '' && country != 'N/A') country,
          if (pincode != '' && pincode != 'N/A') pincode,
        ].join(', ');


        CacheHelper.saveData(key: 'country', value: country);
        CacheHelper.saveData(key: 'locality', value: subDistrict);
        CacheHelper.saveData(key: 'state', value: state);
        CacheHelper.saveData(key: 'district', value: district);
        CacheHelper.saveData(key: 'subDistrict', value: subDistrict);
        CacheHelper.saveData(key: 'village', value: village);
        // CacheHelper.saveData(key: 'street', value: street);
        // CacheHelper.saveData(key: 'building ', value: name);
        // CacheHelper.saveData(key: 'thoroughfare', value: thoroughfare);
        // CacheHelper.saveData(key: 'subThoroughfare', value: subThoroughfare);
        CacheHelper.saveData(key: 'pincode', value: pincode);
        CacheHelper.saveData(key: 'fullAddress', value: fullAddress);

        // return {
        //   'state': place.administrativeArea ?? 'N/A',
        //   'district': place.subAdministrativeArea ?? 'N/A',
        //   'subDistrict': place.locality ?? 'N/A',
        //   'village': place.subLocality ?? 'N/A',
        //   'pincode': place.postalCode ?? 'N/A',
        // };
      }
    } catch (e) {
    }
    return null;
  }
}
