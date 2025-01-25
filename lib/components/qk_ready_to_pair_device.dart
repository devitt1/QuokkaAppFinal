import 'package:flutter/material.dart';
import 'package:quokka_mobile_app/app_localizations.dart';
import 'package:quokka_mobile_app/components/qk_button.dart';
import 'package:quokka_mobile_app/components/spacer.dart';
import 'package:quokka_mobile_app/theme/text_styles.dart';
import 'package:quokka_mobile_app/theme/theme_colors.dart';
import 'package:quokka_mobile_app/utils/measures.dart';

enum QkReadyToPairDeviceState { ready, pairing, paired }

class QkReadyToPairDevice extends StatefulWidget {
  final String title;
  final QkReadyToPairDeviceState action;
  final Function()? onPair;
  final Function()? onUnpair;
  const QkReadyToPairDevice({
    super.key,
    required this.title,
    required this.onPair,
    required this.onUnpair,
    this.action = QkReadyToPairDeviceState.ready,
  });

  @override
  State<QkReadyToPairDevice> createState() => _QkReadyToPairDeviceState();
}

class _QkReadyToPairDeviceState extends State<QkReadyToPairDevice> {
  late AppLocalizations lang;
  late Measures measures;

  Widget _renderButtonState() {
    switch (widget.action) {
      case QkReadyToPairDeviceState.ready:
        return const Text("");
      case QkReadyToPairDeviceState.pairing:
        return Text(
          lang.t("onboard_bluetooth_pairing_button_title"),
          style: TextStyles.roobertTextSm14Bold.copyWith(
            color: ThemeColors.disabledButtonText,
          ),
        );
      case QkReadyToPairDeviceState.paired:
        return Text(
          lang.t("connected"),
          style: TextStyles.roobertTextSm14Bold.copyWith(
            color: ThemeColors.successStatus,
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _renderButtonAction() {
    switch (widget.action) {
      case QkReadyToPairDeviceState.ready:
        return QkButton(
          title: lang.t("pair"),
          onPressed: widget.onPair,
          type: QkButtonType.tertiary,
        );
      case QkReadyToPairDeviceState.pairing:
        return const CircularProgressIndicator(); // TODO: Implement spinner from Figma
      case QkReadyToPairDeviceState.paired:
        // DC: Unpair button is not part of MVP
        return const SizedBox.shrink();
      /*return QkButton(
          title: lang.t("unpair"),
          onPressed: widget.onUnpair,
          type: QkButtonType.tertiary,
        );*/
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    lang = AppLocalizations.of(context)!;
    measures = Measures(context);
    return Container(
      padding: const EdgeInsets.only(
        left: 0,
        right: 0,
        top: 15,
        bottom: 15,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
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
                    width: measures.width(30),
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
                  _renderButtonState(),
                ],
              ),
            ],
          ),
          _renderButtonAction(),
        ],
      ),
    );
  }
}
