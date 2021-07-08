import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ggroceries/provider/account_provider.dart';
import 'package:virtual_ggroceries/provider/cart_provider.dart';
import 'package:virtual_ggroceries/provider/payment_provider.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';
import 'package:virtual_ggroceries/view/widgets/flutterwave_checkout.dart';
import 'package:virtual_ggroceries/view/widgets/material_button.dart';
import 'package:virtual_ggroceries/view/widgets/snack_bar_builder.dart';

class CheckOutActivity extends StatefulWidget {
  static final String id = "CheckOutActivity";
  final Address addressData;

  const CheckOutActivity({
    Key? key,
    required this.addressData,
  }) : super(key: key);

  @override
  _CheckOutActivityState createState() => _CheckOutActivityState();
}

class _CheckOutActivityState extends State<CheckOutActivity> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  StepperType stepperType = StepperType.horizontal;
  AccountProvider _accountProvider = AccountProvider();
  var locationController = TextEditingController(),
      namesController = TextEditingController(),
      emailController = TextEditingController();
  String names = '',
      email = '',
      location = '',
      phoneNumber = '',
      province = '',
      address = '';
  int userId = 0;

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
      userId = tempId;
      namesController.text = tempName!;
      emailController.text = tempEmail;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Checkout'),
        ),
        body: Container(
          child: Column(
            children: [
              Expanded(
                child: Stepper(
                  type: stepperType,
                  physics: ScrollPhysics(),
                  currentStep: _currentStep,
                  onStepTapped: (step) => tapped(step),
                  onStepContinue: continued,
                  onStepCancel: cancel,
                  steps: <Step>[
                    Step(
                      title: Text('Shipping'),
                      content: shippingContainer(),
                      isActive: _currentStep == 0,
                      state: _currentStep >= 0
                          ? StepState.complete
                          : StepState.disabled,
                    ),
                    Step(
                      title: Text('Confirm'),
                      content: confirmationSection(context),
                      isActive: _currentStep == 1,
                      state: _currentStep >= 1
                          ? StepState.complete
                          : StepState.disabled,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.list),
          onPressed: switchStepsType,
        ),
      ),
    );
  }

  Container shippingContainer() {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'CONTACT DETAILS',
              style: kTextStyleSubHeader,
            ),
            SizedBox(height: 10),
            borderCard(
              title: 'Email Address',
              controller: emailController,
              errorText: 'please enter email',
              returnedParameter: (value) {
                email = value;
              },
            ),
            SizedBox(height: 8),
            borderCard(
              title: 'Name',
              controller: namesController,
              errorText: 'please enter name',
              returnedParameter: (value) {
                names = value;
              },
            ),
            SizedBox(height: 8),
            borderCard(
              title: 'Phone Number',
              controller: null,
              errorText: 'please enter phoneNumber',
              returnedParameter: (value) {
                phoneNumber = value;
              },
            ),
            SizedBox(height: 15),
            Text(
              'Shipping Address',
              style: kTextStyleSubHeader,
            ),
            SizedBox(height: 10),
            borderCard(
              title: 'Address',
              controller: null,
              errorText: 'please enter address',
              initialValue: widget.addressData.addressLine,
              returnedParameter: (value) {
                address = value;
              },
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: borderCard(
                    title: 'Country',
                    controller: null,
                    initialValue: widget.addressData.countryName,
                    errorText: 'please enter province',
                    returnedParameter: (value) {
                      province = value;
                    },
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: borderCard(
                    title: 'ZIP CODE',
                    controller: null,
                    initialValue: widget.addressData.postalCode,
                    errorText: 'please enter zip code',
                    returnedParameter: (value) {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container confirmationSection(BuildContext context) {
    var provider = Provider.of<CartProvider>(context, listen: true);
    Widget cartItemList() {
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
                            data.quantity.toString(),
                            style: kTextStyleFaint,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'ZMW ${data.price} $index',
                        style: TextStyle(color: kAccentColor),
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

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PRODUCT ORDER:',
            style: kTextStyleFaint,
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: materialCard(
              child: cartItemList(),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Product Cost',
                  style: kTextStyleFaint,
                ),
              ),
              Text('ZMW ${provider.getTotalCost()}'),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Delivery Cost',
                  style: kTextStyleFaint,
                ),
              ),
              Text('ZMW 20.50'),
            ],
          ),
        ],
      ),
    );
  }

  Container borderCard(
      {required String title,
      required String errorText,
      String? initialValue,
      required Function(String) returnedParameter,
      required final controller}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: kBorderRadiusCircular,
        border: Border.all(
          color: kCardBackground,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: TextFormField(
            controller: controller,
            initialValue: initialValue,
            decoration: InputDecoration(
              border: InputBorder.none,
              labelText: title,
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return errorText;
              } else {
                returnedParameter(value);
              }
              return null;
            }),
      ),
    );
  }

  switchStepsType() {
    setState(() => stepperType == StepperType.vertical
        ? stepperType = StepperType.horizontal
        : stepperType = StepperType.vertical);
  }

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() async {
    if (_currentStep < 1) {
      if (_formKey.currentState!.validate()) {
        setState(() => _currentStep += 1);
      }
    } else if (_currentStep == 1) {
      var provider = Provider.of<CartProvider>(context, listen: false);
      FlutterWaveCheckout _flutterCheckout = FlutterWaveCheckout(
        name: names,
        email: email,
        phoneNumber: phoneNumber,
        amount: provider.getTotalCost().toString(),
        context: context,
        userId: userId,
        productList: provider.list,
        distId: 2,
        address: address,
      );

      await _flutterCheckout.beginPayment();
    }
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }
}
