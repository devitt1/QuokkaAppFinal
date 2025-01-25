import 'package:flutter/material.dart';

class Separator extends StatelessWidget {
  final Size size;
  const Separator({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: size.width, height: size.height);
  }
}
