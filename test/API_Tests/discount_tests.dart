import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_connect/http/src/http/mock/http_request_mock.dart';
import 'package:virtual_ggroceries/provider/discount_provider.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';

@GenerateMocks([http.Client])
main() {
  DiscountProvider _discountProvider = DiscountProvider();

  test('Get List Of Discounts', () async {
    var discountCode = "1234";
    var data = await _discountProvider.checkDiscountCode(
      discountCode: discountCode,
    );
    print("HAS ERROR: ${data.hasError}");
    print("DATA: ${data.discountModal}");
  });
}
