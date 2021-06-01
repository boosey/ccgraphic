import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'constants.dart';
import 'ccsection.dart';
import 'ibmsection.dart';
import 'section.dart';
import 'package:vector_math/vector_math.dart' as vector;
// import 'dart:math' as math;

class CCDAGraphicPaint2 extends StatefulWidget {
  @override
  _CCDAGraphicPaint2State createState() => _CCDAGraphicPaint2State();
}

enum RotationDirection {
  Clockwise,
  Counterclockwise,
}

class _CCDAGraphicPaint2State extends State<CCDAGraphicPaint2>
    with TickerProviderStateMixin {
  late double previousRotationRadians;
  late double targetRotationRadians;
  late RotationDirection rotationDirection;
  late CCDAGraphicPainter painter;
  late AnimationController _controller;
  late CurvedAnimation _curvedAnimation;

  @override
  void initState() {
    super.initState();
    previousRotationRadians = 0;
    targetRotationRadians = 0;
    rotationDirection = RotationDirection.Clockwise;

    _controller = AnimationController(
      duration: const Duration(milliseconds: Constants.animationMilliseconds),
      vsync: this,
    );

    _curvedAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInCirc);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  setRotationRadians(double r) {
    setState(() {
      previousRotationRadians = targetRotationRadians;
      targetRotationRadians = r;
      var mills = (Constants.animationMilliseconds *
              ((targetRotationRadians - previousRotationRadians).abs()) /
              Constants.r360)
          .truncate();
      var duration = Duration(milliseconds: mills);
      _controller.duration = duration;
    });
  }

  @override
  Widget build(BuildContext context) {
    this.painter = CCDAGraphicPainter(this);
    return AnimatedBuilder(
      animation: _curvedAnimation,
      child: Container(
        child: GestureDetector(
          onTapUp: handleTap,
          child: CustomPaint(
            painter: painter,
          ),
        ),
      ),
      builder: (BuildContext context, Widget? child) {
        double currentAngle = previousRotationRadians +
            (_curvedAnimation.value *
                (targetRotationRadians - previousRotationRadians));

        return Transform.rotate(
          angle: currentAngle,
          child: child,
        );
      },
    );
  }

  handleTap(TapUpDetails tapUpDetails) {
    // this.setRotationRadians(0);
    painter.handleTap(tapUpDetails);
    _controller.reset();
    _controller.forward();
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
        log("CC HIT: " + section.sectionNumber.toString());
      }
    });

    if (!found) {
      IBMSection.sections().asMap().forEach((i, section) {
        if (!found && section.hitTest(zeroCenterPoint)) {
          found = true;
          var r = calculateNewRotationAngleIBM(section);
          widgetState.setRotationRadians(r);
          log("IBM HIT: " +
              section.sectionNumber.toString() +
              " " +
              section.title);
        }
      });
    }
  }

  double calculateNewRotationAngleCC(Section section) {
    double r = (section.sectionNumber * Constants.r180) + Constants.r90;
    log("new rotation angle: " + vector.degrees(r).toString());
    return r;
  }

  double calculateNewRotationAngleIBM(Section section) {
    double r =
        (section.sweepRadians * (6 - section.sectionNumber)) - Constants.r22;
    return r;
  }

  double get rotationRadians => widgetState.targetRotationRadians;

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
