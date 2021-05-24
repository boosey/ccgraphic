import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'constants.dart';
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
  final ibmSectionStart = (int i) =>
      Constants.NorthRadians + (Constants.IBMSectionPortionRadians * i);

  final ibmSectionStartDegrees = (int i) =>
      Constants.NorthDegrees + (Constants.IBMSectionPortionDegrees * i);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final side = size.shortestSide;

    final ccLogoRadius = side * Constants.CCLogoSizePct;
    final ccSectionRadius = side * Constants.CCSectionSizePct;

    final ibmSectionRadius = side * Constants.IBMSectionSizePct;

    final fontSize = (ccSectionRadius - ccLogoRadius) / 3;
    Constants.setCCFontSize(fontSize);
    Constants.setIBMFontSize(fontSize);

    Constants.setIBMTitleRadius(ibmSectionRadius - 10);
    Constants.setIBMRect(Rect.fromCircle(
      center: center,
      radius: ibmSectionRadius,
    ));

    final textPainter = TextPainter(
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    );

    Constants.setCCTitleRadius(
        ccLogoRadius + ((ccSectionRadius - ccLogoRadius) / 2));

    Constants.setCCRect(Rect.fromCircle(
      center: center,
      radius: ccSectionRadius,
    ));

    final ccLogoBrush = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    drawSection(int i, SectionInfo sectInfo) {
      canvas.drawArc(
        sectInfo.drawingInfo.rect!,
        sectInfo.drawingInfo.sectionStartRadians(i),
        sectInfo.drawingInfo.sectionPortionRadians,
        true,
        sectInfo.sectionBrush,
      );

      paintArcText(
        sectInfo.title,
        canvas,
        size,
        sectInfo.drawingInfo.titleRadius,
        textPainter,
        sectInfo.drawingInfo.style,
        sectInfo.drawingInfo.sectionStartDegrees(i),
        sectInfo.drawingInfo.sectionStartDegrees(i) +
            sectInfo.drawingInfo.sectionPortionDegrees,
        sectInfo.drawingInfo.baseline,
      );
    }

    drawIBMSection(i) {
      SectionInfo sectInfo = Constants.ibmSectionInfo[i];
      drawSection(i, sectInfo);
    }

    drawCCSection(i) {
      SectionInfo sectInfo = Constants.ccSectionInfo[i];
      drawSection(i, sectInfo);
    }

    drawIBMSection(0);
    drawIBMSection(1);
    drawIBMSection(2);
    drawIBMSection(3);
    drawIBMSection(4);
    drawIBMSection(5);
    drawIBMSection(6);
    drawIBMSection(7);

    // CC Sections
    drawCCSection(0);
    drawCCSection(1);

    // CC Logo
    canvas.drawCircle(center, ccLogoRadius, ccLogoBrush);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
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
}
