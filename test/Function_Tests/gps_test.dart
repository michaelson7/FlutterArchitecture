import 'package:flutter_test/flutter_test.dart';
import 'package:virtual_ggroceries/provider/gps_provider.dart';

main() {
  GPSProvider gpsProvider = GPSProvider();
  gpsProvider.setBike(false);

  test('Getting distance Between Coordinates', () async {
    var latitudeSample = -15.448608, longitudeSample = 28.241074;

    var coordinates = await gpsProvider.getCoordinates();

    var distance = gpsProvider.calculateDistance(gpsProvider.centralLatitude,
        gpsProvider.centralLongitude, latitudeSample, longitudeSample);
    var finalDistance = distance.toStringAsFixed(2);

    var finalPrice = await gpsProvider.getShippingCharge(coordinates);
    print("Final Cost : ZMK $finalPrice");
  });
}
