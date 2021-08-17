import 'dart:math';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ggroceries/model/core/discount_modal.dart';
import 'package:virtual_ggroceries/provider/account_provider.dart';
import 'package:virtual_ggroceries/provider/cart_provider.dart';
import 'package:virtual_ggroceries/provider/discount_provider.dart';
import 'package:virtual_ggroceries/provider/gps_provider.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';
import 'package:virtual_ggroceries/view/screens/activities/checkout_activity.dart';
import 'package:virtual_ggroceries/view/widgets/custome_input_form.dart';
import 'package:virtual_ggroceries/view/widgets/get_location.dart';
import 'package:virtual_ggroceries/view/widgets/horizontal_evenly_spaced_widget.dart';
import 'package:virtual_ggroceries/view/widgets/logger_widget.dart';
import 'package:virtual_ggroceries/view/widgets/material_button.dart';
import 'package:virtual_ggroceries/view/widgets/padded_container.dart';
import 'package:virtual_ggroceries/view/widgets/snack_bar_builder.dart';
import 'package:geocoder/geocoder.dart';

class CartActivity extends StatefulWidget {
  static final String id = "CartActivity";
  const CartActivity({Key? key}) : super(key: key);

  @override
  _CartActivityState createState() => _CartActivityState();
}

class _CartActivityState extends State<CartActivity> {
  GPSProvider _gpsProvider = GPSProvider();
  DiscountProvider _discountProvider = DiscountProvider();
  AccountProvider _accountProvider = AccountProvider();

  final _formKey = GlobalKey<FormState>();
  final _discountKey = GlobalKey<FormState>();
  final _shippingKey = GlobalKey<FormState>();

  String? userName,
      userEmail,
      discountCode,
      userPhoneNumber,
      shippingCountry,
      shippingProvince,
      shippingCity,
      shippingAddress1,
      shippingAddress2;
  Address? addressData;
  late int userId;
  late double shippingCost = 0, productCost = 0, absoluteCost = 0;
  late bool isSignedIn = false,
      isBike = true,
      isProductDiscount = false,
      hasDiscount = false,
      isLoading = true,
      loadMore = false;
  dynamic discountCalculation = 0;

  _getUserData() async {
    var signedData = await _accountProvider.isSignedIn();
    var tempName,
        tempEmail,
        tempId,
        tempUserAddress1,
        tempPhone,
        tempCountry,
        tempProvince,
        tempCity,
        tempAddress2;
    if (signedData) {
      tempName = await _accountProvider.getUserName();
      tempEmail = await _accountProvider.getUserEmail();
      tempId = await _accountProvider.getUserId();
      tempUserAddress1 = await _accountProvider.getAddress1();
      tempPhone = await _accountProvider.getUserPhoneNumber();
      tempCountry = await _accountProvider.getCountry();
      tempProvince = await _accountProvider.getShippingProvince();
      tempCity = await _accountProvider.getCity();
      tempAddress2 = await _accountProvider.getAddress2();
    }
    setState(() {
      isSignedIn = signedData;
      userId = tempId;
      userEmail = tempEmail;
      userName = tempName;
      userPhoneNumber = tempPhone;
      shippingAddress1 = tempUserAddress1;
      shippingAddress2 = tempAddress2;
      shippingCountry = tempCountry;
      shippingProvince = tempProvince;
      shippingCity = tempCity;
    });
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    _getUserData();
    super.initState();
  }

  @override
  void dispose() {
    _discountProvider.dispose();
    _accountProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: ModalProgressHUD(
        inAsyncCall: loadMore,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Cart'),
          ),
          body: isLoading
              ? Center(child: CircularProgressIndicator())
              : SafeArea(
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
                            'Shipping Details',
                            style: kTextStyleSubHeader,
                          ),
                          SizedBox(height: 10),
                          Container(
                            child: shippingContainer(),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Discount Code',
                            style: kTextStyleSubHeader,
                          ),
                          SizedBox(height: 10),
                          Container(
                            child: discountContainer(),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Checkout',
                                style: kTextStyleSubHeader,
                              ),
                              hasDiscount
                                  ? Text(
                                      "Enjoy ZMW ${discountCalculation} Off your order!",
                                      style: TextStyle(color: kAccentColor),
                                    )
                                  : Container(),
                            ],
                          ),
                          SizedBox(height: 10),
                          Container(
                            child: costSection(),
                          ),
                          SizedBox(height: 25),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate() &&
                                    _shippingKey.currentState!.validate()) {
                                  if (await _getCoordinates()) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CheckOutActivity(
                                          deliverCost: shippingCost,
                                          productCost: productCost,
                                          absoluteCost: absoluteCost,
                                          hasDiscount: hasDiscount,
                                          discountPrice: discountCalculation,
                                          phoneNumber: '$userPhoneNumber',
                                          shippingAddress:
                                              '$shippingAddress1 ,$shippingAddress2 ,$shippingCity ,$shippingProvince ,$shippingCountry',
                                          country: '$shippingCountry',
                                        ),
                                      ),
                                    );
                                  }
                                } else {
                                  snackBarBuilder(
                                    context: context,
                                    message:
                                        "Please fill in all required fields",
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
      ),
    );
  }

  shippingContainer() {
    return PaddedContainer(
      child: Form(
        key: _shippingKey,
        child: Column(
          children: [
            customCardDesign(
              title: "Country",
              hintText: 'Country',
              errorText: 'Please enter country',
              initialText: shippingCountry,
              returnedValue: (value) {
                shippingCountry = value;
              },
            ),
            Row(
              children: [
                Expanded(
                  child: customCardDesign(
                    initialText: shippingProvince,
                    title: "Province",
                    hintText: 'Province',
                    errorText: 'Please enter province',
                    returnedValue: (value) {
                      shippingProvince = value;
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: customCardDesign(
                    initialText: shippingCity,
                    title: "City",
                    hintText: 'City',
                    errorText: 'Please enter city',
                    returnedValue: (value) {
                      shippingCity = value;
                    },
                  ),
                ),
              ],
            ),
            customCardDesign(
              initialText: shippingAddress1,
              title: "Address 1",
              hintText: 'e.g Woodlands',
              errorText: 'Please enter address 1',
              returnedValue: (value) {
                shippingAddress1 = value;
              },
            ),
            customCardDesign(
              initialText: shippingAddress2,
              title: "Address 2",
              hintText: 'e.g Plot 3256, chantumbu road',
              errorText: 'Please enter address 2',
              returnedValue: (value) {
                shippingAddress2 = value;
              },
            ),
          ],
        ),
      ),
    );
  }

  discountContainer() {
    changeLoadingStae() {
      setState(() {
        loadMore = !loadMore;
      });
    }

    void activeDiscountCode(BuildContext context, DiscountList modelData) {
      setState(() {
        hasDiscount = true;
      });
      snackBarBuilder(
        context: context,
        message:
            "Discount Code: '${modelData.title}' Applied ${modelData.discount_price} off",
      );
      discountCalculation = modelData.discount_price;
      if (modelData.target == "Products") {
        isProductDiscount = true;
      } else {
        isProductDiscount = false;
      }
    }

    Future _onPressMethod(BuildContext context) async {
      if (_discountKey.currentState!.validate()) {
        changeLoadingStae();

        var data = await _discountProvider.checkDiscountCode(
          discountCode: discountCode!,
        );
        var modelData = data.discountModal;

        if (modelData != null) {
          if (modelData.is_active == "True") {
            activeDiscountCode(context, modelData);
          } else {
            snackBarBuilder(
              context: context,
              message: "Discount Code: '${modelData.title}' Is no longer valid",
            );
          }
        } else {
          snackBarBuilder(
              context: context, message: "Invalid discount code entered");
        }

        changeLoadingStae();
      }
    }

    return PaddedContainer(
      child: Form(
        key: _discountKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: materialCard(
                child: CustomInputForm(
                  hintText: 'Discount Code',
                  errorText: 'Please enter code',
                  returnedParameter: (value) {
                    discountCode = value;
                  },
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _onPressMethod(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text('Apply Discount Code'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PaddedContainer costSection() {
    var provider = Provider.of<CartProvider>(context, listen: true);

    productCost = provider.getTotalCost();
    absoluteCost = productCost + shippingCost;

    //final params
    var isProduct = false, isShipping = false;
    var finalShippingCost, finalAbsoluteCost, finalProductCost;

    //values without discount
    var baseProductCost = productCost,
        baseShippingCost = shippingCost,
        baseAbsoluteCost = absoluteCost;

    //values with discount
    var newShippingCost, newProductCost, newAbsoluteCost;
    dynamic costWidget, absoluteCostWidget;

    if (hasDiscount) {
      if (isProductDiscount) {
        setState(() {
          isProduct = true;
          isShipping = false;
        });

        newProductCost = productCost - discountCalculation;
        newAbsoluteCost = newProductCost + shippingCost;

        finalProductCost = newProductCost;
        finalAbsoluteCost = newAbsoluteCost;
        finalShippingCost = baseShippingCost;

        costWidget = Row(
          children: [
            Text('Cart Items: ZMW ${finalProductCost.toStringAsFixed(2)}'),
            SizedBox(width: 30),
            Text(
              'ZMW ${baseProductCost.toStringAsFixed(2)}',
              style: kTextStyleFaint.copyWith(
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ],
        );
      } else {
        setState(() {
          isShipping = true;
          isProduct = false;
        });
        newShippingCost = shippingCost - discountCalculation;
        newAbsoluteCost = productCost + newShippingCost;

        finalProductCost = baseProductCost;
        finalAbsoluteCost = newAbsoluteCost;
        finalShippingCost = newShippingCost;

        costWidget = Row(
          children: [
            Text('Shipping: ZMW ${finalShippingCost.toStringAsFixed(2)}'),
            SizedBox(width: 30),
            Text(
              'ZMW ${baseShippingCost.toStringAsFixed(2)}',
              style: kTextStyleFaint.copyWith(
                decoration: TextDecoration.lineThrough,
              ),
            ),
          ],
        );
      }
    } else {
      finalProductCost = baseProductCost;
      finalAbsoluteCost = baseAbsoluteCost;
      finalShippingCost = baseShippingCost;
    }

    absoluteCostWidget = Row(
      children: [
        Text('Total Cost: ZMW ${finalAbsoluteCost.toStringAsFixed(2)}'),
        SizedBox(width: 30),
        Text(
          'ZMW ${baseAbsoluteCost.toStringAsFixed(2)}',
          style: kTextStyleFaint.copyWith(
            decoration: TextDecoration.lineThrough,
          ),
        ),
      ],
    );

    return PaddedContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isProduct
              ? costWidget
              : Text('Cart Items: ZMW ${finalProductCost.toStringAsFixed(2)}'),
          paddedDivider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isShipping
                  ? costWidget
                  : Text(
                      'Shipping: ZMK ${finalShippingCost.toStringAsFixed(2)}',
                    ),
              isBike
                  ? Icon(Icons.electric_bike_outlined)
                  : Icon(FontAwesomeIcons.car)
            ],
          ),
          paddedDivider(),
          isProductDiscount
              ? absoluteCostWidget
              : Text(
                  'Total Cost: ZMW ${finalAbsoluteCost.toStringAsFixed(2)}',
                )
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
                labelText: userName!,
                hintText: 'Enter Names',
                errorText: 'Please enter Names',
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
                labelText: userEmail!,
                returnedParameter: (value) {},
              ),
            ),
            SizedBox(height: 10),
            customCardDesign(
              initialText: userPhoneNumber,
              title: "Phone Number",
              hintText: "Enter Phone Number",
              errorText: "Please Enter Phone Number",
              returnedValue: (value) {
                userPhoneNumber = value;
              },
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
        physics: NeverScrollableScrollPhysics(),
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
                          'ZMW ${data.price}',
                          style: kTextStyleFaint,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'qty: ${data.orderQuantity}',
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

  _getCoordinates() async {
    setState(() => loadMore = true);
    var userAddress =
        '$shippingAddress1 ,$shippingCity ,$shippingProvince ,$shippingCountry';
    var cartSize = Provider.of<CartProvider>(
      context,
      listen: false,
    ).getItemSize();
    if (cartSize > 20) {
      isBike = false;
    }
    _gpsProvider.setBike(isBike);

    try {
      var coordinates = await _gpsProvider.getCoordinates(
        address: userAddress,
      );
      var location = await _gpsProvider.getSpecificLocation(coordinates);
      addressData = location;
      var data = await _gpsProvider.getShippingCharge(coordinates);
      setState(() => shippingCost = data);
      setState(() => loadMore = false);
      return true;
    } catch (e) {
      snackBarBuilder(context: context, message: "$e");
      loggerInfo(message: "EXCEPTION: $e");
      setState(() => loadMore = false);
      return false;
    }
  }

  Padding paddedDivider() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Divider(color: Color(0xfffffff)),
    );
  }

  Column customCardDesign({
    TextEditingController? controller,
    required title,
    required hintText,
    required errorText,
    required initialText,
    required Function(String) returnedValue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: kTextStyleFaint,
        ),
        SizedBox(height: 5),
        materialCard(
          child: CustomInputForm(
            labelText: initialText,
            controller: controller,
            hintText: hintText,
            errorText: errorText,
            returnedParameter: (value) {
              returnedValue(value);
            },
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
