import 'package:flutter/material.dart';

class Measures {
  double _width = 0.0;
  double _height = 0.0;

  static double separator8 = 8;
  static double separator10 = 10;
  static double separator16 = 16;
  static double separator22 = 22;
  static double separator32 = 32;
  static double separator40 = 40;
  static double separator64 = 64;

  static double defaultHeight = 62;

  double deviceWidth = 0;
  double deviceHeight = 0;

  Measures(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = MediaQuery.of(context).size.height;
    deviceWidth = _width;
    deviceHeight = _height;
  }

  double width(double value) => (value * _width) / 100;
  double height(double value) => (value * _height) / 100;
}
