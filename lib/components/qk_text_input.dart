import 'package:flutter/material.dart';
import 'package:quokka_mobile_app/components/spacer.dart';
import 'package:quokka_mobile_app/theme/text_styles.dart';
import 'package:quokka_mobile_app/theme/theme_colors.dart';
import 'package:quokka_mobile_app/utils/measures.dart';

class QkTextInput extends StatefulWidget {
  final String title;
  final TextEditingController controller;
  final bool? disabled;
  final String? placeholder;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final bool? obscureText;
  final double? fontSize;

  const QkTextInput({
    super.key,
    required this.title,
    required this.controller,
    this.fontSize,
    this.disabled = false,
    this.placeholder = '',
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.obscureText = false,
  });

  @override
  State<QkTextInput> createState() => _QkTextInputState();
}

class _QkTextInputState extends State<QkTextInput> {
  late Measures measures;
  final dataKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    measures = Measures(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: TextStyles.roobertTextMd16Bold.copyWith(
            color: widget.disabled == true
                ? ThemeColors.disabledButtonText
                : ThemeColors.title,
          ),
        ),
        Separator(size: Size(0, Measures.separator8)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: widget.disabled == true
                ? ThemeColors.disabledStatus3
                : ThemeColors.cards,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: ThemeColors.lines,
              width: 1,
            ),
          ),
          child: TextField(
            key: dataKey,
            textAlignVertical: TextAlignVertical.center,
            controller: widget.controller,
            decoration: InputDecoration(
              hintText: widget.placeholder,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              suffixIcon: widget.suffixIcon ?? const SizedBox.shrink(),
              contentPadding: EdgeInsets.zero,
            ),
            obscureText: widget.obscureText ?? false,
            keyboardType: widget.keyboardType,
            style: TextStyles.roobertTextMd16.copyWith(
              color: ThemeColors.hintText,
              fontSize: widget.fontSize,
            ),
            enabled: widget.disabled == false,
            textAlign: TextAlign.start,
            maxLines: widget.obscureText! || widget.disabled! ? 1 : null,
            minLines: null,
            autofocus: false,
            cursorColor: ThemeColors.button,
            cursorWidth: 2,
            onTap: () {
              Scrollable.ensureVisible(dataKey
                  .currentContext!); //here you can scroll to the respective widget referring the key.
            },
          ),
        ),
      ],
    );
  }
}
