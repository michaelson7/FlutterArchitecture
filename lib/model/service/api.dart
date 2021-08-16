import 'package:logger/logger.dart';
import 'package:virtual_ggroceries/model/core/products_model.dart';
import 'package:virtual_ggroceries/view/constants/enums.dart';
import 'package:virtual_ggroceries/view/widgets/logger_widget.dart';
import 'data_access.dart';

class Api {
  // String baseUrl = "10.0.2.2";
  // String urlPath = "/web_clientProjects/virtualgroceries/api/API.php";
  String baseUrl = "virtualgroceries.net";
  String urlPath = "/api/API.php";
  Logger logger = Logger();

  Future<dynamic> loginUsers({required String email}) async {
    final requestParameters = {
      "apicall": "account_handler",
      "src": "login",
    };
    final body = {
      'email': email,
    };
    Uri uri = Uri.http(baseUrl, urlPath, requestParameters);
    return await postResponse(uri, body);
  }

  Future<dynamic> registerUser({
    required String email,
    required String password,
    required String names,
  }) async {
    final requestParameters = {
      "apicall": "account_handler",
      "src": "register",
    };
    final body = {
      'email': email,
      'password': password,
      'names': names,
    };
    Uri uri = Uri.http(baseUrl, urlPath, requestParameters);
    return await postResponse(uri, body);
  }

  //update user
  Future<dynamic> updateUserAccount({
    required String userName,
    required String userAddress,
    required String userContact,
    required String userEmail,
  }) async {
    final requestParameters = {
      "apicall": "account_handler",
      "src": "update_user",
      "name": userName,
      "address": userAddress,
      "contact": userContact,
    };
    final body = {
      'email': userEmail,
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

    if (productFilters == ProductFilters.wish_list) {
      print(uri);
    }
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
      "user_id": userId.toString(),
      "prod_id": prodId.toString(),
      "src": filterValue,
    };
    Uri uri = Uri.http(baseUrl, urlPath, requestParameters);
    return await getResponse(uri);
  }

  Future<dynamic> updateUserPurchase({
    required int userId,
    required int distId,
    required String address,
    required List<ProductsModelList> productList,
    required String email,
    required String name,
    required String amount,
    required String phoneNumber,
    required String transId,
  }) async {
    //get  product ids
    int size = productList.length;
    final requestParameters = {
      "apicall": "update_purchase",
      "array_size": size.toString(),
    };

    final body = {
      "user_id": userId.toString(),
      "total": amount,
      "address": address,
      "dist_id": distId.toString(),
      "user_name": name,
      "user_phone": phoneNumber,
      "trans_id": transId,
      "email": email,
    };

    //pass product id and selected quantity
    int num = 0;
    for (var data in productList) {
      body['productId($num)'] = data.id.toString();
      body['productQuantity($num)'] = data.orderQuantity.toString();
      num++;
    }

    //pass which delivery type to use
    if (productList.length > 20) {
      body['deliveryType'] = "CAR";
    } else {
      body['deliveryType'] = "BIKE";
    }

    loggerInfo(message: 'requestParameters: $requestParameters \nbody: $body');

    Uri uri = Uri.http(baseUrl, urlPath, requestParameters);
    return await postResponse(uri, body);
  }

  //get user orders
  Future<dynamic> getUserOrders(
      {required int userId,
      required String src,
      String? trans_id,
      int page = 1}) async {
    final requestParameters = {
      "apicall": "fetchUserOrders",
      "user_id": userId.toString(),
      "trans_id": trans_id,
      "src": src,
      "page": page.toString()
    };
    Uri uri = Uri.http(baseUrl, urlPath, requestParameters);
    return await getResponse(uri);
  }

  //fetch discount data
  Future<dynamic> getDiscount({
    required String discountCode,
  }) async {
    final requestParameters = {
      "apicall": "getDiscounts",
      "src": "checkCode",
      "code": discountCode,
    };
    Uri uri = Uri.http(baseUrl, urlPath, requestParameters);
    return await getResponse(uri);
  }
}
