import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:virtual_ggroceries/view/widgets/get_location.dart';
import 'dart:math' show cos, sqrt, asin;

class GPSProvider {
  double centralLatitude = -15.398910, centralLongitude = 28.308830;
  bool _isBike = false;

  setBike(bool value) {
    _isBike = value;
  }

  Future<Position> getCoordinates() async {
    return await getUserCoordinates();
  }

  //get specific location
  Future<Address> getSpecificLocation(Position userCoordinates) async {
    var actualLocation = await getActualLocation(userCoordinates);
    return actualLocation;
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future<double> getShippingCharge(Position userCoordinates) async {
    //calculate distance between central point and user location
    var distanceBetweenPoints = calculateDistance(
      centralLatitude,
      centralLongitude,
      userCoordinates.latitude,
      userCoordinates.longitude,
    );
    print("TOTAL DISTANCE: KM $distanceBetweenPoints");

    //check distance
    //check if distance is within 4km
    if (distanceBetweenPoints <= 4) {
      if (_isBike) {
        //if shipping is via bike
        return 16.0;
      } else {
        //if shipping is via car
        return 36.0;
      }
    }
    //if distance is greater than 4km add an additional charge per km;
    else {
      var differenceBetweenPoints = distanceBetweenPoints - 4;
      print("DIFFERENCE IN DISTANCE: KM $differenceBetweenPoints");
      if (_isBike) {
        print("TRANSPORT TYPE: Bike @ ZMK 16 +4/KM");
        var additionalCharge = (differenceBetweenPoints * 4) + 16.0;
        return additionalCharge;
      } else {
        print("TRANSPORT TYPE: Car @ ZMK 36 +6/KM");
        var additionalCharge = (differenceBetweenPoints * 6) + 36.0;
        return additionalCharge;
      }
    }
  }
}
