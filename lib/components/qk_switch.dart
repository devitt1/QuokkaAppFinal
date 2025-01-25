import 'package:flutter/material.dart';
import 'package:quokka_mobile_app/theme/theme_colors.dart';

class QkSwitch extends StatefulWidget {
  final Function(bool)? onChanged;
  final bool? value;
  const QkSwitch({
    super.key,
    this.onChanged,
    this.value = false,
  });

  @override
  State<QkSwitch> createState() => _QkSwitchState();
}

class _QkSwitchState extends State<QkSwitch> {
  @override
  Widget build(BuildContext context) {
    return Switch(
      value: widget.value!,
      onChanged: widget.onChanged,
      activeColor: ThemeColors.cards,
      activeTrackColor: ThemeColors.button,
      inactiveThumbColor: ThemeColors.cards,
      inactiveTrackColor: ThemeColors.disabledStatus2,
      trackOutlineColor: WidgetStatePropertyAll<Color?>(widget.value == true
          ? ThemeColors.button
          : ThemeColors.disabledStatus2),
    );
  }
}
