import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:virtual_ggroceries/model/core/ads_model.dart';
import 'package:virtual_ggroceries/model/core/discount_modal.dart';
import 'package:virtual_ggroceries/model/helper/api_helper.dart';
import 'package:virtual_ggroceries/provider/account_provider.dart';
import 'package:virtual_ggroceries/view/constants/enums.dart';

class DiscountProvider extends ChangeNotifier {
  final _apiHelper = ApiHelper();

  Future<DiscountModal> checkDiscountCode(
      {required String discountCode}) async {
    var data = await _apiHelper.getDiscount(discountCode: discountCode);
    return data;
  }
}
