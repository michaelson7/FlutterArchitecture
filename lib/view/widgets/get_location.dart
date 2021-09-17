import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:virtual_ggroceries/view/widgets/logger_widget.dart';

Future<Position> getUserCoordinates() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    throw "Location services are disabled";
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      throw "Location permissions are denied";
    }
  }

  if (permission == LocationPermission.deniedForever) {
    await Geolocator.openLocationSettings();
    throw 'Location permissions are permanently denied, we cannot request permissions.';
  }

  return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
}

// Future<Location> getUserCoordinates(String address) async {
//   List<Location> locations = [];
//
//   try {
//     locations = await locationFromAddress("$address , Lusaka Zambia");
//     loggerInfo(
//       message:
//           "COORDINATES: ${locations.first.latitude} ${locations.first.longitude} \n LOCATION: $address",
//     );
//   } catch (e) {
//     throw e;
//   }
//   return locations.first;
// }

Future<Address> getActualLocation(Position value) async {
  try {
    final coordinates = new Coordinates(value.latitude, value.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    return addresses.first;
  } catch (e) {
    throw ('Specific Location Error : $e');
  }
}
