import 'dart:developer';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:text_x_arc/text_x_arc.dart';
import 'constants.dart';
import 'section.dart';

class CCSection extends Section {
  CCSection({
    required sectionNumber,
    required title,
    required sectionBrush,
  }) {
    super.sectionNumber = sectionNumber;
    super.title = title;
    super.brush = sectionBrush;

    super.sweepRadians = Constants.r180;
    super.style = Constants.ccTextStyle;
    super.baseline = ArcTextBaseline.Center;
  }

  static final _sections = [
    CCSection(
        sectionNumber: 0,
        title: "IT",
        sectionBrush: Section.brushFor(color: Constants.CCGreen)),
    CCSection(
        sectionNumber: 1,
        title: "Research",
        sectionBrush: Section.brushFor(color: Constants.CCBlue)),
  ];

  static List<Section> sections() {
    return _sections;
  }

  @override
  bool hitTest(Offset point) {
    double startAngle = this.startDrawDegrees();
    double endAngle = startAngle + this.sweepDegrees();
    double angle = calculateAngleForPoint(point);
    double rayLen = calculateRayLength(point);

    angle = (angle > 0) && (angle <= 90) ? angle + 360 : angle;

    log("start: " +
        startAngle.toString() +
        " end: " +
        endAngle.toString() +
        " angle: " +
        angle.truncate().toString());

    if (angle >= math.min(startAngle, endAngle) &&
        angle <= math.max(startAngle, endAngle) &&
        rayLen < this.sectionRadius()) {
      return true;
    } else
      return false;
  }

  @override
  double startDrawRadians() {
    double r = (this.sweepRadians * sectionNumber) + (math.pi / 2);
    r = r > (math.pi * 2) ? r % (math.pi * 2) : r;

    return r % Constants.r360;
  }

  @override
  double startHitTestRadians() {
    double r = (this.sweepRadians * sectionNumber) +
        Constants.r90 +
        this.rotationRadians;

    r = r > (math.pi * 2) ? r % (math.pi * 2) : r;

    return r % Constants.r360;
  }

  @override
  double sectionRadius() {
    return diameter * Constants.CCSectionSizePct;
  }

  @override
  double titleRadius() {
    double ccLogoRadius = diameter * Constants.CCLogoSizePct;
    return ccLogoRadius + ((sectionRadius() - ccLogoRadius) / 2);
  }
}
