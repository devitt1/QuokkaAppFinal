import 'package:flutter/material.dart';
import 'package:quokka_mobile_app/theme/theme_colors.dart';
import 'package:quokka_mobile_app/utils/measures.dart';

class ScrollableBottomSheetLayout extends StatelessWidget {
  final BorderRadiusGeometry? borderRadius;
  final Color? backgroundColor;
  final double? height;
  final EdgeInsets? padding;
  final EdgeInsets? headerPadding;
  final Widget child;
  final bool hasDragIndicator;
  final Widget? leading;
  final Widget? trailing;
  final Widget? title;
  final double? sheetSize;
  final Color? dragColor;

  const ScrollableBottomSheetLayout({
    super.key,
    required this.child,
    required this.hasDragIndicator,
    this.borderRadius,
    this.height,
    this.backgroundColor,
    this.padding,
    this.leading,
    this.trailing,
    this.sheetSize,
    this.title,
    this.headerPadding,
    this.dragColor,
  });

  @override
  Widget build(BuildContext context) {
    final measures = Measures(context);

    // COMMENT:DC We can customize the size after if needed.
    // ignore: no_leading_underscores_for_local_identifiers
    final _sheetSize = sheetSize ?? 0.95;

    return DraggableScrollableSheet(
      minChildSize: _sheetSize - 0.05,
      initialChildSize: _sheetSize,
      maxChildSize: _sheetSize,
      expand: true,
      builder: (context, scrollController) {
        const borderRadiusSize = Radius.circular(16);
        const emptyHeaderSection = SizedBox(width: 40);

        return ClipRRect(
          borderRadius: borderRadius ??
              const BorderRadius.only(
                topLeft: borderRadiusSize,
                topRight: borderRadiusSize,
              ),
          child: Scaffold(
            backgroundColor: backgroundColor ?? ThemeColors.cards,
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              controller: scrollController,
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SizedBox(
                width: measures.deviceWidth,
                child: Container(
                  decoration: BoxDecoration(
                      color:
                          backgroundColor ?? ThemeColors.secondaryBackground),
                  padding: padding ?? const EdgeInsets.only(top: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      hasDragIndicator
                          ? Center(
                              child: Container(
                                width: measures.width(15),
                                height: 4,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(2),
                                  ),
                                  color: dragColor ??
                                      ThemeColors.secondaryBackground,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                      Padding(
                        padding: headerPadding ??
                            const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 18,
                            ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            leading ?? emptyHeaderSection,
                            title ?? emptyHeaderSection,
                            trailing ?? emptyHeaderSection,
                          ],
                        ),
                      ),
                      child,
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
