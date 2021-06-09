class UserOrderModel {
  String _errorMessage = "";
  bool _hasError = false;
  int _size = 0;
  List<UserOrderModelList> _userModelList = [];

  UserOrderModel.testJson(List<UserOrderModelList> model) {
    for (int i = 0; i < model.length; i++) {
      _userModelList.add(UserOrderModelList(
        transId: model[i].transId,
        total: model[i].total,
        status: model[i].status,
        timeSTamp: model[i].timeSTamp,
        address: model[i].address,
      ));
    }
  }

  UserOrderModel.fromJson(Map<String, dynamic> jsonResponse) {
    if (!jsonResponse['error']) {
      print("Account model added");
      _hasError = false;
      List<dynamic> results = jsonResponse["results"];

      for (int i = 0; i < results.length; i++) {
        _userModelList.add(UserOrderModelList(
          transId: results[i]['Id'],
          total: results[i]['Id'],
          status: results[i]['Id'],
          timeSTamp: results[i]['Id'],
          address: results[i]['Id'],
        ));
      }
    } else {
      _hasError = true;
      _errorMessage = jsonResponse['message'];
      print("Category model failed: $_errorMessage");
    }
  }

  int get size => _userModelList.length;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  List<UserOrderModelList> get userModelList => _userModelList;
}

class UserOrderModelList {
  late final String transId, total, status, timeSTamp, address;

  UserOrderModelList({
    required this.transId,
    required this.total,
    required this.status,
    required this.timeSTamp,
    required this.address,
  });
}
