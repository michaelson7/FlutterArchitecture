import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ggroceries/provider/account_provider.dart';
import 'package:virtual_ggroceries/provider/cart_provider.dart';
import 'package:virtual_ggroceries/provider/gps_provider.dart';
import 'package:virtual_ggroceries/provider/payment_provider.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';
import 'package:virtual_ggroceries/view/constants/enums.dart';
import 'package:virtual_ggroceries/view/widgets/flutterwave_checkout.dart';
import 'package:virtual_ggroceries/view/widgets/horizontal_evenly_spaced_widget.dart';
import 'package:virtual_ggroceries/view/widgets/logger_widget.dart';
import 'package:virtual_ggroceries/view/widgets/material_button.dart';
import 'package:virtual_ggroceries/view/widgets/outlines_textformfield.dart';
import 'package:virtual_ggroceries/view/widgets/snack_bar_builder.dart';

enum SingingCharacter { Carrier, Standard }

class CheckOutActivity extends StatefulWidget {
  static final String id = "CheckOutActivity";
  final String phoneNumber;
  final double productCost, absoluteCost;
  final bool hasDiscount;
  final dynamic discountPrice;

  const CheckOutActivity(
      {Key? key,
      required this.productCost,
      required this.absoluteCost,
      this.hasDiscount = false,
      this.discountPrice = 0,
      required this.phoneNumber})
      : super(key: key);

  @override
  _CheckOutActivityState createState() => _CheckOutActivityState();
}

class _CheckOutActivityState extends State<CheckOutActivity> {
  final _formKey = GlobalKey<FormState>();
  StepperType stepperType = StepperType.horizontal;
  GPSProvider _gpsProvider = GPSProvider();
  AccountProvider _accountProvider = AccountProvider();

  var locationController = TextEditingController(),
      namesController = TextEditingController(),
      emailController = TextEditingController(),
      displayedDate = TextEditingController();

  double finalAbsoluteCost = 0,
      deliverCost = 0,
      carrierCost = 0,
      standardCost = 0;
  int _currentStep = 0, userId = 0;
  String names = '',
      coordinatesValue = '',
      email = '',
      location = '',
      phoneNumber = '',
      province = '',
      address = '',
      country = '',
      shippingAddress = '';
  bool isLoading = true;
  SingingCharacter? _character = SingingCharacter.Carrier;
  var deliveryCosts;

  @override
  void initState() {
    _getUserData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _accountProvider.dispose();
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
    await _getUserLocation();
  }

  _getUserLocation() async {
    bool isBike = false;
    var cartSize =
        Provider.of<CartProvider>(context, listen: false).getItemSize();
    if (cartSize > 20) {
      isBike = false;
    }
    _gpsProvider.setBike(isBike);
    try {
      var coordinates = await _gpsProvider.getCoordinates();
      var location = await _gpsProvider.getSpecificLocation(coordinates);
      deliveryCosts = await _gpsProvider.getShippingCharge(coordinates);
      setState(() {
        coordinatesValue = coordinates.toString();
        shippingAddress = location.addressLine;
        country = location.countryName;
        carrierCost = deliveryCosts[0];
        standardCost = deliveryCosts[1];

        //TODO: if count > 20 switch to car by default
        deliverCost = carrierCost;

        isLoading = false;
      });
      await _calculateDiscountPrice();
      return true;
    } catch (e) {
      setState(() => isLoading = false);
      snackBarBuilder(context: context, message: "$e");
      loggerInfo(message: "EXCEPTION: $e");
      return false;
    }
  }

  _calculateDiscountPrice() async {
    finalAbsoluteCost += deliverCost;
    if (widget.hasDiscount) {
      setState(() =>
          finalAbsoluteCost += widget.absoluteCost - widget.discountPrice);
    } else {
      setState(() => finalAbsoluteCost += widget.absoluteCost);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Checkout'),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : buildContainer(context),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.list),
          onPressed: switchStepsType,
        ),
      ),
    );
  }

  //main body
  Container buildContainer(BuildContext context) {
    return Container(
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
    );
  }

  //shipping Tab
  Container shippingContainer() {
    DateTime now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    displayedDate.text = formattedDate;

    var contentDetailsTab = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CONTACT DETAILS',
          style: kTextStyleSubHeader,
        ),
        SizedBox(height: 10),
        outlinedTextFormField(
          title: 'Email Address',
          controller: emailController,
          errorText: 'please enter email',
          returnedParameter: (value) {
            email = value;
          },
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: outlinedTextFormField(
                title: 'Name',
                controller: namesController,
                errorText: 'please enter name',
                returnedParameter: (value) {
                  names = value;
                },
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: outlinedTextFormField(
                title: 'Phone Number',
                initialValue: widget.phoneNumber,
                errorText: 'please enter phoneNumber',
                controller: null,
                returnedParameter: (value) {
                  phoneNumber = value;
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 30),
      ],
    );
    var shippingAddressTab = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Shipping Address',
          style: kTextStyleSubHeader,
        ),
        SizedBox(height: 10),
        outlinedTextFormField(
          title: 'Address',
          controller: null,
          errorText: 'please enter address',
          initialValue: shippingAddress,
          returnedParameter: (value) {
            address = value;
          },
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: outlinedTextFormField(
                title: 'Country',
                controller: null,
                initialValue: country,
                errorText: 'please enter province',
                returnedParameter: (value) {
                  province = value;
                },
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: outlinedTextFormField(
                title: 'ZIP CODE',
                controller: null,
                initialValue: "0000",
                errorText: 'please enter zip code',
                returnedParameter: (value) {},
              ),
            ),
          ],
        ),
        SizedBox(height: 30),
      ],
    );
    var shippingOptionsTab = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Shipping Options',
          style: kTextStyleSubHeader,
        ),
        SizedBox(height: 10),
        shippingOptionsContainer(
          icon: Icons.electric_bike,
          title: SingingCharacter.Carrier,
          price: carrierCost.toStringAsFixed(2),
          onChange: (value) {
            snackBarBuilder(context: context, message: value.toString());
          },
        ),
        shippingOptionsContainer(
          icon: FontAwesomeIcons.car,
          title: SingingCharacter.Standard,
          price: standardCost.toStringAsFixed(2),
          onChange: (value) {
            snackBarBuilder(context: context, message: value.toString());
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
          leading: Icon(FontAwesome.calendar),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  'Schedule',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(displayedDate.text),
              IconButton(
                icon: Icon(Icons.chevron_right),
                onPressed: () {
                  DatePicker.showDatePicker(
                    context,
                    showTitleActions: true,
                    minTime: DateTime(2018, 3, 5),
                    maxTime: DateTime(2022, 6, 7),
                    onChanged: (date) {},
                    onConfirm: (date) {
                      snackBarBuilder(
                        context: context,
                        message:
                            'Schedule Delivery Set for ${formatter.format(date)}',
                      );
                      setState(
                          () => displayedDate.text = formatter.format(date));
                    },
                    currentTime: DateTime.now(),
                    locale: LocaleType.en,
                  );
                },
              )
            ],
          ),
        )
      ],
    );

    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            contentDetailsTab,
            shippingAddressTab,
            shippingOptionsTab,
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
          physics: NeverScrollableScrollPhysics(),
          itemCount: Provider.of<CartProvider>(
            context,
            listen: true,
          ).getItemSize(),
          itemBuilder: (BuildContext context, int index) {
            var data = Provider.of<CartProvider>(
              context,
              listen: true,
            ).list[index];
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
                            "Qty: ${data.orderQuantity}",
                            style: kTextStyleFaint,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'ZMW ${data.price}',
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
          horizontalEvenlySpacedWidget(
            leftWidget: Text(
              'Product Cost',
              style: kTextStyleFaint,
            ),
            rightWidget: Text('ZMW ${widget.productCost.toStringAsFixed(2)}'),
          ),
          SizedBox(height: 10),
          horizontalEvenlySpacedWidget(
            leftWidget: Text(
              'Delivery Cost',
              style: kTextStyleFaint,
            ),
            rightWidget: Text('ZMW ${deliverCost.toStringAsFixed(2)}'),
          ),
          widget.hasDiscount
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: horizontalEvenlySpacedWidget(
                    leftWidget: Text(
                      'Discount',
                      style: kTextStyleFaint,
                    ),
                    rightWidget:
                        Text('ZMW -${widget.discountPrice.toStringAsFixed(2)}'),
                  ),
                )
              : SizedBox(
                  height: 10,
                ),
          horizontalEvenlySpacedWidget(
            leftWidget: Text(
              'Total',
              style: kTextStyleFaint,
            ),
            rightWidget: Text('ZMW ${finalAbsoluteCost.toStringAsFixed(2)}'),
          ),
        ],
      ),
    );
  }

  Future<void> initFlutterWave() async {
    var provider = Provider.of<CartProvider>(context, listen: false);
    FlutterWaveCheckout _flutterCheckout = FlutterWaveCheckout(
      name: names,
      location: coordinatesValue,
      email: email,
      phoneNumber: phoneNumber,
      amount: '10',
      context: context,
      userId: userId,
      productList: provider.list,
      distId: 2,
      address: address,
    );
    try {
      await _flutterCheckout.beginPayment();
    } catch (e) {
      snackBarBuilder(context: context, message: e.toString());
      loggerError(message: e.toString());
    }
  }

  //Stepper Functions
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
      await initFlutterWave();
    }
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  Widget shippingOptionsContainer({
    required IconData icon,
    required SingingCharacter title,
    required String price,
    bool isChecked = false,
    required Function onChange,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 0.0, right: 0.0),
      leading: Icon(icon),
      title: Row(
        children: [
          Expanded(
            child: Text(
              getEnumValue(title),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Text('ZMW $price'),
          Radio<SingingCharacter>(
            value: title,
            groupValue: _character,
            onChanged: (SingingCharacter? value) async {
              setState(() {
                _character = value;
                value == SingingCharacter.Carrier
                    ? deliverCost = deliveryCosts[0]
                    : deliverCost = deliveryCosts[1];
                finalAbsoluteCost = 0;
              });
              await _calculateDiscountPrice();
            },
          )
        ],
      ),
    );
  }
}
