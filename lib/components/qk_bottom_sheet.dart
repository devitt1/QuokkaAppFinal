import 'package:flutter/material.dart';
import 'package:quokka_mobile_app/components/qk_bottom_sheet_layout.dart';
import 'package:quokka_mobile_app/components/qk_scrollable_bottom_sheet_layout.dart';
import 'package:quokka_mobile_app/theme/text_styles.dart';
import 'package:quokka_mobile_app/utils/measures.dart';

void openBottomSheet({
  required BuildContext context,
  String headerTitle = '',
  Widget? child,
  bool? isDismissible,
  bool? enableDrag,
  bool? scrollable,
  bool? hasDragIndicator,
  EdgeInsets? headerPadding,
  double? sheetSize,
  EdgeInsets? padding,
  Color? backgroundColor,
  Color? dragColor,
  Widget? trailing,
  Function()? whenComplete,
  double? maxHeight,
}) {
  final measures = Measures(context);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: isDismissible ?? true,
    enableDrag: enableDrag ?? true,
    useSafeArea: true,
    constraints: BoxConstraints(maxHeight: measures.height(maxHeight ?? 65)),
    builder: (_) => scrollable != null && scrollable
        ? ScrollableBottomSheetLayout(
            trailing: trailing,
            title: headerTitle.isNotEmpty
                ? Text(
                    headerTitle,
                    style: TextStyles.roobertTextMd16Bold,
                  )
                : const SizedBox.shrink(),
            hasDragIndicator: hasDragIndicator ?? true,
            dragColor: dragColor,
            backgroundColor: backgroundColor,
            padding: padding,
            headerPadding: headerPadding,
            sheetSize: sheetSize,
            child: child ?? const SizedBox.shrink(),
          )
        : BottomSheetLayout(
            trailing: trailing,
            title: headerTitle.isNotEmpty
                ? Text(
                    headerTitle,
                    style: TextStyles.roobertTextMd16Bold,
                  )
                : const SizedBox.shrink(),
            dragColor: dragColor,
            hasDragIndicator: hasDragIndicator ?? true,
            backgroundColor: backgroundColor,
            padding: padding,
            headerPadding: headerPadding,
            sheetSize: sheetSize,
            child: child ?? const SizedBox.shrink(),
          ),
  ).whenComplete(() {
    if (whenComplete != null) {
      whenComplete();
    }
  });
}
