import 'package:flutter/material.dart';
import '../constants/constants.dart';

Widget emptyHandler({
  required String message,
  IconData iconData = Icons.inbox_rounded,
}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 100),
        Icon(
          iconData,
          size: 50,
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
