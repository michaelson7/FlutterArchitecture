import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:virtual_ggroceries/view/constants/app_icons.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';
import 'package:virtual_ggroceries/view/screens/activities/cart_activity.dart';
import 'package:virtual_ggroceries/view/screens/activities/search_activity.dart';
import 'package:virtual_ggroceries/view/screens/fragments/categories_fragment.dart';
import 'package:virtual_ggroceries/view/screens/fragments/home_fragment.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:virtual_ggroceries/view/screens/fragments/profile_fragment.dart';
import 'package:virtual_ggroceries/view/screens/fragments/wishlist_fragment.dart';

import '../fragments/home_fragment.dart';

class InitActivity extends StatefulWidget {
  static String id = "HomeActivity";
  @override
  _InitActivityState createState() => _InitActivityState();
}

class _InitActivityState extends State<InitActivity> {
  var logger = Logger();
  List<Widget> fragments = [
    Home(),
    CategoryFragment(),
    WishListFragment(),
    ProfileFragment(),
  ];
  int _selectedIndex = 0;
  PageController _pageController = PageController(
    initialPage: 0,
  );

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                title: Text('Virtual Groceries'),
                floating: true,
                snap: true,
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, SearchActivity.id);
                    },
                    icon: Icon(Icons.search),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, CartActivity.id);
                    },
                    icon: Icon(Icons.shopping_bag),
                  ),
                ],
              ),
            ];
          },
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: fragments,
            ),
          ),
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: kCardBackground,
          ),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  AppIcons.home,
                  size: 24,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(AppIcons.category),
                label: 'Category',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(AppIcons.heart),
                label: 'Wishlist',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(AppIcons.user),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: kAccentColor,
            unselectedItemColor: Colors.grey,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }
}
