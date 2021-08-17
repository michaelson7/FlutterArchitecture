import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:virtual_ggroceries/model/core/account_model.dart';
import 'package:virtual_ggroceries/provider/account_provider.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';
import 'package:virtual_ggroceries/view/widgets/custome_input_form.dart';
import 'package:virtual_ggroceries/view/widgets/material_button.dart';
import 'package:virtual_ggroceries/view/widgets/outlines_textformfield.dart';
import 'package:virtual_ggroceries/view/widgets/snack_bar_builder.dart';

class ProfileUpdateActivity extends StatefulWidget {
  static String id = 'ProfileUpdateActivity';

  @override
  _ProfileUpdateActivityState createState() => _ProfileUpdateActivityState();
}

class _ProfileUpdateActivityState extends State<ProfileUpdateActivity> {
  AccountProvider _accountProvider = AccountProvider();
  int? userId;
  String? userName,
      userEmail,
      userPhoneNumber,
      shippingCountry,
      shippingProvince,
      shippingCity,
      shippingAddress1,
      shippingAddress2;
  final _personalInfoKey = GlobalKey<FormState>();
  final _shippingAddressKey = GlobalKey<FormState>();
  bool isLoading = true;

  getUserData() async {
    var tempName,
        tempEmail,
        tempUserId,
        tempUserAddress1,
        tempPhone,
        tempCountry,
        tempProvince,
        tempCity,
        tempAddress2;
    bool isSigned = await _accountProvider.isSignedIn();

    if (isSigned) {
      tempEmail = await _accountProvider.getUserEmail();
      tempName = await _accountProvider.getUserName();
      tempUserId = await _accountProvider.getUserId();
      tempUserAddress1 = await _accountProvider.getAddress1();
      tempPhone = await _accountProvider.getUserPhoneNumber();
      tempCountry = await _accountProvider.getCountry();
      tempProvince = await _accountProvider.getShippingProvince();
      tempCity = await _accountProvider.getCity();
      tempAddress2 = await _accountProvider.getAddress2();
      setState(() {
        userId = tempUserId;
        userEmail = tempEmail;
        userName = tempName;
        userPhoneNumber = tempPhone;
        shippingAddress1 = tempUserAddress1;
        shippingAddress2 = tempAddress2;
        shippingCountry = tempCountry;
        shippingProvince = tempProvince;
        shippingCity = tempCity;
      });
    }
    setState(() => isLoading = false);
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _accountProvider.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Profile Update'),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : buildSafeArea(),
      ),
    );
  }

  SafeArea buildSafeArea() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: mainInterface(),
        ),
      ),
    );
  }

  mainInterface() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          personalInformationCard(),
          SizedBox(height: 20),
          shippingAddressCard(),
          SizedBox(height: 20),
          submitButton()
        ],
      ),
    );
  }

  personalInformationCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Information',
          style: kTextStyleHeader,
        ),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius: kBorderRadiusCircular,
            color: kCardBackgroundFaint,
          ),
          child: Form(
            key: _personalInfoKey,
            child: Column(
              children: [
                outlinedTextFormField(
                  title: 'Name',
                  errorText: 'Please input name',
                  initialValue: userName,
                  returnedParameter: (value) {
                    userName = value;
                  },
                ),
                outlinedTextFormField(
                  title: 'Email',
                  errorText: 'Please input name',
                  initialValue: userEmail,
                  returnedParameter: (value) {
                    userEmail = value;
                  },
                ),
                outlinedTextFormField(
                  title: 'Phone',
                  errorText: 'Please input name',
                  initialValue: userPhoneNumber,
                  returnedParameter: (value) {
                    userPhoneNumber = value;
                  },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  shippingAddressCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Shipping Address',
          style: kTextStyleHeader,
        ),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            borderRadius: kBorderRadiusCircular,
            color: kCardBackgroundFaint,
          ),
          child: Form(
            key: _shippingAddressKey,
            child: Column(
              children: [
                outlinedTextFormField(
                  title: 'Country',
                  errorText: 'Please input country',
                  initialValue: shippingCountry,
                  returnedParameter: (value) {
                    shippingCountry = value;
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: outlinedTextFormField(
                        title: 'Province',
                        errorText: 'Please input province',
                        initialValue: shippingProvince,
                        returnedParameter: (value) {
                          shippingProvince = value;
                        },
                      ),
                    ),
                    Expanded(
                      child: outlinedTextFormField(
                        title: 'City',
                        errorText: 'Please input city',
                        initialValue: shippingCity,
                        returnedParameter: (value) {
                          shippingCity = value;
                        },
                      ),
                    ),
                  ],
                ),
                outlinedTextFormField(
                  title: 'Address 1',
                  errorText: 'Please input address1',
                  initialValue: shippingAddress1,
                  returnedParameter: (value) {
                    shippingAddress1 = value;
                  },
                ),
                outlinedTextFormField(
                  title: 'Address 2',
                  errorText: 'Please input address 2',
                  initialValue: shippingAddress2,
                  returnedParameter: (value) {
                    shippingAddress2 = value;
                  },
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  submitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (_personalInfoKey.currentState!.validate() &&
              _shippingAddressKey.currentState!.validate()) {
            //TODO: update database
            await _accountProvider.updateStoredUserData(
              userName: userName ?? '',
              userEmail: userEmail,
              userPhoneNumber: userPhoneNumber,
              shippingCountry: shippingCountry,
              shippingProvince: shippingProvince,
              shippingCity: shippingCity,
              shippingAddress1: shippingAddress1,
              shippingAddress2: shippingAddress2,
            );
            snackBarBuilder(context: context, message: 'Account Updated');
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('SUBMIT'),
        ),
      ),
    );
  }
}
