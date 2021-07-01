import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virtual_ggroceries/model/core/account_model.dart';
import 'package:virtual_ggroceries/model/core/shared_pereferences_model.dart';
import 'package:virtual_ggroceries/view/constants/enums.dart';

class SharedPreferenceProvider extends ChangeNotifier {
  SharedPreferenceModel sharedPreferenceModel = SharedPreferenceModel();

  //setDarkMode
  setTheme({required bool isDarkTheme}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isDarkTheme', isDarkTheme);
      print("Shared Preferences Theme: isDark: $isDarkTheme");
      notifyListeners();
    } catch (e) {
      print("Error on sharedPreferences: $e");
    }
  }

  //get theme
  Future<bool?> isDarkMode() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool? spItem = prefs.getBool('isDarkTheme');
      print('Current Theme data: $spItem');
      if (spItem == null) {
        return false;
      } else {
        return spItem;
      }
    } catch (e) {
      print("Error on sharedPreferences: $e");
    }
  }

  //adding sp
  addUserDetails(AccountModelList userModel) async {
    try {
      var userName = getEnumValue(UserDetails.userName);
      var userEmail = getEnumValue(UserDetails.userEmail);
      var userId = getEnumValue(UserDetails.userId);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(userName, userModel.names);
      prefs.setString(userEmail, userModel.email);
      prefs.setInt(userId, userModel.id);
      print("Shared Preferences Updated");
      notifyListeners();
    } catch (e) {
      print("Error on sharedPreferences: $e");
    }
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

  //getting
  Future<String?> getStringValue(String value) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? spItem = prefs.getString(value);
      return spItem;
    } catch (e) {
      print("Error on sharedPreferences [getStringValue]: $e");
    }
  }

  Future<int?> getIntValue(String value) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int? spItem = prefs.getInt(value);
      return spItem;
    } catch (e) {
      print("Error on sharedPreferences [getStringValue]: $e");
    }
  }

  //remove
  removeValue(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(value);
    notifyListeners();
  }
}
