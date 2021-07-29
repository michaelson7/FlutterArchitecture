import 'package:virtual_ggroceries/model/core/account_model.dart';
import 'package:virtual_ggroceries/model/helper/api_helper.dart';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:virtual_ggroceries/provider/shared_pereferences_provider.dart';
import 'package:virtual_ggroceries/view/constants/enums.dart';

class AccountProvider extends ChangeNotifier {
  final _apiHelper = ApiHelper();
  SharedPreferenceProvider _sp = SharedPreferenceProvider();

  var _userNameEnum = getEnumValue(UserDetails.userName);
  var _userEmailEnum = getEnumValue(UserDetails.userEmail);
  var _userIdEnum = getEnumValue(UserDetails.userId);

  //login users
  Future<bool> loginUser({
    required String email,
    required String password,
  }) async {
    var helperResult = await _apiHelper.loginUsers(
      email: email,
      password: password,
    );
    //if user is signed not in
    if (helperResult.hasError) {
      return false;
    } else {
      _sp.addUserDetails(helperResult.accountModelList!);
      return true;
    }
  }

  Future<bool> registerUser({
    required String email,
    required String password,
    required String names,
  }) async {
    var helperResult = await _apiHelper.registerUser(
      email: email,
      password: password,
      names: names,
    );
    //if user is signed not in
    if (helperResult.hasError) {
      return false;
    } else {
      _sp.addUserDetails(helperResult.accountModelList!);
      return true;
    }
  }

  Future<void> updateUserAccount({
    required String userName,
    required String userAddress,
    required String userContact,
    required String userEmail,
  }) async {
    await _apiHelper.updateUserAccount(
      userAddress: userAddress,
      userContact: userContact,
      userEmail: userEmail,
      userName: userName,
    );
  }

  Future<bool> isSignedIn() async {
    var signedData = await _sp.isLoggedIn();
    return signedData;
  }

  Future<String?> getUserName() async {
    var name = await _sp.getStringValue(_userNameEnum);
    return name;
  }

  Future<String?> getUserEmail() async {
    return await _sp.getStringValue(_userEmailEnum);
  }

  Future<int?> getUserId() async {
    return await _sp.getIntValue(_userIdEnum);
  }
}
