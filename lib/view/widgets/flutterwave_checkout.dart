import 'dart:math';
import 'package:secure_random/secure_random.dart';
import 'package:flutter/material.dart';
import 'package:flutterwave/core/flutterwave.dart';
import 'package:flutterwave/models/responses/charge_response.dart';
import 'package:flutterwave/utils/flutterwave_constants.dart';
import 'package:flutterwave/utils/flutterwave_currency.dart';
import 'package:virtual_ggroceries/model/core/products_model.dart';
import 'package:virtual_ggroceries/provider/payment_provider.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';
import 'package:intl/intl.dart';
import 'package:virtual_ggroceries/view/widgets/snack_bar_builder.dart';

class FlutterWaveCheckout {
  PaymentProvider _paymentProvider = PaymentProvider();
  final String txref = SecureRandom().nextString(length: 17),
      currency = FlutterwaveCurrency.ZMW,
      phoneNumber,
      email,
      name,
      address,
      amount;
  final BuildContext context;
  final int userId, distId;
  final List<ProductsModelList> productList;

  FlutterWaveCheckout({
    required this.userId,
    required this.distId,
    required this.address,
    required this.productList,
    required this.email,
    required this.name,
    required this.amount,
    required this.phoneNumber,
    required this.context,
  });

  beginPayment() async {
    final Flutterwave flutterwave = Flutterwave.forUIPayment(
      context: context,
      encryptionKey: "FLWSECK_TESTa83747c7397c",
      publicKey: "FLWPUBK_TEST-a57bd9375b9aa5bf9422064fc04521bf-X",
      currency: currency,
      amount: amount,
      email: email,
      fullName: name,
      txRef: txref,
      isDebugMode: true,
      phoneNumber: phoneNumber,
      acceptCardPayment: true,
      acceptUSSDPayment: false,
      acceptZambiaPayment: true,
    );

    try {
      final ChargeResponse response =
          await flutterwave.initializeForUiPayments();
      if (response == null) {
        // user didn't complete the transaction. Payment wasn't successful.
        print('TRANSACTION Incomplete');
        snackBarBuilder(context: context, message: "Transaction Incomplete");
      } else {
        final isSuccessful = checkPaymentIsSuccessful(response);
        if (isSuccessful) {
          //if transaction successful
          print('TRANSACTION COMPLETE');
          _paymentProvider.updateUserPurchase(
            userId: userId,
            distId: distId,
            address: address,
            productList: productList,
            email: email,
            name: name,
            amount: amount,
            phoneNumber: phoneNumber,
            transId: txref,
          );
          _confirmationDialog();
        } else {
          // check message
          print('FLUTTERERROR: ${response.message}');

          // check status
          print('FLUTTER ERROR ${response.status}');

          // check processor error
          print('FLUTTER ERROR: ${response.data!.processorResponse}');
        }
      }
    } catch (error, stacktrace) {
      // handleError(error);
      print(stacktrace);
      print('FLUTTER ERROR: ${error}');
    }
  }

  bool checkPaymentIsSuccessful(final ChargeResponse response) {
    return response.data!.status == FlutterwaveConstants.SUCCESSFUL &&
        response.data!.currency == currency &&
        response.data!.amount == amount &&
        response.data!.txRef == txref;
  }

  _confirmationDialog() {
    //dialogs
    Row rowWidget(
        {required String title1,
        required String title2,
        bool isFaint = false}) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title1,
            style: isFaint
                ? kTextStyleFaint
                : kTextStyleSubHeader.copyWith(color: Colors.white),
          ),
          Text(
            title2,
            style: isFaint
                ? kTextStyleFaint
                : kTextStyleSubHeader.copyWith(color: Colors.white),
          )
        ],
      );
    }

    Widget dialogLayout() {
      final currentDate = new DateTime.now();
      String formatter = DateFormat('yMd').format(currentDate);

      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Center(
              child: Text(
                'Thank You!',
                style: TextStyle(
                  color: kAccentColor,
                ),
                textScaleFactor: 1,
              ),
            ),
            Center(
              child: Text(
                'Your Transaction Was Successful!',
                style: kTextStyleFaint,
                textScaleFactor: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(
                color: Colors.white,
              ),
            ),
            rowWidget(
              title1: 'Date',
              title2: 'Time',
              isFaint: true,
            ),
            rowWidget(
              title1: formatter,
              title2: currentDate.hour.toString() +
                  " : " +
                  currentDate.minute.toString(),
            ),
            SizedBox(height: 15),
            rowWidget(
              title1: 'TO:',
              title2: '',
              isFaint: true,
            ),
            rowWidget(
              title1: email,
              title2: '',
            ),
            SizedBox(height: 15),
            rowWidget(
              title1: 'Amount',
              title2: 'Completed',
              isFaint: true,
            ),
            rowWidget(
              title1: 'ZMK $amount',
              title2: '',
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(
                color: Colors.white,
              ),
            ),
            Center(
              child: Column(
                children: [
                  Text(
                    'Your items will be delived to:',
                    textScaleFactor: 1,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    address,
                    textScaleFactor: 1,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Reference Code: $txref',
                    textScaleFactor: 1,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    }

    Dialog errorDialog = Dialog(
      child: Container(
        height: 320.0,
        color: Colors.grey[900],
        child: dialogLayout(),
      ),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) => errorDialog,
    );
  }
}
