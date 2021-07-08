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
import 'package:virtual_ggroceries/view/widgets/get_location.dart';
import 'package:virtual_ggroceries/view/widgets/material_button.dart';
import 'package:virtual_ggroceries/view/widgets/padded_container.dart';
import 'package:virtual_ggroceries/view/widgets/snack_bar_builder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';

class CartActivity extends StatefulWidget {
  static final String id = "CartActivity";
  const CartActivity({Key? key}) : super(key: key);

  @override
  _CartActivityState createState() => _CartActivityState();
}

class _CartActivityState extends State<CartActivity> {
  final _formKey = GlobalKey<FormState>();
  AccountProvider _accountProvider = AccountProvider();
  var locationController = TextEditingController(),
      namesController = TextEditingController(),
      emailController = TextEditingController();
  late int userId;
  late bool isSignedIn = false;
  Address? addressData;

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
      isSignedIn = signedData;
      namesController.text = tempName!;
      emailController.text = tempEmail;
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
                        if (addressData == null) {
                          snackBarBuilder(
                              context: context,
                              message: 'Please select location');
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckOutActivity(
                                addressData: addressData!,
                              ),
                            ),
                          );
                        }
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
          Text('Overall Cost: ZMW ${provider.getTotalCost()}')
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
                controller: namesController,
                returnedParameter: (value) {},
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Email',
              style: kTextStyleFaint,
            ),
            SizedBox(height: 5),
            materialCard(
              child: CustomInputForm(
                hintText: 'Enter Names',
                errorText: 'Please enter Email',
                controller: emailController,
                returnedParameter: (value) {},
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Location',
              style: kTextStyleFaint,
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: materialCard(
                    child: CustomInputForm(
                      hintText: 'Enter Location',
                      errorText: 'Please enter location',
                      controller: locationController,
                      returnedParameter: (value) {},
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    color: kCardBackground,
                    borderRadius: kBorderRadiusCircular,
                    child: IconButton(
                      onPressed: () async {
                        _getCoordinates();
                      },
                      icon: Icon(Icons.my_location),
                    ),
                  ),
                )
              ],
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

  void _getCoordinates() async {
    getUserCoordinates().then((value) async {
      _getActualLocation(value);
    }).catchError((error) {
      print('Coordinates ERROR: $error');
      snackBarBuilder(context: context, message: error.toString());
    });
  }

  _getActualLocation(var coordinates) {
    getActualLocation(coordinates).then((value) async {
      var fullAdress = "${value.featureName} : ${value.addressLine}";
      locationController.text = fullAdress;
      addressData = value;
    }).catchError((error) {
      print('LOCATION ERROR: $error');
      snackBarBuilder(context: context, message: error.toString());
    });
  }

  Padding paddedDivider() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Divider(color: Color(0xfffffff)),
    );
  }
}
