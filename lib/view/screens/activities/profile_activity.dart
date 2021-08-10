import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virtual_ggroceries/model/core/products_model.dart';
import 'package:virtual_ggroceries/model/core/shared_pereferences_model.dart';
import 'package:virtual_ggroceries/provider/account_provider.dart';
import 'package:virtual_ggroceries/provider/products_provider.dart';
import 'package:virtual_ggroceries/provider/shared_pereferences_provider.dart';
import 'package:virtual_ggroceries/provider/user_orders_provider.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';
import 'package:virtual_ggroceries/view/constants/enums.dart';
import 'package:virtual_ggroceries/view/screens/activities/profile_update_activity.dart';
import 'package:virtual_ggroceries/view/widgets/products_card_horizontal.dart';
import 'package:virtual_ggroceries/view/widgets/snapshot_handler.dart';

class ProfileActivity extends StatefulWidget {
  static String id = 'ProfileActivity';

  @override
  _ProfileActivityState createState() => _ProfileActivityState();
}

class _ProfileActivityState extends State<ProfileActivity> {
  ProductsProvider _productsProvider = ProductsProvider();
  AccountProvider _accountProvider = AccountProvider();
  UserOrdersProvider _userOrdersProvider = UserOrdersProvider();
  SharedPreferenceProvider sp = SharedPreferenceProvider();

  getWishList() async {
    var userId = await _accountProvider.getUserId();

    await _productsProvider.getProducts(
      filter: ProductFilters.wish_list,
      userId: userId,
    );
    await _userOrdersProvider.getUserOrders(userId: userId!);
  }

  @override
  void initState() {
    getWishList();
    super.initState();
  }

  logOutDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        sp.logOut();
        Navigator.of(context).pop();
      },
    );

    Widget noButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Logout"),
      content: Text("Are you sure you want to log out?"),
      actions: [okButton, noButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Account Details'),
          actions: [
            IconButton(
              onPressed: () {
                logOutDialog(context);
              },
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        body: buildSafeArea(),
        floatingActionButton: FloatingActionButton(
          elevation: 0.0,
          child: new Icon(Icons.edit),
          onPressed: () {
            Navigator.pushNamed(context, ProfileUpdateActivity.id);
          },
        ),
      ),
    );
  }

  SafeArea buildSafeArea() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              profilePhotoSection(),
              SizedBox(height: 15),
              reviewSection(),
              SizedBox(height: 30),
              userInfomrationCard(),
              SizedBox(height: 30),
              recentlyPurchasedItems(),
              SizedBox(height: 30),
              userWishList(),
            ],
          ),
        ),
      ),
    );
  }

  profilePhotoSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: kBorderRadiusCircular,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 70,
            backgroundImage: CachedNetworkImageProvider(
              'https://images.unsplash.com/photo-1568053681878-f758cb99e2b6?ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8YmxhY2slMjB3b21hbnxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
            ),
          ),
          SizedBox(height: 15),
          Text(
            'UserName',
            style: kTextStyleSubHeader,
          ),
          SizedBox(height: 10),
          Text(
            'Email',
            style: kTextStyleFaint,
          )
        ],
      ),
    );
  }

  reviewSection() {
    Column reviewTabs({required String header, required String subHeader}) {
      return Column(
        children: [
          Text(header),
          SizedBox(height: 10),
          Text(
            subHeader,
            style: kTextStyleFaint,
          ),
        ],
      );
    }

    return Container(
      child: Material(
        color: kCardBackground,
        borderRadius: kBorderRadiusCircular,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              reviewTabs(
                header: 'Orders made',
                subHeader: '5',
              ),
              reviewTabs(
                header: 'Review Made',
                subHeader: '55',
              ),
              reviewTabs(
                header: 'Wishlist Items',
                subHeader: '59',
              ),
            ],
          ),
        ),
      ),
    );
  }

  userInfomrationCard() {
    Row rowDesign({required String header, required String subHeader}) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$header:'),
          Text(
            subHeader,
            style: kTextStyleFaint,
          ),
        ],
      );
    }

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Information',
            style: kTextStyleHeader,
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            width: double.infinity,
            child: Material(
              color: kCardBackground,
              borderRadius: kBorderRadiusCircular,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    rowDesign(
                      header: 'Name',
                      subHeader: 'Michael Nawa',
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    rowDesign(
                      header: 'Email',
                      subHeader: 'Michaelnawa@email.com',
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    rowDesign(
                      header: 'Phone',
                      subHeader: '0978905095',
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    rowDesign(
                      header: 'Address',
                      subHeader: 'Woodlands Chalala',
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  userWishList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'WishList Items',
          style: kTextStyleHeader,
        ),
        SizedBox(
          height: 10,
        ),
        StreamBuilder(
          stream: _productsProvider.getWishListProductsStream,
          builder: (context, AsyncSnapshot<ProductsModel> snapshot) {
            return snapShotBuilder(
              snapshot: snapshot,
              widget: ProductsCardHorizontal(snapshot),
            );
          },
        ),
      ],
    );
  }

  recentlyPurchasedItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recently Purchased Items',
          style: kTextStyleHeader,
        ),
        SizedBox(
          height: 10,
        ),
        StreamBuilder(
          stream: _productsProvider.getWishListProductsStream,
          builder: (context, AsyncSnapshot<ProductsModel> snapshot) {
            return snapShotBuilder(
              snapshot: snapshot,
              widget: ProductsCardHorizontal(snapshot),
            );
          },
        ),
      ],
    );
  }
}
