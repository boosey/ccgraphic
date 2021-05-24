import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:text_x_arc/text_x_arc.dart';
import 'package:vector_math/vector_math.dart' as vector;

class DrawingInfo {
  Rect? rect;
  double sectionRadius = 0;
  double titleRadius = 0;
  double Function(int) sectionStartRadians;
  double Function(int) sectionStartDegrees;
  double sectionPortionRadians;
  late TextStyle style;
  ArcTextBaseline baseline;

  DrawingInfo({
    required this.sectionStartRadians,
    required this.sectionStartDegrees,
    required this.sectionPortionRadians,
    required this.baseline,
    required this.style,
  });

  double get sectionPortionDegrees => vector.degrees(sectionPortionRadians);

  set fontSize(double s) {
    this.style = this.style.copyWith(fontSize: s);
  }
}

class SectionInfo {
  String title;
  Paint sectionBrush;
  late DrawingInfo drawingInfo;

  SectionInfo({
    required this.title,
    required this.sectionBrush,
    required this.drawingInfo,
  });
}

class Constants {
  static const OneDegreeInRadians = 0.0174533;
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
  static const IBMSectionPortionRadians = ((math.pi * 2) / 8);
  static const IBMSectionPortionDegrees = (360 / 8);

  // Colors
  static const CCBlue = Color.fromRGBO(6, 103, 171, 1.0);
  static const CCGreen = Color.fromRGBO(0, 106, 58, 1.0);

  static final ccSectionStartRadians = (int i) =>
      Constants.NorthRadians + (Constants.CCSectionPortionRadians * i);

  static final ccSectionStartDegrees =
      (int i) => vector.degrees(ccSectionStartRadians(i));

  static final ibmSectionStartRadians = (int i) =>
      Constants.NorthRadians +
      (Constants.IBMSectionPortionRadians * i) +
      OneDegreeInRadians;

  static final ibmSectionStartDegrees =
      (int i) => vector.degrees(ibmSectionStartRadians(i));

  static final ccDrawingInfo = DrawingInfo(
    sectionStartRadians: ccSectionStartRadians,
    sectionStartDegrees: ccSectionStartDegrees,
    sectionPortionRadians: Constants.CCSectionPortionRadians,
    baseline: ArcTextBaseline.Inner,
    style: ccTextStyle,
  );

  static final ibmDrawingInfo = DrawingInfo(
    sectionStartRadians: ibmSectionStartRadians,
    sectionStartDegrees: ibmSectionStartDegrees,
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

  static setCCSectionRadius(double r) {
    ccSectionInfo.asMap().forEach((i, s) {
      s.drawingInfo.sectionRadius = r;
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
      title: "Research",
      sectionBrush: paintFor(color: CCBlue),
      drawingInfo: ccDrawingInfo,
    ),
    SectionInfo(
      title: "IT",
      sectionBrush: paintFor(color: CCGreen),
      drawingInfo: ccDrawingInfo,
    ),
  ];

  static final ibmSectionInfo = [
    SectionInfo(
      title: "Research",
      sectionBrush: paintFor(color: Colors.amber),
      drawingInfo: ibmDrawingInfo,
    ),
    SectionInfo(
      title: "GBS",
      sectionBrush: paintFor(color: Colors.deepOrange),
      drawingInfo: ibmDrawingInfo,
    ),
    SectionInfo(
      title: "Systems",
      sectionBrush: paintFor(color: Colors.lime),
      drawingInfo: ibmDrawingInfo,
    ),
    SectionInfo(
      title: "Garage",
      sectionBrush: paintFor(color: Colors.blue),
      drawingInfo: ibmDrawingInfo,
    ),
    SectionInfo(
      title: "Research",
      sectionBrush: paintFor(color: Colors.amber),
      drawingInfo: ibmDrawingInfo,
    ),
    SectionInfo(
      title: "GBS",
      sectionBrush: paintFor(color: Colors.deepOrange),
      drawingInfo: ibmDrawingInfo,
    ),
    SectionInfo(
      title: "Systems",
      sectionBrush: paintFor(color: Colors.lime),
      drawingInfo: ibmDrawingInfo,
    ),
    SectionInfo(
      title: "Garage",
      sectionBrush: paintFor(color: Colors.blue),
      drawingInfo: ibmDrawingInfo,
    ),
  ];
}
