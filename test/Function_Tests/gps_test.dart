import 'package:flutter_test/flutter_test.dart';
import 'package:geocoding/geocoding.dart';
import 'package:virtual_ggroceries/view/widgets/logger_widget.dart';

main() {
  test('Getting Coordinates2077', () async {
    List<Location> locations = await locationFromAddress(
      "Gronausestraat 710, Enschede",
    );
    loggerInfo(message: "mmmmm");
  });
}
