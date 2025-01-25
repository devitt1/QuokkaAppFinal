import 'package:flutter/material.dart';
import 'package:quokka_mobile_app/theme/theme_colors.dart';
import 'package:quokka_mobile_app/utils/measures.dart';

class QKCircleAnimation extends StatefulWidget {
  const QKCircleAnimation({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _QKCircleAnimationState createState() => _QKCircleAnimationState();
}

class _QKCircleAnimationState extends State<QKCircleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Measures measures;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.5,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  Widget _buildBody() {
    return AnimatedBuilder(
      animation:
          CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _buildContainer(measures.width(100) * _controller.value),
            _buildContainer(measures.width(80) * _controller.value),
            _buildContainer(measures.width(70) * _controller.value),
          ],
        );
      },
    );
  }

  Widget _buildContainer(double radius) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: ThemeColors.button.withOpacity(1 - (_controller.value)),
          width: 1,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    measures = Measures(context);
    return _buildBody();
  }
}
