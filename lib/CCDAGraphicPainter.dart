import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'constants.dart';
import 'dart:math' as math;
import 'package:text_x_arc/text_x_arc.dart';

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
  final ccSectionStart = (int i) =>
      Constants.NorthRadians + (Constants.CCSectionPortionRadians * i);
  final ibmSectionStart = (int i) =>
      Constants.NorthRadians + (Constants.IBMSectionPortionRadians * i);

  final ccSectionStartDegrees = (int i) =>
      Constants.NorthDegrees + (Constants.CCSectionPortionDegrees * i);
  final ibmSectionStartDegrees = (int i) =>
      Constants.NorthDegrees + (Constants.IBMSectionPortionDegrees * i);

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

    final ibmTextStyle = ccTextStyle;

    final textPainter = TextPainter(
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    );

    final ccTextRadius = ccLogoRadius + ((ccSectionRadius - ccLogoRadius) / 2);

    final ibmTextRadius = ibmSectionRadius - 10;

    final ccLogoBrush = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final ccResearchSectionBrush = Paint()
      ..color = Constants.CCBlue
      ..style = PaintingStyle.fill;

    final ccITSectionBrush = Paint()
      ..color = Constants.CCGreen
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

    Constants.CCSectionTitles.asMap().forEach((i, title) {
      newPaintTextArc(
        title,
        canvas,
        size,
        ccTextRadius,
        textPainter,
        ccTextStyle,
        ccSectionStartDegrees(i),
        ccSectionStartDegrees(i) + Constants.CCSectionPortionDegrees,
        ArcTextBaseline.Center,
      );
    });

    Constants.IBMSectionTitles.asMap().forEach((i, title) {
      newPaintTextArc(
        title,
        canvas,
        size,
        ibmTextRadius,
        textPainter,
        ibmTextStyle,
        ibmSectionStartDegrees(i),
        ibmSectionStartDegrees(i) + Constants.IBMSectionPortionDegrees,
        ArcTextBaseline.Inner,
      );
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  newPaintTextArc(
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

  void paintTextArc(
    Canvas canvas,
    double radius,
    String text,
    TextStyle style,
    Size size,
    double sectionArcRadians, {
    double initialAngle = 0,
  }) {
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2 - radius);

    double textPixelLength = calculateTextWidth(text, style);
    double textRadians = textPixelLength / radius;
    double offset = (sectionArcRadians - (textRadians / 2));
    initialAngle = initialAngle + offset;

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
    textPainterFor(c, style).preferredLineHeight;
    return textPainterFor(c, style).width;
  }

  double calculateLine(String c, TextStyle style) {
    return textPainterFor(c, style).preferredLineHeight;
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
