import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:virtual_ggroceries/model/core/products_model.dart';
import 'package:virtual_ggroceries/model/core/user_order_model.dart';
import 'package:virtual_ggroceries/provider/account_provider.dart';
import 'package:virtual_ggroceries/provider/user_orders_provider.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';
import 'package:virtual_ggroceries/view/screens/activities/user_order_details.dart';
import 'package:virtual_ggroceries/view/widgets/order_cards.dart';

class UserOrderActivity extends StatefulWidget {
  static String id = 'UserOrderActivity';

  @override
  _UserOrderActivityState createState() => _UserOrderActivityState();
}

class _UserOrderActivityState extends State<UserOrderActivity> {
  UserOrdersProvider _userOrdersProvider = UserOrdersProvider();
  AccountProvider _accountProvider = AccountProvider();

  @override
  void initState() {
    _getUserOrders();
    super.initState();
  }

  _getUserOrders() async {
    int? userId = await _accountProvider.getUserId();
    if (userId != null) {
      _userOrdersProvider.getUserOrders(userId: userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Orders'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: orderListBuilder(),
          ),
        ),
      ),
    );
  }

  Widget orderListBuilder() {
    return StreamBuilder(
      stream: _userOrdersProvider.getStream,
      builder: (context, AsyncSnapshot<UserOrderModel> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            var data = snapshot.data;
            return cardLayout(data!);
          } else if (!snapshot.hasData) {
            return Center(
              child: Text('No Orders Made'),
            );
          }
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget cardLayout(UserOrderModel data) {
    var dataList = data.userModelList;
    return ListView.builder(
      itemCount: dataList.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        var productData =
            dataList[index].productsModel.productsModelList[index];
        var purchaseData = dataList[index];
        return OrderCards(
          productData: productData,
          purchaseData: purchaseData,
          function: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserOrderDetails(
                  productData: productData,
                  purchaseData: purchaseData,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
