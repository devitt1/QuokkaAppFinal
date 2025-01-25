import 'package:flutter/material.dart';
import 'package:quokka_mobile_app/theme/text_styles.dart';
import 'package:quokka_mobile_app/theme/theme_colors.dart';
import 'package:quokka_mobile_app/utils/measures.dart';

enum QkButtonType { primary, secondary, tertiary }

class QkButton extends StatelessWidget {
  final String title;
  final Function()? onPressed;
  final bool? disabled;
  final QkButtonType? type;
  const QkButton({
    super.key,
    required this.title,
    this.onPressed,
    this.disabled = false,
    this.type = QkButtonType.primary,
  });

  Color getButtonColor() {
    switch (type) {
      case QkButtonType.primary:
        return ThemeColors.button;
      case QkButtonType.secondary:
      case QkButtonType.tertiary:
        return ThemeColors.background;
      default:
        return ThemeColors.button;
    }
  }

  Size getButtonSize(BuildContext context) {
    switch (type) {
      case QkButtonType.primary:
      case QkButtonType.secondary:
        return Size(
          Measures(context).width(100),
          Measures.defaultHeight,
        );
      case QkButtonType.tertiary:
        return const Size(92, 44);
      default:
        return Size(
          Measures(context).width(100),
          Measures.defaultHeight,
        );
    }
  }

  TextStyle getButtonTextStyle() {
    switch (type) {
      case QkButtonType.primary:
        return TextStyles.roobertTextMd16Bold.copyWith(
          color: disabled == true
              ? ThemeColors.disabledButtonText
              : ThemeColors.buttonTitleColor,
        );
      case QkButtonType.secondary:
      case QkButtonType.tertiary:
        return TextStyles.roobertTextMd16Bold.copyWith(
          color: disabled == true
              ? ThemeColors.disabledButtonText
              : ThemeColors.button,
        );
      default:
        return TextStyles.roobertTextMd16Bold.copyWith(
          color: disabled == true
              ? ThemeColors.disabledButtonText
              : ThemeColors.buttonTitleColor,
        );
    }
  }

  BorderSide getButtonBorder() {
    switch (type) {
      case QkButtonType.primary:
        return BorderSide.none;
      case QkButtonType.secondary:
      case QkButtonType.tertiary:
        return BorderSide(
          color: disabled == true
              ? ThemeColors.disabledButtonText
              : ThemeColors.button,
          width: 1,
        );
      default:
        return BorderSide.none;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: getButtonBorder(),
        elevation: 0,
        backgroundColor: getButtonColor(),
        foregroundColor: getButtonColor(),
        fixedSize: getButtonSize(context),
      ),
      onPressed: disabled == true ? null : onPressed,
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Text(
          title,
          style: getButtonTextStyle(),
        ),
      ),
    );
  }
}
