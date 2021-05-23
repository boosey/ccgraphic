import 'dart:math' as math;
import 'dart:ui';

class Constants {
  static const CCLogoSizePct = 0.10;
  static const CCSectionSizePct = 0.20;
  // Origin at 90 degrees, so counter rotate 90 degrees
  static const North = -math.pi / 2;
  static const CCSectionPortionRadians = math.pi; // 180 degrees
  static const IBMSectionSizePct = 0.5;
  static const IBMSectionPortionRadians = math.pi * 2 / 8; // 360 degrees / 8
  static const ccBlue = Color.fromRGBO(6, 103, 171, 1.0);
  static const ccGreen = Color.fromRGBO(0, 106, 58, 1.0);
}
