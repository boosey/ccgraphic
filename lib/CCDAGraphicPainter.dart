import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'constants.dart';
import 'sectioninfo.dart';

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
      previousRotationRadians = rotationRadians;
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

  CCDAGraphicPainter(
    this.widgetState,
  );

  handleTap(TapUpDetails tapUpDetails) {
    bool found = false;
    var l = tapUpDetails.localPosition;
    var zeroCenterPoint = Offset((l.dx - center.dx), (l.dy - center.dy));

    CCSection.sections().asMap().forEach((i, section) {
      if (!found && section.hitTest(zeroCenterPoint)) {
        found = true;
        var r = calculateNewRotationAngleCC(section);
        widgetState.setRotationRadians(r);
      }
    });

    if (!found) {
      IBMSection.sections().asMap().forEach((i, section) {
        if (!found && section.hitTest(zeroCenterPoint)) {
          found = true;
          var r = calculateNewRotationAngleIBM(section);
          widgetState.setRotationRadians(r);
        }
      });
    }
  }

  double calculateNewRotationAngleCC(Section section) {
    return (section.sectionNumber * Constants.r180) + Constants.r90;
  }

  double calculateNewRotationAngleIBM(Section section) {
    double r =
        (section.sweepRadians * (6 - section.sectionNumber)) - Constants.r22;
    return r;
  }

  double get rotationRadians => widgetState.rotationRadians;

  @override
  void paint(Canvas canvas, Size size) {
    center = Offset(size.width / 2, size.height / 2);
    final side = size.shortestSide;

    IBMSection.sections().forEach((section) {
      section.rotationRadians = this.rotationRadians;
      section.diameter = side;
      section.draw(canvas, size);
    });

    CCSection.sections().forEach((section) {
      section.rotationRadians = this.rotationRadians;
      // section.diameter = side * Constants.CCSectionSizePct;
      section.diameter = side;
      section.draw(canvas, size);
    });

    // CC Logo
    final ccLogoRadius = side * Constants.CCLogoSizePct;
    final ccLogoBrush = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, ccLogoRadius, ccLogoBrush);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
