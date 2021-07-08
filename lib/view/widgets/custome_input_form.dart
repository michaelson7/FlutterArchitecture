import 'package:flutter/material.dart';

class CustomInputForm extends StatelessWidget {
  final String hintText, errorText, labelText;
  final bool obscureText, hasLabel;
  final Function(String) returnedParameter;
  final controller;

  const CustomInputForm({
    Key? key,
    required this.hintText,
    required this.errorText,
    this.obscureText = false,
    required this.returnedParameter,
    this.labelText = '',
    this.hasLabel = false,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      initialValue: hasLabel ? labelText : null,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hintText,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return errorText;
        } else {
          returnedParameter(value);
        }
        return null;
      },
    );
  }
}
