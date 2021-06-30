import 'package:flutter/material.dart';

class CustomInputForm extends StatelessWidget {
  final String hintText;
  final String errorText;
  final bool obscureText;
  final Function(String) returnedParameter;

  const CustomInputForm({
    Key? key,
    required this.hintText,
    required this.errorText,
    this.obscureText = false,
    required this.returnedParameter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
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
