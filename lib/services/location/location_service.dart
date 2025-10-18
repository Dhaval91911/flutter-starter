import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationResult {
  final double? latitude;
  final double? longitude;
  final String? address;
  final LocationPermission permission;

  const LocationResult({required this.latitude, required this.longitude, required this.address, required this.permission});

  bool get hasLocation => latitude != null && longitude != null;
}

class LocationService {
  const LocationService();

  Future<LocationPermission> ensurePermission() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) return LocationPermission.deniedForever;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission;
  }

  Future<Position?> getCurrentPosition({LocationAccuracy accuracy = LocationAccuracy.high}) async {
    try {
      return await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high));
    } catch (_) {
      return null;
    }
  }

  Future<String?> getReadableAddress(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isEmpty) return null;
      final p = placemarks.first;
      final parts = [
        p.name,
        p.subLocality,
        p.locality,
        p.administrativeArea,
        p.postalCode,
        p.country,
      ].where((e) => (e ?? '').trim().isNotEmpty).map((e) => e!.trim()).toList();
      return parts.join(', ');
    } catch (_) {
      return null;
    }
  }

  Future<LocationResult> getCurrentLocationAndAddress() async {
    final permission = await ensurePermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      return LocationResult(latitude: null, longitude: null, address: null, permission: permission);
    }

    final position = await getCurrentPosition();
    if (position == null) {
      return LocationResult(latitude: null, longitude: null, address: null, permission: permission);
    }

    final address = await getReadableAddress(position.latitude, position.longitude);
    return LocationResult(latitude: position.latitude, longitude: position.longitude, address: address, permission: permission);
  }
}
