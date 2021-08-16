import 'package:logger/logger.dart';
import 'package:virtual_ggroceries/model/core/account_model.dart';
import 'package:virtual_ggroceries/model/core/ads_model.dart';
import 'package:virtual_ggroceries/model/core/categories_model.dart';
import 'package:virtual_ggroceries/model/core/discount_modal.dart';
import 'package:virtual_ggroceries/model/core/products_model.dart';
import 'package:virtual_ggroceries/model/core/sub_categories_model.dart';
import 'package:virtual_ggroceries/model/core/user_order_model.dart';
import 'package:virtual_ggroceries/provider/shared_pereferences_provider.dart';
import 'package:virtual_ggroceries/view/constants/enums.dart';
import '../service/api.dart';

class ApiHelper {
  Api _api = Api();
  Logger logger = Logger();

  Future<AccountModel> loginUsers({
    required String email,
    required String password,
  }) async {
    try {
      dynamic response = await _api.loginUsers(email: email);
      AccountModel model = AccountModel.fromJson(response);
      return model;
    } catch (e) {
      throw Exception('Error while passing to loginUsers in Api_helper: $e');
    }
  }

  Future<AccountModel> registerUser({
    required String email,
    required String password,
    required String names,
  }) async {
    try {
      dynamic response = await _api.registerUser(
        email: email,
        names: names,
        password: password,
      );
      AccountModel model = AccountModel.fromJson(response);
      return model;
    } catch (e) {
      throw Exception('Error while passing to RegisterUsers in Api_helper: $e');
    }
  }

  //update user
  Future<void> updateUserAccount({
    required String userName,
    required String userAddress,
    required String userContact,
    required String userEmail,
  }) async {
    try {
      await _api.updateUserAccount(
        userName: userName,
        userEmail: userEmail,
        userAddress: userAddress,
        userContact: userContact,
      );
    } catch (e) {
      throw Exception(
          'Error while passing to updateUserAccount in Api_helper: $e');
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
      var response = await _api.getProducts(
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
      var response = await _api.getAds(
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
      var response = await _api.getCategory();
      CategoryModel model = CategoryModel.fromJson(response);
      return model;
    } catch (e) {
      throw Exception('Error while passing to getCategories: $e');
    }
  }

  //fetch discount data
  Future<DiscountModal> getDiscount({required String discountCode}) async {
    try {
      var response = await _api.getDiscount(discountCode: discountCode);
      DiscountModal model = DiscountModal.fromJson(response);
      return model;
    } catch (e) {
      throw Exception('Error while passing to getDiscount: $e');
    }
  }

  //subcategory
  Future<SubCategoryModel> getSubCategories({required int categoryId}) async {
    try {
      var response = await _api.getSubCategories(categoryId: categoryId);
      SubCategoryModel model = SubCategoryModel.fromJson(response);
      return model;
    } catch (e) {
      throw Exception('Error while passing to Sub Category model: $e');
    }
  }

  //user order
  Future<ProductsModel> getUserOrders(
      {required int userId, required String transactionId}) async {
    try {
      var response = await _api.getUserOrders(
        userId: userId,
        src: "getOrders",
        trans_id: transactionId,
      );
      ProductsModel finalModel = ProductsModel.fromJson(response);
      return finalModel;
    } catch (e) {
      throw Exception('Error while passing to getUserOrders model: $e');
    }
  }

  Future<UserOrderModel> getUserTransactions(
      {required int userId, int page = 1}) async {
    try {
      var response = await _api.getUserOrders(
        userId: userId,
        page: page,
        src: "getTransactions",
      );
      UserOrderModel finalModel = UserOrderModel.fromJson(response);
      return finalModel;
    } catch (e) {
      throw Exception('Error while passing to getUserTransactions model: $e');
    }
  }

  //set wishList
  void setWishList({
    required WishListFilters wishListFilters,
    required int userId,
    required int prodId,
  }) async {
    try {
      await _api.setWishList(
        wishListFilters: wishListFilters,
        userId: userId,
        prodId: prodId,
      );
    } catch (e) {
      throw Exception('Error while passing to set wishlist model: $e');
    }
  }

  updateUserPurchase({
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
    try {
      await _api.updateUserPurchase(
        userId: userId,
        distId: distId,
        address: address,
        productList: productList,
        email: email,
        name: name,
        amount: amount,
        phoneNumber: phoneNumber,
        transId: transId,
      );
    } catch (e) {
      throw Exception('Error while passing to Update User Purchase model: $e');
    }
  }

  //
}
