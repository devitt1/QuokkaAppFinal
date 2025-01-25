import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:quokka_mobile_app/app_localizations.dart';
import 'package:quokka_mobile_app/components/qk_bottom_sheet.dart';
import 'package:quokka_mobile_app/components/qk_card.dart';
import 'package:quokka_mobile_app/components/qk_switch.dart';
import 'package:quokka_mobile_app/components/spacer.dart';
import 'package:quokka_mobile_app/models/qk_device_model.dart';
import 'package:quokka_mobile_app/controllers/app_provider.dart';
import 'package:quokka_mobile_app/theme/text_styles.dart';
import 'package:quokka_mobile_app/theme/theme_colors.dart';
import 'package:quokka_mobile_app/utils/measures.dart';

class QkAccordionItem extends StatefulWidget {
  const QkAccordionItem({
    super.key,
    required this.device,
    required this.unpairAction,
  });

  final QkDeviceModel device;
  final Function() unpairAction;

  @override
  State<QkAccordionItem> createState() => _QkAccordionItemState();
}

class _QkAccordionItemState extends State<QkAccordionItem> {
  late AppLocalizations lang;
  late Measures measures;
  late AppProvider appProvider;
  bool isExpanded = false;

  void _onExpand() => setState(() => isExpanded = !isExpanded);

  void _onMoreActionPressed() {
    openBottomSheet(
      scrollable: true,
      enableDrag: true,
      hasDragIndicator: true,
      headerTitle: "",
      sheetSize: 1,
      dragColor: ThemeColors.secondaryBackground,
      backgroundColor: ThemeColors.cards,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      context: context,
      child: Column(
        children: [
          // QkAccordionButton(
          //   label: lang.t("give_your_quokka_a_home"),
          //   fontSize: TextStyles.fontSize16,
          //   onPressed: () => _onGiveYourQuokkaHomePressed(),
          // ),
          // const Divider(color: ThemeColors.lines, thickness: 0.5),
          // QkAccordionButton(
          //   label: lang.t("my_quokkas_change_wifi_network"),
          //   fontSize: TextStyles.fontSize16,
          //   onPressed: () => _onWifiNetworkChange(),
          // ),
          // const Divider(color: ThemeColors.lines, thickness: 0.5),
          QkAccordionButton(
            label: lang.t("unpair"),
            fontSize: TextStyles.fontSize16,
            onPressed: () => _onUnpair(),
          ),
          // const Divider(color: ThemeColors.lines, thickness: 0.5),
          // QkAccordionButton(
          //   label: lang.t("reset"),
          //   fontSize: TextStyles.fontSize16,
          //   labelColor: ThemeColors.errorStatus,
          //   onPressed: () => _onReset(),
          // ),
        ],
      ),
    );
  }

/*
  void _onGiveYourQuokkaHomePressed() => Navigator.pushNamed(
        context,
        StepXGiveYourQuokkaPage.route,
        arguments: widget.device,
      );

  void _onWifiNetworkChange() => {}; // TODO: Implement this

  // TODO Currently only one quokka device so clearing local storage resets this one device
  void _onReset() => {};
*/

  void _onUnpair() {
    // Close current Bottomsheet
    Navigator.pop(context);
    // Call parent function to open new bottomsheet to confirm action
    widget.unpairAction();
  }

  Widget _conditionalRender({required Widget child}) =>
      isExpanded ? child : const SizedBox.shrink();

  @override
  Widget build(BuildContext context) {
    measures = Measures(context);
    lang = AppLocalizations.of(context)!;
    appProvider = Provider.of<AppProvider>(context);

    return QkCard(
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 22,
                  left: 15,
                  right: 15,
                  bottom: isExpanded ? 0 : 22,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'lib/assets/images/small_device.png',
                      width: measures.width(15),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Measures.separator16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.device.deviceName,
                              style: TextStyles.roobertTextMd16Bold,
                            ),
                            Separator(size: Size(0, Measures.separator8)),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                QkOnlineIndicator(
                                  label: lang.t("private"),
                                  isOnline: widget.device.isOnlinePrivate,
                                ),
                                Separator(size: Size(Measures.separator8, 0)),
                                QkOnlineIndicator(
                                  label: lang.t("public"),
                                  isOnline: widget.device.isOnlinePublic,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _onExpand,
                      child: Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),
              _conditionalRender(
                child: Separator(size: Size(0, Measures.separator16)),
              ),
              _conditionalRender(
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: Measures.separator16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            lang.t("private_network_ip"),
                            style: TextStyles.roobertTextSm14SemiBold,
                          ),
                          Separator(size: Size(Measures.separator8, 0)),
                          Expanded(
                            child: Text(
                              widget.device.deviceIp,
                              style: TextStyles.roobertTextSm14
                                  .copyWith(color: ThemeColors.hintText),
                            ),
                          ),
                        ],
                      ),
                      Separator(size: Size(0, Measures.separator8)),
                      Row(
                        children: [
                          Text(
                            lang.t("public_address"),
                            style: TextStyles.roobertTextSm14SemiBold,
                          ),
                          Separator(size: Size(Measures.separator8, 0)),
                          // TODO: Full address does not fit on the one line
                          // Expanded(
                          //   child: Text(
                          //     widget.device.privateAddress,
                          //     style: TextStyles.roobertTextSm14
                          //         .copyWith(color: ThemeColors.hintText),
                          //   ),
                          // ),
                        ],
                      ),
                      Text(
                        widget.device.privateAddress,
                        style: TextStyles.roobertTextSm14
                            .copyWith(color: ThemeColors.hintText),
                      ),
                      Separator(size: Size(0, Measures.separator16)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            lang.t("turn_on_off_public_access"),
                            style: TextStyles.roobertTextSm14SemiBold,
                          ),
                          // DC: Switch is not part of MVP
                          const QkSwitch(value: false),
                        ],
                      ),
                      Separator(size: Size(0, Measures.separator10)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _conditionalRender(
            child: const Divider(
              color: ThemeColors.lines,
              thickness: 0.5,
              height: 0,
            ),
          ),
          _conditionalRender(
            child: QkAccordionButton(
              label: lang.t("more_action"),
              onPressed: _onMoreActionPressed,
            ),
          ),
        ],
      ),
    );
  }
}

class QkAccordionButton extends StatelessWidget {
  final String label;
  final Function() onPressed;
  final Color? labelColor;
  final double? fontSize;
  const QkAccordionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.labelColor,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final measures = Measures(context);
    return SizedBox(
      width: measures.width(100),
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          surfaceTintColor: WidgetStateProperty.all(Colors.transparent),
          enableFeedback: false,
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          splashFactory: NoSplash.splashFactory,
        ),
        child: Text(
          label,
          style: TextStyles.roobertTextSm14Bold.copyWith(
            color: labelColor ?? ThemeColors.button,
            fontSize: fontSize ?? TextStyles.roobertTextSm14Bold.fontSize,
          ),
        ),
      ),
    );
    /*return GestureDetector(
      onTap: onPressed,
      child: Text(
        label,
        style: TextStyles.roobertTextSm14Bold.copyWith(
          color: labelColor ?? ThemeColors.button,
          fontSize: fontSize ?? TextStyles.roobertTextSm14Bold.fontSize,
        ),
      ),
    );*/
  }
}

class QkOnlineIndicator extends StatelessWidget {
  final bool isOnline;
  final String label;

  const QkOnlineIndicator({
    super.key,
    required this.label,
    required this.isOnline,
  });

  @override
  Widget build(BuildContext context) {
    AppLocalizations lang = AppLocalizations.of(context)!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          children: [
            const Separator(size: Size(0, 2)),
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isOnline
                    ? ThemeColors.successStatus
                    : ThemeColors.disabledStatus3,
              ),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
        const Separator(size: Size(4, 0)),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            '${lang.t(isOnline ? 'online' : 'offline')} $label',
            style: TextStyles.roobertTextSm14.copyWith(
              color: isOnline
                  ? ThemeColors.subText
                  : ThemeColors.disabledButtonText,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
