import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_ggroceries/provider/cart_provider.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';
import 'package:virtual_ggroceries/view/widgets/snack_bar_builder.dart';

class CheckOutActivity extends StatefulWidget {
  static final String id = "CheckOutActivity";
  const CheckOutActivity({Key? key}) : super(key: key);

  @override
  _CheckOutActivityState createState() => _CheckOutActivityState();
}

class _CheckOutActivityState extends State<CheckOutActivity> {
  int _currentStep = 0;
  StepperType stepperType = StepperType.horizontal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    title: new Text('Address'),
                    content: paymentContainer(),
                    isActive: _currentStep == 1,
                    state: _currentStep >= 1
                        ? StepState.complete
                        : StepState.disabled,
                  ),
                  Step(
                    title: new Text('Confirm'),
                    content: confirmationSection(context),
                    isActive: _currentStep == 2,
                    state: _currentStep >= 2
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
    );
  }

  Container shippingContainer() {
    return Container(
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
          ),
          SizedBox(height: 8),
          borderCard(
            title: 'Password',
          ),
          SizedBox(height: 8),
          borderCard(
            title: 'Phone Number',
          ),
          SizedBox(height: 15),
          Text(
            'Shipping Address',
            style: kTextStyleSubHeader,
          ),
          SizedBox(height: 10),
          borderCard(
            title: 'Address',
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: borderCard(
                  title: 'Province',
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: borderCard(
                  title: 'ZIP CODE',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container paymentContainer() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Container()),
              Text('VISA'),
            ],
          ),
          SizedBox(height: 10),
          borderCard(title: 'Visa Express'),
          SizedBox(height: 10),
          borderCard(title: 'Card Number'),
          SizedBox(height: 10),
          borderCard(title: 'Name'),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: borderCard(
                  title: 'Expire Date',
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: borderCard(
                  title: 'Csv',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container confirmationSection(BuildContext context) {
    Widget cartItemList() {
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

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SHIPPING TO:',
            style: kTextStyleFaint,
          ),
          SizedBox(height: 10),
          borderCard(title: ''),
          SizedBox(height: 10),
          Text(
            'PAYMENT DETAILS:',
            style: kTextStyleFaint,
          ),
          SizedBox(height: 10),
          borderCard(title: ''),
          SizedBox(height: 10),
          Text(
            'PRODUCT ORDER:',
            style: kTextStyleFaint,
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: cartItemList(),
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
              Text('ZMW 123.50'),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Order Cost',
                  style: kTextStyleFaint,
                ),
              ),
              Text('ZMW 193.50'),
            ],
          ),
        ],
      ),
    );
  }

  Container borderCard({required String title}) {
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
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: title,
          ),
        ),
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

  continued() {
    _currentStep < 2 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }
}
