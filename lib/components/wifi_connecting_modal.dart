import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quokka_mobile_app/app_localizations.dart';
import 'package:quokka_mobile_app/components/qk_card.dart';
import 'package:quokka_mobile_app/components/spacer.dart';
import 'package:quokka_mobile_app/pages/my_quokkas_page/my_quokkas_page.dart';
import 'package:quokka_mobile_app/controllers/app_provider.dart';
import 'package:quokka_mobile_app/theme/text_styles.dart';
import 'package:quokka_mobile_app/theme/theme_colors.dart';
import 'package:quokka_mobile_app/utils/measures.dart';

enum QkWifiConnectStatus { connecting, success, error }

class QkWifiConnectionModal extends StatefulWidget {
  final QkWifiConnectStatus type;
  const QkWifiConnectionModal({
    super.key,
    required this.type,
  });

  @override
  State<QkWifiConnectionModal> createState() => _QkWifiConnectionModalState();
}

class _QkWifiConnectionModalState extends State<QkWifiConnectionModal> {
  late AppLocalizations lang;
  late AppProvider appProvider;
  late Measures measures;

  Widget _renderConnectingBody() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(), // TODO: Add loading animation
        Separator(size: Size(0, Measures.separator16)),
        Text(
          lang.t("wifi_modal_connecting_title"),
          style: TextStyles.roobertTextLg20Bold.copyWith(
            color: ThemeColors.title,
          ),
          textAlign: TextAlign.center,
        ),
        Separator(size: Size(0, Measures.separator8)),
        Text(
          lang.t("wifi_modal_connecting_description"),
          style: TextStyles.roobertTextMd16.copyWith(
            color: ThemeColors.subText,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _renderSuccessBody() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushNamedAndRemoveUntil(
          context, MyQuokkasPage.route, (_) => false);
    });

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.check_circle,
          color: ThemeColors.button,
        ), // TODO: Add loading animation
        Text(
          lang.t("wifi_modal_success_title"),
          style: TextStyles.roobertTextLg20Bold.copyWith(
            color: ThemeColors.title,
          ),
          textAlign: TextAlign.center,
        ),
        Separator(size: Size(0, Measures.separator8)),
        Text(
          lang.t("wifi_modal_success_description"),
          style: TextStyles.roobertTextMd16.copyWith(
            color: ThemeColors.subText,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _renderErrorBody() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context);
    });

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.error,
          color: ThemeColors.errorStatus,
        ), // TODO: Add loading animation
        Text(
          lang.t("wifi_modal_error_title"),
          style: TextStyles.roobertTextLg20Bold.copyWith(
            color: ThemeColors.title,
          ),
          textAlign: TextAlign.center,
        ),
        Separator(size: Size(0, Measures.separator8)),
        Text(
          lang.t("wifi_modal_error_description"),
          style: TextStyles.roobertTextMd16.copyWith(
            color: ThemeColors.subText,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _renderBody() {
    switch (widget.type) {
      case QkWifiConnectStatus.connecting:
        return _renderConnectingBody();
      case QkWifiConnectStatus.success:
        return _renderSuccessBody();
      case QkWifiConnectStatus.error:
        return _renderErrorBody();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    measures = Measures(context);
    lang = AppLocalizations.of(context)!;
    appProvider = Provider.of<AppProvider>(context, listen: true);

    return AlertDialog(
      elevation: 0,
      titlePadding: EdgeInsets.zero,
      actionsPadding: EdgeInsets.zero,
      backgroundColor: ThemeColors.cards,
      content: SizedBox(
        width: measures.width(60),
        child: QkCard(child: _renderBody()),
      ),
    );
  }
}
