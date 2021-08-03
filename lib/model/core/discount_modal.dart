class DiscountModal {
  String _errorMessage = "";
  bool _hasError = false;
  DiscountList? _discountModal;

  DiscountModal.fromJson(Map<String, dynamic> jsonResponse) {
    if (!jsonResponse['error']) {
      _hasError = false;
      List<dynamic> results = jsonResponse["results"];

      for (int i = 0; i < results.length; i++) {
        _discountModal = DiscountList(
          Id: results[i]['Id'],
          title: results[i]['title'],
          code: results[i]['code'],
          is_active: results[i]['is_active'],
          target: results[i]['target'],
          discount_price: results[i]['discount_price'],
        );
      }
    } else {
      _hasError = true;
      _errorMessage = jsonResponse['message'];
      print("account model failed: $_errorMessage");
    }
  }

  DiscountList? get discountModal => _discountModal;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
}

class DiscountList {
  final int Id;
  final String title, code, is_active, target;
  final dynamic discount_price;

  DiscountList({
    required this.Id,
    required this.title,
    required this.code,
    required this.is_active,
    required this.target,
    required this.discount_price,
  });
}
