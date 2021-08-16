import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

loggerInfo({required String message}) {
  Logger logger = Logger();
  logger.i(message);
}

loggerError({required String message}) {
  Logger logger = Logger();
  logger.e(message);
}
