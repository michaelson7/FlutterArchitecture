import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ggroceries/model/core/products_model.dart';
import 'package:virtual_ggroceries/model/core/user_order_model.dart';
import 'package:virtual_ggroceries/provider/account_provider.dart';
import 'package:virtual_ggroceries/provider/products_provider.dart';
import 'package:virtual_ggroceries/provider/shared_pereferences_provider.dart';
import 'package:virtual_ggroceries/provider/user_orders_provider.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';
import 'package:virtual_ggroceries/view/screens/activities/user_order_details.dart';
import 'package:virtual_ggroceries/view/widgets/empty_handler.dart';
import 'package:virtual_ggroceries/view/widgets/order_cards.dart';
import 'package:virtual_ggroceries/view/widgets/sign_in_promt.dart';
import 'package:virtual_ggroceries/view/widgets/snapshot_handler.dart';

class UserOrderActivity extends StatefulWidget {
  static String id = 'UserOrderActivity';

  @override
  _UserOrderActivityState createState() => _UserOrderActivityState();
}

class _UserOrderActivityState extends State<UserOrderActivity> {
  UserOrdersProvider _userOrdersProvider = UserOrdersProvider();
  AccountProvider _accountProvider = AccountProvider();
  SharedPreferenceProvider _sp = SharedPreferenceProvider();
  bool isSignedIn = false, isLoading = true, loadMore = false;
  int page = 1;
  int userId = 0;

  @override
  void dispose() {
    super.dispose();
    _userOrdersProvider.dispose();
    _accountProvider.dispose();
  }

  @override
  void initState() {
    _getUserOrders();
    super.initState();
  }

  _getUserOrders() async {
    var isLoggedIn = await _sp.isLoggedIn();
    if (isLoggedIn) {
      userId = (await _accountProvider.getUserId())!;
      await _userOrdersProvider.getUserTransaction(userId: userId);
      setState(() {
        isSignedIn = true;
      });
    } else {
      setState(() => isSignedIn = false);
    }
    setState(() => isLoading = false);
  }

  _loadMore() async {
    page++;
    setState(() => loadMore = true);
    await _userOrdersProvider.updateTransaction(userId: userId, page: page);
    setState(() => loadMore = false);
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Orders'),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : SafeArea(
                child: LazyLoadScrollView(
                  onEndOfPage: () => _loadMore(),
                  isLoading: loadMore,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: isSignedIn
                        ? orderListBuilder()
                        : signInPromte(message: "Sign in to view orders"),
                  ),
                ),
              ),
      ),
    );
  }

  Widget orderListBuilder() {
    return SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder(
            stream: _userOrdersProvider.getStream,
            builder: (context, AsyncSnapshot<UserOrderModel> snapshot) {
              var data = snapshot.data;
              return snapShotBuilder(
                snapshot: snapshot,
                emptyMessage: "No Orders Made",
                widget: cardLayout(data),
              );
            },
          ),
          loadMore
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(),
                )
              : Container()
        ],
      ),
    );
  }

  Widget cardLayout(UserOrderModel? data) {
    if (data != null) {
      var dataList = data.userModelList;
      return ListView.builder(
        itemCount: dataList.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          var transactionData = dataList[index];
          return Container(
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserOrderDetails(
                          transactionData: transactionData,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: kBorderRadiusCircular,
                        child: CachedNetworkImage(
                          imageUrl: transactionData.thumbnail,
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Status: ${transactionData.status}",
                                  style: kTextStyleHeader,
                                ),
                                Text(
                                  "Items Ordered:${transactionData.orderCount}\n"
                                  "ID: ${transactionData.transId}",
                                  style: kTextStyleFaint,
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'ZMK ${transactionData.total}',
                                        style: kTextStyleSubHeader,
                                      ),
                                    ),
                                    Text(
                                      transactionData.timeStamp,
                                      style: kTextStyleFaint,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Divider(
                    color: kCardBackground,
                  ),
                )
              ],
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
