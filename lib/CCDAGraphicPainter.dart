import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'constants.dart';
import 'package:text_x_arc/text_x_arc.dart';

class CCDAGraphicPaint2 extends StatefulWidget {
  @override
  _CCDAGraphicPaint2State createState() => _CCDAGraphicPaint2State();
}

class _CCDAGraphicPaint2State extends State<CCDAGraphicPaint2> {
  double rotationRadians = 0;

  late CCDAGraphicPainter painter;

  @override
  void initState() {
    super.initState();
    painter = CCDAGraphicPainter(this);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: handleTap,
      child: CustomPaint(
        painter: painter,
      ),
    );
  }

  handleTap(TapUpDetails tapUpDetails) {
    painter.handleTap(tapUpDetails);
  }
}

class CCDAGraphicPainter extends CustomPainter {
  final _CCDAGraphicPaint2State widgetState;
  Offset center = Offset.zero;
  final constants = Constants();

  CCDAGraphicPainter(this.widgetState);

  handleTap(TapUpDetails tapUpDetails) {
    var l = tapUpDetails.localPosition;
    var zeroCenterPoint = Offset((l.dx - center.dx), (l.dy - center.dy));
    Constants.ibmSectionInfo.asMap().forEach((i, info) {
      if (info.checkPointForIBM(zeroCenterPoint)) {
        log("Clicked " + i.toString());
      }
    });
  }

  @override
  void paint(Canvas canvas, Size size) {
    center = Offset(size.width / 2, size.height / 2);

    final side = size.shortestSide;

    final ccLogoRadius = side * Constants.CCLogoSizePct;
    final ccSectionRadius = side * Constants.CCSectionSizePct;

    final ibmSectionRadius = side * Constants.IBMSectionSizePct;

    final fontSize = (ccSectionRadius - ccLogoRadius) / 3;
    Constants.setCCFontSize(fontSize);
    Constants.setIBMFontSize(fontSize);

    Constants.setIBMTitleRadius(ibmSectionRadius - 10);
    Constants.setIBMSectionRadius(ibmSectionRadius);
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

      canvas.drawArc(
        sectInfo.drawingInfo.rect!,
        sectInfo.drawingInfo.sectionStartRadians(i),
        sectInfo.drawingInfo.sectionPortionRadians,
        true,
        Constants.outlinePaint,
      );

      // paintText(
      //   sectInfo.title,
      //   canvas,
      //   sectInfo.drawingInfo.sectionRadius - ccSectionRadius,
      //   sectInfo.drawingInfo.style.fontSize!,
      //   sectInfo.drawingInfo.sectionStartRadians(sectInfo.sectionNumber),
      // );

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
