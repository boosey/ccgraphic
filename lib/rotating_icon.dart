import 'package:flutter/material.dart';

class RotatingIcon extends StatefulWidget {
  final double width;
  final double height;

  const RotatingIcon({required this.width, required this.height});

  @override
  State<RotatingIcon> createState() => _RotatingIconState();
}

class _RotatingIconState extends State<RotatingIcon>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 2500),
    vsync: this,
  )..forward();

  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInCirc,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  animateIcon() {
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _animation,
      child: GestureDetector(
        onTap: animateIcon,
        child: Image.asset(
          'assets/icons/cc_icon4.png',
          width: widget.width,
          height: widget.height,
          colorBlendMode: BlendMode.srcATop,
        ),
      ),
    );
  }
}
