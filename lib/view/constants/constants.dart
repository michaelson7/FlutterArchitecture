import 'package:flutter/material.dart';
import 'package:virtual_ggroceries/view/widgets/color_handler.dart';

//colors
ColorHandler _themeData = ColorHandler();

const kAccentColor = Color(0xff264653);
const kPrimaryColor = Color(0xff264653);

Color kIconColor = _themeData.iconColor;
Color kCardBackground = _themeData.cardBackground;
Color kCardBackgroundFaint = _themeData.cardBackgroundFaint;
Color kScaffoldColor = _themeData.scaffoldColor;
Brightness kBrightness =
    _themeData.isDarkMode ? Brightness.dark : Brightness.light;

//other consts
const kTextStyleHeader = TextStyle(fontSize: 22, fontWeight: FontWeight.bold);
const kTextStyleSubHeader =
    TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
TextStyle kTextStyleFaint = TextStyle(color: _themeData.textFaintColor);
const kImageRadiusTop = BorderRadius.only(
  topLeft: Radius.circular(8),
  topRight: Radius.circular(8),
);
const kBorderRadiusCircular = BorderRadius.all(Radius.circular(8));
