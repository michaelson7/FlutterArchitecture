import 'package:virtual_ggroceries/model/core/account_model.dart';
import 'package:virtual_ggroceries/model/helper/api_helper.dart';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:virtual_ggroceries/provider/shared_pereferences_provider.dart';

class AccountProvider extends ChangeNotifier {
  final _apiHelper = ApiHelper();
  SharedPreferenceProvider _sp = SharedPreferenceProvider();
  final _streamController = BehaviorSubject<AccountModel>();

  Stream<AccountModel> get getStream {
    return _streamController.stream;
  }

  //getUser
  Future<void> getUser({required int userId}) async {
    final helperResult = await _apiHelper.loginUsers(email: "", password: "");
    _streamController.add(helperResult);
  }

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
}
