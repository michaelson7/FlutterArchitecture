import 'dart:convert';

import 'package:virtual_ggroceries/view/constants/enums.dart';

import 'data_access.dart';

class Api {
  // String baseUrl = "10.0.2.2";
  // String urlPath = "/web_clientProjects/MartinProject/aAPI/API.php";
  String baseUrl = "virtualgroceries.net";
  String urlPath = "/api/API.php";

  Future<dynamic> loginUsers(
      {required String email, required String password}) async {
    final requestParameters = {
      "apicall": "account",
      "src": "login",
    };
    final body = {
      'Email': email,
      'Password': password,
    };
    Uri uri = Uri.http(baseUrl, urlPath, requestParameters);
    return await postResponse(uri, body);
  }

  //fetch categories
  Future<dynamic> getCategory() async {
    final requestParameters = {
      "apicall": "fetch_category",
    };
    Uri uri = Uri.http(baseUrl, urlPath, requestParameters);
    return await getResponse(uri);
  }

  //load sub categories based on categoryID
  Future<dynamic> getSubCategories({required int categoryId}) async {
    final requestParameters = {
      "apicall": "fetchCategorySub",
      "Id": categoryId.toString(),
    };
    Uri uri = Uri.http(baseUrl, urlPath, requestParameters);
    return await getResponse(uri);
  }

  //PRODUCTS
  Future<dynamic> getProducts({
    required ProductFilters productFilters,
    int? page,
    int? categoryId,
    int? userId,
    int? subCategoryId,
    String? sortData,
    String? searchTerm,
  }) async {
    //
    String filterValue = getEnumValue(productFilters);

    Map<String, dynamic> requestParameters = {
      "apicall": "fetch_products",
      "src": filterValue,
      "page": page == null ? '1' : page.toString(),
      "term": searchTerm,
      "cat_id": categoryId.toString(),
      "sort": sortData,
      "user_id": userId.toString(),
      "SubCategoryId": subCategoryId.toString(),
    };

    Uri uri = Uri.http(baseUrl, urlPath, requestParameters);
    print('URI: $uri');
    return await getResponse(uri);
  }

  //fetch ads
  Future<dynamic> getAds({
    required int page,
    int? categoryId,
  }) async {
    final requestParameters = {
      "apicall": "fetch_ads",
      // "cat_id": categoryId,
      "page": page.toString(),
    };
    Uri uri = Uri.http(baseUrl, urlPath, requestParameters);
    return await getResponse(uri);
  }

  Future<dynamic> setWishList({
    required WishListFilters wishListFilters,
    required int userId,
    required int prodId,
  }) async {
    String filterValue = getEnumValue(wishListFilters);
    final requestParameters = {
      "apicall": "handle_wish_list",
      "user_id": userId,
      "prod_id": prodId,
      "src": filterValue,
    };
    Uri uri = Uri.http(baseUrl, urlPath, requestParameters);
    return await getResponse(uri);
  }

//
}
