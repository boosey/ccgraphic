import 'dart:math';
import 'package:ccgraphic/rotating_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'CCDAGraphicPainter.dart';
import 'constants.dart';

class HomeWidget extends StatelessWidget {
  shortestSide(BoxConstraints c) => min(c.maxHeight, c.maxWidth);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.center,
      color: Colors.white,
      padding: EdgeInsets.all(20),
      child: LayoutBuilder(
        builder: (context, constraints) => Container(
          alignment: AlignmentDirectional.center,
          width: shortestSide(constraints),
          height: shortestSide(constraints),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              SizedBox(
                width: shortestSide(constraints),
                height: shortestSide(constraints),
                child: CCDAGraphicPaint(),
              ),
              RotatingIcon(
                width: constraints.maxWidth * Constants.CCLogoSizePct,
                height: constraints.maxHeight * Constants.CCLogoSizePct,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
