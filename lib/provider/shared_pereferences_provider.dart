import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virtual_ggroceries/model/core/account_model.dart';
import 'package:virtual_ggroceries/model/core/shared_pereferences_model.dart';

class SharedPreferenceProvider extends ChangeNotifier {
  SharedPreferenceModel sharedPreferenceModel = SharedPreferenceModel();

  //adding sp
  addUserDetails(AccountModelList userModel) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userName', userModel.names);
      prefs.setString('userEmail', userModel.email);
      prefs.setInt('userId', userModel.id);
      print("Shared Preferences Updated");
      notifyListeners();
    } catch (e) {
      print("Error on sharedPreferences: $e");
    }
  }

  //getting
  Future<String?> getStringValue(String value) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? spItem = prefs.getString(value);
      print(spItem);
      return spItem;
    } catch (e) {
      print("Error on sharedPreferences: $e");
    }
  }

  Future<int?> getIntValue(String value) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? spItem = prefs.getInt(value);
      return spItem;
    } catch (e) {
      print("Error on sharedPreferences: $e");
    }
  }

  //remove
  removeValue(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(value);
    notifyListeners();
  }

//check if signed in
  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool userVal = prefs.containsKey("userId");
    return userVal;
  }

  //deleteAll
  logOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
}
