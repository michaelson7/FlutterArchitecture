import 'package:flutter/material.dart';

snackBarBuilder({required BuildContext context, required String message}) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
