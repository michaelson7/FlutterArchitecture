import 'package:random_words/random_words.dart';
import 'package:virtual_ggroceries/model/core/account_model.dart';
import 'package:virtual_ggroceries/model/core/ads_model.dart';
import 'package:virtual_ggroceries/model/core/categories_model.dart';
import 'package:virtual_ggroceries/model/core/products_model.dart';
import 'package:virtual_ggroceries/model/core/user_order_model.dart';
import 'package:virtual_ggroceries/provider/image_provider.dart';
import 'package:random_string/random_string.dart';
import '../service/api.dart';

class ApiHelper {
  Api api = Api();
  ImageProviders _imageProviders = ImageProviders();

  Future<AccountModel> loginUsers(
      {required String email, required String password}) async {
    try {
      dynamic response = await api.loginUsers(email: email, password: password);
      AccountModel model = AccountModel.fromJson(response);
      return model;
    } catch (e) {
      throw Exception('Error while passing to model: $e');
    }
  }

  Future<ProductsModel> getProduct() async {
    try {
      var response = await api.getProducts();
      ProductsModel model = ProductsModel.fromJson(response);
      return model;
    } catch (e) {
      throw Exception('Error while passing to model: $e');
    }
  }

  //accountModel

//adsModel
  Future<AdsModel> getAds() async {
    try {
      List<AdsModelList> model = [];
      model.add(
        AdsModelList(
          adsId: 5,
          productId: 3,
          header: generateAdjective().take(1).first.toString(),
          subHeader: randomString(15),
          imgPath: _imageProviders.getRandomImage(),
        ),
      );
      AdsModel adsModel = AdsModel.testJson(model);
      return adsModel;
    } catch (e) {
      throw Exception('Error while passing to model: $e');
    }
  }

  //category
  Future<CategoryModel> getCategories() async {
    try {
      var response = await api.getCategory();
      CategoryModel model = CategoryModel.fromJson(response);
      return model;
    } catch (e) {
      throw Exception('Error while passing to Categorymodel: $e');
    }
  }

  //products
  Future<ProductsModel> getProducts() async {
    try {
      List<ProductsModelList> model = [];
      for (int i = 0; i < 8; i++) {
        model.add(ProductsModelList(
            id: i,
            categoryId: i,
            quantity: i,
            price: randomBetween(10, 200),
            rating: 3,
            name: generateAdjective().take(1).first.toString(),
            imgPath: _imageProviders.getRandomImage(),
            description: randomString(100),
            status: randomString(5),
            timestamp: randomString(12)));
      }
      ProductsModel finalModel = ProductsModel.testJson(model);
      return finalModel;
    } catch (e) {
      throw Exception('Error while passing to getProducts: $e');
    }
  }

  //search for product
  Future<ProductsModel> searchProduct({required String searchTerm}) async {
    try {
      List<ProductsModelList> model = [];
      for (int i = 0; i < 6; i++) {
        model.add(ProductsModelList(
            id: i,
            categoryId: i,
            quantity: i,
            price: randomBetween(10, 200),
            rating: 3,
            name: '$searchTerm ${generateAdjective().take(1).first.toString()}',
            imgPath: _imageProviders.getRandomImage(),
            description: randomString(100),
            status: randomString(5),
            timestamp: randomString(12)));
      }
      ProductsModel finalModel = ProductsModel.testJson(model);
      return finalModel;
    } catch (e) {
      throw Exception('Error while passing to searchProduct: $e');
    }
  }

  //user order
  Future<UserOrderModel> getUserOrders() async {
    try {
      List<UserOrderModelList> model = [];
      for (int i = 0; i < 8; i++) {
        model.add(
          UserOrderModelList(
              transId: randomBetween(10000, 20000).toString(),
              total: randomBetween(10, 200).toString(),
              status: generateAdjective().take(1).first.toString(),
              timeSTamp: randomString(15),
              address: randomString(15)),
        );
      }
      UserOrderModel finalModel = UserOrderModel.testJson(model);
      return finalModel;
    } catch (e) {
      throw Exception('Error while passing to model: $e');
    }
  }
}
