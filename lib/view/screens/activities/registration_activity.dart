import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:virtual_ggroceries/provider/account_provider.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';
import 'package:virtual_ggroceries/view/screens/activities/login_activity.dart';
import 'package:virtual_ggroceries/view/widgets/custome_input_form.dart';
import 'package:virtual_ggroceries/view/widgets/padded_container.dart';
import 'package:virtual_ggroceries/view/widgets/snack_bar_builder.dart';

class RegistrationActivity extends StatefulWidget {
  static final String id = "RegistrationActivity";
  const RegistrationActivity({Key? key}) : super(key: key);

  @override
  _RegistrationActivityState createState() => _RegistrationActivityState();
}

class _RegistrationActivityState extends State<RegistrationActivity> {
  AccountProvider _accountProvider = AccountProvider();
  bool isloading = false;
  late String email, password, names;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _accountProvider.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: ModalProgressHUD(
        inAsyncCall: isloading,
        color: Colors.black,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Registration'),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Welcome to Virtual Groceries',
                    style: kTextStyleHeader,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Please enter your credentials to get started',
                    style: kTextStyleFaint,
                  ),
                  SizedBox(height: 20),
                  PaddedContainer(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(FontAwesomeIcons.user),
                            title: CustomInputForm(
                              hintText: 'Enter Names',
                              errorText: 'Please enter Names',
                              returnedParameter: (value) {
                                names = value;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Divider(),
                          ),
                          ListTile(
                            leading: Icon(FontAwesomeIcons.envelope),
                            title: CustomInputForm(
                              hintText: 'Enter Username',
                              errorText: 'Please enter username',
                              returnedParameter: (value) {
                                email = value;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Divider(),
                          ),
                          ListTile(
                            leading: Icon(FontAwesomeIcons.lock),
                            title: CustomInputForm(
                              obscureText: true,
                              hintText: 'Enter Password',
                              errorText: 'Please enter password',
                              returnedParameter: (value) {
                                password = value;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(),
                      ElevatedButton(
                        onPressed: () async {
                          await _onPressMethod(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('Register'),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('or'),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Icon(FontAwesomeIcons.google),
                        ),
                        Text('Sign in with Google')
                      ],
                    ),
                  ),
                  Spacer(),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        children: [
                          Text('Already have an account?'),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                              Navigator.pushNamed(
                                context,
                                LoginActivity.id,
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'Login',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future _onPressMethod(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _openSpinner();
      bool isSignedIn = await _accountProvider.registerUser(
        email: email,
        password: password,
        names: names,
      );
      if (isSignedIn) {
        snackBarBuilder(context: context, message: "Registration Successful");
        Navigator.pop(context, true);
      } else {
        snackBarBuilder(context: context, message: "Account does not exist");
      }
      _closeSpinner();
    }
  }

  _openSpinner() {
    setState(() {
      isloading = true;
    });
  }

  _closeSpinner() {
    setState(() {
      isloading = false;
    });
  }
}
