import 'package:flutter/material.dart';
import 'package:flutterwave/core/flutterwave.dart';
import 'package:flutterwave/models/responses/charge_response.dart';
import 'package:flutterwave/utils/flutterwave_constants.dart';
import 'package:flutterwave/utils/flutterwave_currency.dart';

class PaymentWidget extends StatefulWidget {
  static final String id = "PaymentWidget";
  @override
  _PaymentWidgetState createState() => _PaymentWidgetState();
}

class _PaymentWidgetState extends State<PaymentWidget> {
  final String txref = "My_unique_transaction_reference_123";
  final String amount = "200";
  final String currency = FlutterwaveCurrency.ZMW;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'FLUTTER PAYMENT',
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Container(
              child: ElevatedButton(
                onPressed: () {
                  beginPayment();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('nandato?'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  beginPayment() async {
    final Flutterwave flutterwave = Flutterwave.forUIPayment(
      context: this.context,
      encryptionKey: "FLWPUBK_TEST-SANDBOXDEMOKEY-X",
      publicKey: "FLWPUBK_TEST-SANDBOXDEMOKEY-X",
      currency: this.currency,
      amount: this.amount,
      email: "valid@email.com",
      fullName: "Valid Full Name",
      txRef: this.txref,
      isDebugMode: true,
      phoneNumber: "0123456789",
      acceptCardPayment: true,
      acceptUSSDPayment: true,
      acceptZambiaPayment: true,
    );

    try {
      final ChargeResponse response =
          await flutterwave.initializeForUiPayments();
      if (response == null) {
        // user didn't complete the transaction. Payment wasn't successful.
      } else {
        final isSuccessful = checkPaymentIsSuccessful(response);
        if (isSuccessful) {
          // provide value to customer
        } else {
          // check message
          print(response.message);

          // check status
          print(response.status);

          // check processor error
          print(response.data!.processorResponse);
        }
      }
    } catch (error, stacktrace) {
      // handleError(error);
      // print(stacktrace);
    }
  }

  bool checkPaymentIsSuccessful(final ChargeResponse response) {
    return response.data!.status == FlutterwaveConstants.SUCCESSFUL &&
        response.data!.currency == this.currency &&
        response.data!.amount == this.amount &&
        response.data!.txRef == this.txref;
  }
}
