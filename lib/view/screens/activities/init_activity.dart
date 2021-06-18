import 'package:flutter/material.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';
import 'package:virtual_ggroceries/view/screens/activities/cart_activity.dart';
import 'package:virtual_ggroceries/view/screens/activities/search_activity.dart';
import 'package:virtual_ggroceries/view/screens/fragments/categories_fragment.dart';
import 'package:virtual_ggroceries/view/screens/fragments/home_fragment.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:virtual_ggroceries/view/screens/fragments/profile_fragment.dart';
import 'package:virtual_ggroceries/view/screens/fragments/wishlist_fragment.dart';

class InitActivity extends StatefulWidget {
  static String id = "HomeActivity";
  @override
  _InitActivityState createState() => _InitActivityState();
}

class _InitActivityState extends State<InitActivity> {
  List<Widget> fragments = [
    Home(),
    CategoryFragment(),
    WishListFragment(),
    ProfileFragment(),
  ];
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Virtual Groceries"),
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: fragments[_selectedIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.boxes),
            label: 'Category',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.heart),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.userAlt),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: kAccentColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
