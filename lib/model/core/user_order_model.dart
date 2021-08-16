import 'package:virtual_ggroceries/model/core/products_model.dart';

class UserOrderModel {
  List<UserOrderModelList> _userModelList = [];

  UserOrderModel.fromJson(Map<String, dynamic> jsonResponse) {
    List<dynamic> results = jsonResponse["results"];
    for (int i = 0; i < results.length; i++) {
      try {
        _userModelList.add(
          UserOrderModelList(
            userId: int.parse(results[i]['user_id']),
            transId: results[i]['trans_id'],
            total: results[i]['total'],
            status: results[i]['status'],
            timeStamp: results[i]['timestamp'],
            address: results[i]['address'],
            orderCount: results[i]['orderCount'],
            thumbnail: results[i]['img_path'],
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
  final String transId, status, timeStamp, address, thumbnail;
  final dynamic total, orderCount;
  final int userId;

  UserOrderModelList({
    required this.userId,
    required this.transId,
    required this.status,
    required this.timeStamp,
    required this.address,
    required this.thumbnail,
    required this.total,
    required this.orderCount,
  });
}
