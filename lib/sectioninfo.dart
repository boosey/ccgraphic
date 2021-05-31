import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:text_x_arc/text_x_arc.dart';
import 'constants.dart';
import 'package:vector_math/vector_math.dart' as vector;

abstract class Section {
  late String title;
  late Paint brush;
  late int sectionNumber;
  late double diameter;
  late double sweepRadians;
  late TextStyle style;
  late ArcTextBaseline baseline;
  late double rotationRadians;

  final Paint outlinePaint = Paint()
    ..color = Colors.white
    ..strokeWidth = 4.0
    ..style = PaintingStyle.stroke;

  final TextPainter textPainter = TextPainter(
    textAlign: TextAlign.left,
    textDirection: TextDirection.ltr,
  );

  static List<Section> sectionInfo() {
    throw UnimplementedError();
  }

  double titleRadius();
  double sectionRadius();
  double startRadians();
  bool hitTest(Offset p);

  double startDegrees() {
    return vector.degrees(this.startRadians());
  }

  double sweepDegrees() {
    return vector.degrees(this.sweepRadians);
  }

  double rotationsDegrees() {
    return vector.degrees(this.rotationRadians);
  }

  Rect boundingRectangle() {
    return Rect.fromCircle(
      center: Offset(diameter / 2, diameter / 2),
      radius: this.sectionRadius(),
    );
  }

  static Paint brushFor({required Color color}) {
    final p = Paint();
    p.color = color;
    p.style = PaintingStyle.fill;
    return p;
  }

  calculateAngleForPoint(Offset p) {
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

  paintArcText(
    String text,
    Canvas canvas,
    Size size,
    double radius,
    TextPainter textPainter,
    TextStyle style,
    double startAngle,
    double endAngle,
    ArcTextBaseline baseline,
  ) {
    final centerPos = Offset(size.width / 2, size.height / 2);
    XArcTextDrawer.draw(
        canvas: canvas,
        centerPos: centerPos,
        radius: radius,
        text: text,
        startAngle: startAngle,
        endAngle: endAngle,
        textStyle: style,
        textPainter: textPainter,
        baseline: baseline);
  }

  paintText(
    String text,
    Canvas canvas,
    double span,
    double fontSize,
    double startAngle,
  ) {
    var s = ParagraphStyle(
      textAlign: TextAlign.center,
      fontWeight: FontWeight.bold,
      ellipsis: "...",
    );
    var b = ParagraphBuilder(s);
    b.addText(text);
    var p = b.build();

    p.layout(ParagraphConstraints(width: span));

    canvas.save();
    canvas.rotate(startAngle);
    canvas.drawParagraph(p, Offset(350, 275));
    canvas.restore();
  }

  draw(Canvas canvas, Size size) {
    canvas.drawArc(
      this.boundingRectangle(),
      this.startRadians(),
      this.sweepRadians,
      true,
      this.brush,
    );

    canvas.drawArc(
      this.boundingRectangle(),
      this.startRadians(),
      this.sweepRadians,
      true,
      this.outlinePaint,
    );

    // paintText(
    //   sectInfo.title,
    //   canvas,
    //   sectInfo.drawingInfo.sectionRadius - ccSectionRadius,
    //   sectInfo.drawingInfo.style.fontSize!,
    //   sectInfo.drawingInfo.sectionStartRadians(sectInfo.sectionNumber),
    // );

    paintArcText(
      this.title,
      canvas,
      size,
      this.titleRadius(),
      textPainter,
      this.style,
      this.startDegrees(),
      this.startDegrees() + this.sweepDegrees(),
      this.baseline,
    );
  }
}

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
    double startAngle = this.startDegrees();
    double endAngle = startAngle + this.sweepDegrees();

    double angle = calculateAngleForPoint(point);
    double rayLen = calculateRayLength(point);

    if (angle >= math.min(startAngle, endAngle) &&
        angle <= math.max(startAngle, endAngle) &&
        rayLen < this.sectionRadius()) {
      return true;
    } else
      return false;
  }

  @override
  double startRadians() {
    double r = (this.sweepRadians * sectionNumber) +
        (math.pi / 2) +
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
    double startAngle = this.startDegrees();
    double endAngle = startAngle + this.sweepDegrees();

    double angle = calculateAngleForPoint(point);
    var rayLen = calculateRayLength(point);

    if (startAngle > 360 - (360 / 8)) {
      angle += 360;
    }

    if (angle >= math.min(startAngle, endAngle) &&
        angle <= math.max(startAngle, endAngle) &&
        rayLen < this.sectionRadius())
      return true;
    else
      return false;
  }

  @override
  double startRadians() {
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
