import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:virtual_ggroceries/model/core/products_model.dart';
import 'package:virtual_ggroceries/model/core/user_order_model.dart';
import 'package:virtual_ggroceries/provider/products_provider.dart';
import 'package:virtual_ggroceries/provider/user_orders_provider.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';
import 'package:virtual_ggroceries/view/widgets/order_cards.dart';
import 'package:virtual_ggroceries/view/widgets/snapshot_handler.dart';

class UserOrderDetails extends StatefulWidget {
  static String id = 'UserOrderDetails';
  final UserOrderModelList transactionData;
  UserOrderDetails({required this.transactionData});

  @override
  _UserOrderDetailsState createState() => _UserOrderDetailsState();
}

class _UserOrderDetailsState extends State<UserOrderDetails> {
  UserOrdersProvider _userOrdersProvider = UserOrdersProvider();
  bool transitStatus = false, clearedStatus = false;

  getUserOrders() async {
    //check delivery status
    if (widget.transactionData.status == "transit") {
      setState(() => transitStatus = true);
    } else if (widget.transactionData.status == "cleared") {
      setState(() {
        transitStatus = true;
        clearedStatus = true;
      });
    }

    await _userOrdersProvider.getUserOrder(
      userId: widget.transactionData.userId,
      transactionId: widget.transactionData.transId,
    );
  }

  @override
  void initState() {
    super.initState();
    getUserOrders();
  }

  @override
  void dispose() {
    super.dispose();
    _userOrdersProvider.dispose();
  }

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
            // Text(
            //   date,
            //   style: kTextStyleFaint,
            // )
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
                    title: 'Processing',
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
                      isTrue: transitStatus),
                  Expanded(
                    child: Divider(color: Colors.grey),
                  ),
                  deliveryStatusInterface(
                      title: 'Delivered',
                      date: '25 June',
                      isTrue: clearedStatus),
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                '$title: ',
                style: kTextStyleFaint,
              ),
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
            value: widget.transactionData.timeStamp,
          ),
          orderInfoDetails(
            title: 'Transaction ID',
            value: widget.transactionData.transId,
          ),
          orderInfoDetails(
            title: 'Total Cost',
            value: 'ZMK ${widget.transactionData.total.toString()}',
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
          StreamBuilder(
            stream: _userOrdersProvider.ordersStream,
            builder: (context, AsyncSnapshot<ProductsModel> snapshot) {
              return snapShotBuilder(
                snapshot: snapshot,
                emptyMessage: "No items",
                widget: OrderCards(
                  productData: snapshot.data,
                  function: () {},
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
