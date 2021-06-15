import 'package:flutter/cupertino.dart';
import 'data_access.dart';
import 'network_helper.dart';

class Api {
  // String baseUrl = "10.0.2.2";
  // String urlPath = "/web_clientProjects/MartinProject/aAPI/API.php";
  String baseUrl = "mwila-university.000webhostapp.com";
  String urlPath = "/MartinDB/aAPI/API.php";

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
    Uri uri = Uri.https(baseUrl, urlPath, requestParameters);
    return await postResponse(uri, body);
  }

  Future<dynamic> getProducts() async {
    final requestParameters = {
      "apicall": "Products",
      "src": "getAll",
    };
    Uri uri = Uri.https(baseUrl, urlPath, requestParameters);
    return await getResponse(uri);
  }

  Future<dynamic> getCategory() async {
    final requestParameters = {
      "apicall": "ProductCategory",
      "src": "getAll",
    };
    Uri uri = Uri.https(baseUrl, urlPath, requestParameters);
    return await getResponse(uri);
  }
}