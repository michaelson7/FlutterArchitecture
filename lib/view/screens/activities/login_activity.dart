import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:virtual_ggroceries/provider/account_provider.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';
import 'package:virtual_ggroceries/view/screens/activities/registration_activity.dart';
import 'package:virtual_ggroceries/view/widgets/custome_input_form.dart';
import 'package:virtual_ggroceries/view/widgets/material_button.dart';
import 'package:virtual_ggroceries/view/widgets/padded_container.dart';
import 'package:virtual_ggroceries/view/widgets/snack_bar_builder.dart';

class LoginActivity extends StatefulWidget {
  static final String id = "LoginActivity";
  const LoginActivity({Key? key}) : super(key: key);

  @override
  _LoginActivityState createState() => _LoginActivityState();
}

class _LoginActivityState extends State<LoginActivity> {
  AccountProvider _accountProvider = AccountProvider();
  bool isloading = false;
  late String email, password;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: ModalProgressHUD(
        inAsyncCall: isloading,
        opacity: 0.4,
        color: Colors.black,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Login'),
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
                  Form(
                    key: _formKey,
                    child: PaddedContainer(
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(FontAwesomeIcons.envelope),
                            title: CustomInputForm(
                              hintText: 'Enter Email',
                              errorText: 'Please enter email',
                              returnedParameter: (value) {
                                email = value;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
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
                      TextButton(
                        onPressed: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Forgot Password?',
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await _onPressMethod(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('Login'),
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
                          Text('Dont have an account?'),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, RegistrationActivity.id);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                'Register Account',
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
      bool isSignedIn = await _accountProvider.loginUser(
        email: email,
        password: password,
      );
      if (isSignedIn) {
        snackBarBuilder(context: context, message: "Login Successful");
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
