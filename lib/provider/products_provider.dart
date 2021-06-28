import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:virtual_ggroceries/model/core/categories_model.dart';
import 'package:virtual_ggroceries/model/core/products_model.dart';
import 'package:virtual_ggroceries/model/helper/api_helper.dart';
import 'package:virtual_ggroceries/view/constants/enums.dart';

class ProductsProvider extends ChangeNotifier {
  final _apiHelper = ApiHelper();
  final _featuredStreamController = BehaviorSubject<ProductsModel>();
  final _recommendedController = BehaviorSubject<ProductsModel>();
  final _newController = BehaviorSubject<ProductsModel>();
  final _popularController = BehaviorSubject<ProductsModel>();
  final _allController = BehaviorSubject<ProductsModel>();

  Stream<ProductsModel> get getStream {
    return _featuredStreamController.stream;
  }

  Future<void> getProduct({required ProductFilters filter}) async {
    var helperResult = await _apiHelper.getProducts(
      productFilters: filter,
    );
    switch (filter) {
      case ProductFilters.recommendation:
        _recommendedController.add(helperResult);
        break;
      case ProductFilters.new_arrival:
        _newController.add(helperResult);
        break;
      case ProductFilters.all_products:
        _allController.add(helperResult);
        break;
      case ProductFilters.cat_prod:
        // TODO: Handle this case.
        break;
      case ProductFilters.user_purchase:
        // TODO: Handle this case.
        break;
      case ProductFilters.subProducts:
        // TODO: Handle this case.
        break;
      case ProductFilters.wish_list:
        // TODO: Handle this case.
        break;
      case ProductFilters.search_term:
        // TODO: Handle this case.
        break;
    }
  }

  Future<void> searchForProduct({required String searchTerm}) async {
    var helperResult = await _apiHelper.getProducts(
      productFilters: ProductFilters.search_term,
      searchTerm: searchTerm,
    );
    _featuredStreamController.add(helperResult);
  }

  Future<void> refreshProducts() async {
    await getProduct();
  }

  void endStream() {
    _featuredStreamController.close();
  }
}
