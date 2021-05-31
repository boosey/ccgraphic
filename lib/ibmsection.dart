import 'dart:developer';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:text_x_arc/text_x_arc.dart';
import 'constants.dart';
import 'section.dart';

class IBMSection extends Section {
  IBMSection({
    required sectionNumber,
    required title,
    required sectionBrush,
  }) {
    super.sectionNumber = sectionNumber;
    super.title = title;
    super.brush = sectionBrush;

    super.sweepRadians = Constants.r45;
    super.style = Constants.ibmTextStyle;
    super.baseline = ArcTextBaseline.Inner;
  }

  static final _sections = [
    IBMSection(
        sectionNumber: 0,
        title: "Quantum",
        sectionBrush: Section.brushFor(color: Constants.IBMQuantumColor)),
    IBMSection(
        sectionNumber: 1,
        title: "Garage",
        sectionBrush: Section.brushFor(color: Constants.IBMGarageColor)),
    IBMSection(
        sectionNumber: 2,
        title: "Research",
        sectionBrush: Section.brushFor(color: Constants.IBMResearchColor)),
    IBMSection(
        sectionNumber: 3,
        title: "GBS",
        sectionBrush: Section.brushFor(color: Constants.IBMGBSColor)),
    IBMSection(
        sectionNumber: 4,
        title: "Quantum",
        sectionBrush: Section.brushFor(color: Constants.IBMQuantumColor)),
    IBMSection(
        sectionNumber: 5,
        title: "Garage",
        sectionBrush: Section.brushFor(color: Constants.IBMGarageColor)),
    IBMSection(
        sectionNumber: 6,
        title: "Research",
        sectionBrush: Section.brushFor(color: Constants.IBMResearchColor)),
    IBMSection(
        sectionNumber: 7,
        title: "GBS",
        sectionBrush: Section.brushFor(color: Constants.IBMGBSColor)),
  ];

  static List<Section> sections() {
    return _sections;
  }

  @override
  bool hitTest(Offset point) {
    double startAngle = this.startDrawDegrees();
    double endAngle = startAngle + this.sweepDegrees();

    double angle = calculateAngleForPoint(point);
    var rayLen = calculateRayLength(point);

    if (startAngle > 360 - (360 / 8)) {
      angle += 360;
    }

    log("start: " +
        startAngle.toString() +
        " end: " +
        endAngle.toString() +
        " angle: " +
        angle.truncate().toString());

    if (angle >= math.min(startAngle, endAngle) &&
        angle <= math.max(startAngle, endAngle) &&
        rayLen < this.sectionRadius())
      return true;
    else
      return false;
  }

  @override
  double startDrawRadians() {
    double r = (this.sweepRadians * this.sectionNumber) % (math.pi * 2);
    return r;
  }

  @override
  double startHitTestRadians() {
    double r =
        ((this.sweepRadians * this.sectionNumber) + this.rotationRadians) %
            (math.pi * 2);
    return r;
  }

  @override
  double sectionRadius() {
    return diameter * Constants.IBMSectionSizePct;
  }

  @override
  double titleRadius() {
    return sectionRadius() - 10;
  }
}
