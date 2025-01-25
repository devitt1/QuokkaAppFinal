import 'package:flutter/material.dart';
import 'package:quokka_mobile_app/components/spacer.dart';
import 'package:quokka_mobile_app/theme/text_styles.dart';
import 'package:quokka_mobile_app/theme/theme_colors.dart';
import 'package:quokka_mobile_app/theme/theme_icons.dart';
import 'package:quokka_mobile_app/utils/measures.dart';

class QkErrorMessage extends StatelessWidget {
  final String title;
  final String message;
  const QkErrorMessage({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Separator(size: Size(0, Measures.separator8)),
            const Icon(
              ThemeIcons.warning,
              color: ThemeColors.errorStatus,
            ),
            Separator(size: Size(0, Measures.separator8)),
            Text(
              title,
              style: TextStyles.roobertTextLg20Bold,
              textAlign: TextAlign.center,
            ),
            Separator(size: Size(0, Measures.separator8)),
            Text(
              message,
              style: TextStyles.roobertTextMd16,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ],
    );
  }
}
