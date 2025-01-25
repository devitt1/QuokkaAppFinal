import 'package:flutter/material.dart';
import 'package:quokka_mobile_app/components/spacer.dart';
import 'package:quokka_mobile_app/theme/text_styles.dart';
import 'package:quokka_mobile_app/theme/theme_colors.dart';
import 'package:quokka_mobile_app/theme/theme_icons.dart';
import 'package:quokka_mobile_app/utils/measures.dart';

class QkOptionPicker extends StatefulWidget {
  final Function() onPickerPressed;
  final String title;
  final Color? titleColor;
  final String hintText;
  final String defaultValue;
  final bool withBorder;
  final bool disabled;

  const QkOptionPicker(
      {super.key,
      required this.title,
      required this.hintText,
      required this.onPickerPressed,
      this.defaultValue = '',
      this.withBorder = false,
      this.disabled = false,
      this.titleColor});

  @override
  State<QkOptionPicker> createState() => _QkOptionPickerState();
}

class _QkOptionPickerState extends State<QkOptionPicker> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyles.roobertTextMd16Bold.copyWith(
            color: widget.titleColor ??
                (widget.disabled
                    ? ThemeColors.disabledButtonText
                    : ThemeColors.title),
          ),
        ),
        Separator(size: Size(0, Measures.separator8)),
        SizedBox(
          height: Measures.defaultHeight,
          child: Ink(
            decoration: BoxDecoration(
              color: widget.disabled
                  ? ThemeColors.disabledButtonText
                  : ThemeColors.cards,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: ThemeColors.lines,
                width: 1,
              ),
            ),
            child: InkWell(
              onTap: widget.disabled ? null : widget.onPickerPressed,
              child: Container(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 28,
                ),
                decoration: widget.withBorder
                    ? BoxDecoration(
                        border: Border.all(
                          color: ThemeColors.lines,
                          width: 1,
                        ),
                        borderRadius:
                            BorderRadius.circular(Measures.separator8),
                        color: widget.disabled
                            ? ThemeColors.disabledStatus3
                            : ThemeColors.cards,
                      )
                    : BoxDecoration(
                        color: widget.disabled
                            ? ThemeColors.disabledStatus3
                            : ThemeColors.cards,
                      ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.defaultValue.isNotEmpty
                        ? Text(
                            widget.defaultValue,
                            style: TextStyles.roobertTextMd16.copyWith(
                              color: ThemeColors.button,
                            ),
                          )
                        : Text(
                            widget.hintText,
                            style: TextStyles.roobertTextMd16.copyWith(
                              color: ThemeColors.hintText,
                            ),
                          ),
                    const Icon(
                      ThemeIcons.chevronDown,
                      size: 10,
                      color: ThemeColors.button,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
