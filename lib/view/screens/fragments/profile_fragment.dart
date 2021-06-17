import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';

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
          //AACCOUNT SECTION
          Text(
            'Account',
            style: kTextStyleFaint.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Container(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: kDarkCardBackground,
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
                      cardFunction: doNothing(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                    CardItem(
                      header: 'My Orders',
                      cardFunction: doNothing(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          // iINTERFACE SECTION
          Text(
            'Interface',
            style: kTextStyleFaint.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Container(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: kDarkCardBackground,
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
          ),
          SizedBox(height: 15),
          //SUPPORT
          Text(
            'Support',
            style: kTextStyleFaint.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Container(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: kDarkCardBackground,
                borderRadius: kBorderRadiusCircular,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CardItem(
                      header: 'FAQ',
                      cardFunction: doNothing(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                    CardItem(
                      header: 'Terms Of Service',
                      cardFunction: doNothing(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                    CardItem(
                      header: 'Contact',
                      cardFunction: doNothing(),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Divider(
                        color: Colors.grey,
                      ),
                    ),
                    CardItem(
                      header: 'Report a Problem',
                      cardFunction: doNothing(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
        ],
      ),
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

doNothing() {}
