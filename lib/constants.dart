import 'dart:math' as math;
import 'package:flutter/material.dart';

class Constants {
  static const double r360 = math.pi * 2;
  static const double r270 = r180 + r90;
  static const double r180 = r360 / 2;
  static const double r90 = r180 / 2;
  static const double r45 = r90 / 2;
  static const double r22 = r45 / 2;

  static const double d360 = 360;

  static const double graphicFullSize = 850;
  static const double mainFontSize = 28;
  static const double projectFontSize = 16;
  static const double projectLineScaleFactor = 1.5;
  static const double ibmSectionBaseHeight = 100;

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
  static final h2d = (String h) => int.parse(h, radix: 16);

  static const CCBlue = Color.fromRGBO(6, 103, 171, 1.0);
  static const CCGreen = Color.fromRGBO(0, 106, 58, 1.0);
  static Color iBMResearchColor = Color.fromRGBO(0, h2d("1d"), h2d("6c"), 1.0);
  static Color iBMQuantumColor = Color.fromRGBO(0, h2d("2d"), h2d("9c"), 1.0);
  static Color iBMGarageColor = Color.fromRGBO(0, h2d("43"), h2d("ce"), 1.0);
  static Color iBMGBSColor =
      Color.fromRGBO(h2d("0f"), h2d("62"), h2d("fe"), 1.0);
}
