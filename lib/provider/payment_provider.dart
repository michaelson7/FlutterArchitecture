import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:virtual_ggroceries/model/core/ads_model.dart';
import 'package:virtual_ggroceries/model/core/products_model.dart';
import 'package:virtual_ggroceries/model/helper/api_helper.dart';

class PaymentProvider extends ChangeNotifier {
  final _apiHelper = ApiHelper();
  bool hasPurchased = false;

  updatePurchasedState() {
    hasPurchased = !hasPurchased;
    notifyListeners();
  }

  updateUserPurchase({
    required int userId,
    required int distId,
    required String address,
    required List<ProductsModelList> productList,
    required String email,
    required String name,
    required String amount,
    required String phoneNumber,
    required String transId,
  }) async {
    await _apiHelper.updateUserPurchase(
      userId: userId,
      distId: distId,
      address: address,
      productList: productList,
      email: email,
      name: name,
      amount: amount,
      phoneNumber: phoneNumber,
      transId: transId,
    );
  }
}
