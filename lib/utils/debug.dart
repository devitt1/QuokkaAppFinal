// Thing you want printed when errors occur
import 'package:flutter/material.dart';

void printError(String input) {
  debugPrint(input);
}

// Things you want printed for debug but not in production builds
void printDebug(String input) {
  // ignore: avoid_print
  print(input);
}
