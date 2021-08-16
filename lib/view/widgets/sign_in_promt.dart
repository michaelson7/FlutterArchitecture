import 'package:flutter/material.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';

Widget signInPromte({required String message}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.verified_user,
          size: 100,
          color: kAccentColor,
        ),
        SizedBox(height: 10),
        Text(
          message,
          style: kTextStyleFaint,
        ),
      ],
    ),
  );
}
