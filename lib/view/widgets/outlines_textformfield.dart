import 'package:flutter/material.dart';
import 'package:virtual_ggroceries/view/constants/constants.dart';

Container outlinedTextFormField({
  required String title,
  required String errorText,
  String? initialValue,
  required Function(String) returnedParameter,
  TextEditingController? controller,
}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: kBorderRadiusCircular,
      border: Border.all(
        color: kCardBackground,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextFormField(
          controller: controller,
          initialValue: initialValue,
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: title,
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return errorText;
            } else {
              returnedParameter(value);
            }
            return null;
          }),
    ),
  );
}
