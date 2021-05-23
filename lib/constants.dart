import 'dart:math' as math;
import 'dart:ui';

class Constants {
  // Origin at 90 degrees, so counter rotate 90 degrees
  static const NorthRadians = -math.pi / 2;
  static const NorthDegrees = -90.0;

  // CC Logo level
  static const CCLogoSizePct = 0.10;

  // CC Section
  static const CCSectionSizePct = 0.20;
  static const CCSectionPortionRadians = math.pi; // 180 degrees
  static const CCSectionPortionDegrees = 180; // 180 degrees

  // IBM Section
  static const IBMSectionSizePct = 0.5;
  // 360 degrees / 8 = 45 degrees
  static const IBMSectionPortionRadians = (math.pi * 2) / 8;
  static const IBMSectionPortionDegrees = 360 / 8;

  // Colors
  static const CCBlue = Color.fromRGBO(6, 103, 171, 1.0);
  static const CCGreen = Color.fromRGBO(0, 106, 58, 1.0);

  static const CCSectionTitles = [
    "Research",
    "IT",
  ];
  static const IBMSectionTitles = [
    "Research",
    "GBS",
    "Systems",
    "Garage",
    "Research",
    "GBS",
    "Systems",
    "Garage",
  ];
}
