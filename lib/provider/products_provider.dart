import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart';
import 'package:virtual_ggroceries/model/core/categories_model.dart';
import 'package:virtual_ggroceries/model/core/products_model.dart';
import 'package:virtual_ggroceries/model/helper/api_helper.dart';
import 'package:virtual_ggroceries/view/constants/enums.dart';

class ProductsProvider extends ChangeNotifier {
  final _apiHelper = ApiHelper();
  final _allProductsStream = BehaviorSubject<ProductsModel>();
  final _newProductsStream = BehaviorSubject<ProductsModel>();
  final _categoryProductsStream = BehaviorSubject<ProductsModel>();
  final _subCategoryProductsStream = BehaviorSubject<ProductsModel>();
  final _searchProductsStream = BehaviorSubject<ProductsModel>();
  final _wishListProductsStream = BehaviorSubject<ProductsModel>();
  final _recommendedProductsStream = BehaviorSubject<ProductsModel>();
  final _mostViewedStream = BehaviorSubject<ProductsModel>();

  List<ProductsModel> _list = [];
  List<ProductsModel> get list => _list;

  Stream<ProductsModel> get getStream {
    return _allProductsStream.stream;
  }

  get getAllProductsStream => _allProductsStream;
  get getNewProductsStream => _newProductsStream;
  get getCategoryProductsStream => _categoryProductsStream.stream;
  get getSubCategoryProductsStream => _subCategoryProductsStream;
  get getSearchProductsStream => _searchProductsStream;
  get getWishListProductsStream => _wishListProductsStream;
  get getRecommndedProductsStream => _recommendedProductsStream;
  get getMostPopularStream => _mostViewedStream;

  Future<void> getProducts(
      {ProductFilters filter = ProductFilters.all_products,
      int? categoryId,
      int? subCategoryId,
      int? userId,
      int? page,
      String? searchTerm}) async {
    var helperResult = await _apiHelper.getProducts(
      productFilters: filter,
      categoryId: categoryId,
      searchTerm: searchTerm,
      userId: userId,
      subCategoryId: subCategoryId,
    );

    switch (filter) {
      case ProductFilters.mostPopular:
      case ProductFilters.recommendation:
        getRecommndedProductsStream.add(helperResult);
        _mostViewedStream.add(helperResult);
        break;
      case ProductFilters.new_arrival:
        _newProductsStream.add(helperResult);
        break;
      case ProductFilters.all_products:
        _allProductsStream.add(helperResult);
        _categoryProductsStream.sink.add(helperResult);
        break;
      case ProductFilters.cat_prod:
        _list.add(helperResult);
        _categoryProductsStream.add(helperResult);
        break;
      case ProductFilters.subProducts:
        _subCategoryProductsStream.add(helperResult);
        break;
      case ProductFilters.search_term:
        _searchProductsStream.add(helperResult);
        break;
      case ProductFilters.wish_list:
        _wishListProductsStream.add(helperResult);
        break;
    }
    notifyListeners();
  }

  Future<void> addToProductsList({
    ProductFilters filter = ProductFilters.all_products,
    int? categoryId,
    int? subCategoryId,
    int? userId,
    int? page,
    String? searchTerm,
  }) async {
    var helperResult = await _apiHelper.getProducts(
      productFilters: filter,
      categoryId: categoryId,
      searchTerm: searchTerm,
      userId: userId,
      subCategoryId: subCategoryId,
    );

    _list.add(helperResult);
    notifyListeners();
  }

  Future<void> refreshProducts() async {
    await getProducts();
  }

  void endStream() {
    _allProductsStream.close();
    _newProductsStream.close();
    _categoryProductsStream.close();
    _subCategoryProductsStream.close();
    _searchProductsStream.close();
    _wishListProductsStream.close();
    _recommendedProductsStream.close();
    _mostViewedStream.close();
  }
}
