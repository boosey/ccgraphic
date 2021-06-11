// import 'dart:developer';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:text_x_arc/text_x_arc.dart';
import 'constants.dart';
import 'section.dart';

class IBMSection extends Section {
  late List<String> _projects;

  IBMSection({
    required sectionNumber,
    required title,
    required sectionBrush,
    projects,
  }) {
    super.sectionNumber = sectionNumber;
    super.title = title;
    super.brush = sectionBrush;

    if (projects != null) {
      _projects = projects;
    } else {
      _projects = const <String>[];
    }

    super.sweepRadians = Constants.r45;
    super.style = Constants.ibmTextStyle;
    super.baseline = ArcTextBaseline.Inner;
  }

  static final _sections = [
    IBMSection(
        sectionNumber: 0,
        title: "Quantum",
        projects: <String>[],
        sectionBrush: Section.brushFor(color: Constants.iBMQuantumColor)),
    IBMSection(
        sectionNumber: 1,
        title: "Garage",
        projects: <String>[
          "HPC MVP",
          "Data & AI Infra MVP",
        ],
        sectionBrush: Section.brushFor(color: Constants.iBMGarageColor)),
    IBMSection(
        sectionNumber: 2,
        title: "C&CS",
        projects: <String>[],
        sectionBrush: Section.brushFor(color: Constants.iBMResearchColor)),
    IBMSection(
        sectionNumber: 3,
        title: "GBS",
        projects: <String>[],
        sectionBrush: Section.brushFor(color: Constants.iBMGBSColor)),
    IBMSection(
        sectionNumber: 4,
        title: "Systems",
        projects: <String>[],
        sectionBrush: Section.brushFor(color: Constants.iBMQuantumColor)),
    IBMSection(
        sectionNumber: 5,
        title: "Garage",
        projects: <String>[],
        sectionBrush: Section.brushFor(color: Constants.iBMGarageColor)),
    IBMSection(
        sectionNumber: 6,
        title: "Research",
        projects: <String>["Sandbox Env"],
        sectionBrush: Section.brushFor(color: Constants.iBMResearchColor)),
    IBMSection(
        sectionNumber: 7,
        title: "GBS",
        projects: <String>[
          "Sandbox Mgmnt",
        ],
        sectionBrush: Section.brushFor(color: Constants.iBMGBSColor)),
  ];

  static List<Section> sections() {
    return _sections;
  }

  @override
  void draw(Canvas canvas, Size size) {
    super.draw(canvas, size);

    TextStyle style = Constants.ibmTextStyle
        .copyWith(fontSize: 16 * sizeRatio(), color: Colors.white);

    _projects.asMap().forEach((i, project) {
      InlineSpan span = TextSpan(
        text: project,
        style: style,
      );

      TextPainter painter = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
        maxLines: 2,
        ellipsis: "...",
      );

      painter.layout();
      var lm = painter.computeLineMetrics().first;
      var a = startDrawRadians() + Constants.r90;
      double yOffset = -this.titleRadius() +
          ((i + 1) * lm.height * Constants.projectLineScaleFactor);

      canvas.save();
      canvas.translate(radius(), radius());
      canvas.rotate(a);
      canvas.translate(-lm.width / 2, -lm.height / 2);
      canvas.rotate(Constants.r22);
      painter.paint(canvas, Offset(0, yOffset));
      // ((i + 1) * (Constants.projectLineFullHeight * sizeRatio()))));
      canvas.restore();
    });
  }

  @override
  bool hitTest(Offset point) {
    double startAngle = this.startDrawDegrees();
    double endAngle = startAngle + this.sweepDegrees();

    double angle = calculateAngleForPoint(point);
    var rayLen = calculateRayLength(point);

    if (startAngle > Constants.d360 - (Constants.d360 / sections().length)) {
      angle += Constants.d360;
    }

    if (angle >= math.min(startAngle, endAngle) &&
        angle <= math.max(startAngle, endAngle) &&
        rayLen < this.sectionRadius())
      return true;
    else
      return false;
  }

  @override
  double startDrawRadians() {
    double r = (this.sweepRadians * this.sectionNumber) % Constants.r360;
    return r;
  }

  @override
  double startHitTestRadians() {
    double r =
        ((this.sweepRadians * this.sectionNumber) + this.rotationRadians) %
            Constants.r360;
    return r;
  }

  @override
  double sectionRadius() {
    return diameter * Constants.IBMSectionSizePct;
  }

  @override
  double titleRadius() {
    return (this.boundingRectangle().height / 2) - 10;
  }

  double minimumBaseHeight() {
    var r = Constants.ibmSectionBaseHeight +
        ((Constants.CCSectionSizePct) * diameter);

    return r;
  }

  @override
  Rect boundingRectangle() {
    TextPainter painter = TextPainter(
      text: TextSpan(text: "Dummy"),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      maxLines: 2,
      ellipsis: "...",
    )..layout();
    var lm = painter.computeLineMetrics();

    double r = minimumBaseHeight() +
        (this._projects.length *
            lm[0].height *
            Constants.projectLineScaleFactor);
    return Rect.fromCircle(
      center: Offset(radius(), radius()),
      radius: r,
    );
  }
}
