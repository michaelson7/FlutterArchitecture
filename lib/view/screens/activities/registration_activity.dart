import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';
import 'package:virtual_ggroceries/view/widgets/padded_container.dart';

class RegistrationActivity extends StatefulWidget {
  static final String id = "RegistrationActivity";
  const RegistrationActivity({Key? key}) : super(key: key);

  @override
  _RegistrationActivityState createState() => _RegistrationActivityState();
}

class _RegistrationActivityState extends State<RegistrationActivity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(FontAwesomeIcons.envelope),
                      title: TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter Username'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Divider(),
                    ),
                    ListTile(
                      leading: Icon(FontAwesomeIcons.lock),
                      title: TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter Password'),
                      ),
                    ),
                  ],
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
                        '',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
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
                          Navigator.pop(context);
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
    );
  }
}
