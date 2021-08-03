import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:virtual_ggroceries/model/core/ads_model.dart';
import 'package:virtual_ggroceries/model/helper/api_helper.dart';
import 'package:virtual_ggroceries/provider/account_provider.dart';
import 'package:virtual_ggroceries/view/constants/enums.dart';

class WishListProvider extends ChangeNotifier {
  final _apiHelper = ApiHelper();
  AccountProvider _accountProvider = AccountProvider();

  Future<bool> wishListHandler({
    required WishListFilters wishListFilters,
    required int prodId,
  }) async {
    var userId = await _accountProvider.getUserId();
    if (userId != null) {
      _apiHelper.setWishList(
        wishListFilters: wishListFilters,
        userId: userId,
        prodId: prodId,
      );
      return true;
    } else {
      return false;
    }
  }
}
