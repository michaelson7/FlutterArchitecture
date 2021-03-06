import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:virtual_ggroceries/provider/account_provider.dart';
import 'package:virtual_ggroceries/provider/shared_pereferences_provider.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';
import 'package:virtual_ggroceries/view/constants/enums.dart';
import 'package:virtual_ggroceries/view/screens/activities/login_activity.dart';
import 'package:virtual_ggroceries/view/screens/activities/profile_activity.dart';
import 'package:virtual_ggroceries/view/screens/activities/user_order_activity.dart';
import 'package:virtual_ggroceries/view/widgets/logger_widget.dart';
import 'package:virtual_ggroceries/view/widgets/material_button.dart';
import 'package:virtual_ggroceries/view/widgets/padded_container.dart';
import 'package:virtual_ggroceries/view/widgets/color_handler.dart';

class ProfileFragment extends StatefulWidget {
  const ProfileFragment({Key? key}) : super(key: key);

  @override
  _ProfileFragmentState createState() => _ProfileFragmentState();
}

class _ProfileFragmentState extends State<ProfileFragment>
    with AutomaticKeepAliveClientMixin<ProfileFragment> {
  @override
  bool get wantKeepAlive => false;

  SharedPreferenceProvider _sp = SharedPreferenceProvider();
  AccountProvider _accountProvider = AccountProvider();

  bool isNotificationSwitched = false;
  bool isDarkMode = false;
  bool isSignedIn = false;

  String? userName, userEmail;
  int? userId;

  @override
  void initState() {
    super.initState();
    _checkState();
  }

  @override
  void dispose() {
    _accountProvider.dispose();
    super.dispose();
  }

  _checkState() async {
    var themData = await _sp.isDarkMode();
    var signedData = await _sp.isLoggedIn();

    //get user data
    var tempName, tempEmail, tempId;
    if (signedData) {
      tempName = await _accountProvider.getUserName();
      tempEmail = await _accountProvider.getUserEmail();
      tempId = await _accountProvider.getUserId();
    }

    setState(() {
      isDarkMode = themData!;
      isSignedIn = signedData;
      userEmail = tempEmail;
      userName = tempName;
      userId = tempId;
    });
  }

  refreshProfilePage() {
    _checkState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
          // Text(
          //   'Support',
          //   style: kTextStyleFaint.copyWith(fontWeight: FontWeight.bold),
          // ),
          // SizedBox(height: 10),
          // supportCard(),
          // SizedBox(height: 15),
        ],
      ),
    );
  }

  Container supportCard() {
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
                  materialCard(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: 'Enter Email', border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  materialCard(
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
              cardItem(
                header: 'FAQ',
                cardFunction: () {
                  _handleClickMe(DialogTerms.FAQ);
                },
              ),
              dividerPadded(),
              cardItem(
                header: 'Terms Of Service',
                cardFunction: () {},
              ),
              dividerPadded(),
              cardItem(
                header: 'Contact',
                cardFunction: () {
                  _handleClickMe(DialogTerms.Contact);
                },
              ),
              dividerPadded(),
              cardItem(
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
    //setting  theme
    setTheme(BuildContext context) {
      isDarkMode = !isDarkMode;
      ThemeSwitcher.of(context)!.changeTheme(
        theme: ThemeProvider.of(context)!.brightness == Brightness.light
            ? themeState(isDark: true)
            : themeState(isDark: false),
      );
    }

    //switcher widget
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
              cardItem(
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
              dividerPadded(),
              ThemeSwitcher(
                clipper: ThemeSwitcherCircleClipper(),
                builder: (context) {
                  return cardItem(
                    header: 'Dark Mode',
                    cardFunction: () {
                      setState(() {
                        setTheme(context);
                      });
                    },
                    rightWidget: switchBuilder(
                      boolValue: isDarkMode,
                      switchFunction: (value) {
                        print(value);
                        setState(() {
                          setTheme(context);
                        });
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container accountCard(BuildContext context) {
    return Container(
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
            cardItem(
              header: isSignedIn ? userName! : 'Not SIgned In',
              subHeader: isSignedIn ? userEmail! : 'Click to sign in',
              cardFunction: () async {
                var signedState;
                isSignedIn
                    ? signedState =
                        await Navigator.pushNamed(context, ProfileActivity.id)
                    : signedState =
                        await Navigator.pushNamed(context, LoginActivity.id);
                try {
                  if (signedState) {
                    refreshProfilePage();
                  }
                } catch (e) {}
              },
            ),
            dividerPadded(),
            cardItem(
              header: 'My Orders',
              cardFunction: () {
                Navigator.pushNamed(context, UserOrderActivity.id);
              },
            ),
          ],
        ),
      ),
    );
  }

  Container cardItem({
    required Function cardFunction,
    required String header,
    String? subHeader,
    Widget rightWidget = const Icon(
      Icons.keyboard_arrow_right,
    ),
  }) {
    List<Widget> widgetTexts = [];

    if (subHeader != null) {
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

    return Container(
      child: InkWell(
        onTap: () => cardFunction(),
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
    );
  }

  dividerPadded() {
    return Divider(
      color: Colors.grey,
    );
  }
}
