import 'package:flutter/material.dart';
import 'empty_handler.dart';

dynamic snapShotBuilder({
  required dynamic snapshot,
  required dynamic widget,
  Widget? shimmer,
  String emptyMessage = "No Products Found",
}) {
  if (snapshot.hasData) {
    //check if  modal s empty
    if (snapshot.data!.size <= 0) {
      return emptyHandler(message: emptyMessage);
    } else {
      return widget;
    }
  } else if (snapshot.hasError) {
    return emptyHandler(message: snapshot.error.toString());
  }

  if (shimmer == null) {
    return Center(
      child: Center(child: CircularProgressIndicator()),
    );
  } else {
    return shimmer;
  }
}
