import 'dart:math' as math;

class Constants {
  static const CCLogoSizePct = 0.10;
  static const CCSectionSizePct = 0.20;
  // Origin at 90 degrees, so counter rotate 90 degrees
  static const North = -math.pi / 2;
  static const CCSectionPortion = math.pi; // 180 degrees
  static const IBMSectionSizePct = 0.5;
  static const IBMSectionPortion = math.pi * 2 / 8; // 360 degrees / 8
}
