import 'package:flutter/material.dart';
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

  Stream<ProductsModel> get getStream {
    return _allProductsStream.stream;
  }

  get getAllProductsStream => _allProductsStream;
  get getNewProductsStream => _newProductsStream;
  get getCategoryProductsStream => _categoryProductsStream;
  get getSubCategoryProductsStream => _subCategoryProductsStream;
  get getSearchProductsStream => _searchProductsStream;

  Future<void> getProducts(
      {ProductFilters filter = ProductFilters.all_products,
      int? categoryId,
      int? subCategoryId,
      String? searchTerm}) async {
    var helperResult = await _apiHelper.getProducts(
        productFilters: filter,
        categoryId: categoryId,
        searchTerm: searchTerm,
        subCategoryId: subCategoryId);

    switch (filter) {
      case ProductFilters.recommendation:
        break;
      case ProductFilters.new_arrival:
        _newProductsStream.add(helperResult);
        break;
      case ProductFilters.all_products:
        _allProductsStream.add(helperResult);
        break;
      case ProductFilters.cat_prod:
        _categoryProductsStream.add(helperResult);
        break;
      case ProductFilters.subProducts:
        _subCategoryProductsStream.add(helperResult);
        break;
      case ProductFilters.search_term:
        _searchProductsStream.add(helperResult);
        break;
    }
  }

  Future<void> refreshProducts() async {
    await getProducts();
  }

  void endStream() {
    _allProductsStream.close();
  }
}

// class ProductsProvider extends ChangeNotifier {
//   final _apiHelper = ApiHelper();
//   final _featuredStreamController = BehaviorSubject<ProductsModel>();
//   final _recommendedController = BehaviorSubject<ProductsModel>();
//   final _newController = BehaviorSubject<ProductsModel>();
//   final _popularController = BehaviorSubject<ProductsModel>();
//   final _allController = BehaviorSubject<ProductsModel>();
//
//   Stream<ProductsModel> get getStream {
//     return _featuredStreamController.stream;
//   }
//
//   Future<void> getProduct({required ProductFilters filter}) async {
//     var helperResult = await _apiHelper.getProducts(
//       productFilters: filter,
//     );
//     switch (filter) {
//       case ProductFilters.recommendation:
//         _recommendedController.add(helperResult);
//         break;
//       case ProductFilters.new_arrival:
//         _newController.add(helperResult);
//         break;
//       case ProductFilters.all_products:
//         _allController.add(helperResult);
//         break;
//       case ProductFilters.cat_prod:
//         // TODO: Handle this case.
//         break;
//       case ProductFilters.user_purchase:
//         // TODO: Handle this case.
//         break;
//       case ProductFilters.subProducts:
//         // TODO: Handle this case.
//         break;
//       case ProductFilters.wish_list:
//         // TODO: Handle this case.
//         break;
//       case ProductFilters.search_term:
//         // TODO: Handle this case.
//         break;
//     }
//   }
//
//   Future<void> searchForProduct({required String searchTerm}) async {
//     var helperResult = await _apiHelper.getProducts(
//       productFilters: ProductFilters.search_term,
//       searchTerm: searchTerm,
//     );
//     _featuredStreamController.add(helperResult);
//   }
//
//   Future<void> refreshProducts() async {
//     await getProduct();
//   }
//
//   void endStream() {
//     _featuredStreamController.close();
//   }
// }
