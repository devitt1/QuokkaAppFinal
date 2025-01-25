import 'package:flutter/material.dart';
import 'package:quokka_mobile_app/components/spacer.dart';
import 'package:quokka_mobile_app/theme/text_styles.dart';
import 'package:quokka_mobile_app/theme/theme_colors.dart';
import 'package:quokka_mobile_app/utils/measures.dart';

class QkItem extends StatefulWidget {
  final String title;
  final String description;
  final bool selected;
  final Function()? onPressed;
  const QkItem({
    super.key,
    required this.title,
    required this.description,
    required this.onPressed,
    this.selected = false,
  });

  @override
  State<QkItem> createState() => _QkItemState();
}

class _QkItemState extends State<QkItem> {
  late Measures measures;

  @override
  Widget build(BuildContext context) {
    measures = Measures(context);

    return Ink(
      child: InkWell(
        onTap: widget.onPressed,
        child: Container(
          decoration: BoxDecoration(
            color: ThemeColors.secondaryBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.selected ? ThemeColors.button : Colors.transparent,
              width: 1,
            ),
          ),
          padding: const EdgeInsets.only(
            left: 16,
            right: 28,
            top: 15,
            bottom: 15,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Image.asset(
                      'lib/assets/images/small_device.png',
                      width: measures.width(15),
                    ),
                    Separator(size: Size(Measures.separator16, 0)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: measures.width(50),
                          child: Text(
                            widget.title,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: true,
                            style: TextStyles.roobertTextMd16Bold
                                .copyWith(color: ThemeColors.title),
                          ),
                        ),
                        Separator(size: Size(Measures.separator8, 0)),
                        SizedBox(
                          width: measures.width(50),
                          child: Text(
                            widget.description,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            softWrap: true,
                            style: TextStyles.roobertTextSm14
                                .copyWith(color: ThemeColors.subText),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              widget.selected
                  ? const Icon(Icons.check_circle_rounded,
                      color: ThemeColors.button)
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
