import 'package:flutter/material.dart';

dynamic SnaphotHandler({required dynamic snapshot, required dynamic widget}) {
  if (snapshot.hasData) {
    return widget;
  } else if (snapshot.hasError) {
    return Text(snapshot.error.toString());
  }
  return Center(
    child: CircularProgressIndicator(),
  );
}
