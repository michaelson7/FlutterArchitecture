import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
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

  ProductsModel? _paginatedProductList;

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
        page: page);

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
        addToPaginatedList(helperResult);
        _allProductsStream.add(helperResult);
        _categoryProductsStream.add(helperResult);
        break;
      case ProductFilters.cat_prod:
        addToPaginatedList(helperResult);
        _categoryProductsStream.add(helperResult);
        break;
      case ProductFilters.subProducts:
        addToPaginatedList(helperResult);
        _subCategoryProductsStream.add(helperResult);
        break;
      case ProductFilters.search_term:
        _searchProductsStream.add(helperResult);
        break;
      case ProductFilters.wish_list:
        _wishListProductsStream.add(helperResult);
        break;
    }
  }

  Future<void> updatePaginatedList({
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
        page: page);
    for (var data in helperResult.productsModelList) {
      _paginatedProductList!.productsModelList.add(data);
    }
    notifyListeners();
  }

  clearProductList() {
    _paginatedProductList = null;
  }

  hasData() {
    if (_paginatedProductList!.size > 0) {
      return true;
    } else {
      return false;
    }
  }

  void addToPaginatedList(ProductsModel helperResult) {
    _paginatedProductList = helperResult;
    notifyListeners();
  }
}
