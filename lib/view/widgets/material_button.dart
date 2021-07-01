import 'package:flutter/material.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';

Material materialCard({required Widget child}) {
  return Material(
    color: kCardBackgroundFaint,
    borderRadius: kBorderRadiusCircular,
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: child,
    ),
  );
}
