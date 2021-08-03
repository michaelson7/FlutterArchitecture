import 'package:flutter/material.dart';

Row horizontalEvenlySpacedWidget({
  required Widget leftWidget,
  required Widget rightWidget,
}) {
  return Row(
    children: [
      Expanded(
        child: leftWidget,
      ),
      rightWidget,
    ],
  );
}

Widget horizontalEvenlySpacedWrapWidget(
    {required Widget leftWidget,
    required Widget rightWidget,
    bool isSpaced = true}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          children: [
            leftWidget,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Expanded(child: rightWidget),
            ),
          ],
        ),
        Divider()
      ],
    ),
  );
}
