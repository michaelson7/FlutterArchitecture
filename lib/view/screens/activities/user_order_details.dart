import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:virtual_ggroceries/model/core/products_model.dart';
import 'package:virtual_ggroceries/model/core/user_order_model.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';
import 'package:virtual_ggroceries/view/widgets/order_cards.dart';

class UserOrderDetails extends StatelessWidget {
  static String id = 'UserOrderDetails';
  final UserOrderModelList purchaseData;
  final ProductsModelList productData;

  UserOrderDetails({required this.purchaseData, required this.productData});

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Order Details'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  deliveryInfoCard(),
                  SizedBox(height: 20),
                  orderDetailsCard(),
                  SizedBox(height: 20),
                  orderItemCard(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  deliveryInfoCard() {
    Container deliveryStatusInterface(
        {required String title, required String date, bool isTrue = false}) {
      return Container(
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: isTrue ? Colors.green : kCardBackground,
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: kTextStyleFaint,
            ),
            Text(
              date,
              style: kTextStyleFaint,
            )
          ],
        ),
      );
    }

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Delivery Information',
            style: kTextStyleHeader,
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  deliveryStatusInterface(
                    title: 'Paid',
                    date: '14 June',
                    isTrue: true,
                  ),
                  Expanded(
                      child: Divider(
                    color: Colors.green,
                  )),
                  deliveryStatusInterface(
                    title: 'In Transit',
                    date: '14 June',
                  ),
                  Expanded(
                    child: Divider(color: Colors.grey),
                  ),
                  deliveryStatusInterface(
                    title: 'Delivered',
                    date: '25 June',
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  orderDetailsCard() {
    Padding orderInfoDetails({required String title, required String value}) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              '$title: ',
              style: kTextStyleFaint,
            ),
            Text(value)
          ],
        ),
      );
    }

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Details',
            style: kTextStyleHeader,
          ),
          SizedBox(
            height: 15,
          ),
          orderInfoDetails(
            title: 'Time Bought',
            value: purchaseData.timeStamp,
          ),
          orderInfoDetails(
            title: 'Transaction ID',
            value: purchaseData.transId,
          ),
          orderInfoDetails(
            title: 'Total Cost',
            value: 'ZMK ${purchaseData.total.toString()}',
          )
        ],
      ),
    );
  }

  orderItemCard() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ordered Item',
            style: kTextStyleHeader,
          ),
          SizedBox(height: 10),
          OrderCards(
            productData: productData,
            purchaseData: purchaseData,
            function: () {},
          )
        ],
      ),
    );
  }
}
