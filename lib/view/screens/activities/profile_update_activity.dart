import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:virtual_ggroceries/model/core/account_model.dart';
import 'package:virtual_ggroceries/provider/account_provider.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';
import 'package:virtual_ggroceries/view/widgets/custome_input_form.dart';
import 'package:virtual_ggroceries/view/widgets/material_button.dart';

class ProfileUpdateActivity extends StatefulWidget {
  static String id = 'ProfileUpdateActivity';

  @override
  _ProfileUpdateActivityState createState() => _ProfileUpdateActivityState();
}

class _ProfileUpdateActivityState extends State<ProfileUpdateActivity> {
  AccountProvider _accountProvider = AccountProvider();
  var namesController = TextEditingController(),
      emailController = TextEditingController(),
      addressController = TextEditingController();
  int? userId;
  String? userName, userAddress, userContact;
  final _formKey = GlobalKey<FormState>();

  getUserData() async {
    var tempName, tempEmail, tempUserId, tempUserAddress;
    bool isSigned = await _accountProvider.isSignedIn();

    if (isSigned) {
      tempEmail = await _accountProvider.getUserEmail();
      tempName = await _accountProvider.getUserName();
      tempUserId = await _accountProvider.getUserId();
      tempUserAddress = 'woodlands Chalala';

      setState(() {
        emailController.text = tempEmail;
        namesController.text = tempName;
        userId = tempUserId;
        addressController.text = tempUserAddress;
      });
    }
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Profile Update'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: mainInterface(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget mainInterface() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Information',
          style: kTextStyleHeader,
        ),
        SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: materialCard(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    boxInputContainer(
                      customeWidget: CustomInputForm(
                        hintText: 'Enter Name',
                        errorText: 'please enter name',
                        labelText: 'Full Names',
                        controller: namesController,
                        returnedParameter: (value) {
                          userName = value;
                        },
                      ),
                    ),
                    boxInputContainer(
                      customeWidget: CustomInputForm(
                        hintText: 'Enter Email',
                        errorText: 'please enter email',
                        controller: emailController,
                        returnedParameter: (value) {},
                      ),
                    ),
                    boxInputContainer(
                      customeWidget: CustomInputForm(
                        hintText: 'Enter Phone',
                        errorText: 'please enter phone',
                        returnedParameter: (value) {
                          userContact = value;
                        },
                      ),
                    ),
                    boxInputContainer(
                      customeWidget: CustomInputForm(
                        hintText: 'Enter Address',
                        errorText: 'please enter address',
                        controller: addressController,
                        returnedParameter: (value) {
                          userAddress = value;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {}
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text('UPDATE'),
            ),
          ),
        )
      ],
    );
  }

  Padding boxInputContainer({required Widget customeWidget}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: kBorderRadiusCircular,
          border: Border.all(
            color: kCardBackground,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: customeWidget,
        ),
      ),
    );
  }
}
