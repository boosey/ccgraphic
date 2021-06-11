import 'dart:developer';
import 'dart:math' as math;
import 'dart:ui';
import 'package:ccgraphic/constants.dart';
import 'package:flutter/material.dart';
import 'package:text_x_arc/text_x_arc.dart';
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

  double titleRadius();
  double sectionRadius();
  double startDrawRadians();
  double startHitTestRadians();
  bool hitTest(Offset p);

  double startDrawDegrees() {
    return vector.degrees(this.startDrawRadians());
  }

  double startHitTestDegrees() {
    return vector.degrees(this.startHitTestRadians());
  }

  double sweepDegrees() {
    return vector.degrees(this.sweepRadians);
  }

  double rotationsDegrees() {
    return vector.degrees(this.rotationRadians);
  }

  Rect boundingRectangle() {
    return Rect.fromCircle(
      center: Offset(radius(), radius()),
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
    a = correctForNegative(a);
    log("calculating angle for: " + p.toString() + " = " + a.toString());
    return a;
  }

  correctForNegative(double a) {
    return a < 0 ? Constants.d360 + a : a;
  }

  calculateRayLength(Offset p) {
    var asq = math.pow(p.dx, 2);
    var bsq = math.pow(p.dy, 2);
    return math.sqrt(asq + bsq);
  }

  double sizeRatio() {
    return this.diameter / Constants.graphicFullSize;
  }

  double radius() {
    return diameter / 2;
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

  void draw(Canvas canvas, Size size) {
    // Main Arc
    canvas.drawArc(
      this.boundingRectangle(),
      this.startDrawRadians(),
      this.sweepRadians,
      true,
      this.brush,
    );

    // Outline of Arc
    canvas.drawArc(
      this.boundingRectangle(),
      this.startDrawRadians(),
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

    double fontSize = Constants.mainFontSize * sizeRatio();

    TextStyle style = this.style.copyWith(fontSize: fontSize);

    // Section Title
    paintArcText(
      this.title,
      canvas,
      size,
      this.titleRadius(),
      textPainter,
      style,
      this.startDrawDegrees(),
      this.startDrawDegrees() + this.sweepDegrees(),
      this.baseline,
    );
  }
}
