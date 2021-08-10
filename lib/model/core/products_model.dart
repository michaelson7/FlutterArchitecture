class ProductsModel {
  String _errorMessage = "";
  bool _hasError = false;
  int _size = 0;
  List<ProductsModelList> _productsModelList = [];

  ProductsModel.fromJson(Map<String, dynamic> jsonResponse) {
    _hasError = false;
    List<dynamic> results = jsonResponse["results"];

    for (int i = 0; i < results.length; i++) {
      _productsModelList.add(ProductsModelList(
        id: results[i]['prod_id'],
        categoryId: results[i]['prod_cat_id'],
        quantity: results[i]['quantity'],
        price: results[i]['price'],
        rating: results[i]['rating'],
        name: results[i]['name'],
        imgPath: results[i]['img_path'],
        description: results[i]['description'],
        status: results[i]['status'],
        timestamp: results[i]['timestamp'],
        originalPrice: results[i]['price'],
      ));
    }
  }

  int get size => _productsModelList.length;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  List<ProductsModelList> get productsModelList => _productsModelList;
}

class ProductsModelList {
  int quantity, orderQuantity;
  final int id, categoryId;
  final String name, imgPath, description, status, timestamp;
  dynamic price, rating, originalPrice;

  ProductsModelList({
    this.orderQuantity = 1,
    required this.id,
    required this.originalPrice,
    required this.categoryId,
    required this.quantity,
    required this.price,
    required this.rating,
    required this.name,
    required this.imgPath,
    required this.description,
    required this.status,
    required this.timestamp,
  });
}
