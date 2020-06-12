import 'package:geolocator/geolocator.dart';

abstract class ILocationService {
  Future<Position> getPosition();
}

class LocationService implements ILocationService {
  @override
  Future<Position> getPosition() async {
    return Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
  }
}
