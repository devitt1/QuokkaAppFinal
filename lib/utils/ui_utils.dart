import 'package:flutter/material.dart';
import 'package:quokka_mobile_app/components/spacer.dart';
import 'package:quokka_mobile_app/theme/text_styles.dart';
import 'package:quokka_mobile_app/theme/theme_colors.dart';
import 'package:quokka_mobile_app/theme/theme_icons.dart';

enum QkSnakBarType { error, success }

void showSnackbar(
  BuildContext context, {
  String title = '',
  QkSnakBarType type = QkSnakBarType.error,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      showCloseIcon: true,
      closeIconColor: type == QkSnakBarType.error
          ? ThemeColors.errorStatus
          : ThemeColors.successStatus,
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                type == QkSnakBarType.error
                    ? ThemeIcons.warning
                    : ThemeIcons.check,
                color: type == QkSnakBarType.error
                    ? ThemeColors.errorStatus
                    : ThemeColors.successStatus,
              ),
              const Separator(size: Size(8, 0)),
              Text(
                title,
                style: TextStyles.satoshiTextSm16.copyWith(
                  color: type == QkSnakBarType.error
                      ? ThemeColors.errorStatus
                      : ThemeColors.successStatus,
                ),
              ),
            ],
          ),
        ],
      ),
      duration: const Duration(seconds: 5),
      backgroundColor: type == QkSnakBarType.error
          ? ThemeColors.errorBackground
          : ThemeColors.successBackground,
    ),
  );
}
