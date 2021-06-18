import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:virtual_ggroceries/model/core/categories_model.dart';
import 'package:virtual_ggroceries/model/core/products_model.dart';
import 'package:virtual_ggroceries/model/helper/api_helper.dart';

class ProductsProvider extends ChangeNotifier {
  final _apiHelper = ApiHelper();
  final _streamController = BehaviorSubject<ProductsModel>();

  Stream<ProductsModel> get getStream {
    return _streamController.stream;
  }

  Future<void> getProducts() async {
    var helperResult = await _apiHelper.getProducts();
    _streamController.add(helperResult);
  }

  Future<void> searchForProduct({required String searchTerm}) async {
    var helperResult = await _apiHelper.searchProduct(searchTerm: searchTerm);
    _streamController.add(helperResult);
  }

  Future<void> refreshProducts() async {
    await getProducts();
  }

  void endStream() {
    _streamController.close();
  }
}
