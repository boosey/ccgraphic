import 'package:flutter/material.dart';
import 'CCDAGraphicPainter.dart';
import 'constants.dart';

class HomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(20),
      child: LayoutBuilder(
        builder: (context, constraints) => Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              SizedBox(
                width: constraints.maxHeight,
                height: constraints.maxWidth,
                child: CCDAGraphicPaint(
                  height: constraints.maxHeight,
                  width: constraints.maxWidth,
                ),
              ),
              Image.asset(
                'assets/icons/cc_icon4.png',
                width: constraints.maxWidth * Constants.CCLogoSizePct,
                height: constraints.maxHeight * Constants.CCLogoSizePct,
                colorBlendMode: BlendMode.srcATop,
              )
            ],
          ),
        ),
      ),
    );
  }
}
