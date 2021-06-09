import 'package:flutter/material.dart';

Widget horizontalWidgetBuilder(List<Widget> widgetItems) {
  return Container(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: widgetItems),
        ),
      ],
    ),
  );
}
