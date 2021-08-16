import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:virtual_ggroceries/model/core/ads_model.dart';
import 'package:virtual_ggroceries/model/core/products_model.dart';
import 'package:virtual_ggroceries/model/core/user_order_model.dart';
import 'package:virtual_ggroceries/model/helper/api_helper.dart';

class UserOrdersProvider extends ChangeNotifier {
  final _apiHelper = ApiHelper();
  final _transactionStream = BehaviorSubject<UserOrderModel>();
  final _ordersStream = BehaviorSubject<ProductsModel>();
  UserOrderModel? _paginatedList;

  get ordersStream => _ordersStream.stream;
  get getStream => _transactionStream.stream;

  Future<void> getUserTransaction({required int userId, int page = 1}) async {
    var helperResult =
        await _apiHelper.getUserTransactions(userId: userId, page: page);
    _transactionStream.add(helperResult);
    addToPaginatedList(helperResult);
  }

  Future<void> updateTransaction({required int userId, int page = 1}) async {
    var helperResult =
        await _apiHelper.getUserTransactions(userId: userId, page: page);
    for (var data in helperResult.userModelList) {
      _paginatedList!.userModelList.add(data);
    }
    notifyListeners();
  }

  void addToPaginatedList(UserOrderModel helperResult) {
    _paginatedList = helperResult;
    notifyListeners();
  }

  Future<void> getUserOrder(
      {required int userId, required String transactionId}) async {
    var helperResult = await _apiHelper.getUserOrders(
        userId: userId, transactionId: transactionId);
    _ordersStream.add(helperResult);
  }
}
