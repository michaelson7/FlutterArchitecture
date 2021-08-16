import 'package:virtual_ggroceries/provider/shared_pereferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';

class ColorHandler {
  final bool isDarkModee;

  ColorHandler({this.isDarkModee = false});

  Color get cardBackground {
    var darkTheme = Color(0xED1F1F1F);
    var lightTheme = Color(0xFFE7E7E7);
    return isDarkModee ? darkTheme : lightTheme;
  }

  get cardBackgroundFaint {
    var darkTheme = Color(0xca7a7a7);
    var lightTheme = Color(0x66CACACA);
    return isDarkModee ? darkTheme : lightTheme;
  }

  get scaffoldColor {
    var darkTheme = Color(0xff151515);
    var lightTheme = Color(0xffffffff);
    return isDarkModee ? darkTheme : lightTheme;
  }

  get textFaintColor {
    var darkTheme = Color(0x5bffffff);
    var lightTheme = Color(0x99000000);
    return isDarkModee ? darkTheme : lightTheme;
  }

  get iconColor {
    const darkTheme = Color(0x5bffffff);
    const lightTheme = Color(0xE2000000);
    return isDarkModee ? darkTheme : lightTheme;
  }

  bool get isDarkMode => isDarkModee;
}

ThemeData themeState({required bool isDark}) {
  SharedPreferenceProvider _themeHandler = SharedPreferenceProvider();
  ColorHandler _themeData = ColorHandler(isDarkModee: isDark);
  kCardBackground = _themeData.cardBackground;
  kIconColor = _themeData.iconColor;
  kCardBackground = _themeData.cardBackground;
  kCardBackgroundFaint = _themeData.cardBackgroundFaint;
  kScaffoldColor = _themeData.scaffoldColor;
  kTextStyleFaint = TextStyle(color: _themeData.textFaintColor);

  //chnage sp
  _themeHandler.setTheme(isDarkTheme: isDark);
  return ThemeData(
//color
    brightness: _themeData.isDarkMode ? Brightness.dark : Brightness.light,
    primaryColor: kPrimaryColor,
    accentColor: kAccentColor,
    scaffoldBackgroundColor: _themeData.scaffoldColor,

//buttons
    buttonTheme: ButtonThemeData(
      buttonColor: kPrimaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          kPrimaryColor,
        ), //button color
        foregroundColor: MaterialStateProperty.all<Color>(
          Color(0xffffffff),
        ), //text (and icon)
      ),
    ),

//text
    fontFamily: 'Georgia',
    textTheme: TextTheme(
      headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      bodyText2: TextStyle(fontSize: 18.0, fontFamily: 'Georgia'),
    ),
  );
}
