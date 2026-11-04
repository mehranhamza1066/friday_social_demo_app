import 'package:geolocator/geolocator.dart';

class LocationService {
  // null when the user does not allow the location
  static Future<({double lat, double lng})?> getUserLocation() async {
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }
      final position = await Geolocator.getCurrentPosition();
      return (lat: position.latitude, lng: position.longitude);
    } catch (_) {
      return null;
    }
  }
}
