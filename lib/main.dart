import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:virtual_ggroceries/view/screens/init_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays(
      [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  runApp(initScreen());
}
