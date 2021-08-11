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
  GPSProvider _gpsProvider = GPSProvider();
  DiscountProvider _discountProvider = DiscountProvider();
  AccountProvider _accountProvider = AccountProvider();

  var locationController = TextEditingController(),
      namesController = TextEditingController(),
      discountController = TextEditingController(),
      emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _discountKey = GlobalKey<FormState>();

  String discountCode = "";
  Address? addressData;
  late int userId;
  late double shippingCost = 0, productCost = 0, absoluteCost = 0;
  late bool isSignedIn = false,
      isBike = true,
      isProductDiscount = false,
      hasDiscount = false,
      isloading = false;
  dynamic discountCalculation = 0;

  @override
  void initState() {
    _getUserData();
    _getUserLocation();
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

  _getUserLocation() async {
    _getCoordinates();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: ModalProgressHUD(
        inAsyncCall: isloading,
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
                                  deliverCost: shippingCost,
                                  productCost: productCost,
                                  absoluteCost: absoluteCost,
                                  hasDiscount: hasDiscount,
                                  discountPrice: discountCalculation,
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
      ),
    );
  }

  discountContainer() {
    changeLoadingStae() {
      setState(() {
        isloading = !isloading;
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
            discountCode: discountCode);
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
                  controller: discountController,
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
        Text('Overall Cost: ZMW ${finalAbsoluteCost.toStringAsFixed(2)}'),
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
                  'Overall Cost: ZMW ${finalAbsoluteCost.toStringAsFixed(2)}',
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

  void _getCoordinates() async {
    var cartSize =
        Provider.of<CartProvider>(context, listen: false).getItemSize();
    if (cartSize > 20) {
      isBike = false;
    }
    print("ISBIKE: $isBike");
    _gpsProvider.setBike(isBike);

    var coordinates = await _gpsProvider.getCoordinates();
    var location = await _gpsProvider.getSpecificLocation(coordinates);
    locationController.text = location.addressLine;
    addressData = location;
    var data = await _gpsProvider.getShippingCharge(coordinates);
    setState(() {
      shippingCost = data;
    });
  }

  Padding paddedDivider() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Divider(color: Color(0xfffffff)),
    );
  }
}
