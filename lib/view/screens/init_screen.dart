import 'package:virtual_ggroceries/provider/adsProvider.dart';
import 'package:virtual_ggroceries/provider/cart_provider.dart';
import 'package:virtual_ggroceries/provider/products_provider.dart';
import 'package:virtual_ggroceries/provider/shared_pereferences_provider.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';
import 'package:virtual_ggroceries/view/screens/activities/cart_activity.dart';
import 'package:virtual_ggroceries/view/widgets/color_handler.dart';

import '../../provider/account_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'activities/init_activity.dart';
import 'activities/login_activity.dart';
import 'activities/registration_activity.dart';
import 'activities/search_activity.dart';

class initScreen extends StatefulWidget {
  @override
  _initScreenState createState() => _initScreenState();
}

class _initScreenState extends State<initScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (BuildContext context) => AccountProvider()),
        ChangeNotifierProvider(create: (BuildContext context) => AdsProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => AccountProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => ProductsProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => SharedPreferenceProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => CartProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          //color
          brightness: kBrightness,
          primaryColor: kPrimaryColor,
          accentColor: kAccentColor,
          scaffoldBackgroundColor: kScaffoldColor,

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
        ),
        initialRoute: InitActivity.id,
        routes: {
          InitActivity.id: (context) => InitActivity(),
          CartActivity.id: (context) => CartActivity(),
          SearchActivity.id: (context) => SearchActivity(),
          LoginActivity.id: (context) => LoginActivity(),
          RegistrationActivity.id: (context) => RegistrationActivity(),
        },
      ),
    );
  }
}
