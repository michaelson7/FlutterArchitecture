import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:virtual_ggroceries/model/core/products_model.dart';
import 'package:virtual_ggroceries/model/core/user_order_activity_model.dart';
import 'package:virtual_ggroceries/provider/account_provider.dart';
import 'package:virtual_ggroceries/provider/products_provider.dart';
import 'package:virtual_ggroceries/provider/shared_pereferences_provider.dart';
import 'package:virtual_ggroceries/provider/user_orders_provider.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';
import 'package:virtual_ggroceries/view/constants/enums.dart';
import 'package:virtual_ggroceries/view/screens/activities/profile_update_activity.dart';
import 'package:virtual_ggroceries/view/widgets/products_card_horizontal.dart';
import 'package:virtual_ggroceries/view/widgets/shimmers.dart';
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
  bool isLoading = true;
  String? userName,
      userEmail,
      userPhoneNumber,
      shippingAddress1,
      shippingAddress2;

  getData() async {
    var userId = await _accountProvider.getUserId();
    await _userOrdersProvider.getUserOrder(
      userId: userId!,
      transactionId: '',
      filter: UserOrders.fetchUserOrders,
    );
    await _productsProvider.getProducts(
      filter: ProductFilters.wish_list,
      userId: userId,
    );
    await _userOrdersProvider.getCustomerData(userId: userId);
    userName = await _accountProvider.getUserName();
    userEmail = await _accountProvider.getUserEmail();
    userPhoneNumber = await _accountProvider.getUserPhoneNumber();
    shippingAddress1 = await _accountProvider.getAddress1();
    shippingAddress2 = await _accountProvider.getAddress2();
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _accountProvider.dispose();
    _productsProvider.dispose();
    _userOrdersProvider.dispose();
  }

  logOutDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        sp.logOut();
        Navigator.of(context).pop();
        Navigator.pop(context, true);
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
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : buildSafeArea(),
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
              userInformationCard(),
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
              'https://images.unsplash.com/photo-1496115965489-21be7e6e59a0?ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTd8fGN1c3RvbWVyfGVufDB8fDB8fA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
            ),
          ),
          SizedBox(height: 15),
          Text(
            '$userName',
            style: kTextStyleSubHeader,
          ),
          SizedBox(height: 10),
          Text(
            '$userEmail',
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
          Text(
            header,
            style: kTextStyleSubHeader,
          ),
          SizedBox(height: 10),
          Text(
            subHeader,
            style: kTextStyleFaint,
          ),
        ],
      );
    }

    cardBuilder(AsyncSnapshot<CustomerDataModal> snapshot) {
      if (snapshot.data != null) {
        var modal = snapshot.data!.accountModelList;
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
                    header: 'Transactions',
                    subHeader: modal!.transactionCount,
                  ),
                  reviewTabs(
                    header: 'Orders',
                    subHeader: modal.ordersCount,
                  ),
                  reviewTabs(
                    header: 'Wish-list',
                    subHeader: modal.wishlistCount,
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }

    return StreamBuilder(
      stream: _userOrdersProvider.customerDataStream,
      builder: (context, AsyncSnapshot<CustomerDataModal> snapshot) {
        return snapShotBuilder(
          snapshot: snapshot,
          shimmer: productCardGridShimmer(displayTwo: true),
          widget: cardBuilder(snapshot),
        );
      },
    );
  }

  userInformationCard() {
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
                      subHeader: '$userName',
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    rowDesign(
                      header: 'Email',
                      subHeader: '$userEmail',
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    rowDesign(
                      header: 'Phone',
                      subHeader: userPhoneNumber ?? '',
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    rowDesign(
                      header: 'Address',
                      subHeader: shippingAddress1 ?? '',
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
              shimmer: productCardGridShimmer(displayTwo: true),
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
          stream: _userOrdersProvider.ordersStream,
          builder: (context, AsyncSnapshot<ProductsModel> snapshot) {
            return snapShotBuilder(
              snapshot: snapshot,
              shimmer: productCardGridShimmer(displayTwo: true),
              widget: ProductsCardHorizontal(snapshot),
            );
          },
        ),
      ],
    );
  }
}
