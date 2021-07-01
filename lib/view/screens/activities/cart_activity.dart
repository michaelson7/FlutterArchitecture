import 'dart:math';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ggroceries/provider/account_provider.dart';
import 'package:virtual_ggroceries/provider/cart_provider.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';
import 'package:virtual_ggroceries/view/screens/activities/checkout_activity.dart';
import 'package:virtual_ggroceries/view/widgets/custome_input_form.dart';
import 'package:virtual_ggroceries/view/widgets/material_button.dart';
import 'package:virtual_ggroceries/view/widgets/padded_container.dart';
import 'package:virtual_ggroceries/view/widgets/snack_bar_builder.dart';

class CartActivity extends StatefulWidget {
  static final String id = "CartActivity";
  const CartActivity({Key? key}) : super(key: key);

  @override
  _CartActivityState createState() => _CartActivityState();
}

class _CartActivityState extends State<CartActivity> {
  final _formKey = GlobalKey<FormState>();
  AccountProvider _accountProvider = AccountProvider();
  late String names, email, location, userId;

  @override
  void initState() {
    _getUserData();
    super.initState();
  }

  _getUserData() async {
    var signedData = await _accountProvider.isSignedIn();
    var tempName, tempEmail, tempId;
    if (signedData) {
      tempName = await _accountProvider.getUserName();
      tempEmail = await _accountProvider.getUserEmail();
      tempId = await _accountProvider.getUserId();
    }

    setState(() {
      names = tempName!;
      email = tempEmail;
      tempEmail = tempEmail;
      userId = tempId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Cart'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selected Items',
                    style: kTextStyleSubHeader,
                  ),
                  SizedBox(height: 10),
                  PaddedContainer(
                    child: cartItemList(context),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Personal Information',
                    style: kTextStyleSubHeader,
                  ),
                  SizedBox(height: 10),
                  PaddedContainer(
                    child: personalInfoCard(),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Checkout',
                    style: kTextStyleSubHeader,
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: costSection(),
                  ),
                  SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, CheckOutActivity.id);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text('CHECKOUT'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  PaddedContainer costSection() {
    var provider = Provider.of<CartProvider>(context, listen: true);
    var rng = new Random();

    return PaddedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Cost: ZMW ${provider.getTotalCost()}'),
          paddedDivider(),
          Text('Tax: 15%'),
          paddedDivider(),
          Text('Discounts: 3%'),
          paddedDivider(),
          Text(
              'Overall Cost: ZMW ${provider.getTotalCost() + rng.nextInt(300)}')
        ],
      ),
    );
  }

  Container personalInfoCard() {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Names',
              style: kTextStyleFaint,
            ),
            SizedBox(height: 5),
            materialCard(
              child: CustomInputForm(
                hintText: 'Enter Names',
                errorText: 'Please enter Names',
                returnedParameter: (value) {
                  names = value;
                },
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Email',
              style: kTextStyleFaint,
            ),
            SizedBox(height: 5),
            materialCard(
              child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: 'Enter Email'),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Location',
              style: kTextStyleFaint,
            ),
            SizedBox(height: 5),
            materialCard(
              child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: 'Enter Location'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget cartItemList(BuildContext context) {
    var provider = Provider.of<CartProvider>(context, listen: true);
    if (provider.hasData()) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount:
            Provider.of<CartProvider>(context, listen: true).getItemSize(),
        itemBuilder: (BuildContext context, int index) {
          var data =
              Provider.of<CartProvider>(context, listen: true).list[index];
          return Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ClipRRect(
                      borderRadius: kBorderRadiusCircular,
                      child: CachedNetworkImage(
                        imageUrl: data.imgPath,
                        fit: BoxFit.cover,
                        height: 100,
                        width: 100,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data.name),
                        SizedBox(height: 10),
                        Text(
                          'ZMW ${data.price} $index',
                          style: kTextStyleFaint,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      onPressed: () {
                        if (Provider.of<CartProvider>(context, listen: false)
                            .removeFromCart(index)) {
                          snackBarBuilder(
                              context: context,
                              message: '${data.name} removed from cart');
                        }
                      },
                      icon: Icon(Icons.delete),
                    ),
                  ),
                ],
              ),
              Divider(
                color: Color(0xfffffff),
              )
            ],
          );
        },
      );
    } else {
      return Center(child: Text('No Item Added To Cart'));
    }
  }

  Padding paddedDivider() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Divider(color: Color(0xfffffff)),
    );
  }
}
