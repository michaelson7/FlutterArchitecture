import 'package:virtual_ggroceries/model/core/products_model.dart';

class UserOrderModel {
  List<UserOrderModelList> _userModelList = [];

  UserOrderModel.fromJson(Map<String, dynamic> jsonResponse) {
    List<dynamic> results = jsonResponse["results"];
    for (int i = 0; i < results.length; i++) {
      try {
        _userModelList.add(
          UserOrderModelList(
            transId: results[i]['trans_id'],
            total: results[i]['total'],
            status: results[i]['PurchaseStatus'],
            timeStamp: results[i]['purchaseTime'],
            address: results[i]['address'],
            productsModel: ProductsModel.fromJson(jsonResponse),
          ),
        );
      } catch (e) {
        print('Error setting userOrderModel: $e');
      }
    }
  }

  int get size => _userModelList.length;
  List<UserOrderModelList> get userModelList => _userModelList;
}

class UserOrderModelList {
  final String transId, status, timeStamp, address;
  final dynamic total;
  final ProductsModel productsModel;

  UserOrderModelList({
    required this.transId,
    required this.total,
    required this.status,
    required this.timeStamp,
    required this.address,
    required this.productsModel,
  });
}
