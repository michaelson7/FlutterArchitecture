class ProductsModel {
  String _errorMessage = "";
  bool _hasError = false;
  int _size = 0;
  List<ProductsModelList> _productsModelList = [];

  ProductsModel.testJson(List<ProductsModelList> model) {
    for (int i = 0; i < model.length; i++) {
      _productsModelList.add(ProductsModelList(
        id: model[i].id,
        categoryId: model[i].categoryId,
        quantity: model[i].quantity,
        price: model[i].price,
        rating: model[i].rating,
        name: model[i].name,
        imgPath: model[i].imgPath,
        description: model[i].description,
        status: model[i].status,
        timestamp: model[i].timestamp,
      ));
    }
  }

  ProductsModel.fromJson(Map<String, dynamic> jsonResponse) {
    if (!jsonResponse['error']) {
      print("Account model added");
      _hasError = false;
      List<dynamic> results = jsonResponse["results"];

      for (int i = 0; i < results.length; i++) {
        _productsModelList.add(ProductsModelList(
          id: results[i]['Id'],
          categoryId: results[i]['Id'],
          quantity: results[i]['Id'],
          price: results[i]['Id'],
          rating: results[i]['Id'],
          name: results[i]['Id'],
          imgPath: results[i]['Id'],
          description: results[i]['Id'],
          status: results[i]['Id'],
          timestamp: results[i]['Id'],
        ));
      }
    } else {
      _hasError = true;
      _errorMessage = jsonResponse['message'];
      print("Category model failed: $_errorMessage");
    }
  }

  int get size => _productsModelList.length;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  List<ProductsModelList> get productsModelList => _productsModelList;
}

class ProductsModelList {
  late final int id, categoryId, quantity, price, rating;
  late final String name, imgPath, description, status, timestamp;

  ProductsModelList({
    required this.id,
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
