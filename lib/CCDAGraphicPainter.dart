import 'dart:developer';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:vector_math/vector_math.dart' as vector;
import 'constants.dart';
import 'package:text_x_arc/text_x_arc.dart';

class CCDAGraphicPaint2 extends StatefulWidget {
  @override
  _CCDAGraphicPaint2State createState() => _CCDAGraphicPaint2State();
}

enum RotationDirection {
  Clockwise,
  Counterclockwise,
}

class _CCDAGraphicPaint2State extends State<CCDAGraphicPaint2> {
  late double previousRotationRadians;
  late double rotationRadians;
  late RotationDirection rotationDirection;
  late CCDAGraphicPainter painter;

  @override
  void initState() {
    super.initState();
    previousRotationRadians = 0;
    rotationRadians = 0;
    rotationDirection = RotationDirection.Clockwise;
  }

  setRotationRadians(double r) {
    setState(() {
      // If angle is zero, then need to go another 22.5 degrees to get
      // sector exactly vertical
      // var extra = (rotationRadians == 0) ? math.pi / 8 : 0;

      // We are only going to rotate the difference from where we are
      // to the new location
      // var diff = (rotationRadians - r).abs();

      previousRotationRadians = rotationRadians;
      // rotationRadians = r + extra;
      rotationRadians = r;

      var diff = (previousRotationRadians - rotationRadians);

      if (0 <= diff && diff < 180) {
        // Counterclockwise
        rotationDirection = RotationDirection.Clockwise;
      } else {
        rotationDirection = RotationDirection.Counterclockwise;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    this.painter = CCDAGraphicPainter(this);
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
  late Constants constants;

  CCDAGraphicPainter(
    this.widgetState,
  ) {
    constants = Constants(this);
  }

  handleTap(TapUpDetails tapUpDetails) {
    bool found = false;
    var l = tapUpDetails.localPosition;
    var zeroCenterPoint = Offset((l.dx - center.dx), (l.dy - center.dy));

    constants.ccSectionInfo.asMap().forEach((i, info) {
      if (!found && info.checkPointForCC(zeroCenterPoint)) {
        found = true;
        log("Clicked " + i.toString());

        var r = calculateNewRotationAngleCC(i);

        log("Rotation: " + vector.degrees(r).toString());
        widgetState.setRotationRadians(r);
      }
    });

    if (!found) {
      constants.ibmSectionInfo.asMap().forEach((i, info) {
        if (!found && info.checkPointForIBM(zeroCenterPoint)) {
          found = true;
          log("Clicked " + i.toString());

          var r = calculateNewRotationAngleIBM(i);

          log("Rotation: " + vector.degrees(r).toString());
          widgetState.setRotationRadians(r);
        }
      });
    }
  }

  double calculateNewRotationAngleCC(i) {
    var three60 = math.pi * 2;
    var correction = three60 * (9 / 16);
    var sectionPortion = three60 / 2;

    double r = ((sectionPortion * i) - correction);
    log("New rotation position: " + r.truncate().toString());
    return r;
  }

  double calculateNewRotationAngleIBM(i) {
    var three60 = math.pi * 2;
    var two2pt5 = three60 / 16;
    var sectionPortion = three60 / 8;

    double r = (sectionPortion * (6 - i)) - two2pt5;
    log("New rotation position: " + r.truncate().toString());
    return r;
  }

  double get rotationRadians => widgetState.rotationRadians;

  @override
  void paint(Canvas canvas, Size size) {
    center = Offset(size.width / 2, size.height / 2);

    final side = size.shortestSide;

    final ccLogoRadius = side * Constants.CCLogoSizePct;
    final ccSectionRadius = side * Constants.CCSectionSizePct;

    final ibmSectionRadius = side * Constants.IBMSectionSizePct;

    final fontSize = (ccSectionRadius - ccLogoRadius) / 3;
    constants.setCCFontSize(fontSize);
    constants.setIBMFontSize(fontSize);

    constants.setIBMTitleRadius(ibmSectionRadius - 10);
    constants.setIBMSectionRadius(ibmSectionRadius);
    constants.setIBMRect(Rect.fromCircle(
      center: center,
      radius: ibmSectionRadius,
    ));

    final textPainter = TextPainter(
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    );

    constants.setCCTitleRadius(
        ccLogoRadius + ((ccSectionRadius - ccLogoRadius) / 2));

    constants.setCCRect(Rect.fromCircle(
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
      SectionInfo sectInfo = constants.ibmSectionInfo[i];
      drawSection(i, sectInfo);
    }

    drawCCSection(i) {
      SectionInfo sectInfo = constants.ccSectionInfo[i];
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
    return true;
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
