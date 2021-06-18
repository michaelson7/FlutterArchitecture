import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';
import 'package:virtual_ggroceries/view/constants/enums.dart';
import 'package:virtual_ggroceries/view/screens/activities/login_activity.dart';
import 'package:virtual_ggroceries/view/widgets/material_button.dart';
import 'package:virtual_ggroceries/view/widgets/padded_container.dart';

class ProfileFragment extends StatefulWidget {
  const ProfileFragment({Key? key}) : super(key: key);

  @override
  _ProfileFragmentState createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment> {
  bool isNotificationSwitched = false;
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account',
            style: kTextStyleFaint.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          accountCard(context),
          SizedBox(height: 15),
          Text(
            'Interface',
            style: kTextStyleFaint.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          interfaceCard(),
          SizedBox(height: 15),
          Text(
            'Support',
            style: kTextStyleFaint.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          supportCard(),
          SizedBox(height: 15),
        ],
      ),
    );
  }

  Container supportCard() {
    return Container(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: kCardBackground,
          borderRadius: kBorderRadiusCircular,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardItem(
                header: 'FAQ',
                cardFunction: () {
                  _handleClickMe(DialogTerms.FAQ);
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Divider(
                  color: Colors.grey,
                ),
              ),
              CardItem(
                header: 'Terms Of Service',
                cardFunction: () {},
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Divider(
                  color: Colors.grey,
                ),
              ),
              CardItem(
                header: 'Contact',
                cardFunction: () {
                  _handleClickMe(DialogTerms.Contact);
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Divider(
                  color: Colors.grey,
                ),
              ),
              CardItem(
                header: 'Report a Problem',
                cardFunction: () {
                  _handleClickMe(DialogTerms.Problem);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container interfaceCard() {
    return Container(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: kCardBackground,
          borderRadius: kBorderRadiusCircular,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardItem(
                header: 'Notifications',
                cardFunction: () {
                  setState(() {
                    isNotificationSwitched = !isNotificationSwitched;
                  });
                },
                rightWidget: switchBuilder(
                  boolValue: isNotificationSwitched,
                  switchFunction: (value) {
                    print(value);
                    setState(() {
                      isNotificationSwitched = !isNotificationSwitched;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Divider(
                  color: Colors.grey,
                ),
              ),
              CardItem(
                header: 'Dark Mode',
                cardFunction: () {
                  setState(() {
                    isDarkMode = !isDarkMode;
                  });
                },
                rightWidget: switchBuilder(
                  boolValue: isDarkMode,
                  switchFunction: (value) {
                    print(value);
                    setState(() {
                      isDarkMode = !isDarkMode;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container accountCard(BuildContext context) {
    return Container(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: kCardBackground,
          borderRadius: kBorderRadiusCircular,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardItem(
                header: 'Not SIgned In',
                subHeader: 'Click to sign in',
                cardFunction: () {
                  Navigator.pushNamed(context, LoginActivity.id);
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Divider(
                  color: Colors.grey,
                ),
              ),
              CardItem(
                header: 'My Orders',
                cardFunction: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleClickMe(DialogTerms term) async {
    var content;

    Column contactContent() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Our Contact',
              style: kTextStyleSubHeader,
            ),
          ),
          SizedBox(height: 20),
          Text('Woodlands Chalala 34th Street\n 0978905095')
        ],
      );
    }

    Column problemsContent() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              'Report a problem ',
              style: kTextStyleSubHeader,
            ),
          ),
          SizedBox(height: 20),
          PaddedContainer(
            child: Column(
              children: [
                materialButtonDesign(
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: 'Enter Email', border: InputBorder.none),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                materialButtonDesign(
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: 'Enter Issue', border: InputBorder.none),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Submit Issue'),
              ),
            ),
          )
        ],
      );
    }

    switch (term) {
      case DialogTerms.Problem:
        content = problemsContent();
        break;
      case DialogTerms.Contact:
        content = contactContent();
        break;
      case DialogTerms.FAQ:
        break;
    }

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: Text('Success!'),
          content: content,
        );
      },
    );
  }
}

class CardItem extends StatelessWidget {
  final Function cardFunction;
  final String header, subHeader;
  final Widget rightWidget;
  List<Widget> widgetTexts = [];

  CardItem({
    required this.cardFunction,
    required this.header,
    this.subHeader = '',
    this.rightWidget = const Icon(
      Icons.keyboard_arrow_right,
    ),
  }) {
    if (subHeader != '') {
      widgetTexts = [
        Text(header),
        SizedBox(height: 10),
        Text(
          subHeader,
          style: kTextStyleFaint,
        ),
      ];
    } else {
      widgetTexts = [Text(header)];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () => cardFunction(),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widgetTexts,
                ),
              ),
              rightWidget
            ],
          ),
        ),
      ),
    );
  }
}

Switch switchBuilder(
    {required bool boolValue, required Function(bool) switchFunction}) {
  return Switch(
    value: boolValue,
    onChanged: (value) {
      switchFunction(value);
    },
    activeColor: kAccentColor,
  );
}
