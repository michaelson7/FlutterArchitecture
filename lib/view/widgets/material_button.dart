import 'package:flutter/material.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';

Material materialCard({required Widget child}) {
  return Material(
    color: Colors.grey[400],
    borderRadius: kBorderRadiusCircular,
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: child,
    ),
  );
}
