import 'package:virtual_ggroceries/provider/adsProvider.dart';
import 'package:virtual_ggroceries/provider/cart_provider.dart';
import 'package:virtual_ggroceries/provider/payment_provider.dart';
import 'package:virtual_ggroceries/provider/products_provider.dart';
import 'package:virtual_ggroceries/provider/shared_pereferences_provider.dart';
import 'package:virtual_ggroceries/provider/user_orders_provider.dart';
import 'package:virtual_ggroceries/view/screens/activities/cart_activity.dart';
import 'package:virtual_ggroceries/view/widgets/color_handler.dart';

import '../../provider/account_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'activities/checkout_activity.dart';
import 'activities/init_activity.dart';
import 'activities/login_activity.dart';
import 'activities/profile_activity.dart';
import 'activities/registration_activity.dart';
import 'activities/search_activity.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';

import 'activities/user_order_activity.dart';
import 'activities/user_order_details.dart';

class initScreen extends StatefulWidget {
  @override
  _initScreenState createState() => _initScreenState();
}

class _initScreenState extends State<initScreen> {
  SharedPreferenceProvider _themeData = SharedPreferenceProvider();
  Future? currentTheme;

  @override
  void initState() {
    super.initState();
    currentTheme = _checkTheme();
  }

  _checkTheme() async {
    return await _themeData.isDarkMode();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: currentTheme,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          var _isDarkMode = snapshot.data;
          var initTheme = _isDarkMode
              ? themeState(isDark: true)
              : themeState(isDark: false);
          return initConstructer(initTheme);
        }
        return CircularProgressIndicator();
      },
    );
  }

  MultiProvider initConstructer(ThemeData initTheme) {
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
        ChangeNotifierProvider(
            create: (BuildContext context) => PaymentProvider()),
        ChangeNotifierProvider(
            create: (BuildContext context) => UserOrdersProvider()),
      ],
      child: ThemeProvider(
        initTheme: initTheme,
        builder: (_, myTheme) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: InitActivity.id,
            routes: {
              InitActivity.id: (context) => InitActivity(),
              CartActivity.id: (context) => CartActivity(),
              SearchActivity.id: (context) => SearchActivity(),
              LoginActivity.id: (context) => LoginActivity(),
              RegistrationActivity.id: (context) => RegistrationActivity(),
              UserOrderActivity.id: (context) => UserOrderActivity(),
              ProfileActivity.id: (context) => ProfileActivity(),
            },
          );
        },
      ),
    );
  }
}
