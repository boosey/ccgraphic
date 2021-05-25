import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:text_x_arc/text_x_arc.dart';
import 'package:vector_math/vector_math.dart' as vector;

class DrawingInfo {
  Rect? rect;
  double sectionRadius = 0;
  double titleRadius = 0;
  double Function(int) sectionStartRadians;
  double sectionPortionRadians;
  late TextStyle style;
  ArcTextBaseline baseline;

  DrawingInfo({
    required this.sectionStartRadians,
    required this.sectionPortionRadians,
    required this.baseline,
    required this.style,
  });

  double sectionStartDegrees(i) => vector.degrees(sectionStartRadians(i));
  double get sectionPortionDegrees => vector.degrees(sectionPortionRadians);

  set fontSize(double s) {
    this.style = this.style.copyWith(fontSize: s);
  }
}

class SectionInfo {
  String title;
  Paint sectionBrush;
  DrawingInfo drawingInfo;
  int sectionNumber;
  double sectionPortionDegrees;

  SectionInfo({
    required this.sectionNumber,
    required this.title,
    required this.sectionBrush,
    required this.drawingInfo,
    required this.sectionPortionDegrees,
  });

  bool checkPointForIBM(Offset point) {
    double radius = drawingInfo.sectionRadius;

    double startAngle =
        correctForNegative(drawingInfo.sectionStartDegrees(sectionNumber));

    double sectionPercent = sectionPortionDegrees / 360;
    double endAngle = (360 * sectionPercent) + startAngle;

    var angle = calculateAngle(point);
    var rayLen = calculateRayLength(point);

    if (angle >= math.min(startAngle, endAngle) &&
        angle <= math.max(startAngle, endAngle) &&
        rayLen < radius)
      return true;
    else
      return false;
  }

  calculateAngle(Offset p) {
    var a = vector.degrees(math.atan2(p.dy, p.dx));
    return correctForNegative(a);
  }

  correctForNegative(double a) {
    return a < 0 ? 360 + a : a;
  }

  calculateRayLength(Offset p) {
    var asq = math.pow(p.dx, 2);
    var bsq = math.pow(p.dy, 2);
    return math.sqrt(asq + bsq);
  }
}

class Constants {
  // CC Logo level
  static const CCLogoSizePct = 0.10;

  // CC Section
  static const double CCSectionSizePct = 0.20;
  static const double CCSectionPortionRadians = math.pi; // 180 degrees
  // ignore: non_constant_identifier_names
  static double CCSectionPortionDegrees =
      vector.degrees(CCSectionPortionRadians); // 180 degrees

  // IBM Section
  static const double IBMSectionSizePct = 0.5;
  // 360 degrees / 8 = 45 degrees
  static const double IBMSectionPortionRadians = ((math.pi * 2) / 8);
  // ignore: non_constant_identifier_names
  static final double IBMSectionPortionDegrees =
      vector.degrees(IBMSectionPortionRadians);

  // Colors
  static const CCBlue = Color.fromRGBO(6, 103, 171, 1.0);
  static const CCGreen = Color.fromRGBO(0, 106, 58, 1.0);

  static final ccSectionStartRadians =
      (int i) => (Constants.CCSectionPortionRadians * i) + (math.pi / 2);

  static final ibmSectionStartRadians =
      (int i) => (Constants.IBMSectionPortionRadians * i);

  static final ccDrawingInfo = DrawingInfo(
    sectionStartRadians: ccSectionStartRadians,
    sectionPortionRadians: Constants.CCSectionPortionRadians,
    baseline: ArcTextBaseline.Inner,
    style: ccTextStyle,
  );

  static final ibmDrawingInfo = DrawingInfo(
    sectionStartRadians: ibmSectionStartRadians,
    sectionPortionRadians: Constants.IBMSectionPortionRadians,
    baseline: ArcTextBaseline.Inner,
    style: ibmTextStyle,
  );

  static final ccTextStyle = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    textBaseline: TextBaseline.alphabetic,
  );

  static final ibmTextStyle = ccTextStyle;

  static setCCRect(Rect r) {
    ccSectionInfo.asMap().forEach((i, s) {
      s.drawingInfo.rect = r;
    });
  }

  static setCCFontSize(double size) {
    ccSectionInfo.asMap().forEach((i, s) {
      s.drawingInfo.style = s.drawingInfo.style.copyWith(fontSize: size);
    });
  }

  static setCCTitleRadius(double r) {
    ccSectionInfo.asMap().forEach((i, s) {
      s.drawingInfo.titleRadius = r;
    });
  }

  static setIBMRect(Rect r) {
    ibmSectionInfo.asMap().forEach((i, s) {
      s.drawingInfo.rect = r;
    });
  }

  static setIBMFontSize(double size) {
    ibmSectionInfo.asMap().forEach((i, s) {
      s.drawingInfo.style = s.drawingInfo.style.copyWith(fontSize: size);
    });
  }

  static setIBMTitleRadius(double r) {
    ibmSectionInfo.asMap().forEach((i, s) {
      s.drawingInfo.titleRadius = r;
    });
  }

  static setIBMSectionRadius(double r) {
    ibmSectionInfo.asMap().forEach((i, s) {
      s.drawingInfo.sectionRadius = r;
    });
  }

  static final outlinePaint = Paint()
    ..color = Colors.white
    ..strokeWidth = 4.0
    ..style = PaintingStyle.stroke;

  static Paint paintFor({required Color color}) {
    final p = Paint();
    p.color = color;
    p.style = PaintingStyle.fill;
    return p;
  }

  static final ccSectionInfo = [
    SectionInfo(
      sectionNumber: 0,
      title: "IT",
      sectionBrush: paintFor(color: CCGreen),
      drawingInfo: ccDrawingInfo,
      sectionPortionDegrees: Constants.CCSectionPortionDegrees,
    ),
    SectionInfo(
      sectionNumber: 1,
      title: "Research",
      sectionBrush: paintFor(color: CCBlue),
      drawingInfo: ccDrawingInfo,
      sectionPortionDegrees: Constants.CCSectionPortionDegrees,
    ),
  ];

  static final ibmSectionInfo = [
    SectionInfo(
      sectionNumber: 0,
      title: "Systems",
      sectionBrush: paintFor(color: Colors.lime),
      drawingInfo: ibmDrawingInfo,
      sectionPortionDegrees: Constants.IBMSectionPortionDegrees,
    ),
    SectionInfo(
      sectionNumber: 1,
      title: "Garage",
      sectionBrush: paintFor(color: Colors.blue),
      drawingInfo: ibmDrawingInfo,
      sectionPortionDegrees: Constants.IBMSectionPortionDegrees,
    ),
    SectionInfo(
      sectionNumber: 2,
      title: "Research",
      sectionBrush: paintFor(color: Colors.amber),
      drawingInfo: ibmDrawingInfo,
      sectionPortionDegrees: Constants.IBMSectionPortionDegrees,
    ),
    SectionInfo(
      sectionNumber: 3,
      title: "GBS",
      sectionBrush: paintFor(color: Colors.deepOrange),
      drawingInfo: ibmDrawingInfo,
      sectionPortionDegrees: Constants.IBMSectionPortionDegrees,
    ),
    SectionInfo(
      sectionNumber: 4,
      title: "Systems",
      sectionBrush: paintFor(color: Colors.lime),
      drawingInfo: ibmDrawingInfo,
      sectionPortionDegrees: Constants.IBMSectionPortionDegrees,
    ),
    SectionInfo(
      sectionNumber: 5,
      title: "Garage",
      sectionBrush: paintFor(color: Colors.blue),
      drawingInfo: ibmDrawingInfo,
      sectionPortionDegrees: Constants.IBMSectionPortionDegrees,
    ),
    SectionInfo(
      sectionNumber: 6,
      title: "Research",
      sectionBrush: paintFor(color: Colors.amber),
      drawingInfo: ibmDrawingInfo,
      sectionPortionDegrees: Constants.IBMSectionPortionDegrees,
    ),
    SectionInfo(
      sectionNumber: 7,
      title: "GBS",
      sectionBrush: paintFor(color: Colors.deepOrange),
      drawingInfo: ibmDrawingInfo,
      sectionPortionDegrees: Constants.IBMSectionPortionDegrees,
    ),
  ];
}
