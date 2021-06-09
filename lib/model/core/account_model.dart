class AccountModel {
  String _errorMessage = "";
  bool _hasError = false;
  int _size = 0;
  List<AccountModelList> _accountModelList = [];

  AccountModel.testJson(List<AccountModelList> model) {
    for (int i = 0; i < model.length; i++) {
      _accountModelList.add(
        AccountModelList(
          email: model[i].email,
          address: model[i].address,
          contact: model[i].contact,
          names: model[i].names,
          accType: model[i].accType,
          imgPath: model[i].imgPath,
          id: model[i].id,
        ),
      );
    }
  }

  AccountModel.fromJson(Map<String, dynamic> jsonResponse) {
    if (!jsonResponse['error']) {
      print("Account model added");
      _hasError = false;
      List<dynamic> results = jsonResponse["results"];

      for (int i = 0; i < results.length; i++) {
        _accountModelList.add(
          AccountModelList(
            email: results[i]['Id'],
            address: results[i]['Id'],
            contact: results[i]['Id'],
            names: results[i]['Id'],
            accType: results[i]['Id'],
            imgPath: results[i]['Id'],
            id: results[i]['Id'],
          ),
        );
      }
    } else {
      _hasError = true;
      _errorMessage = jsonResponse['message'];
      print("Category model failed: $_errorMessage");
    }
  }

  List<AccountModelList> get accountModelList => _accountModelList;
  int get size => _accountModelList.length;
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
