import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:virtual_ggroceries/model/core/ads_model.dart';
import 'package:virtual_ggroceries/model/core/user_order_model.dart';
import 'package:virtual_ggroceries/model/helper/api_helper.dart';

class UserOrdersProvider extends ChangeNotifier {
  final _apiHelper = ApiHelper();
  final _streamController = BehaviorSubject<UserOrderModel>();

  Stream<UserOrderModel> get getStream {
    return _streamController.stream;
  }

  Future<void> getUserOrders({required int userId}) async {
    var helperResult = await _apiHelper.getUserOrders(userId: userId);
    _streamController.add(helperResult);
  }
}
