import 'dart:math' as math;
import 'package:flutter/material.dart';

class Constants {
  static const double r360 = math.pi * 2;
  static const double r270 = r180 + r90;
  static const double r180 = r360 / 2;
  static const double r90 = r180 / 2;
  static const double r45 = r90 / 2;
  static const double r22 = r45 / 2;

  static const double fullSize = 850;
  static const double fontSize = 28;

  static const int animationMilliseconds = 6000;

  static const ccTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    textBaseline: TextBaseline.alphabetic,
  );

  static final ibmTextStyle = ccTextStyle;

  static const double CCLogoSizePct = 0.10;
  static const double CCSectionSizePct = 0.20;
  static const double IBMSectionSizePct = 0.5;

  // Colors
  static const CCBlue = Color.fromRGBO(6, 103, 171, 1.0);
  static const CCGreen = Color.fromRGBO(0, 106, 58, 1.0);
  static const IBMResearchColor = Color.fromRGBO(52, 122, 120, 1.0);
  static const IBMQuantumColor = Color.fromRGBO(126, 75, 242, 1.0);
  static const IBMGarageColor = Color.fromRGBO(7, 48, 150, 1.0);
  static const IBMGBSColor = Color.fromRGBO(37, 101, 244, 1.0);
}
