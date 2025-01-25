import 'package:flutter/material.dart';
import 'package:quokka_mobile_app/theme/text_styles.dart';
import 'package:quokka_mobile_app/theme/theme_colors.dart';
import 'package:quokka_mobile_app/theme/theme_icons.dart';

class QkHelperText extends StatelessWidget {
  final String title;
  final bool showIcon;
  const QkHelperText({
    super.key,
    required this.title,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        showIcon
            ? const Icon(
                ThemeIcons.info,
                size: 16,
                color: ThemeColors.button,
              )
            : const SizedBox.shrink(),
        showIcon ? const SizedBox(width: 8) : const SizedBox.shrink(),
        Expanded(
          child: Text(
            title,
            style: TextStyles.roobertTextMd16.copyWith(
              color: ThemeColors.subText,
            ),
          ),
        ),
      ],
    );
  }
}
