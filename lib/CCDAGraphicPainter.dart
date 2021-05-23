import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'constants.dart';
import 'dart:math' as math;

class CCDAGraphicPaint extends StatelessWidget {
  final double width;
  final double height;

  const CCDAGraphicPaint({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CCDAGraphicPainter(),
    );
  }
}

class CCDAGraphicPainter extends CustomPainter {
  final ccSectionStart =
      (int i) => Constants.North + (Constants.CCSectionPortionRadians * i);
  final ibmSectionStart =
      (int i) => Constants.North + (Constants.IBMSectionPortionRadians * i);

  @override
  void paint(Canvas canvas, Size size) async {
    final center = Offset(size.width / 2, size.height / 2);
    final side = size.shortestSide;
    final ccLogoRadius = side * Constants.CCLogoSizePct;
    final ccSectionRadius = side * Constants.CCSectionSizePct;
    final ibmSectionRadius = side * Constants.IBMSectionSizePct;

    final fontSize = (ccSectionRadius - ccLogoRadius) / 3;

    final ccTextStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: fontSize,
      textBaseline: TextBaseline.alphabetic,
    );

    final ccTextRadius =
        ccLogoRadius + ((ccSectionRadius - ccLogoRadius) / 3.5);

    final ccLogoBrush = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final ccResearchSectionBrush = Paint()
      ..color = Constants.ccBlue
      ..style = PaintingStyle.fill;

    final ccITSectionBrush = Paint()
      ..color = Constants.ccGreen
      ..style = PaintingStyle.fill;

    final ccSectionRect = Rect.fromCircle(
      center: center,
      radius: ccSectionRadius,
    );

    final ibmResearchSectionBrush = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.fill;

    final ibmGBSSectionBrush = Paint()
      ..color = Colors.deepOrange
      ..style = PaintingStyle.fill;

    final ibmSystemsSectionBrush = Paint()
      ..color = Colors.lime
      ..style = PaintingStyle.fill;

    final ibmTechGarageSectionBrush = Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.fill;

    final ibmSectionRect = Rect.fromCircle(
      center: center,
      radius: ibmSectionRadius,
    );

    final drawIBMSection = (i, brush) => canvas.drawArc(
          ibmSectionRect,
          ibmSectionStart(i),
          Constants.IBMSectionPortionRadians,
          true,
          brush,
        );

    final drawCCSection = (i, brush) => canvas.drawArc(
          ccSectionRect,
          ccSectionStart(i),
          Constants.CCSectionPortionRadians,
          true,
          brush,
        );

    // IBM Sections
    drawIBMSection(0, ibmResearchSectionBrush);
    drawIBMSection(1, ibmGBSSectionBrush);
    drawIBMSection(2, ibmSystemsSectionBrush);
    drawIBMSection(3, ibmTechGarageSectionBrush);
    drawIBMSection(4, ibmResearchSectionBrush);
    drawIBMSection(5, ibmGBSSectionBrush);
    drawIBMSection(6, ibmSystemsSectionBrush);
    drawIBMSection(7, ibmTechGarageSectionBrush);

    // CC Sections
    drawCCSection(0, ccResearchSectionBrush);
    drawCCSection(1, ccITSectionBrush);

    // CC Logo
    canvas.drawCircle(center, ccLogoRadius, ccLogoBrush);

    paintTextArc(
      canvas,
      ccTextRadius,
      "Research",
      ccTextStyle,
      size,
      Constants.CCSectionPortionRadians,
      initialAngle: ccSectionStart(0),
    );

    paintTextArc(
      canvas,
      ccTextRadius,
      "IT",
      ccTextStyle,
      size,
      Constants.CCSectionPortionRadians,
      initialAngle: ccSectionStart(1),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  void paintTextArc(
    Canvas canvas,
    double radius,
    String text,
    TextStyle style,
    Size size,
    double canvasArcRadians, {
    double initialAngle = 0,
  }) {
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2 - radius);

    double textPixelLength = calculateTextWidth(text, style);

    double textRadians = textPixelLength / radius;
    initialAngle += (canvasArcRadians - (textRadians / 2));

    if (initialAngle != 0) {
      final d = 2 * radius * math.sin(initialAngle / 2);
      final rotationAngle = _calculateRotationAngle(0, initialAngle);
      canvas.rotate(rotationAngle);
      canvas.translate(d, 0);
    }

    double angle = initialAngle;
    for (int i = 0; i < text.length; i++) {
      angle = _drawLetter(canvas, text[i], angle, style, radius);
    }
    canvas.restore();
  }

  double _drawLetter(Canvas canvas, String letter, double prevAngle,
      TextStyle textStyle, double radius) {
    final double d = calculateLetterWidth(letter, textStyle);
    final double alpha = 2 * math.asin(d / (2 * radius));

    final newAngle = _calculateRotationAngle(prevAngle, alpha);
    canvas.rotate(newAngle);

    final txtPainter = textPainterFor(letter, textStyle);
    txtPainter.paint(
      canvas,
      Offset(0, -txtPainter.height),
    );
    canvas.translate(d, 0);

    return alpha;
  }

  TextPainter textPainterFor(String t, TextStyle style) {
    final txtPainter = TextPainter(textDirection: TextDirection.ltr);
    txtPainter.text = TextSpan(text: t, style: style);
    txtPainter.layout(
      minWidth: 0,
      maxWidth: double.maxFinite,
    );
    return txtPainter;
  }

  double calculateLetterWidth(String c, TextStyle style) {
    return textPainterFor(c, style).width;
  }

  double calculateTextWidth(String s, TextStyle style) {
    double len = 0;
    for (int i = 0; i < s.length; i++) {
      len += calculateLetterWidth(s[i], style);
    }
    return len;
  }

  double _calculateRotationAngle(double prevAngle, double alpha) =>
      (alpha + prevAngle) / 2;
}
