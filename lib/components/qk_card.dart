import 'package:flutter/material.dart';
import 'package:quokka_mobile_app/theme/theme_colors.dart';

class QkCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  const QkCard({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 17, vertical: 21),
      decoration: BoxDecoration(
        color: ThemeColors.cards,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}
