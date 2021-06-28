import 'package:random_words/random_words.dart';
import 'package:virtual_ggroceries/model/core/account_model.dart';
import 'package:virtual_ggroceries/model/core/ads_model.dart';
import 'package:virtual_ggroceries/model/core/categories_model.dart';
import 'package:virtual_ggroceries/model/core/products_model.dart';
import 'package:virtual_ggroceries/model/core/sub_categories_model.dart';
import 'package:virtual_ggroceries/model/core/user_order_model.dart';
import 'package:virtual_ggroceries/provider/image_provider.dart';
import 'package:random_string/random_string.dart';
import 'package:virtual_ggroceries/view/constants/enums.dart';
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
      throw Exception('Error while passing to loginUsers: $e');
    }
  }

  //PRODUCTS
  Future<ProductsModel> getProducts({
    required ProductFilters productFilters,
    int? page,
    int? categoryId,
    int? userId,
    int? subCategoryId,
    String? sortData,
    String? searchTerm,
  }) async {
    try {
      var response = await api.getProducts(
        productFilters: productFilters,
        page: page,
        categoryId: categoryId,
        userId: userId,
        subCategoryId: subCategoryId,
        sortData: sortData,
        searchTerm: searchTerm,
      );
      ProductsModel model = ProductsModel.fromJson(response);
      return model;
    } catch (e) {
      throw Exception('Error while passing to getProducts: $e');
    }
  }

//adsModel
  Future<AdsModel> getAds({required int page, int? categoryId}) async {
    try {
      var response = await api.getAds(
        page: page,
        categoryId: categoryId,
      );
      AdsModel adsModel = AdsModel.fromJson(response);
      return adsModel;
    } catch (e) {
      throw Exception('Error while passing to getAds model: $e');
    }
  }

  //category
  Future<CategoryModel> getCategories() async {
    try {
      var response = await api.getCategory();
      CategoryModel model = CategoryModel.fromJson(response);
      return model;
    } catch (e) {
      throw Exception('Error while passing to getCategories: $e');
    }
  }

  //subcategory
  Future<SubCategoryModel> getSubCategories({required int categoryId}) async {
    try {
      var response = await api.getSubCategories(categoryId: categoryId);
      SubCategoryModel model = SubCategoryModel.fromJson(response);
      return model;
    } catch (e) {
      throw Exception('Error while passing to Sub Category model: $e');
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
      throw Exception('Error while passing to getUSerOrder model: $e');
    }
  }

  //set wishList
  Future<ProductsModel> setWishList(
      {required WishListFilters wishListFilters,
      required int userId,
      required int prodId}) async {
    try {
      var response = await api.setWishList(
        wishListFilters: wishListFilters,
        userId: userId,
        prodId: prodId,
      );
      ProductsModel model = ProductsModel.fromJson(response);
      return model;
    } catch (e) {
      throw Exception('Error while passing to set wishlist model: $e');
    }
  }
}
