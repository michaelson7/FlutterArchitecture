class AccountModel {
  String _errorMessage = "";
  bool _hasError = false;
  int _size = 0;
  AccountModelList? _accountModelList;

  AccountModel.fromJson(Map<String, dynamic> jsonResponse) {
    if (!jsonResponse['error']) {
      _hasError = false;
      List<dynamic> results = jsonResponse["results"];

      for (int i = 0; i < results.length; i++) {
        _accountModelList = AccountModelList(
            email: results[i]['email'],
            address: results[i]['address'],
            contact: results[i]['contact'],
            names: results[i]['names'],
            accType: results[i]['acc_type'],
            imgPath: results[i]['img_path'],
            id: results[i]['user_id']);
      }
    } else {
      _hasError = true;
      _errorMessage = jsonResponse['message'];
      print("account model failed: $_errorMessage");
    }
  }

  AccountModelList? get accountModelList => _accountModelList;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
}

class AccountModelList {
  late final int id;
  late final String names, email, address, imgPath, accType, contact;

  AccountModelList(
      {required this.id,
      required this.names,
      required this.email,
      required this.address,
      required this.imgPath,
      required this.accType,
      required this.contact});
}
