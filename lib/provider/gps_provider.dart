import 'package:geocoder/geocoder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:virtual_ggroceries/view/widgets/get_location.dart';
import 'dart:math' show cos, sqrt, asin;

import 'package:virtual_ggroceries/view/widgets/logger_widget.dart';

class GPSProvider {
  double centralLatitude = -15.427331, centralLongitude = 28.279809;
  bool _isBike = false;

  setBike(bool value) {
    _isBike = value;
  }

  Future<Location> getCoordinates({required String address}) async {
    return await getUserCoordinates(address);
  }

  //get specific location
  Future<Address> getSpecificLocation(Location userCoordinates) async {
    var actualLocation = await getActualLocation(userCoordinates);
    loggerInfo(
      message:
          "USER SPECIFIC LOCATION: ${actualLocation.addressLine} , ${actualLocation.countryName}",
    );
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

  Future<double> getShippingCharge(Location userCoordinates) async {
    //calculate distance between central point and user location
    var distanceBetweenPoints = calculateDistance(
      centralLatitude,
      centralLongitude,
      userCoordinates.latitude,
      userCoordinates.longitude,
    );
    loggerInfo(message: "TOTAL DISTANCE: KM $distanceBetweenPoints");

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
      loggerInfo(
          message: "DIFFERENCE IN DISTANCE: KM $differenceBetweenPoints");
      if (_isBike) {
        var additionalCharge = (differenceBetweenPoints * 4) + 16.0;
        loggerInfo(message: "TRANSPORT TYPE: Bike || PRICE: $additionalCharge");
        return additionalCharge;
      } else {
        var additionalCharge = (differenceBetweenPoints * 6) + 36.0;
        loggerInfo(message: "TRANSPORT TYPE: Car || PRICE: $additionalCharge");
        return additionalCharge;
      }
    }
  }
}
