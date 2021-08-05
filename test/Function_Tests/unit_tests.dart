import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:virtual_ggroceries/provider/gps_provider.dart';

main() {
  test('Test Loggers', () async {
    var logger = Logger();
    logger.i("Info log");
    logger.w("Warning log");
    logger.e("Error log");
    logger.wtf("What a terrible failure log");
  });
}
