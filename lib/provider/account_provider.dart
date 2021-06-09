import 'package:virtual_ggroceries/model/core/account_model.dart';
import 'package:virtual_ggroceries/model/helper/api_helper.dart';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class AccountProvider extends ChangeNotifier {
  final _apiHelper = ApiHelper();
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
  Future<AccountModel> loginUser(
      {required String email, required String password}) async {
    var helperResult =
        await _apiHelper.loginUsers(email: email, password: password);
    _streamController.add(helperResult);
    return helperResult;
  }
}
