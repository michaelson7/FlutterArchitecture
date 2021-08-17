import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:virtual_ggroceries/model/core/ads_model.dart';
import 'package:virtual_ggroceries/model/core/products_model.dart';
import 'package:virtual_ggroceries/model/core/user_order_activity_model.dart';
import 'package:virtual_ggroceries/model/core/user_order_model.dart';
import 'package:virtual_ggroceries/model/helper/api_helper.dart';
import 'package:virtual_ggroceries/view/constants/enums.dart';

class UserOrdersProvider extends ChangeNotifier {
  final _apiHelper = ApiHelper();
  final _transactionStream = BehaviorSubject<UserOrderModel>();
  final _ordersStream = BehaviorSubject<ProductsModel>();
  final _customerDataStream = BehaviorSubject<CustomerDataModal>();

  UserOrderModel? _paginatedList;

  get customerDataStream => _customerDataStream;
  get ordersStream => _ordersStream.stream;
  get getStream => _transactionStream.stream;

  Future<void> getUserTransaction({required int userId, int page = 1}) async {
    var helperResult =
        await _apiHelper.getUserTransactions(userId: userId, page: page);
    _transactionStream.add(helperResult);
    addToPaginatedList(helperResult);
  }

  Future<void> getUserOrder({
    required int userId,
    required String transactionId,
    UserOrders filter = UserOrders.getOrders,
  }) async {
    var helperResult = await _apiHelper.getUserOrders(
      userId: userId,
      transactionId: transactionId,
      filter: filter,
    );
    _ordersStream.add(helperResult);
  }

  Future<void> getCustomerData({
    required int userId,
  }) async {
    var helperResult = await _apiHelper.getCustomerData(
      userId: userId,
    );
    _customerDataStream.add(helperResult);
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
}
