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
import 'package:virtual_ggroceries/view/widgets/logger_widget.dart';
import 'package:virtual_ggroceries/view/widgets/snack_bar_builder.dart';

class FlutterWaveCheckout {
  PaymentProvider _paymentProvider = PaymentProvider();
  final String txref = SecureRandom().nextString(length: 17),
      currency = FlutterwaveCurrency.ZMW,
      phoneNumber,
      email,
      name,
      address,
      location,
      amount;
  final BuildContext context;
  final int userId, distId;
  final List<ProductsModelList> productList;

  FlutterWaveCheckout({
    required this.userId,
    required this.distId,
    required this.location,
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
      encryptionKey: "dbbd5e58cd35f22c20af85f2",
      publicKey: "FLWPUBK-abe07113945d2536840268fb2c97b15b-X",
      currency: currency,
      amount: amount,
      email: email,
      fullName: name,
      txRef: txref,
      isDebugMode: false,
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
        loggerError(message: 'TRANSACTION Incomplete');
        snackBarBuilder(context: context, message: "Transaction Incomplete");
      } else {
        final isSuccessful = checkPaymentIsSuccessful(response);
        if (isSuccessful) {
          //if transaction successful
          loggerInfo(message: 'TRANSACTION COMPLETE');
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
            location: location,
          );
          _confirmationDialog();
        } else {
          // check message
          loggerError(message: 'FLUTTERERROR: ${response.message}');

          // check status
          loggerError(message: 'FLUTTER ERROR ${response.status}');

          // check processor error
          loggerError(
              message: 'FLUTTER ERROR: ${response.data!.processorResponse}');
        }
        throw ('ERROR: ${response.message}');
      }
    } catch (error, stacktrace) {
      // handleError(error);
      print(stacktrace);
      loggerError(message: 'FLUTTER ERROR: ${error}');
      throw ('FLUTTER ERROR: ${error}');
    }
  }

  testUpload() async {
    await _paymentProvider.updateUserPurchase(
      userId: userId,
      distId: distId,
      address: address,
      productList: productList,
      email: email,
      name: name,
      amount: amount,
      phoneNumber: phoneNumber,
      transId: txref,
      location: location,
    );
    _confirmationDialog();
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
                    'Your items will be delivered to:',
                    textScaleFactor: 1,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    address,
                    textAlign: TextAlign.center,
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
