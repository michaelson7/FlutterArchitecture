import 'package:flutter/material.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';

class PaddedContainer extends StatelessWidget {
  final Widget child;

  const PaddedContainer({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kCardBackground,
        borderRadius: kBorderRadiusCircular,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: child,
      ),
    );
  }
}
