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
  final _textPainter = TextPainter(textDirection: TextDirection.ltr);
  final ccSectionStart =
      (int i) => Constants.North + (Constants.CCSectionPortion * i);
  final ibmSectionStart =
      (int i) => Constants.North + (Constants.IBMSectionPortion * i);

  @override
  void paint(Canvas canvas, Size size) async {
    final center = Offset(size.width / 2, size.height / 2);
    final side = size.shortestSide;
    final ccLogoRadius = side * Constants.CCLogoSizePct;
    final ccSectionRadius = side * Constants.CCSectionSizePct;
    final ibmSectionRadius = side * Constants.IBMSectionSizePct;

    final ccLogoBrush = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final ccResearchSectionBrush = Paint()
      ..color = Color.fromRGBO(6, 103, 171, 1.0)
      ..style = PaintingStyle.fill;

    final ccITSectionBrush = Paint()
      ..color = Color.fromRGBO(0, 106, 58, 1.0)
      ..style = PaintingStyle.fill;

    final ccResearchSectionRect =
        Rect.fromCircle(center: center, radius: ccSectionRadius);

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

    final ibmSectionRect =
        Rect.fromCircle(center: center, radius: ibmSectionRadius);

    final drawIBMSection = (i, brush) => canvas.drawArc(ibmSectionRect,
        ibmSectionStart(i), Constants.IBMSectionPortion, true, brush);

    final drawCCSection = (i, brush) => canvas.drawArc(ccResearchSectionRect,
        ccSectionStart(i), Constants.CCSectionPortion, true, brush);

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
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  void paintTextArc(
      Canvas canvas, double radius, String text, TextStyle style, Size size,
      {double initialAngle = 0}) {
    canvas.translate(size.width / 2, size.height / 2 - radius);

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
  }

  double _drawLetter(Canvas canvas, String letter, double prevAngle,
      TextStyle textStyle, double radius) {
    _textPainter.text = TextSpan(text: letter, style: textStyle);
    _textPainter.layout(
      minWidth: 0,
      maxWidth: double.maxFinite,
    );

    final double d = _textPainter.width;
    final double alpha = 2 * math.asin(d / (2 * radius));

    final newAngle = _calculateRotationAngle(prevAngle, alpha);
    canvas.rotate(newAngle);

    _textPainter.paint(canvas, Offset(0, -_textPainter.height));
    canvas.translate(d, 0);

    return alpha;
  }

  double _calculateRotationAngle(double prevAngle, double alpha) =>
      (alpha + prevAngle) / 2;
}
