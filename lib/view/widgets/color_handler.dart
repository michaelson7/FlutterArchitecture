import 'package:virtual_ggroceries/provider/shared_pereferences_provider.dart';
import 'package:flutter/material.dart';

class ColorHandler {
  SharedPreferenceProvider _themeData = SharedPreferenceProvider();
  bool _isDarkMode = true;

  ColorHandler() {
    // getTheme();
  }

  void getTheme() async {
    var data = await _themeData.isDarkMode();
    // print('selected theme is $data');
    _isDarkMode = true;
  }

  Color get cardBackground {
    var darkTheme = Color(0x1bffffff);
    var lightTheme = Color(0x9AD4D4D4);
    return _isDarkMode ? darkTheme : lightTheme;
  }

  get cardBackgroundFaint {
    var darkTheme = Color(0xcffffff);
    var lightTheme = Color(0x66CACACA);
    return _isDarkMode ? darkTheme : lightTheme;
  }

  get scaffoldColor {
    var darkTheme = Color(0xff151515);
    var lightTheme = Color(0xffffffff);
    return _isDarkMode ? darkTheme : lightTheme;
  }

  get textFaintColor {
    var darkTheme = Color(0x5bffffff);
    var lightTheme = Color(0x99000000);
    return _isDarkMode ? darkTheme : lightTheme;
  }

  get iconColor {
    const darkTheme = Color(0x5bffffff);
    const lightTheme = Color(0xE2000000);
    return _isDarkMode ? darkTheme : lightTheme;
  }

  bool get isDarkMode => _isDarkMode;
}
