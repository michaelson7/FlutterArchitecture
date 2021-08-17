class CustomerDataModal {
  late CustomerDataModalList _accountModelList;

  CustomerDataModal.fromJson(Map<String, dynamic> jsonResponse) {
    List<dynamic> results = jsonResponse["results"];
    for (int i = 0; i < results.length; i++) {
      _accountModelList = CustomerDataModalList(
        transactionCount: results[i]['transactionCount'],
        ordersCount: results[i]['ordersCount'],
        wishlistCount: results[i]['wishlistCount'],
      );
    }
  }

  int get size => 1;
  CustomerDataModalList? get accountModelList => _accountModelList;
}

class CustomerDataModalList {
  final dynamic transactionCount, ordersCount, wishlistCount;
  CustomerDataModalList({
    required this.transactionCount,
    required this.ordersCount,
    required this.wishlistCount,
  });
}
